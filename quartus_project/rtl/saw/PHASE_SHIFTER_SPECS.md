# Phase Shifter (Carry-Chain) – Especificações

## Objetivo

Permitir o teste do TDC comparando o sinal de 160 MHz (referência) com uma cópia defasada do mesmo sinal. A defasagem é gerada por uma **linha de atraso baseada em carry logic** do Cyclone V.

## Princípio

- **Carry chain**: o sinal propaga pela cadeia de carry de full adders.
- Cada estágio implementa `1 + 0 + cin` → `cout = cin`, usando a carry chain do ALM.
- Atraso por estágio: ~40–60 ps (Cyclone V).
- **128 taps** (0–127), ~4.9 ns por tap, tap 127 ≈ 625 ns (período 1.6 MHz).
- Cada tap = 98 estágios de carry chain (~50 ps/estágio).

## Interface

| Porta     | Direção | Descrição                            |
|-----------|---------|--------------------------------------|
| `sig_in`  | input   | Sinal de entrada (ex.: clk 160 MHz) |
| `tap_sel` | input   | Seleção do tap (0 = sem atraso)      |
| `sig_out` | output  | Sinal atrasado do tap selecionado    |

## Parâmetros

| Parâmetro   | Padrão | Descrição                    |
|-------------|--------|------------------------------|
| NUM_STAGES  | 127    | Comprimento da cadeia        |
| TAP_BITS    | 7      | Largura de `tap_sel`         |

## Uso no projeto

O barramento `tap_sel` é ligado ao Pulpino (PIO_OUT); o valor é definido em software.

- **PIO_OUT[14:8]** = `tap_sel` (0–127).
- **PIO_OUT[15]** = 1: modo de teste (RX = saída do phase shifter).

Com isso:
- **PulseA** = referência (TX / clk).
- **PulseB** = clk atrasado pelo phase shifter.
- **TDC** mede o atraso entre as bordas.

## Sinais no osciloscópio (quando `phase_test_en=1`)

| Pino   | Pino DE10-Nano | Sinal  |
|--------|----------------|--------|
| GPIO_1[34] | JP7 pin 39 (AE19) | PulseA (TDC start) |
| GPIO_1[35] | JP7 pin 40 (AE17) | PulseB (TDC stop) |

Conectar as sondas do osciloscópio para observar a janela de medida do TDC.

## Forçar carry chain (RTL)

O Quartus pode rotear a entrada como clock global, o que destrói a linha de atraso.
RTL: (1) `sig_in` passa por LUT (`sig_in ? 1'b1 : 1'b0`); (2) `(* altera_attribute = "-name AUTO_CARRY_CHAINS ON" *)` no módulo.
Nota: `GLOBAL_SIGNAL OFF` não pode ser usado – a mesma rede alimenta outros clocks do design.

## Interpretação

- `tap_sel` maior → atraso maior → valor do TDC cresce.
- A curva TDC vs `tap_sel` permite calibrar o LSB do TDC.
- A cada período (~6,25 ns) o TDC “dá a volta” (ambiguidade de fase).
