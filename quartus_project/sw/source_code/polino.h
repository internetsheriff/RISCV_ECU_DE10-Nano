#include <stdint.h>
#include "addresses.h"

#define PRIV_REG_TEMPLATE(base_address, offset, step) (*((volatile uint32_t*) ((base_address) + ((step) * (offset))) ))
#define LED(number) (PRIV_REG_TEMPLATE((PIN_OUT1), (number), 1 ))