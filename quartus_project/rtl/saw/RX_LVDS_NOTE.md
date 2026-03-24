# RX LVDS on DE10-Nano – Limitações

## Tentativa de configuração LVDS

O Pin Planner permitiu selecionar LVDS para o pino RX (saw_rx_p), com:
- **Positivo:** PIN_AH13 (GPIO_0[5], JP6 pin 6)
- **Negativo:** PIN_AG14 (GPIO_0[11], JP6 pin 11)

## Erros do Fitter

1. **AH13 não suporta entrada diferencial** – O pino não dispõe de buffer LVDS.
2. **Banco 4A usa VCCIO 3,3 V** – LVDS exige 2,5 V. O header GPIO da DE10-Nano está em 3,3 V.

## Conclusão

O header GPIO (JP6) da DE10-Nano usa banco I/O com 3,3 V. LVDS requer 2,5 V e buffers diferenciais específicos, que não existem nesses pinos.

**Solução:** Manter RX em single-ended 3,3-V LVTTL e usar um **comparador externo** para sinais pequenos (ex.: 700 mV pp).
