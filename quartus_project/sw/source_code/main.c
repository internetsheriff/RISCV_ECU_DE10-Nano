#include "acess_structs.h"
#include "debbuging.h"
#include "mem_map.h"
#include <stdint.h>

// Cast address to uint_32 register
#define REG(addr)            (*((volatile uint32_t*) (addr)))

// memory region for counting "variable"
#define COUNT                (REG(0x02000000))

#define JTAG_UART_DATA        (JTAG + 0x0)
#define JTAG_UART_CONTROL     (JTAG + 0x4)
#define JTAG_UART_WSPACE_MASK 0xFFFF0000u

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

static void wait_timeout(void){
	while ((REG(TIMER) & 0x1u) == 0u) { }
	REG(TIMER) = 0u;
}


/* 
  ======= Comments about Debbuging with LEDs =======
	Timer interrupt is configured for the interrupt number 2

	Snippets of code are indentifies by their main number 0x0X-
	followed by a number indicating a step 0x0-X

	Example: step 4 of snippet A is indicated by 0x0A4
	==================================================
*/

/* 
  Function to setup 32TIMER for interruptions:
	- uses the bit 3 in the CONRTOL register (offset 0x04)
	- writes time to 16 bit regions PERIODL (0x8) and PERIODH (0xC)
	- cleans first bit of CONTROL register to clean interrupts in the peripheral
	- Activates counting (START=1), in the single shot mode (CONT=0) and (ITO=1)
	
	Debugging LED format: 0x0A-
*/
void setup_timer_interruption(void){
	DEBUG(0x0A0);

	// Stop counter
	REG(TIMER+0x4) |= (1<<3);
	DEBUG(0x0A1);


	// set time period (very slow so LEDs are visible)
	uint32_t period_full = MS2CYCLES(1000000);
	REG(TIMER+0x8) =  (  period_full & 0xFFFF );
	REG(TIMER+0xC) =  (( period_full >> 16 ) & 0xFFFF );
	DEBUG(0x0A2);


	// Clear old timer interrupts
	REG(TIMER) &= ~(1);
	DEBUG(0x0A3);


	// Activate counting in repeating mode
	// (START = 1 ; CONT = 1 ; ITO =1) => 5
	uint32_t cleaned_value = REG(TIMER+0x4) & (~ 5);
	REG(TIMER+0x4) = cleaned_value | 5;
	DEBUG(0x0A4);
}


/* 
  Function to enable interruptions, all, in the interrupt peripheral:
	- uses the bit 3 in the CONRTOL register (offset 0x04)
	- writes time to 16 bit regions PERIODL (0x8) and PERIODH (0xC)
	- cleans first bit of CONTROL register to clean interrupts in the peripheral
	- Activates counting (START=1), in the single shot mode (CONT=0) and (ITO=1)
	
	Debugging LED format: 0x0A-
*/
void enable_irq(void){
	DEBUG(0x0B0);


	// Clear enabled interruptions
	REG(ICP) = 0xFFFFFFFF;
	DEBUG(0x0B1);


	// Set IRP mask for interrupt 2 (timer)
	REG(IRP)     = (1<< 2);
	DEBUG(0x0B2);


	// Set mstatus to 8
	__asm__(
		"li x6, 0x00000008\n"
		"csrs mstatus, x6"
	);
	DEBUG(0x0B3);
}


/*
	Interrupt handler for unexpected IO interrupts 
	INT_NUM = 2

	Lights up all LEDs and cleans interrupts
*/
void __attribute__((interrupt)) null_handler(void){
	REG(ICP) = 0xFFFFFFFF;
	REG(PIO_OUT) = 0x3FF;
}


/*
	Interrupt handler for JTAG, cleans the JTAG interrupt signal 
	INT_NUM = 0 
*/
void __attribute__((interrupt)) jtag_interrupt_handler(void){
	// Clean the interruprt
	REG(ICP) = (1 << 0);
}



/*
	Interrupt handler betng tested, timer interrupts
	INT_NUM = 2
*/
void __attribute__((interrupt)) interrupt_test_handler(void){
	DEBUG(0x200);
	
	// clears interrupt on the interrupt constroler
	REG(ICP) = (1 << 2);
	REG(TIMER+4) |= ~1;
	DEBUG(0x201);
	
	// clears timeout bit in the timer
	REG(TIMER) |= ~1;
	DEBUG(0x202);

	REG(PIO_OUT) = COUNT;
	if(COUNT==7){
		COUNT = 0;
	} else {
		COUNT ++;
	}
}


int main(int argc, char **argv){
	// Setup process
	COUNT = 0;

	DEBUG(0x0D0);
	// Disable interrupts and timer for a clear image-check pattern
	REG(IRP) = 0x0;
	DEBUG(0x0D1);
	DEBUG(0x0FF);
	
	// Configure timer for ~1s period (50 MHz clock)
	timer_start_period(50000000u - 1u);

	// infinite loop
	while (1){
		REG(PIO_OUT) = 0xF0u;
		wait_timeout();
		REG(PIO_OUT) = 0x0Fu;
		wait_timeout();
		DEBUG(0x3FF);
	}
	return 0;
}
