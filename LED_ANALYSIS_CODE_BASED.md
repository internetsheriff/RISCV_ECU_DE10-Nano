# Análise dos LEDs - Baseada no Código Fonte

## Arquivos Analisados

- `quartus_project/sw/source_code/main.c`
- `quartus_project/sw/source_code/crt0.boot.S`
- `quartus_project/sw/source_code/mem_map.h`
- `quartus_project/sw/source_code/debbuging.h`

---

## 1. Definições e Inicialização

### COUNT (Variável do Contador)
```c
#define COUNT (REG(0x02000000))
```
- **Tipo:** Variável em memória mapeada (endereço 0x02000000)
- **Inicialização:** `COUNT = 0;` na linha 148 de `main()`
- **Uso:** Armazena o valor do contador (0 a 7)

### PIO_OUT (Registrador de Saída)
```c
#define PIO_OUT 0x00200000
```
- **Endereço:** 0x00200000
- **Função:** Controla os LEDs através de `REG(PIO_OUT)`

---

## 2. Handlers que Escrevem em PIO_OUT

### a) `interrupt_test_handler()` - Handler Principal

**Localização:** `main.c`, linhas 124-143  
**Vetor de Interrupção:** INT2 (0x08) - Timer  
**Código:**
```c
void __attribute__((interrupt)) interrupt_test_handler(void){
    REG(ICP) = (1 << 2);
    REG(TIMER+4) |= ~1;
    REG(TIMER) |= ~1;
    
    REG(PIO_OUT) = COUNT;  // ← Escreve COUNT nos LEDs
    
    if(COUNT==7){
        COUNT = 0;  // Reinicia após 7
    } else {
        COUNT ++;   // Incrementa
    }
}
```

**Comportamento Esperado:**
- Escreve o valor de COUNT em PIO_OUT
- COUNT incrementa: 0 → 1 → 2 → 3 → 4 → 5 → 6 → 7 → 0 → ...
- **Máximo teórico:** COUNT = 7 → 3 LEDs (bits 0, 1, 2)

### b) `null_handler()` - Handler de Interrupções Inesperadas

**Localização:** `main.c`, linhas 100-103  
**Vetor de Interrupção:** INT1 (0x04)  
**Código:**
```c
void __attribute__((interrupt)) null_handler(void){
    REG(ICP) = 0xFFFFFFFF;
    REG(PIO_OUT) = 0x3FF;  // ← Escreve 0x3FF nos LEDs
}
```

**Valor 0x3FF:**
- `0x3FF` = 1023 decimal = `0b001111111111` (11 bits)
- Considerando apenas 8 bits: `0x3FF & 0xFF` = `0xFF` = 255 = `0b11111111`
- **Efeito:** Acenderia **TODOS os 8 LEDs**

**Quando é chamado:**
- Interrupção INT1 (não configurada no código atual)
- Interrupções inesperadas

---

## 3. Configuração de Interrupções

### `enable_irq()` - Linhas 71-91

```c
void enable_irq(void){
    REG(ICP) = 0xFFFFFFFF;  // Limpa todas as interrupções pendentes
    REG(IRP) = (1 << 2);    // Máscara apenas para INT2 (timer)
    
    // Habilita interrupções globais
    __asm__(
        "li x6, 0x00000008\n"
        "csrs mstatus, x6"
    );
}
```

**Análise:**
- Apenas INT2 (timer) está habilitada via máscara `(1 << 2)`
- INT1 (`null_handler`) **não está habilitada** pela máscara
- `null_handler` só seria chamado se INT1 ocorresse por outra razão

---

## 4. Tabela de Vetores de Interrupção

**Arquivo:** `crt0.boot.S`, linhas 84-117

```assembly
.section .vectors, "ax"
.option norvc;

// INT0 (0x00)
.org 0x00
jal x0, jtag_interrupt_handler

// INT1 (0x04)
.org 0x04
jal x0, null_handler

// INT2 (0x08) - Timer
.org 0x08
jal x0, interrupt_test_handler
```

**Mapeamento:**
- **INT0 (0x00):** `jtag_interrupt_handler` - Não escreve em PIO_OUT
- **INT1 (0x04):** `null_handler` - Escreve `0x3FF` em PIO_OUT
- **INT2 (0x08):** `interrupt_test_handler` - Escreve `COUNT` em PIO_OUT

---

## 5. Sequência de Valores de COUNT

**Baseado no código fonte:**

| COUNT | Binário (8 bits) | LEDs Acesos | Número de LEDs |
|-------|-----------------|-------------|----------------|
| 0 | `00000000` | Nenhum | 0 |
| 1 | `00000001` | LED[0] | 1 |
| 2 | `00000010` | LED[1] | 1 |
| 3 | `00000011` | LED[0], LED[1] | 2 |
| 4 | `00000100` | LED[2] | 1 |
| 5 | `00000101` | LED[0], LED[2] | 2 |
| 6 | `00000110` | LED[1], LED[2] | 2 |
| 7 | `00000111` | LED[0], LED[1], LED[2] | **3** |

**Conclusão do código:** Máximo de **3 LEDs** deveriam estar ativos.

---

## 6. Análise: Por Que 4 LEDs Podem Estar Ativos

### Possibilidade 1: COUNT Indo Além de 7

**Se COUNT = 15 (0x0F):**
- Binário: `00001111`
- LEDs: [0, 1, 2, 3] = **4 LEDs** ✓

**Causa possível:**
- Bug na lógica `if(COUNT==7)` não funcionando corretamente
- Condição de corrida (race condition) entre leitura e escrita
- COUNT sendo modificado por outro código (não encontrado no código fonte)

### Possibilidade 2: `null_handler` Sendo Chamado

**Se `null_handler` escrever `0x3FF`:**
- `0x3FF & 0xFF` = `0xFF` = `11111111`
- Acenderia **todos os 8 LEDs**

**Mas se houver algum problema:**
- Se apenas os 4 bits menos significativos forem considerados: `0x3FF & 0x0F` = `0x0F` = `00001111`
- LEDs [0, 1, 2, 3] = **4 LEDs** ✓

**Quando poderia acontecer:**
- INT1 sendo disparada por algum motivo (não configurado no código)
- Interrupção inesperada

### Possibilidade 3: DEBUG() Interferindo

**Valores DEBUG no código:**
```c
DEBUG(0x3FF);  // Loop principal (linha 158)
DEBUG(0x0FF);  // Após setup_timer (linha 154)
```

**Análise:**
- `DEBUG()` escreve em `DEBUG_BASE_ADDR` (0x00300000), **não em PIO_OUT**
- `DEBUG()` não deveria afetar os LEDs
- **Conclusão:** Não é a causa

---

## 7. Conclusão Baseada no Código Fonte

### Comportamento Esperado (Código)

**Baseado apenas no código fonte analisado:**

1. **Handler principal:** `interrupt_test_handler()` escreve `COUNT` em `PIO_OUT`
2. **COUNT vai de 0 a 7:** Lógica `if(COUNT==7) COUNT = 0; else COUNT++;`
3. **Máximo de LEDs:** 3 LEDs (quando COUNT = 7)

### Observação do Usuário

**"Vejo 4 LEDs na contagem"**

### Possíveis Explicações (Baseadas no Código)

1. **COUNT indo até 15 (0x0F):**
   - Não explicado pelo código fonte atual
   - Poderia indicar bug na lógica de incremento ou condição de corrida

2. **`null_handler` sendo chamado ocasionalmente:**
   - INT1 não está habilitada pela máscara, mas poderia ocorrer
   - Escreveria `0x3FF`, mas se apenas 4 bits forem considerados = 4 LEDs

3. **Problema de hardware ou compilação:**
   - Não visível no código fonte
   - Poderia ser bug no compilador ou no hardware

### Valores que Acendem Exatamente 4 LEDs

**Baseado em análise binária:**
- COUNT = 15 (0x0F) → `00001111` → LEDs [0,1,2,3] = **4 LEDs** ✓
- COUNT = 12 (0x0C) → `00001100` → LEDs [2,3] = 2 LEDs
- COUNT = 11 (0x0B) → `00001011` → LEDs [0,1,3] = 3 LEDs
- COUNT = 10 (0x0A) → `00001010` → LEDs [1,3] = 2 LEDs
- COUNT = 9 (0x09) → `00001001` → LEDs [0,3] = 2 LEDs
- COUNT = 8 (0x08) → `00001000` → LED [3] = 1 LED

**Único valor que acende exatamente 4 LEDs:** COUNT = 15 (0x0F)

---

## 8. Referências no Código

### Linhas Relevantes

**main.c:**
- Linha 10: Definição de COUNT
- Linha 136: `REG(PIO_OUT) = COUNT;`
- Linhas 138-142: Lógica de incremento do contador
- Linha 102: `null_handler` escreve `0x3FF`
- Linha 81: Máscara de interrupção `(1 << 2)`

**crt0.boot.S:**
- Linha 96: `null_handler` mapeado para INT1
- Linha 100: `interrupt_test_handler` mapeado para INT2

---

## Resumo Final

**Baseado exclusivamente no código fonte:**

- **Código espera:** COUNT = 0 a 7 → Máximo 3 LEDs
- **Usuário observa:** 4 LEDs ativos
- **Possível causa:** COUNT indo até 15 (0x0F) ou `null_handler` sendo chamado
- **Não explicado pelo código:** Por que COUNT iria além de 7 com a lógica atual

**Recomendação:** Verificar o valor real de COUNT em tempo de execução ou adicionar proteção para limitar COUNT a 0-7.
