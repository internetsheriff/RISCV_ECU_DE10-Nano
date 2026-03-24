# SAW Acquisition FSM – Especificações do Módulo

## 1. Visão Geral

O `saw_acquisition_fsm` controla a interrogação pulsada de um sensor SAW (Surface Acoustic Wave).
Gera um burst de RF em 160 MHz, abre uma janela de recepção e timestamps o eco com o `tdc_linux128`.

A medida obtida é o **tempo de propagação** da onda acústica (ToF — Time of Flight):

```
tdc_result = tdc_linux128.end_soma (15 bits)
           = intervalo entre PulseA (fim do burst) e PulseB (chegada do eco)
```

---

## 2. Arquitetura

```
KEY[1] (active-low)
    │
    ▼
key_edge_detect ──► start_pulse
                         │
                         ▼
                      FSM ──── BURST ──► tx_enable
                         │                   │
                         │           negedge_gate
                         │                   │
                         │             tx_out (160 MHz gated) → GPIO → BPF → SAW
                         │
                         ├── tdc_start (PulseA) ──► tdc_linux128
                         │
                    DEAD_TIME
                         │
                    RX_WAIT
                         │
              rx_in ─► sync_2ff ─► edge_detect ──► tdc_stop (PulseB) ──► tdc_linux128
                                                             │
                                                        DONE ──► done (1 ciclo)
```

---

## 3. Interface

| Porta       | Direção | Largura | Descrição                                              |
|-------------|---------|---------|--------------------------------------------------------|
| `clk`       | input   | 1       | Clock 160 MHz (PLL outclk_1)                          |
| `rst`       | input   | 1       | Reset síncrono, ativo alto                            |
| `key_n`     | input   | 1       | KEY[1] da DE10-Nano, ativo baixo                      |
| `rx_in`     | input   | 1       | Sinal assíncrono do detector de envelope / comparador |
| `tx_out`    | output  | 1       | Clock de 160 MHz gated → GPIO → filtro → SAW          |
| `tdc_start` | output  | 1       | Pulso de 1 ciclo → PulseA do tdc_linux128             |
| `tdc_stop`  | output  | 1       | Pulso de 1 ciclo → PulseB do tdc_linux128             |
| `done`      | output  | 1       | Pulso de 1 ciclo: aquisição concluída (eco ou timeout)|

---

## 4. Parâmetros

| Parâmetro       | Padrão | Tempo (160 MHz) | Descrição                                       |
|-----------------|--------|------------------|-------------------------------------------------|
| `BURST_CYCLES`  | 16     | 100 ns           | Duração do burst de RF (ignorado se `CONTINUOUS_TX=1`) |
| `DEAD_CYCLES`   | 2000   | 12,5 µs          | Blanking após o burst (aguarda TX decair)       |
| `WINDOW_CYCLES` | 20000  | 125 µs           | Janela máxima de espera pelo eco (timeout)      |
| `CONTINUOUS_TX` | 0      | —                | **0** = burst gated; **1** = 160 MHz contínuo na porta TX |

### Modo contínuo (`CONTINUOUS_TX = 1`)

Com `CONTINUOUS_TX = 1`, a saída TX mantém **160 MHz contínuos** na porta (`tx_out = clk`).
O gate e a FSM de burst são ignorados para a saída TX. Use para:
- Interrogação CW (onda contínua)
- Teste de RF sem pulsos
- Alimentação contínua de filtros/amplificadores

> **Nota:** Em modo contínuo, `tdc_start`/`tdc_stop` continuam a ser gerados pela FSM (trigger em KEY[1]), mas o TDC mede o intervalo entre o trigger e o eco — não mais o fim do burst.

### Dimensionamento do DEAD_CYCLES

Para sensores SAW com tempo de voo típico de 1–5 µs:

| DEAD_CYCLES | Tempo (160 MHz) | Uso recomendado                  |
|-------------|-----------------|----------------------------------|
| 800         | 5 µs            | SAW com delay curto (~1 µs)      |
| 2000        | 12,5 µs         | SAW com delay médio (padrão)     |
| 16000       | 100 µs          | SAW com delay longo (> 10 µs)    |

> Atenção: `DEAD_CYCLES` deve ser menor que o tempo de voo esperado para não perder o eco.

---

## 5. Diagrama de Estados

```
         start_pulse
IDLE ──────────────────► BURST
 ▲                          │ (burst_cnt == 0)
 │                          │  tdc_start = 1
 │                          │  tx_enable = 0
 │                          ▼
 │                      DEAD_TIME
 │                          │ (counter >= DEAD_CYCLES-1)
 │                          ▼
 │                       RX_WAIT ◄──────────────────┐
 │                          │                        │ (sem eco)
 │          rx_edge &&      │ counter >= WINDOW-1    │
 │          !captured       │──── timeout ──────────►│
 │               │          │
 │         tdc_stop=1       │
 │               ▼          │
 │            DONE_ST ◄─────┘
 │               │ done = 1
 └───────────────┘
```

---

## 6. Timing do TX (gate sem glitch)

O `tx_out` usa a técnica de **negedge latch** para evitar pulsos espúrios ao ligar/desligar:

```
          __ __ __ __ __ __ __ __ __
clk      |  |  |  |  |  |  |  |  |
         _________
tx_enable         |___________________
                  ↑ posedge: muda tx_enable

              ___
tx_gate      |   |___________________     ← atualizado no NEGEDGE seguinte
             ↑ negedge
                  ________________
tx_out      ____||  clk completo  |____   ← só ciclos inteiros, sem glitch
```

O `tx_gate` é atualizado quando `clk = 0`, então o AND gate `tx_out = tx_gate & clk`
só muda de estado durante o nível baixo do clock → saída sem borda espúria.

---

## 7. Timing do TDC

```
Burst (16 ciclos)   Dead Time (2000 ciclos)    RX Window (até 20000 ciclos)
│←── 100 ns ───→│←──────── 12,5 µs ──────────→│←──── até 125 µs ──────────→│

[TX ativo]         [silêncio]                   [aguarda eco]
        ↑                                              ↑
   tdc_start (PulseA)                           tdc_stop (PulseB)

resultado = tdc_linux128.end_soma (15 bits)
          = tempo de voo (PulseA → PulseB) em unidades do TDC interno
```

> O `tdc_linux128` usa oscilador de anel interno — **não requer clock externo**.
> `PulseA` = referência de disparo (fim do último ciclo do burst).
> `PulseB` = chegada do eco.

---

## 8. Integração em `pulpino_qsys_test.v`

```verilog
// Declaração de wires
wire        saw_tx_out;
wire        saw_tdc_start;
wire        saw_tdc_stop;
wire        saw_done;
wire [14:0] tdc_end;

// FSM
saw_acquisition_fsm #(
    .BURST_CYCLES  (16),
    .DEAD_CYCLES   (2000),
    .WINDOW_CYCLES (20000)
) u_saw_fsm (
    .clk       (clk_160),          // PLL outclk_1 = 160 MHz
    .rst       (~reset_n),
    .key_n     (KEY[1]),            // botão DE10-Nano
    .rx_in     (GPIO_0[11]),        // saída do comparador de envelope
    .tx_out    (saw_tx_out),
    .tdc_start (saw_tdc_start),
    .tdc_stop  (saw_tdc_stop),
    .done      (saw_done)
);

// Saída TX para o pino GPIO
assign GPIO_0[10] = saw_tx_out;

// TDC (oscilador de anel interno, sem clock externo)
tdc_linux128 u_tdc (
    .reset   (reset_n),
    .PulseA  (saw_tdc_start),
    .PulseB  (saw_tdc_stop),
    .end_soma(tdc_end)
);

// Resultado disponível para a CPU via PIO
// gpio_in[16:2] = tdc_end[14:0]
```

### PLL: saídas necessárias

| Saída     | Frequência | Destino                 |
|-----------|------------|-------------------------|
| outclk_0  | 25 MHz     | Pulpino core clock      |
| outclk_1  | 160 MHz    | saw_acquisition_fsm.clk |

VCO configurado: `800 MHz` (50 MHz × 16 / 1), divisores C0=32, C1=5.

---

## 9. Observações de Hardware

- `tx_out` (GPIO_0[10]) deve ser conectado a um **filtro passa-banda** centrado em 160 MHz
  com largura de banda ≥ 1 MHz antes de atingir o sensor SAW.
- `rx_in` (GPIO_0[11]) recebe o sinal já detectado por envelope externo (comparador Schottky).
  O sinal deve ser LVTTL 3,3 V; usar resistor série de proteção (33–100 Ω).
- O módulo usa **synchronous reset**: garantir que `rst` seja deasserido após o PLL travar
  (`pll_locked = 1`) para evitar estado indefinido.

---

## 10. Arquivos do Módulo

| Arquivo                 | Descrição                        |
|-------------------------|----------------------------------|
| `saw_acquisition_fsm.v` | Módulo RTL principal             |
| `SAW_FSM_SPECS.md`      | Esta especificação               |
