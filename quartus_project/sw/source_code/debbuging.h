//#define DEBUG_FLAG

// No-reloading guard
#ifndef DEBUG_H
#define DEBUG_H

	#ifdef DEBUG_FLAG

		#define DEBUG_BASE_ADDR	\
			0x00200000

		#define DEBUG(n) \
			((*((volatile uint32_t*) DEBUG_BASE_ADDR)) = (n))

		#define timer_conversion_factor \
			10
	
	#else

		#define DEBUG_BASE_ADDR \
			0x00000000

		#define DEBUG(n) \
			/* n */

		#define timer_conversion_factor \
			25000

	#endif

	// Independent of DEBUG_FLAG
	#define MS2CYCLES(n) \
		(((n)*(timer_conversion_factor))-1)

#endif // DEBUG_H

