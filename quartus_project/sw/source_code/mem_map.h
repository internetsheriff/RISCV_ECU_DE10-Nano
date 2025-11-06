/*
    ============================================
      HEADER TO DEFINE MEMORY MAPPED ADDRESSES
    ============================================
*/


// Qsys Defined

#define JTAG \
	0x00100010

#define PIO_OUT \
	0x00200000

#define PIO_IN \
	0x00200020

#define GPIO_0 \
	0x00200040

#define GPIO_1 \
	0x00200060

#define GPIO_E \
	0x00200060

#define TIMER \
	0x002000A0




// Pulpino fixed
#define PULPINO_BASE \
	0x10000000

#define SOC_PERIPHERALS_BASE \
	( 0x0A100000 + PULPINO_BASE )

#define EVENT_UNIT_BASE \
	( 0X00004000 + SOC_PERIPHERALS_BASE )

#define IRP \
	( 0x00000000 + EVENT_UNIT_BASE )

#define ICP \
( 0x0000000C + EVENT_UNIT_BASE )


