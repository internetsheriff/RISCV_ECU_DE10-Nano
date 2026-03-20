# RX Frontend – Especificações e Considerações de Implementação

## 1. Visão Geral

O RX frontend implementa a cadeia de recepção digital do interrogador SAW, integrando:

- Sincronização de entrada assíncrona
- Detecção de borda do eco
- Referência TX (PulseA) para o TDC
- Captura de fase do DDS no instante do eco
- FIFO de eventos (phase + step + resultado do TDC)

---

## 2. Arquitetura

```
rx_in (GPIO)     dds_out, dds_valid     dds_phase, dds_step
       │                    │                      │
       ▼                    │                      │
  sync_2ff                  │                      │
       │                    ▼                      │
       ▼             tx_reference ──────────────► pulse_a (TDC)
  edge_detect                    │
       │                         │
       ▼                         │
  pulse_b (TDC) ◄────────────────┘
       │
       ├──► phase_capture (dds_phase)
       │
       ▼
  pipeline (TDC latency)
       │
       ▼
  event_fifo ◄── tdc_result (end_soma)
       │
       ▼
  fifo_data_out, fifo_valid (CPU readout)
```

---

## 3. Interface com tdc_linux128

O **tdc_linux128** mede o intervalo entre dois pulsos:

| Sinal   | Origem           | Descrição                                |
|---------|------------------|------------------------------------------|
| PulseA  | tx_reference     | Primeira borda de subida do DDS quando valid=1 |
| PulseB  | edge_detect      | Borda de subida do eco (rx_in)           |
| end_soma| tdc_linux128     | Resultado (15 bits) usado no evento      |

- **PulseA**: uma vez por passo de frequência (primeira borda do burst em cada dwell)
- **PulseB**: cada eco recebido
- **Tempo total**: combinação de fase DDS + resultado do TDC

---

## 4. Módulos

### 4.1 sync_2ff

- Função: reduzir metastabilidade em sinal assíncrono.
- Saída: `sync_out` = `async_in` atrasado em 2 ciclos de clock.

### 4.2 edge_detect

- Função: detectar borda de subida.
- Entrada: `sig` (síncrona, preferencialmente após sync_2ff).
- Saída: pulso de 1 ciclo em `rise` quando `sig` vai de 0→1.

### 4.3 tx_reference

- Função: gerar PulseA para o TDC.
- Lógica: primeira borda de subida de `dds_out` com `dds_valid=1` em cada dwell.
- Reset: quando `dds_valid` volta a 0.

### 4.4 phase_capture

- Função: amostrar fase do DDS no instante do eco.
- Trigger: borda do eco (PulseB).
- Saída: `phase_sample`, `valid` por 1 ciclo.

### 4.5 event_fifo

- Função: buffer de eventos para leitura pela CPU.
- Formato: `{ 9'b0, tdc[14:0], phase[31:0], step[7:0] }` = 64 bits.
- Controle: `wr_en`, `rd_en`, flags `empty` e `full`.
- Overflow: escrita bloqueada quando `full=1`.

---

## 5. Pipeline TDC

O `tdc_linux128` estabiliza o resultado alguns ciclos após PulseB. O RX frontend:

1. Ao eco (PulseB): captura `phase` e `step`.
2. Aguarda `TDC_LATENCY` ciclos (4 por padrão).
3. Escreve na FIFO: `{ step, phase, tdc_result }`.

Ajuste `TDC_LATENCY` se o TDC demorar mais que 4 ciclos a 200 MHz.

---

## 6. Domínio de Clock

- RX frontend: **200 MHz** (mesmo clock do DDS).
- `rx_in`: assíncrono → sincronizado com sync_2ff.
- FIFO: 200 MHz; leitura pela CPU deve usar bridge de domínio (ex.: FIFO assíncrona) se o CPU rodar em 25 MHz.

---

## 7. Formato do Evento na FIFO

| Bits     | Campo  | Descrição                                      |
|----------|--------|------------------------------------------------|
| [7:0]    | step   | Índice do sweep (-20 a +20, armazenado como 0–40) |
| [39:8]   | phase  | Fase do DDS (32 bits) no instante do eco       |
| [54:40]  | tdc    | end_soma (15 bits) do tdc_linux128            |
| [63:55]  | —      | Reservado (zeros)                              |

---

## 8. Integração no Projeto

### 8.1 Alterações no DDS

O `dds_top` expõe:

- `phase[31:0]`
- `step_index[7:0]`
- `dds_valid`

O `dds_sweep` expõe:

- `step_index_out`

### 8.2 Conexões em pulpino_qsys_test

```verilog
// DDS com saídas para RX
wire [31:0] dds_phase;
wire signed [7:0] dds_step;

dds_top u_dds (
    .clk_200   (clk_200),
    .rst       (~reset_n),
    .start     (dds_start),
    .dds_out   (dds_out),
    .phase     (dds_phase),
    .step_index(dds_step),
    .dds_valid (dds_valid)
);

// RX Frontend
wire rx_pulse_a, rx_pulse_b;
wire [63:0] rx_fifo_data;
wire rx_fifo_valid, rx_fifo_empty, rx_fifo_full;

rx_frontend_top u_rx (
    .clk         (clk_200),
    .rst         (~reset_n),
    .rx_in       (GPIO_0[11]),      // pino do envelope detector
    .dds_phase   (dds_phase),
    .dds_step    (dds_step),
    .dds_out     (dds_out),
    .dds_valid   (dds_valid),
    .tdc_result  (tdc_end),         // end_soma do TDC
    .pulse_a     (rx_pulse_a),
    .pulse_b     (rx_pulse_b),
    .fifo_rd_en  (/* do PIO ou lógica */),
    .fifo_data_out (rx_fifo_data),
    .fifo_valid  (rx_fifo_valid),
    .fifo_empty  (rx_fifo_empty),
    .fifo_full   (rx_fifo_full)
);

// TDC – usar saídas do RX quando em modo SAW
wire tdc_pulse_a_sel = rx_mode ? rx_pulse_a : tdc_pulse_a_gpio;
wire tdc_pulse_b_sel = rx_mode ? rx_pulse_b : tdc_pulse_b_gpio;

tdc_linux128 u_tdc (
    .reset   (reset_n),
    .PulseA  (tdc_pulse_a_sel),
    .PulseB  (tdc_pulse_b_sel),
    .end_soma(tdc_end)
);
```

### 8.3 Entrada do RX

- `rx_in`: sinal digital do detector de envelope (comparador externo).
- Nível esperado: LVTTL 3,3 V.
- Recomendações: resistor de proteção, diodos de clamp, evitar sinais fora da faixa de entrada.

---

## 9. Limitações e Trade-offs

### 9.1 Incerteza de fase

- A fase é amostrada no mesmo ciclo em que o eco é detectado.
- O eco real pode ocorrer dentro de um período de clock (5 ns @ 200 MHz).
- Incerteza aproximada: ~0,3 ciclo do DDS a 60 MHz.

### 9.2 Eco múltiplos

- O detector de borda captura apenas a primeira borda de subida.
- Para vários reflectores, seria necessário contador de bordas ou outra lógica específica.

### 9.3 FIFO e leitura

- FIFO síncrona a 200 MHz.
- Leitura por CPU em domínio de clock diferente exige ponte (FIFO assíncrona ou handshake).
- `fifo_full`: eventos descartados se não houver leitura; pode-se adicionar contador de overflow.

---

## 10. Integração Atual (pulpino_qsys_test)

O RX frontend está conectado com:

- **RX_SAW_MODE** = 1 (parâmetro): usa `pulse_a`/`pulse_b` do RX para o TDC
- **rx_in**: GPIO_0[11]
- **DDS start**: KEY[1]
- **fifo_rd_en**: 1'b0 (CPU pode ser conectado via PIO para leitura)
- Para modo manual do TDC (GPIO/adapter), altere `RX_SAW_MODE` para 0

---

## 11. Arquivos do RX Frontend

| Arquivo          | Descrição                          |
|------------------|------------------------------------|
| sync_2ff.v       | Sincronizador 2 FFs                |
| edge_detect.v    | Detector de borda de subida        |
| tx_reference.v   | Geração de PulseA a partir do DDS  |
| phase_capture.v  | Captura de fase no eco             |
| event_fifo.v     | FIFO de eventos (64 bits)         |
| rx_frontend_top.v| Integração dos módulos             |
