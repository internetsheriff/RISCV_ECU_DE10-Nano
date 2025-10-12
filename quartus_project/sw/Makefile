# Folders
TOOLCHAIN_DIR = /opt/riscv/bin
MEMORY_DIR = mem_init
TOOL_DIR = ../tools
SUBDIRECTORY = source_code

# PATH variable update
export PATH := $(PATH):$(TOOLCHAIN_DIR)


# USED PROGRAMS
CC = riscv64-unknown-elf-gcc
ELFSIZE = riscv64-unknown-elf-size
OBJCOPY = riscv64-unknown-elf-objcopy
BIN2HEX = $(wildcard $(TOOL_DIR)/bin2hex)


# FLAGS
CFLAGS = -Os -march=rv32imc -mabi=ilp32 -fdata-sections -ffunction-sections -fshort-enums -fgnu89-inline -Wall
LDFLAGS = -Wl,--gc-sections -Tlink.riscv.ld --specs=nano.specs -nostartfiles
LIBS =


# FILES
SRCS = $(wildcard $(SUBDIRECTORY)/*.c) $(wildcard $(SUBDIRECTORY)/*.s) crt0.boot.S
DEPS = $(wildcard $(SUBDIRECTORY)/*.h)



all: mem_init_generate



hello.elf: $(SRCS) $(DEPS)
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)
	$(ELFSIZE) $@



mem_init/sys_onchip_memory2_0.hex: hello.elf 
	$(OBJCOPY) --change-addresses -0x8000 -O binary --gap-fill 0 $< mem_init/sys_onchip_memory2_0.bin
	../tools/bin2hex mem_init/sys_onchip_memory2_0.bin mem_init/sys_onchip_memory2_0.hex


mem_init_generate: mem_init/sys_onchip_memory2_0.hex



rv-reprogram: mem_init_generate
	system-console -cli --script ../scripts/rv-reprogram.tcl



clean:
	rm -f *.elf mem_init/*.hex mem_init/*.bin



.PHONY: clean rv-reprogram mem_init_generate all