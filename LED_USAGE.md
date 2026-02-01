# LEDs Utilizados pelo Software

## Análise do Código

### Código do Software

**Arquivo:** `quartus_project/sw/source_code/main.c`

```c
void __attribute__((interrupt)) interrupt_test_handler(void){
    // ...
    REG(PIO_OUT) = COUNT;  // Escreve valor do contador nos LEDs
    
    if(COUNT==7){
        COUNT = 0;  // Reinicia após 7
    } else {
        COUNT ++;   // Incrementa
    }
}
```

**Variável COUNT:**
- **Tipo:** Variável de 32 bits (uint32_t)
- **Valores:** 0, 1, 2, 3, 4, 5, 6, 7 (ciclo)
- **Escrita:** `REG(PIO_OUT) = COUNT;` → Escreve o valor diretamente em PIO_OUT

### Mapeamento Hardware

**Arquivo:** `quartus_project/rtl/pulpino_qsys_test.v`

```verilog
wire [31:0] gpio_out;
assign LED [7:0] = gpio_out [7:0];  // LEDs 0-7 conectados a gpio_out[7:0]
```

**Conexão:**
- `PIO_OUT[31:0]` → `gpio_out[31:0]` → `LED[7:0]`
- Apenas os **8 bits menos significativos** (bits 0-7) são conectados aos LEDs físicos

---

## LEDs Utilizados

### Valores do Contador e LEDs Correspondentes

| COUNT | Binário (8 bits) | Hexadecimal | LEDs Acesos | LEDs Utilizados |
|-------|------------------|-------------|-------------|-----------------|
| **0** | `0000 0000` | `0x00` | Nenhum | - |
| **1** | `0000 0001` | `0x01` | LED[0] | ✅ LED[0] |
| **2** | `0000 0010` | `0x02` | LED[1] | ✅ LED[1] |
| **3** | `0000 0011` | `0x03` | LED[1], LED[0] | ✅ LED[1], LED[0] |
| **4** | `0000 0100` | `0x04` | LED[2] | ✅ LED[2] |
| **5** | `0000 0101` | `0x05` | LED[2], LED[0] | ✅ LED[2], LED[0] |
| **6** | `0000 0110` | `0x06` | LED[2], LED[1] | ✅ LED[2], LED[1] |
| **7** | `0000 0111` | `0x07` | LED[2], LED[1], LED[0] | ✅ LED[2], LED[1], LED[0] |

### Resumo

**LEDs Ativos (Utilizados):**
- ✅ **LED[0]** - Bit menos significativo (LSB)
- ✅ **LED[1]** - Segundo bit
- ✅ **LED[2]** - Terceiro bit

**LEDs Inativos (Nunca Utilizados):**
- ❌ **LED[3]** - Sempre apagado
- ❌ **LED[4]** - Sempre apagado
- ❌ **LED[5]** - Sempre apagado
- ❌ **LED[6]** - Sempre apagado
- ❌ **LED[7]** - Sempre apagado

---

## Padrão de Ativação

### Representação Binária

O contador implementa uma **contagem binária crescente** de 0 a 7:

```
Estado 0: 0000 0000 → Nenhum LED
Estado 1: 0000 0001 → LED[0] apenas
Estado 2: 0000 0010 → LED[1] apenas
Estado 3: 0000 0011 → LED[1] + LED[0]
Estado 4: 0000 0100 → LED[2] apenas
Estado 5: 0000 0101 → LED[2] + LED[0]
Estado 6: 0000 0110 → LED[2] + LED[1]
Estado 7: 0000 0111 → LED[2] + LED[1] + LED[0]
```

### Visualização Temporal

```
Tempo →    0     1     2     3     4     5     6     7     8
          ─────────────────────────────────────────────────────
LED[7]     ─     ─     ─     ─     ─     ─     ─     ─     ─
LED[6]     ─     ─     ─     ─     ─     ─     ─     ─     ─
LED[5]     ─     ─     ─     ─     ─     ─     ─     ─     ─
LED[4]     ─     ─     ─     ─     ─     ─     ─     ─     ─
LED[3]     ─     ─     ─     ─     ─     ─     ─     ─     ─
LED[2]     ─     ─     ─     █     ─     █     █     █     ─
LED[1]     ─     ─     █     █     ─     ─     █     █     ─
LED[0]     ─     █     ─     █     ─     █     ─     █     ─
          ─────────────────────────────────────────────────────
COUNT      0     1     2     3     4     5     6     7     0
```

Legenda: `─` = LED apagado, `█` = LED aceso

---

## Por Que Apenas 3 LEDs?

### Limitação do Contador

O contador vai de **0 a 7**, que são exatamente **8 valores** (2³ = 8).

Para representar valores de 0 a 7 em binário, são necessários apenas **3 bits**:
- Bit 0 (LSB): LED[0]
- Bit 1: LED[1]
- Bit 2: LED[2]

### Bits Superiores

Os bits 3-7 do valor de COUNT sempre serão **zero** porque:
- COUNT nunca excede 7 (valor máximo: `0b0000 0111`)
- Bits 3-7 são sempre `0` na representação binária de 0-7

Portanto, **LED[3] a LED[7] nunca serão ativados** pelo software atual.

---

## Para Usar Mais LEDs

### Opção 1: Aumentar o Limite do Contador

Modificar o código para contar até 15 ou 255:

```c
// Contar até 15 (4 bits = 16 valores)
if(COUNT==15){
    COUNT = 0;
} else {
    COUNT ++;
}
```

**Resultado:** LEDs 0, 1, 2, 3 seriam utilizados (contagem binária 0-15)

```c
// Contar até 255 (8 bits = 256 valores)
if(COUNT==255){
    COUNT = 0;
} else {
    COUNT ++;
}
```

**Resultado:** Todos os 8 LEDs seriam utilizados (contagem binária 0-255)

### Opção 2: Padrão Diferente

Implementar um padrão diferente que utilize mais LEDs, como:
- Sequência de "onda" (LEDs acendendo em sequência)
- Padrão de "Knight Rider" (varredura)
- Contador hexadecimal (0-255)

---

## Resumo

### LEDs Utilizados pelo Software Atual

✅ **LED[0]** - Bit menos significativo (LSB)  
✅ **LED[1]** - Segundo bit  
✅ **LED[2]** - Terceiro bit  

**Total: 3 LEDs ativos de 8 disponíveis**

### LEDs Não Utilizados

❌ **LED[3]** - Sempre apagado  
❌ **LED[4]** - Sempre apagado  
❌ **LED[5]** - Sempre apagado  
❌ **LED[6]** - Sempre apagado  
❌ **LED[7]** - Sempre apagado  

**Total: 5 LEDs inativos**

### Motivo

O contador implementa uma **contagem binária de 0 a 7**, que requer apenas **3 bits** (LEDs 0, 1, 2). Os bits superiores (3-7) sempre são zero, então os LEDs correspondentes nunca são ativados.

---

## Referências

- **Código do Handler:** `quartus_project/sw/source_code/main.c` (linha 136)
- **Mapeamento Hardware:** `quartus_project/rtl/pulpino_qsys_test.v` (linha 39)
- **Análise Completa:** `LED_BEHAVIOR.md`
