#include "acess_structs.h"
#include "debbuging.h"
#include "mem_map.h"
#include <stdint.h>

// Cast address to uint_32 register
#define REG(addr)            (*((volatile uint32_t*) (addr)))

// memory region for counting "variable"
#define COUNT                (REG(0x02000000))


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


	// set time period
	uint32_t period_full = MS2CYCLES(1);
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


	// Set IRP mask for interrupt 2
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
	INT_NUM = 1

	Debbuging LEDs format : 0x20-
	(Leading 2 and 3 turns LEDR[9] on, so it's easy to see in waveform)
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
	enable_irq();
	DEBUG(0x0D1);
	setup_timer_interruption();
	DEBUG(0x0FF);
	
	// infinite loop
	while (1){
		DEBUG(0x3FF);
	}
	return 0;
}
