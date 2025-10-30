#include <stdio.h>
#include <stdint.h>

// Cast address to uint_32 register
#define REG(addr) (*((volatile uint32_t*) (addr)))

//Base peripheral addresses
#define JTAG_BASE                           0x00100010
#define PIO_OUT                             0x00200000
#define PIO_IN                              0x00200020
#define TIMER                               0x00200040
#define PULPINO_BASE                        0x10000000
#define SOC_PERIPHERALS_BASE              ( 0x0A100000 + PULPINO_BASE )
#define EVENT_UNIT_BASE                   ( 0X00004000 + SOC_PERIPHERALS_BASE )
#define IRP                               ( 0x00000000 + EVENT_UNIT_BASE )
#define ICP                               ( 0x0000000C + EVENT_UNIT_BASE )

/*===== Simple math for timer frequency ==== 
	Timer frequency is around the same as the input clock (after PLL),
	the PLL output is configured for 25MHz, that is 40ns.

	To get to 1ms we have (1/40)x(10^-3)/(10^-9), that is 2,5 x 10^4
	or, 25000 timer cycles per milisecond
*/
#define timer_conversion_factor							25000
/* 
	Since the counter only counts to N-1 and not to N itself we need to subtract 1,
	let's handle this with a macro.
*/
#define MS2CYCLES(n)												(((n)*(timer_conversion_factor))-1)
//===============================================


/* ===== Comments about Debbuging with LEDs ======
	Timer interrupt is configured for the interrupt number 2

	Snippets of code are indentifies by their main number 0x0X-
	followed by a number indicating a step 0x0-X

	Example: step 4 of snippet A is indicated by 0x0A4
	================================================= */




/* 
  Function to setup 32TIMER for interruptions:
	- uses the bit 3 in the CONRTOL register (offset 0x04)
	- writes time to 16 bit regions PERIODL (0x8) and PERIODH (0xC)
	- cleans first bit of CONTROL register to clean interrupts in the peripheral
	- Activates counting (START=1), in the single shot mode (CONT=0) and (ITO=1)
	
	Debugging LED format: 0x0A-
*/
void setup_timer_interruption(void){
	REG(PIO_OUT) = 0x0A0;


	// Stop counter
	REG(TIMER+0x4) |= (1<<3);
	REG(PIO_OUT) = 0x0A1;


	// set time period
	uint32_t period_full = MS2CYCLES(50000);
	REG(TIMER+0x8) =  (  period_full & 0xFFFF );
	REG(TIMER+0xC) =  (( period_full >> 16 ) & 0xFFFF );
	REG(PIO_OUT) = 0x0A2;


	// Clear old timer interrupts
	REG(TIMER) &= ~(1);
	REG(PIO_OUT) = 0x0A3;


	// Activate counting in single shot mode
	// (START = 1 ; CONT = 0 ; ITO =1) => 3
	uint32_t cleaned_value = REG(TIMER+0x4) & (~ 3);
	REG(TIMER+0x4) = cleaned_value | 5;
	REG(PIO_OUT) = 0x0A4;
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
	REG(PIO_OUT) = 0x0B0;


	// Clear enabled interruptions
	REG(ICP)     = 0xFFFFFFFF;
	REG(PIO_OUT) = 0x0B1;


	// Set IRP mask for interrupt 2
	REG(IRP)     = (1<< 2);
	REG(PIO_OUT) = 0x0B2;


	// Set mstatus to 8
	__asm__(
			"li x6, 0x00000008\n"
			"csrs mstatus, x6"
	);
	REG(PIO_OUT) = 0x0B3;
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
	Interrupt handler being tested, timer interrupts
	INT_NUM = 1

	Debbuging LEDs format : 0x20-
	(Leading 2 and 3 turns LEDR[9] on, so it's easy to see in waveform)
*/
void __attribute__((interrupt)) interrupt_test_handler(void){
	REG(PIO_OUT) = 0x200;
	
	// clears interrupt on the interrupt constroler
	REG(ICP) = (1 << 2);
	REG(PIO_OUT) = 0x201;
	
	//clears timeout bit in the timer
	REG(TIMER) |= ~1;
	REG(PIO_OUT) = 0x202;
}


int main(int argc, char **argv){
	
	// Setup process 
	REG(PIO_OUT) = 0x0D0;
	enable_irq();
	REG(PIO_OUT) = 0x0D1;
	setup_timer_interruption();
	REG(PIO_OUT) = 0x0FF;
	
	// infinite loop
	while (1){}
	return 0;
}
