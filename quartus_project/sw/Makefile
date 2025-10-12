# Folders

CURRENT_PATH = $(shell pwd)

TOOLCHAIN_DIR = /opt/riscv/bin
MEM_DIR = $(CURRENT_PATH)/mem_init
TOOL_DIR = $(CURRENT_PATH)/../../tools
SUBDIRECTORY = $(CURRENT_PATH)/source_code

# USED PROGRAMS
CC = $(TOOLCHAIN_DIR)/riscv64-unknown-elf-gcc
ELFSIZE = $(TOOLCHAIN_DIR)/riscv64-unknown-elf-size
OBJCOPY = $(TOOLCHAIN_DIR)/riscv64-unknown-elf-objcopy
BIN2HEX = $(TOOL_DIR)/bin2hex


# FLAGS
CFLAGS = -Os -march=rv32imc -mabi=ilp32 -fdata-sections -ffunction-sections -fshort-enums -fgnu89-inline -Wall
LDFLAGS = -Wl,--gc-sections -Tlink.riscv.ld --specs=nano.specs -nostartfiles
LIBS =


# FILES
SRCS = $(wildcard $(SUBDIRECTORY)/*.c) $(wildcard $(SUBDIRECTORY)/*.s) crt0.boot.S
DEPS = $(wildcard $(SUBDIRECTORY)/*.h)
MEM = $(MEM_DIR)/sys_onchip_memory2_0



all: $(MEM).hex



bundle.elf: $(SRCS) $(DEPS)
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)
	$(ELFSIZE) $@



$(MEM).hex: compiled.elf 
	$(OBJCOPY) --change-addresses -0x8000 -O binary --gap-fill 0 $< $(MEM).bin
	$(BIN2HEX) $(MEM).bin $(MEM).hex



rv-reprogram: mem_init_generate
	system-console -cli --script ../scripts/rv-reprogram.tcl



clean:
	rm -f *.elf $(MEM_DIR)/*.hex $(MEM_DIR)/*.bin



.PHONY: clean rv-reprogram mem_init_generate all