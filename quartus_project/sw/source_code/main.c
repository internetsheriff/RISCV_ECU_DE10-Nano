/*
 * Pulpino — TDC com duas ondas quadradas externas (~160 MHz)
 *
 * Cabo o gerador:
 *   GPIO_0[1] (PIN_E8  JP1) -> PulseA
 *   GPIO_1[1] (PIN_AC24 JP2) -> PulseB
 *
 * Firmware: GPIO_0/GPIO_1 data_dir = 0 (entradas). Imprime média do TDC a cada 1 s
 * enquanto ajusta a defasagem no gerador.
 *
 * O TDC usa PulseA ^ PulseB como enable (delta_medida); duas quadradas mesma f
 * bastam para a leitura depender da fase relativa (ver comentário no top .v).
 */

#include "mem_map.h"

void __attribute__((interrupt)) jtag_interrupt_handler(void) { }
void __attribute__((interrupt)) null_handler(void) { }
void __attribute__((interrupt)) interrupt_test_handler(void) { }
#include <stdint.h>

#define REG(addr)  (*((volatile uint32_t*)(addr)))

#define JTAG_UART_DATA     (JTAG + 0x0)
#define JTAG_UART_CONTROL  (JTAG + 0x4)
#define JTAG_UART_WSPACE_MASK  0xFFFF0000u

#define TDC_BIT_SHIFT  2
#define TDC_BIT_MASK   0x7FFFu   /* 15 bits */

#define CYCLES_PER_SEC  (25000000u)

static void jtag_putc(char c)
{
    while ((REG(JTAG_UART_CONTROL) & JTAG_UART_WSPACE_MASK) == 0u) { }
    REG(JTAG_UART_DATA) = (uint32_t)c;
}

static void jtag_puts_slow(const char *s)
{
    while (*s) {
        jtag_putc(*s++);
        for (volatile uint32_t i = 0; i < 2000u; ++i) { }
    }
}

static void jtag_put_dec(uint32_t value)
{
    char buf[12];
    int idx = 11;
    buf[idx--] = '\0';

    if (value == 0u) {
        jtag_putc('0');
        return;
    }

    while (value > 0u && idx >= 0) {
        buf[idx--] = (char)('0' + (value % 10u));
        value /= 10u;
    }

    jtag_puts_slow(&buf[idx + 1]);
}

static void timer_start_period(uint32_t period_ticks)
{
    REG(TIMER + 0x4) = 0u;
    REG(TIMER + 0x8) = (uint32_t)(period_ticks & 0xFFFFu);
    REG(TIMER + 0xC) = (uint32_t)((period_ticks >> 16) & 0xFFFFu);
    REG(TIMER) = 0u;
    REG(TIMER + 0x4) = 0x5u;  /* START=1, CONT=1 */
}

/* PulseA/B nos pinos [1]: periférico deve estar em entrada em todo o porto. */
static void gpio_peripheral_init(void)
{
    REG(GPIO_0 + 0x4) = 0u;
    REG(GPIO_1 + 0x4) = 0u;
}

int main(void)
{
    gpio_peripheral_init();
    REG(PIO_OUT) = 0u;

    jtag_puts_slow("=== TDC ext phase: GPIO_0[1]=A, GPIO_1[1]=B (LVTTL 3.3V) ===\r\n");

    uint32_t sec = 0u;
    while (1) {
        sec++;
        timer_start_period(CYCLES_PER_SEC - 1u);
        uint64_t tdc_sum = 0u;
        uint32_t tdc_count = 0u;

        while ((REG(TIMER) & 0x1u) == 0u) {
            uint32_t pio_in = REG(PIO_IN);
            tdc_sum += (uint64_t)((pio_in >> TDC_BIT_SHIFT) & TDC_BIT_MASK);
            tdc_count++;
        }
        REG(TIMER) = 0u;

        uint32_t tdc_avg = (tdc_count > 0u)
            ? (uint32_t)(tdc_sum / (uint64_t)tdc_count) : 0u;

        jtag_puts_slow("sec=");
        jtag_put_dec(sec);
        jtag_puts_slow(" TDC_avg=");
        jtag_put_dec(tdc_avg);
        jtag_puts_slow("\r\n");
    }
    return 0;
}
