/*
 * Pulpino SAW Interrogator - TDC readout via UART
 *
 * TDC linearity test: 5 pontos (40/80/120/160/200 ns), 5 s cada, média por segundo.
 * Usa clock 25 MHz: 1/2/3/4/5 ciclos = 40/80/120/160/200 ns.
 *
 * PIO_IN mapping:
 *   [1:0]    = KEY[1:0]
 *   [16:2]   = tdc_end (15-bit ToF)
 *   [17]     = saw_done
 *   [27:18]  = rx_edge_count (edges in 2 µs, diagnostic)
 *
 * PIO_OUT (software):
 *   [7:0]   = LED[7:0]
 *   [14:8]  = tap_sel (0..127, phase shifter tap)
 *   [15]    = phase_test_en (1 = 1.6 MHz + delay line)
 *   [16]    = tdc_cal_mode (1 = PulseA/PulseB por ciclos 25 MHz)
 *   [19:17] = delay_sel (cal: 0-4; min: 0-5)
 *   [20]    = tdc_min_mode (1 = limites mínimos @ 160 MHz)
 *   [21]    = tdc_phase_mode (1 = defasagem ~60 ps–6 ns, tap em [14:8])
 *
 * Scope debug: PulseA/PulseB em GPIO_1[34]/[35] (JP7)
 */

#include "mem_map.h"

/* Stub handlers required by crt0.boot.S vector table (unused in polling mode) */
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
#define RX_EDGE_SHIFT  18
#define RX_EDGE_MASK   0x3FFu    /* 10 bits */

#define PHASE_TEST_EN   (1u << 15)   /* PIO_OUT bit 15 */
#define TDC_CAL_MODE    (1u << 16)   /* PIO_OUT bit 16 */
#define TDC_MIN_MODE    (1u << 20)   /* PIO_OUT bit 20 */
#define TDC_PHASE_MODE  (1u << 21)   /* PIO_OUT bit 21 */
#define TAP_SHIFT       8            /* PIO_OUT[14:8] = tap_sel */
#define DELAY_SEL_SHIFT 17           /* PIO_OUT[19:17] */
#define TAP_MAX         127u

static uint32_t pio_out_shadow;  /* shadow para merge com LED */

/* Preserva LED, tap, phase_test; zera [20:16] antes de aplicar modo TDC (evita bit 20 preso). */
#define PIO_KEEP_MASK  ((0xFFu) | (TAP_MAX << TAP_SHIFT) | PHASE_TEST_EN)

/** Define delay_sel e enable tdc_cal (25 MHz). Desliga tdc_min (bit 20). */
static void set_tdc_cal_delay(uint32_t delay_sel)
{
	pio_out_shadow = (pio_out_shadow & PIO_KEEP_MASK) | TDC_CAL_MODE |
		((delay_sel & 7u) << DELAY_SEL_SHIFT);
	REG(PIO_OUT) = pio_out_shadow;
}

/** Define delay_sel e enable tdc_min (160 MHz). Desliga tdc_cal (bit 16). */
static void set_tdc_min_delay(uint32_t delay_sel)
{
	pio_out_shadow = (pio_out_shadow & PIO_KEEP_MASK) | TDC_MIN_MODE |
		((delay_sel & 7u) << DELAY_SEL_SHIFT);
	REG(PIO_OUT) = pio_out_shadow;
}

/** Modo fase: tap 0..127 na carry fina (~50 ps/estágio). Desliga cal/min. */
static void set_tdc_phase_fine_tap(uint32_t tap)
{
	pio_out_shadow = (pio_out_shadow & ((0xFFu) | PHASE_TEST_EN)) |
		((tap & 127u) << TAP_SHIFT) | TDC_PHASE_MODE;
	REG(PIO_OUT) = pio_out_shadow;
}

/* Pulpino sys clock: 25 MHz. 25M cycles = 1 second. */
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

static void gpio_0_set_all_inputs(void)
{
	REG(GPIO_0 + 0x4) = 0u;
}

/* Linearidade: 40, 80, 120, 160, 200 ns (1..5 ciclos @ 25 MHz) */
static const uint32_t CAL_DELAY_NS[5] = {40u, 80u, 120u, 160u, 200u};

/* Limites mínimos: ~6.25, 12.5, 18.75, 25, 31.25, 37.5 ns (1..6 ciclos @ 160 MHz) */
static const uint32_t MIN_DELAY_NS[6] = {6u, 13u, 19u, 25u, 31u, 38u};  /* rounded */

/* Fase 160 MHz: 10 pontos ~60 ps a 6 ns (tap linear na carry fina ~50 ps/estágio) */
static const uint8_t  PHASE_TAP[10]  = {1u, 14u, 28u, 41u, 54u, 67u, 80u, 94u, 107u, 120u};
static const uint32_t PHASE_PS_NOM[10] = {60u, 720u, 1380u, 2040u, 2700u, 3360u, 4020u, 4680u, 5340u, 6000u};

static void run_phase_interval(uint32_t tap, uint32_t nom_ps, uint32_t sec,
	uint64_t tdc_sum, uint32_t tdc_count, uint32_t rx_sum)
{
	uint32_t tdc_avg = (tdc_count > 0u) ? (uint32_t)(tdc_sum / (uint64_t)tdc_count) : 0u;
	uint32_t rx_avg  = (tdc_count > 0u) ? (rx_sum / tdc_count) : 0u;

	jtag_puts_slow("phase tap=");
	jtag_put_dec(tap);
	jtag_puts_slow(" nom_ps=");
	jtag_put_dec(nom_ps);
	jtag_puts_slow(" sec=");
	jtag_put_dec(sec);
	jtag_puts_slow(" TDC=");
	jtag_put_dec(tdc_avg);
	jtag_puts_slow(" RXe=");
	jtag_put_dec(rx_avg);
	jtag_puts_slow("\r\n");
}

static void run_test_interval(uint32_t delay_ns, uint32_t sec,
	uint64_t tdc_sum, uint32_t tdc_count, uint32_t rx_sum)
{
	uint32_t tdc_avg = (tdc_count > 0u) ? (uint32_t)(tdc_sum / (uint64_t)tdc_count) : 0u;
	uint32_t rx_avg  = (tdc_count > 0u) ? (rx_sum / tdc_count) : 0u;

	jtag_puts_slow("delay_ns: ");
	jtag_put_dec(delay_ns);
	jtag_puts_slow(" sec: ");
	jtag_put_dec(sec);
	jtag_puts_slow(" TDC: ");
	jtag_put_dec(tdc_avg);
	jtag_puts_slow(" RXe: ");
	jtag_put_dec(rx_avg);
	jtag_puts_slow("\r\n");
}

int main(void)
{
	gpio_0_set_all_inputs();
	pio_out_shadow = 0u;

	uint32_t sec;

	while (1) {
		/* --- Defasagem sub-ns @ 160 MHz (10 pontos ~60 ps a 6 ns), 5 s cada --- */
		jtag_puts_slow("=== TDC PHASE 160MHz (60ps-6ns) ===\r\n");
		uint32_t ph_idx;
		for (ph_idx = 0u; ph_idx < 10u; ph_idx++) {
			set_tdc_phase_fine_tap((uint32_t)PHASE_TAP[ph_idx]);
			for (sec = 1u; sec <= 5u; sec++) {
				timer_start_period(CYCLES_PER_SEC - 1u);
				uint64_t tdc_sum = 0u;
				uint32_t tdc_count = 0u;
				uint32_t rx_sum = 0u;

				while ((REG(TIMER) & 0x1u) == 0u) {
					uint32_t pio_in = REG(PIO_IN);
					tdc_sum  += (uint64_t)((pio_in >> TDC_BIT_SHIFT) & TDC_BIT_MASK);
					rx_sum   += (uint32_t)((pio_in >> RX_EDGE_SHIFT) & RX_EDGE_MASK);
					tdc_count++;
				}
				REG(TIMER) = 0u;
				run_phase_interval((uint32_t)PHASE_TAP[ph_idx], PHASE_PS_NOM[ph_idx],
					sec, tdc_sum, tdc_count, rx_sum);
			}
		}

		/* --- Teste de limites mínimos: 6 pontos, 5 s cada --- */
		jtag_puts_slow("=== TDC MIN (6.25-37.5 ns) ===\r\n");
		uint32_t min_idx;
		for (min_idx = 0u; min_idx < 6u; min_idx++) {
			uint32_t delay_ns = MIN_DELAY_NS[min_idx];
			set_tdc_min_delay(min_idx);

			for (sec = 1u; sec <= 5u; sec++) {
				timer_start_period(CYCLES_PER_SEC - 1u);
				uint64_t tdc_sum = 0u;
				uint32_t tdc_count = 0u;
				uint32_t rx_sum = 0u;

				while ((REG(TIMER) & 0x1u) == 0u) {
					uint32_t pio_in = REG(PIO_IN);
					tdc_sum  += (uint64_t)((pio_in >> TDC_BIT_SHIFT) & TDC_BIT_MASK);
					rx_sum   += (uint32_t)((pio_in >> RX_EDGE_SHIFT) & RX_EDGE_MASK);
					tdc_count++;
				}
				REG(TIMER) = 0u;
				run_test_interval(delay_ns, sec, tdc_sum, tdc_count, rx_sum);
			}
		}

		/* --- Teste de linearidade: 5 pontos, 5 s cada --- */
		jtag_puts_slow("=== TDC LIN (40-200 ns) ===\r\n");
		uint32_t cal_idx;
		for (cal_idx = 0u; cal_idx < 5u; cal_idx++) {
			uint32_t delay_ns = CAL_DELAY_NS[cal_idx];
			set_tdc_cal_delay(cal_idx);

			for (sec = 1u; sec <= 5u; sec++) {
				timer_start_period(CYCLES_PER_SEC - 1u);
				uint64_t tdc_sum = 0u;
				uint32_t tdc_count = 0u;
				uint32_t rx_sum = 0u;

				while ((REG(TIMER) & 0x1u) == 0u) {
					uint32_t pio_in = REG(PIO_IN);
					tdc_sum  += (uint64_t)((pio_in >> TDC_BIT_SHIFT) & TDC_BIT_MASK);
					rx_sum   += (uint32_t)((pio_in >> RX_EDGE_SHIFT) & RX_EDGE_MASK);
					tdc_count++;
				}
				REG(TIMER) = 0u;
				run_test_interval(delay_ns, sec, tdc_sum, tdc_count, rx_sum);
			}
		}
	}
	return 0;
}
