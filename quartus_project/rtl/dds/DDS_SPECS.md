# Especificações do DDS – Sistema de Interrogação SAW

## 1. Parâmetros do Sistema

| Parâmetro            | Valor      | Descrição                          |
|---------------------|-----------|------------------------------------|
| Clock do sistema    | 200 MHz   | Proveniente do PLL (CLOCK_50 × 4)  |
| Frequência central  | 60 MHz    | Centro do sweep para SAW           |
| Span                | ±100 kHz  | Variação em torno do centro        |
| Passo de frequência | 5 kHz     | Resolução do sweep                 |
| Largura do acumulador | 32 bits | Resolução de fase                  |
| Número de passos    | 41        | De 59,9 MHz a 60,1 MHz em 5 kHz    |

---

## 2. Fórmula do FTW (Frequency Tuning Word)

Para um DDS com acumulador de N bits e clock f_clk:

```
FTW = (f_out / f_clk) × 2^N
```

### Valores calculados (N=32, f_clk=200 MHz)

| Frequência      | FTW           | Hex        |
|-----------------|---------------|------------|
| 60 MHz (centro) | 1 288 490 189 | 0x4CCCCCCD |
| 5 kHz (passo)   | 107 374       | 0x0001A36E |
| 59,9 MHz (mín)  | 1 286 342 709 | —          |
| 60,1 MHz (máx)  | 1 290 637 669 | —          |

---

## 3. Arquitetura

```
                    ┌─────────────────────┐
     ftw ──────────►│  phase_accumulator   │
     enable ──────►│  (32 bits)           │
                    │  phase <= phase+ftw  │
                    └──────────┬──────────┘
                               │
                               ▼
                    dds_out = phase[31]   (MSB → onda quadrada)
```

- **Saída em onda quadrada**: apenas o MSB do acumulador é usado, reduzindo área e simplificando o layout.
- **Controle por enable**: quando `enable=0`, o acumulador não avança, permitindo manter frequência fixa durante o dwell.

---

## 4. Decisões de Projeto

### 4.1 Uso de onda quadrada (MSB)

- **Motivo**: menor uso de recursos e menor jitter na geração de frequência.
- **Limitação**: harmônicas ímpares presentes; filtragem RF externa deve ser usada se necessário.

### 4.2 Sweep simétrico centrado em zero

- `step_index` vai de `-(num_steps-1)/2` a `+(num_steps-1)/2` (ex.: -20 a +20).
- FTW calculado como `ftw_center + step_index × ftw_step`.
- Multiplicação usa `$signed(step_index)` para tratar corretamente índices negativos.

### 4.3 Largura de `ftw_step`

- `STEP_WIDTH = 32` para garantir que FTW_STEP = 107 374 (17 bits) seja representado.
- Evita truncamento e mantém o passo em exatamente 5 kHz.

### 4.4 Ciclo de gap entre passos

- Um ciclo com `valid=0` entre RUN e NEXT.
- Impacto mínimo em 200 MHz (~5 ns por transição).
- Aceitável para interrogação SAW com dwell >> 1 ciclo.

### 4.5 Descontinuidade de fase ao mudar FTW

- Ao trocar FTW, o acumulador mantém o valor, mas o incremento muda.
- Pode gerar glitch pontual na onda quadrada.
- Considerado aceitável para aplicação SAW; alternativa seria suavização de fase se necessário.

### 4.6 Dwell por etapa

- `dwell_cycles = 20 000` ciclos a 200 MHz ≈ 100 μs por frequência.
- Total do sweep: 41 × 100 μs ≈ 4,1 ms.
- Ajustável via parâmetro para diferentes regimes de interrogação.

---

## 5. Interface dos Módulos

### dds_core

| Porta   | Direção | Descrição                          |
|---------|---------|------------------------------------|
| clk     | input   | Clock 200 MHz                      |
| rst     | input   | Reset síncrono                     |
| ftw     | input   | Frequency Tuning Word (32 bits)     |
| enable  | input   | Habilita acumulação                |
| dds_out | output  | Onda quadrada (MSB do acumulador)  |
| phase   | output  | Valor atual do acumulador (debug)  |

### dds_sweep

| Porta       | Direção | Descrição                                      |
|-------------|---------|------------------------------------------------|
| clk         | input   | Clock 200 MHz                                  |
| rst         | input   | Reset síncrono                                 |
| start       | input   | Inicia sweep                                   |
| ftw_center  | input   | FTW do centro (60 MHz)                          |
| ftw_step    | input   | FTW do passo (5 kHz)                            |
| num_steps   | input   | Número de passos (ex.: 41)                       |
| dwell_cycles| input   | Ciclos por frequência                           |
| ftw_out     | output  | FTW atual                                      |
| valid       | output  | 1 quando ftw_out é válido                       |
| done        | output  | 1 quando sweep completo                        |

### dds_top

| Porta    | Direção | Descrição                     |
|----------|---------|-------------------------------|
| clk_200  | input   | Clock 200 MHz do PLL         |
| rst      | input   | Reset (sugestão: ~(reset_n & pll_locked)) |
| start    | input   | Inicia sweep                  |
| dds_out  | output  | Sinal de saída                |

---

## 6. Integração no Projeto

O `dds_top` deve ser instanciado em `pulpino_qsys_test.v` com:

- `clk_200` ← `clk_200` (saída do PLL)
- `rst` ← `~(reset_n & pll_locked)` (reset que depende do PLL travado)
- `start` ← controlado por software (PIO) ou lógica externa

A saída `dds_out` pode ser enviada a um driver LVDS ou buffer antes de sair pelas I/Os.

---

## 7. Referências

- FTW para N bits: FTW = f_out × 2^N / f_clk
- Clock do projeto: PLL 50 MHz → 25 MHz (Pulpino) e 200 MHz (DDS/TDC)
