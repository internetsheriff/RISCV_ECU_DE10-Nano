# =======================================================
#  ----------------ROOT-LEVEL MAKEFILE------------------
# =======================================================
#  Imports fragments from other directories in one place
#  to make things easier and consistent for other 
#  makefiles across the project
# =======================================================

all: auto-testbench

NPROC=$(shell nproc)
PROJECT_DIR=$(shell pwd)
FRAGMENT_DIR=$(PROJECT_DIR)/.make_utils

include $(FRAGMENT_DIR)/project-config.mk
include $(FRAGMENT_DIR)/variables.mk

include $(FRAGMENT_DIR)/riscv-gnu-toolchain.mk
include $(FRAGMENT_DIR)/source-code.mk
include $(FRAGMENT_DIR)/quartus.mk


debug-%:
	@echo '$*=$($*)'

clean-stamps:
	rm -f $(STAMPS_DIR)/*
	touch $(STAMPS_DIR)/.gitkeep

clean-all: clean-stamps clean-all-project clean-memory-files
	@echo "To clean "


.PHONY: debug-% clean-stamps clean-all
