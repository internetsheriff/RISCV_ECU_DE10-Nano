#include <stdio.h>
#include <stdint.h>


#define REG(addr) (*((volatile uint32_t*) (addr)))
#define JTAG_BASE                           0x00100010
#define PIO_OUT                             0x00200000
#define PIO_IN                              0x00200020

#define TIMER                               0x00200040

#define PULPINO_BASE                        0x10000000
#define SOC_PERIPHERALS_BASE              ( 0x0A100000 + PULPINO_BASE )
#define EVENT_UNIT_BASE                   ( 0X00004000 + SOC_PERIPHERALS_BASE )
#define IRP                               ( 0x00000000 + EVENT_UNIT_BASE )
#define ICP                               ( 0x0000000C + EVENT_UNIT_BASE )

/*
	Timer interrupt is configured for the interrupt number 2

	Snippets of code are indentifies by their main number 0x0X-
	followed by a number indicating a step 0x0-X

	Example: step 4 of snippet A is indicated by 0x0A4
*/



//0x0A_
void enable_timer_interruption(void){
    REG(PIO_OUT) = 0x0A0;


    // Stop counter
    REG(TIMER+0x4) |= (1<<3);


    REG(PIO_OUT) = 0x0A1;

    // set time period
    uint32_t period_full = 10 -1;
    REG(TIMER+0x8) =  (  period_full & 0xFFFF );
    REG(TIMER+0xC) =  (( period_full >> 16 ) & 0xFFFF );

    REG(PIO_OUT) = 0x0A2;

    // Clear old timer interrupts
    REG(TIMER) &= ~(1);

    REG(PIO_OUT) = 0x0A3;

    // Activate counting in single shot mode
    // START = 1 ; CONT = 0 ; ITO =1
    uint32_t cleaned_value = REG(TIMER+0x4) & (~ 3);
    REG(TIMER+0x4) = cleaned_value | 5;

    REG(PIO_OUT) = 0x0A4;
}

//0x0B_
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

void __attribute__((interrupt)) null_handler(void){
    // clean all interrupts 
    REG(ICP) = 0xFFFFFFFF;

    // set all leds ON
    REG(PIO_OUT) = 0x3FF;
}

void __attribute__((interrupt)) jtag_interrupt_handler(void){
    REG(ICP) = (1 << 0);
}


// 0x20-
// leading 2 is equivalent to LEDR[9] and is easier to find in a waveform
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
   	// Shows setup process 
    REG(PIO_OUT) = 0x0D0;
    enable_irq();
    REG(PIO_OUT) = 0x0D1;
    enable_timer_interruption();
    REG(PIO_OUT) = 0x0D2;

		// Counts cyclically
    while (1){
        REG(PIO_OUT) = 0x000;
				REG(PIO_OUT) = 0x001;
				REG(PIO_OUT) = 0x002;
				REG(PIO_OUT) = 0x003;
				REG(PIO_OUT) = 0x004;
				REG(PIO_OUT) = 0x005;
				REG(PIO_OUT) = 0x006;
				REG(PIO_OUT) = 0x007;
				REG(PIO_OUT) = 0x008;
				REG(PIO_OUT) = 0x009;
				REG(PIO_OUT) = 0x00A;
				REG(PIO_OUT) = 0x00B;
				REG(PIO_OUT) = 0x00C;
				REG(PIO_OUT) = 0x00D;
				REG(PIO_OUT) = 0x00E;
				REG(PIO_OUT) = 0x00F;
    }
    return 0;
}
