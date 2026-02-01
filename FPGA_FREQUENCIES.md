# Frequências de Operação - FPGA e Contador

## 1. Frequência de Operação da FPGA

### Clock de Entrada (Board)
- **CLOCK_50:** 50 MHz
- **Fonte:** Oscilador da placa DE10-Nano
- **Pino:** `PIN_V11` (conforme pin assignments)

### PLL (Phase-Locked Loop)

**Configuração do PLL:**
- **Arquivo:** `quartus_project/pll/pll_0002.v`
- **Referência:** 50 MHz (CLOCK_50)
- **Saída:** 25 MHz (clk25)
- **Divisor:** 2:1 (50 MHz ÷ 2 = 25 MHz)

```verilog
.reference_clock_frequency("50.0 MHz"),
.output_clock_frequency0("25.000000 MHz"),
```

### Frequência de Operação do Sistema

**Clock do PULPino (clk25):**
- **Frequência:** **25 MHz**
- **Período:** **40 ns** (1 / 25.000.000 Hz = 40 × 10⁻⁹ s)
- **Uso:** Clock principal do processador RISC-V e todos os periféricos

**Hierarquia de Clocks:**
```
CLOCK_50 (50 MHz) → PLL → clk25 (25 MHz) → PULPino + Periféricos
```

---

## 2. Velocidade do Contador Implementado via Software

### Configuração do Timer

**Arquivo:** `quartus_project/sw/source_code/main.c`

```c
uint32_t period_full = MS2CYCLES(1);  // Configura período
```

**Arquivo:** `quartus_project/sw/source_code/debbuging.h`

```c
#define DEBUG_FLAG  // ⚠️ ATIVO no código atual

#ifdef DEBUG_FLAG
    #define timer_conversion_factor 10
#else
    #define timer_conversion_factor 25000
#endif

#define MS2CYCLES(n) (((n)*(timer_conversion_factor))-1)
```

### Cálculo do Período do Timer

**Com DEBUG_FLAG ativo (modo atual):**
- `timer_conversion_factor = 10`
- `MS2CYCLES(1) = (1 × 10) - 1 = 9 ciclos`
- **Período do timer:** 9 ciclos × 40 ns = **360 ns = 0.36 µs**
- **Frequência de interrupção:** 1 / 0.36 µs = **2.78 MHz**

**Sem DEBUG_FLAG (modo produção):**
- `timer_conversion_factor = 25000`
- `MS2CYCLES(1) = (1 × 25000) - 1 = 24999 ciclos`
- **Período do timer:** 24999 ciclos × 40 ns = **999.96 µs ≈ 1 ms**
- **Frequência de interrupção:** 1 / 1 ms = **1 kHz**

### Comportamento do Contador

**Handler de Interrupção:**
```c
void interrupt_test_handler(void){
    REG(PIO_OUT) = COUNT;  // Atualiza LEDs com valor do contador
    
    if(COUNT==7){
        COUNT = 0;  // Reinicia após 7
    } else {
        COUNT ++;   // Incrementa
    }
}
```

**Sequência do Contador:**
```
0 → 1 → 2 → 3 → 4 → 5 → 6 → 7 → 0 → 1 → ...
```

### Velocidade do Contador

**Com DEBUG_FLAG ativo (modo atual):**

| Parâmetro | Valor |
|-----------|-------|
| **Período entre incrementos** | 0.36 µs |
| **Frequência de incremento** | 2.78 MHz |
| **Duração de cada estado (0-7)** | 0.36 µs |
| **Duração do ciclo completo (0→7→0)** | 2.88 µs (8 × 0.36 µs) |
| **Taxa de repetição do ciclo** | **347 kHz** (1 / 2.88 µs) |
| **Ciclos completos por segundo** | **347.000 ciclos/s** |

**Sem DEBUG_FLAG (modo produção):**

| Parâmetro | Valor |
|-----------|-------|
| **Período entre incrementos** | 1 ms |
| **Frequência de incremento** | 1 kHz |
| **Duração de cada estado (0-7)** | 1 ms |
| **Duração do ciclo completo (0→7→0)** | 8 ms (8 × 1 ms) |
| **Taxa de repetição do ciclo** | **125 Hz** (1 / 8 ms) |
| **Ciclos completos por segundo** | **125 ciclos/s** |

---

## 3. Resumo Comparativo

### Frequências do Sistema

| Componente | Frequência | Período |
|------------|------------|---------|
| **Clock da placa (CLOCK_50)** | 50 MHz | 20 ns |
| **Clock do PLL (clk25)** | 25 MHz | 40 ns |
| **Clock do PULPino** | 25 MHz | 40 ns |

### Velocidade do Contador

| Modo | Período Timer | Freq. Interrupção | Ciclo Completo | Taxa Repetição |
|------|--------------|-------------------|-----------------|----------------|
| **DEBUG_FLAG (atual)** | 0.36 µs | 2.78 MHz | 2.88 µs | **347 kHz** |
| **Produção** | 1 ms | 1 kHz | 8 ms | **125 Hz** |

---

## 4. Observações Importantes

### Modo DEBUG_FLAG (Atual)

**Características:**
- ⚠️ **Extremamente rápido:** 347.000 ciclos por segundo
- ⚠️ **Não visível ao olho humano:** Persistência visual não consegue acompanhar
- ⚠️ **Efeito visual:** LEDs aparecem constantemente acesos (LEDs 0, 1, 2)
- ✅ **Útil para debug:** Acelera testes e simulações

**Razão do DEBUG_FLAG:**
- Acelera o timer em **27.750 vezes** (25000 ÷ 10 = 2500, mas considerando o -1, ~27.750×)
- Permite testar o sistema muito mais rápido em simulação
- Reduz tempo de espera durante desenvolvimento

### Modo Produção (Sem DEBUG_FLAG)

**Características:**
- ✅ **Visível ao olho humano:** 125 Hz é perceptível
- ✅ **Padrão binário observável:** Contagem de 0 a 7 visível
- ✅ **Adequado para demonstração:** Efeito visual claro

**Para ativar modo produção:**
1. Comentar `#define DEBUG_FLAG` em `debbuging.h`
2. Recompilar: `make compile-source-code generate-memory reload-memory`
3. Reprogramar: `make program-sof`

---

## 5. Cálculos Detalhados

### Clock do Sistema
```
f_clk = 25 MHz
T_clk = 1 / 25.000.000 = 40 × 10⁻⁹ s = 40 ns
```

### Timer com DEBUG_FLAG
```
timer_conversion_factor = 10
MS2CYCLES(1) = (1 × 10) - 1 = 9 ciclos
T_timer = 9 × 40 ns = 360 ns = 0.36 µs
f_timer = 1 / 0.36 µs = 2.777.778 Hz ≈ 2.78 MHz
```

### Ciclo do Contador
```
Estados: 0, 1, 2, 3, 4, 5, 6, 7 (8 estados)
T_ciclo = 8 × 0.36 µs = 2.88 µs
f_ciclo = 1 / 2.88 µs = 347.222 Hz ≈ 347 kHz
```

### Timer sem DEBUG_FLAG
```
timer_conversion_factor = 25000
MS2CYCLES(1) = (1 × 25000) - 1 = 24999 ciclos
T_timer = 24999 × 40 ns = 999.960 ns ≈ 1 ms
f_timer = 1 / 1 ms = 1.000 Hz = 1 kHz
```

### Ciclo do Contador (Produção)
```
T_ciclo = 8 × 1 ms = 8 ms
f_ciclo = 1 / 8 ms = 125 Hz
```

---

## 6. Referências

- **PLL Configuration:** `quartus_project/pll/pll_0002.v`
- **Timer Setup:** `quartus_project/sw/source_code/main.c`
- **Timer Conversion:** `quartus_project/sw/source_code/debbuging.h`
- **Top-Level Module:** `quartus_project/rtl/pulpino_qsys_test.v`

---

## Conclusão

**Frequência de Operação da FPGA:** **25 MHz** (gerado pelo PLL a partir de 50 MHz)

**Velocidade do Contador (modo atual):**
- **Incremento:** A cada **0.36 µs** (2.78 MHz)
- **Ciclo completo:** A cada **2.88 µs** (347 kHz)
- **Repetição:** **347.000 ciclos por segundo**

**Velocidade do Contador (modo produção):**
- **Incremento:** A cada **1 ms** (1 kHz)
- **Ciclo completo:** A cada **8 ms** (125 Hz)
- **Repetição:** **125 ciclos por segundo**
