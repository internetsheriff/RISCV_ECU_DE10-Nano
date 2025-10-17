#include <stdint.h>


typedef struct{
    uint32_t data;
    uint32_t direction;
    uint32_t int_mask;
    uint32_t edge_capture;
} pio_t;

typedef union{
    uint32_t raw;
    struct {
        unsigned int DATA   : 8;
        unsigned int        : 7;
        unsigned int RVALID : 1;
        unsigned int RAVAIL : 16;
    } bits;
} jtag_uart_data_t;


typedef union{
    uint32_t raw;
    struct {
        unsigned int RE      : 1;
        unsigned int WE      : 1;
        unsigned int         : 6;
        unsigned int RI      : 1;
        unsigned int WI      : 1;
        unsigned int AC      : 1;
        unsigned int         : 5;
        unsigned int WSPACE  : 16;
     } bits;
} jtag_uart_ctrl_t;

typedef struct{
    jtag_uart_data_t data;
    jtag_uart_ctrl_t control;
} jtag_uart_t;



#define JTAG_UART (*((volatile jtag_uart_t*) (JTAG_UART_BASE)))