#include <stdint.h>


typedef struct{
    uint32_t DATA;
    uint32_t DIRECTION;
    uint32_t INT_MASK;
    uint32_t EDGE_CAPTURE;
    uint32_t OUT_SET;
    uint32_t OUT_CLEAR;
} pio_t;

typedef struct{
    uint32_t DATA;
    uint32_t CONTROL;
} jtag_uart_t;


typedef struct {
    uint32_t STATUS;
    uint32_t CONTROL;
    uint32_t PERIOD_L;
    uint32_t PERIOD_H;
    uint32_t SNAP_L;
    uint32_t SNAP_H;
} interval_timer32_t;

typedef struct {
    uint32_t STATUS;
    uint32_t CONTROL;
    uint32_t PERIOD_0;
    uint32_t PERIOD_1;
    uint32_t PERIOD_2;
    uint32_t PERIOD_3;
    uint32_t SNAP_0;
    uint32_t SNAP_1;
} interval_timer64_t;


