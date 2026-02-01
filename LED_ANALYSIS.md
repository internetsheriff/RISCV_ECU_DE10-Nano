# Análise: Por Que 4 LEDs Estão Ativos?

## Observação do Usuário
**"Vejo 4 LEDs na contagem"**

## Análise do Código

### Código Atual
```c
void interrupt_test_handler(void){
    REG(PIO_OUT) = COUNT;  // Escreve COUNT nos LEDs
    
    if(COUNT==7){
        COUNT = 0;  // Reinicia após 7
    } else {
        COUNT ++;   // Incrementa
    }
}
```

### Sequência Esperada (0-7)
| COUNT | Binário | LEDs Acesos | Número de LEDs |
|-------|---------|-------------|----------------|
| 0 | 00000000 | Nenhum | 0 |
| 1 | 00000001 | LED[0] | 1 |
| 2 | 00000010 | LED[1] | 1 |
| 3 | 00000011 | LED[0], LED[1] | 2 |
| 4 | 00000100 | LED[2] | 1 |
| 5 | 00000101 | LED[0], LED[2] | 2 |
| 6 | 00000110 | LED[1], LED[2] | 2 |
| 7 | 00000111 | LED[0], LED[1], LED[2] | **3** |

**Teoricamente:** Máximo de **3 LEDs** deveriam estar ativos.

## Possíveis Explicações para 4 LEDs

### 1. Contador Indo Além de 7

Se o contador for até **15** (0x0F), teríamos:
- COUNT = 15 → `00001111` → LEDs [0, 1, 2, 3] = **4 LEDs**

**Causa possível:**
- Bug na lógica do contador
- Condição de corrida (race condition)
- COUNT não sendo resetado corretamente

### 2. Valores que Acendem 4 LEDs

| COUNT | Binário | LEDs Acesos |
|-------|---------|-------------|
| 15 | 00001111 | [0, 1, 2, 3] |
| 14 | 00001110 | [1, 2, 3] |
| 13 | 00001101 | [0, 2, 3] |
| 12 | 00001100 | [2, 3] |
| 11 | 00001011 | [0, 1, 3] |
| 10 | 00001010 | [1, 3] |
| 9 | 00001001 | [0, 3] |
| 8 | 00001000 | [3] |

**Se o contador vai de 0 a 15:**
- LEDs 0, 1, 2, 3 seriam utilizados
- **4 LEDs ativos** no máximo

### 3. Problema na Lógica do Contador

**Código atual:**
```c
REG(PIO_OUT) = COUNT;  // Escreve primeiro

if(COUNT==7){
    COUNT = 0;
} else {
    COUNT ++;
}
```

**Possível problema:**
Se houver uma interrupção entre `REG(PIO_OUT) = COUNT;` e o incremento, ou se o COUNT não for resetado corretamente, ele pode continuar incrementando além de 7.

### 4. Verificação do Valor Real

Para confirmar qual valor está sendo escrito, seria necessário:
1. Verificar o valor de COUNT em tempo de execução
2. Verificar se o contador realmente reinicia em 7
3. Verificar se há outras partes do código modificando COUNT

## Solução: Verificar o Comportamento Real

### Opção 1: Adicionar Debug
Modificar o código para verificar o valor máximo de COUNT:

```c
void interrupt_test_handler(void){
    REG(PIO_OUT) = COUNT;
    
    // Debug: verificar se COUNT > 7
    if(COUNT > 7) {
        // COUNT está indo além do esperado!
        // Poderia escrever um valor fixo para indicar erro
    }
    
    if(COUNT==7){
        COUNT = 0;
    } else {
        COUNT ++;
    }
}
```

### Opção 2: Limitar Explicitamente
Garantir que COUNT nunca exceda 7:

```c
void interrupt_test_handler(void){
    // Limitar COUNT a 0-7
    COUNT = COUNT & 0x07;  // Máscara para manter apenas bits 0-2
    
    REG(PIO_OUT) = COUNT;
    
    if(COUNT==7){
        COUNT = 0;
    } else {
        COUNT ++;
    }
}
```

### Opção 3: Verificar Hardware
Pode ser que o hardware esteja interpretando os valores de forma diferente, ou há algum problema na conexão dos LEDs.

## Conclusão

**Se você está vendo 4 LEDs consistentemente:**
- O contador provavelmente está indo até **15** (0x0F) em vez de parar em 7
- Isso acenderia LEDs [0, 1, 2, 3] = **4 LEDs**
- A lógica `if(COUNT==7)` pode não estar funcionando corretamente

**Próximos passos:**
1. Verificar se o contador realmente reinicia em 7
2. Adicionar proteção para limitar COUNT a 0-7
3. Verificar se há condições de corrida ou problemas de sincronização
