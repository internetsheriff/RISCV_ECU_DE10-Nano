#=====================================================
# Makefile to deal with the entire compilation process
#=====================================================

-include config.mk


# Getting variables from shell
NPROC=$(shell nproc)
PROJECT_PATH=$(shell pwd)

# Folders path
TOOLCHAIN_DIR=$(PROJECT_PATH)/toolchain
SOFTWARE_DIR=$(PROJECT_PATH)/quartus_project/sw
SOURCE_DIR=$(SOFTWARE_DIR)/source_code
COMPILER_SOURCE_DIR=$(PROJECT_PATH)/riscv-gnu-toolchain
STAMPS_DIR=$(PROJECT_PATH)/.stamps


# Target paths
FINAL_MEMORY=$(SOFTWARE_DIR)/mem_init/sys_onchip_memory2_0.hex
BIN2HEX=$(PROJECT_PATH)/tools/bin2hex
COMPILATION_STAMP=$(STAMPS_DIR)/toolchain_built
SRCS=$(wildcard $(SOURCE_DIR)/*.c) $(wildcard $(SOURCE_DIR)/*.h) $(wildcard $(SOURCE_DIR)/*.s)


#---------general project targets---------

# Build verilog memory for processor
all: $(FINAL_MEMORY)

# Run configuring script
config:
	./setup.sh

# clean everything
clean-all: clean-toolchain clean dist-clean 
	rm -f $(BIN2HEX)


.PHONY: all clean config dist-clean clean-all clean-toolchain install



#--------Memory generation target-------

# Use compiled toolchain to generate program and memory from C source code
$(FINAL_MEMORY): $(SRCS) | $(COMPILATION_STAMP) $(BIN2HEX)
	$(MAKE) --directory $(SOFTWARE_DIR) --environment-override TOOLCHAIN_DIR=$(TOOLCHAIN_DIR)/bin 

# Compile custom bin2hex utility
$(BIN2HEX): $(BIN2HEX).c
	gcc $(BIN2HEX).c -o $(BIN2HEX)

# Clean generated program files
clean:
	$(MAKE) --directory $(SOFTWARE_DIR) clean



#--------RISCV-GNU-TOOLCHAIN targets---------

# Compile gnu-riscv-toolchain tools for project
$(COMPILATION_STAMP):
	mkdir -p $(@D)
	cd $(COMPILER_SOURCE_DIR) && ./configure --prefix=$(TOOLCHAIN_DIR) --enable-multilib
	$(MAKE) --directory $(COMPILER_SOURCE_DIR) --jobs $(NPROC)
	touch $@

# Delete all generated toolchain programs and stamp
clean-toolchain:
	@echo "If you clean toolchain files you'll have to rebuild them, which may take a long time."
	@echo ""
	@echo -n "Are you sure you want to do this? [y/N] " && read ans && ans=$${ans:-N} ; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		echo "Cleaning toolchain..." && \
		rm -rf $(TOOLCHAIN_DIR) && \
		rm -f $(COMPILATION_STAMP) && \
		mkdir -p $(TOOLCHAIN_DIR) && \
		touch $(TOOLCHAIN_DIR)/.gitkeep && \
		echo "Toolchain files cleaned." ; \
	else \
		echo "Cleaning aborted." ; \
	fi


# Clean gnu-riscv-toolchain files
distclean:
	$(MAKE) --directory $(COMPILER_SOURCE_DIR) clean

