#include "acess_structs.h"
#include "debbuging.h"
#include "mem_map.h"
#include <stdint.h>

// Cast address to uint32 register.
#define REG(addr)            (*((volatile uint32_t*) (addr)))

// Memory region used as a counting variable.
#define COUNT                (REG(0x02000000))

#define JTAG_UART_DATA        (JTAG + 0x0)
#define JTAG_UART_CONTROL     (JTAG + 0x4)
#define JTAG_UART_WSPACE_MASK 0xFFFF0000u

#define GPIO_0_DATA           (GPIO_0 + 0x0)
#define GPIO_0_DIR            (GPIO_0 + 0x4)

#define FREQ_VALUE_MASK       0xFFFFu

static void jtag_putc(char c){
	while ((REG(JTAG_UART_CONTROL) & JTAG_UART_WSPACE_MASK) == 0u) { }
	REG(JTAG_UART_DATA) = (uint32_t)c;
}

// Slow write: small delay between characters to avoid FIFO overruns.
static void jtag_puts_slow(const char *s){
	while (*s) {
		jtag_putc(*s++);
		for (volatile uint32_t i = 0; i < 2000u; ++i) { }
	}
}

static void jtag_put_dec(uint32_t value){
	char buf[11];
	int idx = 10;
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

static void jtag_put_hex32(uint32_t value){
	static const char hex_digits[] = "0123456789ABCDEF";
	for (int shift = 28; shift >= 0; shift -= 4) {
		uint32_t nibble = (value >> shift) & 0xFu;
		jtag_putc(hex_digits[nibble]);
	}
}

static void set_leds_with_jtag(uint32_t value, const char *tag){
	static uint32_t last_led = 0xFFFFFFFFu;

	/* Preserva PIO_OUT[31:10] (start/ack em [30:29], etc.); só mexe nos bits dos LEDs [9:0]. */
	uint32_t merged = (REG(PIO_OUT) & ~0x3FFu) | (value & 0x3FFu);
	REG(PIO_OUT) = merged;
	if ((value & 0x3FFu) != (last_led & 0x3FFu)) {
		last_led = value;
		jtag_puts_slow("LED ");
		jtag_puts_slow(tag);
		jtag_puts_slow(": 0x");
		jtag_put_hex32(value & 0x3FFu);
		jtag_puts_slow("\r\n");
	}
}

static void timer_start_period(uint32_t period_ticks){
	// Stop timer
	REG(TIMER + 0x4) = 0u;
	// Load period
	REG(TIMER + 0x8) = (uint32_t)(period_ticks & 0xFFFFu);
	REG(TIMER + 0xC) = (uint32_t)((period_ticks >> 16) & 0xFFFFu);
	// Clear timeout status
	REG(TIMER) = 0u;
	// Start in continuous mode (START=1, CONT=1)
	REG(TIMER + 0x4) = 0x5u;
}

static void gpio_0_set_input_bit0(void){
	uint32_t dir = REG(GPIO_0_DIR);
	dir &= ~0x1u;
	REG(GPIO_0_DIR) = dir;
}

static void freq_pulse_start(void)
{
	uint32_t w = REG(PIO_OUT);
	REG(PIO_OUT) = w | (1u << FREQ_PIO_START_BIT);
	for (volatile uint32_t d = 0; d < 50u; d++) { }
	REG(PIO_OUT) = w & ~(1u << FREQ_PIO_START_BIT);
}

static void freq_ack(void)
{
	uint32_t w = REG(PIO_OUT);
	REG(PIO_OUT) = w | (1u << FREQ_PIO_ACK_BIT);
	for (volatile uint32_t d = 0; d < 50u; d++) { }
	REG(PIO_OUT) = w & ~(1u << FREQ_PIO_ACK_BIT);
}

static uint8_t freq_is_ready(void)
{
	return (REG(PIO_IN) & FREQ_PIO_READY_MASK) ? 1u : 0u;
}

static uint16_t freq_get(void)
{
	return (uint16_t)((REG(PIO_IN) >> FREQ_PIO_VALUE_SHIFT) & FREQ_VALUE_MASK);
}

static uint16_t freq_measure(void)
{
	while (freq_is_ready()) {
		freq_ack();
		for (volatile uint32_t d = 0; d < 200u; d++) { }
	}
	freq_pulse_start();
	/* Reserva: se o bitstream não tiver timeout HW, evita bloqueio infinito */
	uint32_t spins = 0u;
	while (!freq_is_ready()) {
		if (++spins > 500000000u) {
			return 0u;
		}
	}
	uint16_t f = freq_get();
	freq_ack();
	return f;
}

static void jtag_hint_gpio0_vs_counter(uint16_t hz_from_counter)
{
	uint32_t a = REG(GPIO_0_DATA) & 0x1u;
	for (volatile uint32_t i = 0; i < 400000u; i++) { }
	uint32_t b = REG(GPIO_0_DATA) & 0x1u;
	jtag_puts_slow("  [diag] Contador=");
	jtag_put_dec((uint32_t)hz_from_counter);
	jtag_puts_slow(" Hz; GPIO_0[0] leitura CPU: ");
	jtag_putc((char)('0' + (a & 1u)));
	jtag_puts_slow(" -> apos atraso: ");
	jtag_putc((char)('0' + (b & 1u)));
	if (a != b) {
		jtag_puts_slow(" (mudou; entrada chega ao soft-GPIO)\r\n");
	} else {
		jtag_puts_slow(
		    " (igual; se esperava onda, verifique nivel, polaridade ou pin/header)\r\n");
	}
}

__attribute__((unused)) static uint32_t
count_gpio_0_bit0_rising_edges(uint32_t gate_ticks){
	uint32_t count = 0;
	uint32_t prev = REG(GPIO_0_DATA) & 0x1u;

	timer_start_period(gate_ticks);
	while ((REG(TIMER) & 0x1u) == 0u) {
		uint32_t cur = REG(GPIO_0_DATA) & 0x1u;
		if (cur != prev) {
			if (cur != 0u) {
				count++;
			}
			prev = cur;
		}
	}
	REG(TIMER) = 0u;

	return count;
}

/*
 * Debugging with LEDs
 *
 * Timer interrupt is configured for interrupt number 2.
 * Snippets of code are identified by their main number 0x0X,
 * followed by a step number 0x0-X.
 *
 * Example: step 4 of snippet A is indicated by 0x0A4.
 */

/*
 * Setup 32TIMER for interrupts:
 * - Uses bit 3 in the CONTROL register (offset 0x04).
 * - Writes time to 16-bit regions PERIODL (0x08) and PERIODH (0x0C).
 * - Clears the first bit of the CONTROL register to clean interrupts.
 * - Activates counting (START=1) in single-shot mode (CONT=0) with ITO=1.
 *
 * Debugging LED format: 0x0A-
 */
void setup_timer_interruption(void){
	DEBUG(0x0A0);

	// Stop counter
	REG(TIMER+0x4) |= (1<<3);
	DEBUG(0x0A1);


	// Set time period (very slow so LEDs are visible).
	uint32_t period_full = MS2CYCLES(1000000);
	REG(TIMER+0x8) =  (  period_full & 0xFFFF );
	REG(TIMER+0xC) =  (( period_full >> 16 ) & 0xFFFF );
	DEBUG(0x0A2);


	// Clear old timer interrupts.
	REG(TIMER) &= ~(1);
	DEBUG(0x0A3);


	// Activate counting in repeating mode: (START=1; CONT=1; ITO=1) => 5.
	uint32_t cleaned_value = REG(TIMER+0x4) & (~ 5);
	REG(TIMER+0x4) = cleaned_value | 5;
	DEBUG(0x0A4);
}


/*
 * Enable interrupts in the interrupt controller:
 * - Clears enabled interrupts.
 * - Sets IRP mask for interrupt 2 (timer).
 * - Sets mstatus to enable global interrupts.
 *
 * Debugging LED format: 0x0B-
 */
void enable_irq(void){
	DEBUG(0x0B0);


	// Clear enabled interrupts.
	REG(ICP) = 0xFFFFFFFF;
	DEBUG(0x0B1);


	// Set IRP mask for interrupt 2 (timer).
	REG(IRP)     = (1<< 2);
	DEBUG(0x0B2);


	// Set mstatus to 8.
	__asm__(
		"li x6, 0x00000008\n"
		"csrs mstatus, x6"
	);
	DEBUG(0x0B3);
}


/*
 * Interrupt handler for unexpected I/O interrupts (INT_NUM = 2).
 * Lights up all LEDs and clears interrupts.
 */
void __attribute__((interrupt)) null_handler(void){
	REG(ICP) = 0xFFFFFFFF;
	set_leds_with_jtag(0x3FFu, "null");
}


/*
 * Interrupt handler for JTAG (INT_NUM = 0).
 * Clears the JTAG interrupt signal.
 */
void __attribute__((interrupt)) jtag_interrupt_handler(void){
	// Clear the interrupt.
	REG(ICP) = (1 << 0);
}



/*
 * Timer interrupt handler under test (INT_NUM = 2).
 */
void __attribute__((interrupt)) interrupt_test_handler(void){
	DEBUG(0x200);
	
	// Clear interrupt on the interrupt controller.
	REG(ICP) = (1 << 2);
	REG(TIMER+4) |= ~1;
	DEBUG(0x201);
	
	// Clear timeout bit in the timer.
	REG(TIMER) |= ~1;
	DEBUG(0x202);

	set_leds_with_jtag(COUNT, "timer");
	if(COUNT==7){
		COUNT = 0;
	} else {
		COUNT ++;
	}
}


int main(int argc, char **argv){
	// Setup process.
	COUNT = 0;

	DEBUG(0x0D0);
	// Disable interrupts and timer for a clear image-check pattern.
	REG(IRP) = 0x0;

	DEBUG(0x0D1);
	DEBUG(0x0FF);

	/* GPIO_0[0] = entrada (sinal a medir), mesmo net do contador recíproco */
	gpio_0_set_input_bit0();

	jtag_puts_slow("Reciprocal freq (GPIO_0[0]), 25 MHz ref, N=2000 periods\r\n");

	while (1) {
		uint16_t f = freq_measure();
		if (f == 0u) {
			jtag_puts_slow(
			    "Sem sinal medido (0 Hz): timeout HW (~4 s 1.ª borda / ~10 s medição) ou SW. "
			    "Verifique pin V12 (GPIO_0[0]), GND, 3v3 LVTTL.\r\n");
			jtag_hint_gpio0_vs_counter(f);
		} else {
			jtag_puts_slow("Freq: ");
			jtag_put_dec((uint32_t)f);
			jtag_puts_slow(" Hz\r\n");
		}
		set_leds_with_jtag((uint32_t)f & 0x3FFu, "freq");
	}
	return 0;
}
