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

/*
 * Medidor recíproco: sem slave dedicado no Qsys — resultado em PIO_IN:
 *   [17:2]  frequência (Hz), [18] ready
 * PIO_OUT: pulso subida em [30] = iniciar medição; pulso em [29] = ack após leitura
 * (FREQ_COUNTER_BASE é apenas etiqueta lógica; leitura real = PIO_IN)
 */
#define FREQ_COUNTER_BASE     0x02004000u
#define FREQ_PIO_VALUE_SHIFT  2u
#define FREQ_PIO_READY_SHIFT  18u
#define FREQ_PIO_READY_MASK   (1u << FREQ_PIO_READY_SHIFT)
#define FREQ_PIO_START_BIT    30u
#define FREQ_PIO_ACK_BIT      29u



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


