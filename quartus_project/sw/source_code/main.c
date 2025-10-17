#include <stdio.h>
#include <stdint.h>

#define ECP (*((volatile uint32_t *)(0x0000001C)))


void __attribute__((interrupt)) int0_handler(void){
    __asm__(
        "li x7, 0x00F00000\n"
        "li x6, 0x00000001\n"
        "sw x6, 0(x7)"
    );
    ECP = (1 << 0);
}


void __attribute__((interrupt)) interrupt_test_handler(void){
    __asm__(
        "li x7, 0x00F00000\n"
        "li x6, 0x00000002\n"
        "sw x6, 0(x7)"
    );
    ECP = (1 << 1);
}


int main(int argc, char **argv){
    
    __asm__(
        "li x7, 0x00200000\n"
        "li x6, 0x00000003\n"
        "sw x6, 0(x7)\n"
        "li x7, 0x00200028\n"
        "li x6, 0x0000000F\n"
        "sw x6, 0(x7)"
    );

    while (1);

    return 0;
}
