#=====================================================
# Makefile to deal with the entire compilation process
#=====================================================

-include config.mk


# Getting variables from shell
NPROC=$(shell nproc)
PROJECT_PATH=$(shell pwd)

# Folders path
TOOLCHAIN_DIR=$(PROJECT_PATH)/toolchain/bin
SOFTWARE_DIR=$(PROJECT_PATH)/quartus_project/sw
COMPILER_SOURCE_DIR=$(PROJECT_PATH)/riscv-gnu-toolchain

# Target paths
FINAL_MEMORY=$(SOFTWARE_DIR)/mem_init/sys_onchip_memory2_0.hex
CC=$(TOOLCHAIN_DIR)/riscv64-unknown-elf-gcc
ELFSIZE=$(TOOLCHAIN_DIR)/riscv64-unknown-elf-size
OBJCOPY=$(TOOLCHAIN_DIR)/riscv64-unknown-elf-objcopy
BIN2HEX=$(PROJECT_PATH)/tools/bin2hex




#---------general project targets---------

# Build verilog memory for processor
all: $(FINAL_MEMORY)

# Run configuring script
config:
	./setup.sh

# clean everything
clean-all: clean dist-clean
	rm -f $(BIN2HEX)


.PHONY: all clean config dist-clean clean-all



#--------Memory generation target-------

# Use compiled toolchain to generate program and memory from C source code
$(FINAL_MEMORY): $(CC) $(BIN2HEX) | $(ELFSIZE) $(OBJCOPY)
	$(MAKE) --directory $(SOFTWARE_DIR) --environment-override TOOLCHAIN_DIR=$(TOOLCHAIN_DIR) 

# Compile custom bin2hex utility
$(BIN2HEX): $(BIN2HEX).c
	gcc $(BIN2HEX).c -o $(BIN2HEX)

# Clean generated program files
clean:
	$(MAKE) --directory $(SOFTWARE_DIR) clean



#--------RISCV-GNU-TOOLCHAIN targets---------

# Compile gnu-riscv-toolchain tools for project
$(CC):
	cd $(COMPILER_SOURCE_DIR) && ./configure --prefix=$(TOOLCHAIN_DIR) --enable-multilib
	$(MAKE) --directory $(COMPILER_SOURCE_DIR) --jobs $(NPROC)
	$(MAKE) --directory $(COMPILER_SOURCE_DIR) install

# Clean gnu-riscv-toolchain files
dist-clean:
	$(MAKE) --directory $(COMPILER_SOURCE_DIR) dist-clean

