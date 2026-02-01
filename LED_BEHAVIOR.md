# Comportamento Esperado dos LEDs - Software Programado

## Resumo do Software

O software programado no FPGA implementa um **contador binário** que controla os LEDs através de **interrupções do timer**. O sistema incrementa um contador de 0 a 7 (ciclo) e exibe o valor em binário nos LEDs a cada interrupção do timer.

## Análise do Código

### 1. Configuração do Timer

**Arquivo:** `quartus_project/sw/source_code/main.c`

```c
void setup_timer_interruption(void){
    // Configura período do timer
    uint32_t period_full = MS2CYCLES(1);  // 1 milissegundo
    
    REG(TIMER+0x8) =  (  period_full & 0xFFFF );      // PERIODL (low)
    REG(TIMER+0xC) =  (( period_full >> 16 ) & 0xFFFF ); // PERIODH (high)
    
    // Modo contínuo (CONT=1), START=1, ITO=1 (interrupt on timeout)
    REG(TIMER+0x4) = ... | 5;  // (START=1 ; CONT=1 ; ITO=1) = 5
}
```

**Período do Timer:**
- **MS2CYCLES(1)** = (1 × timer_conversion_factor) - 1 ciclos
- **⚠️ IMPORTANTE:** O código está compilado **COM `DEBUG_FLAG` definido**
- **Com `DEBUG_FLAG`:** `timer_conversion_factor = 10` → **MS2CYCLES(1) = 9 ciclos**
- **Período real:** 9 ciclos × 40 ns = **0.36 microssegundos** (muito rápido!)
- Sem DEBUG_FLAG (produção): `timer_conversion_factor = 25000` → período = 1 ms

**Clock do Sistema:**
- Frequência: **25 MHz** (gerado pelo PLL a partir de CLOCK_50 = 50 MHz)
- Período do clock: **40 ns**
- **Com DEBUG_FLAG:** 9 ciclos × 40 ns = **360 ns entre interrupções** (2.78 milhões de interrupções/segundo!)

### 2. Handler de Interrupção do Timer

**Função:** `interrupt_test_handler()` (INT_NUM = 2)

```c
void __attribute__((interrupt)) interrupt_test_handler(void){
    // Limpa interrupção
    REG(ICP) = (1 << 2);
    REG(TIMER+4) |= ~1;
    REG(TIMER) |= ~1;
    
    // Atualiza LEDs com valor do contador
    REG(PIO_OUT) = COUNT;
    
    // Incrementa contador de 0 a 7, depois reinicia
    if(COUNT==7){
        COUNT = 0;
    } else {
        COUNT ++;
    }
}
```

**Comportamento:**
1. A cada interrupção do timer (**≈ 0.36 µs com DEBUG_FLAG**), o contador `COUNT` é escrito em `PIO_OUT`
2. `PIO_OUT` está conectado diretamente aos LEDs `LED[7:0]`
3. O contador incrementa de 0 a 7, depois volta para 0 (ciclo)

### 3. Mapeamento LEDs ↔ Contador

**Hardware:** `quartus_project/rtl/pulpino_qsys_test.v`

```verilog
wire [31:0] gpio_out;
assign LED [7:0] = gpio_out [7:0];  // LEDs 0-7 conectados a gpio_out[7:0]
```

**Valor Binário no Contador → LEDs:**

| COUNT | Binário | LED[7:0] | LEDs Acesos |
|-------|---------|----------|-------------|
| 0     | 0000 0000 | 0x00    | Nenhum      |
| 1     | 0000 0001 | 0x01    | LED[0]      |
| 2     | 0000 0010 | 0x02    | LED[1]      |
| 3     | 0000 0011 | 0x03    | LED[1], LED[0] |
| 4     | 0000 0100 | 0x04    | LED[2]      |
| 5     | 0000 0101 | 0x05    | LED[2], LED[0] |
| 6     | 0000 0110 | 0x06    | LED[2], LED[1] |
| 7     | 0000 0111 | 0x07    | LED[2], LED[1], LED[0] |

**Observação:** Como o contador vai de 0 a 7, apenas os LEDs 0, 1 e 2 são utilizados (bits menos significativos).

## Comportamento Esperado dos LEDs

### Sequência de Ativação (Ciclo Completo)

O ciclo completo tem **8 estados** (0 a 7):

**⚠️ COM DEBUG_FLAG:** Cada estado dura apenas **~0.36 microssegundos** (extremamente rápido!)

1. **Estado 0** (t=0 µs): Nenhum LED aceso → `0000 0000`
2. **Estado 1** (t≈0.36 µs): LED[0] aceso → `0000 0001`
3. **Estado 2** (t≈0.72 µs): LED[1] aceso → `0000 0010`
4. **Estado 3** (t≈1.08 µs): LED[1] + LED[0] acesos → `0000 0011`
5. **Estado 4** (t≈1.44 µs): LED[2] aceso → `0000 0100`
6. **Estado 5** (t≈1.80 µs): LED[2] + LED[0] acesos → `0000 0101`
7. **Estado 6** (t≈2.16 µs): LED[2] + LED[1] acesos → `0000 0110`
8. **Estado 7** (t≈2.88 µs): LED[2] + LED[1] + LED[0] acesos → `0000 0111`
9. **Repete:** Volta para o estado 0

**Ciclo completo dura apenas ~2.88 microssegundos!**

### Tempo Total do Ciclo

**⚠️ COM DEBUG_FLAG ATIVO:**
- **Duração de cada estado:** ~0.36 microssegundos (360 ns)
- **Duração do ciclo completo:** ~2.88 microssegundos
- **Taxa de repetição:** ~347.000 ciclos por segundo (347 kHz!)
- **Interrupções por segundo:** ~2.78 milhões de interrupções

**SEM DEBUG_FLAG (produção):**
- **Duração de cada estado:** ~1 milissegundo
- **Duração do ciclo completo:** ~8 milissegundos
- **Taxa de repetição:** ~125 ciclos por segundo

### Visualização

```
Tempo (ms)  │  0    1    2    3    4    5    6    7    8    9    10
────────────┼─────────────────────────────────────────────────────────
LED[7]      │  ─    ─    ─    ─    ─    ─    ─    ─    ─    ─    ─
LED[6]      │  ─    ─    ─    ─    ─    ─    ─    ─    ─    ─    ─
LED[5]      │  ─    ─    ─    ─    ─    ─    ─    ─    ─    ─    ─
LED[4]      │  ─    ─    ─    ─    ─    ─    ─    ─    ─    ─    ─
LED[3]      │  ─    ─    ─    ─    ─    ─    ─    ─    ─    ─    ─
LED[2]      │  ─    ─    ─    ─    ─    ─    ─    █    █    █    ─
LED[1]      │  ─    ─    █    █    ─    ─    █    █    ─    ─    █
LED[0]      │  ─    █    ─    █    ─    █    ─    █    ─    █    ─
────────────┴─────────────────────────────────────────────────────────
COUNT       │  0    1    2    3    4    5    6    7    0    1    2
```

Onde: `─` = LED apagado, `█` = LED aceso

### Comportamento Observável

**⚠️ IMPORTANTE: O código está compilado COM `DEBUG_FLAG` definido!**

**Comportamento Real (DEBUG_FLAG ativo):**
- O timer está configurado para **9 ciclos apenas** (0.36 µs por interrupção)
- O ciclo completo (0-7) dura apenas **~2.88 microssegundos**
- A taxa de repetição é **~347.000 ciclos por segundo** (347 kHz)
- **Efeito Visual Esperado:**
  - Devido à extrema velocidade, **os LEDs podem aparecer constantemente acesos** (LEDs 0, 1, 2)
  - Ou podem aparecer como um **"brilho constante"** sem mudanças perceptíveis
  - A persistência visual humana não consegue acompanhar mudanças tão rápidas (>100 kHz)
  - Pode haver um leve "flicker" ou "pulsação" se houver limitações de hardware
  
**Nota:** Com `DEBUG_FLAG`, o timer roda **27.750 vezes mais rápido** que no modo produção (10 vs 25000 ciclos). O objetivo deste modo é acelerar o teste para depuração, mas torna difícil observar o padrão visualmente.

**Se compilado SEM DEBUG_FLAG (produção):**
- Os LEDs **0, 1 e 2** acendem e apagam em um padrão **binário crescente**
- O padrão repete em **ciclos de ~8 ms**
- O efeito visual será uma **contagem binária visível** (~125 Hz)
- Devido à persistência visual, pode parecer que múltiplos LEDs estão acesos simultaneamente

## Verificação no Hardware

### O que Esperar ao Ligar a Placa:

**⚠️ ATENÇÃO: Com DEBUG_FLAG ativo (modo atual):**

1. **Após programar o FPGA:**
   - **LEDs 0, 1, 2 podem aparecer constantemente acesos** (devido à velocidade extrema)
   - Ou podem mostrar um **"brilho constante"** sem mudanças perceptíveis
   - LEDs 3-7 devem permanecer apagados
   - **Não será possível ver o padrão binário** devido à velocidade (347 kHz)

2. **Padrão de Contagem (lógico, mas não visualmente perceptível):**
   - Contagem binária de 0 a 7 repetindo
   - Transições extremamente rápidas (~0.36 µs entre estados)
   - Ciclo completo a cada ~2.88 µs

3. **Reset:**
   - **KEY[0]** é usado como reset (ativo em LOW)
   - Pressionar KEY[0] reinicia o sistema e apaga os LEDs
   - Soltar KEY[0] permite que o contador continue

**Para ver o padrão visualmente, seria necessário recompilar SEM DEBUG_FLAG:**
- Comentar ou remover `#define DEBUG_FLAG` em `debbuging.h`
- Recompilar o software: `make compile-source-code generate-memory reload-memory`
- Reprogramar o FPGA: `make program-sof`

### Comandos de Debug

Se quiser verificar o software carregado:

```bash
# Verificar arquivo ELF compilado
riscv64-unknown-elf-objdump -d quartus_project/sw/bundle.elf

# Verificar memória inicializada
hexdump -C quartus_project/sw/mem_init/sys_onchip_memory2_0.hex | head -20
```

## Modificações Possíveis

Para alterar o comportamento:

1. **Mudar velocidade:** Modificar `MS2CYCLES(1)` para `MS2CYCLES(n)` onde `n` é o período em milissegundos
2. **Usar mais LEDs:** Mudar o limite do contador de 7 para 15 ou 255
3. **Padrão diferente:** Modificar `interrupt_test_handler()` para gerar outros padrões

## Referências

- **Código fonte:** `quartus_project/sw/source_code/main.c`
- **Hardware:** `quartus_project/rtl/pulpino_qsys_test.v`
- **Mapeamento de memória:** `quartus_project/sw/source_code/mem_map.h`
