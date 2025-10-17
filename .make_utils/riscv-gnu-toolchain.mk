# =======================================================
#  ----------------TOOLCHAIN MAKEFILE------------------
# =======================================================
#  Fragment with rules to compile the gnu toolchain to
#  work with RISC-V code.
#
#  To avoid changing the Makefile of a submodule, this 
#  one is not made with fragments but with recursive
#  make calls.
# =======================================================


built-toolchain: $(TOOLCHAIN_COMPILATION_STAMP)

$(TOOLCHAIN_COMPILATION_STAMP):
	mkdir -p $(@D)
	cd $(COMPILER_SOURCE_DIR) && ./configure --prefix=$(TOOLCHAIN_DIR) $(TOOLCHAIN_COMPILATION_FLAGS)
	$(MAKE) --directory $(COMPILER_SOURCE_DIR) --jobs $(NPROC)
	touch $@


clean-toolchain:
	@echo "If you clean toolchain files you'll have to rebuild them, which may take a long time."
	@echo ""
	@echo -n "Are you sure you want to do this? [y/N] " && read ans && ans=$${ans:-N} ; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		echo "Cleaning toolchain..." && \
		rm -rf $(TOOLCHAIN_DIR) && \
		rm -f $(TOOLCHAIN_COMPILATION_STAMP) && \
		mkdir -p $(TOOLCHAIN_DIR) && \
		touch $(TOOLCHAIN_DIR)/.gitkeep && \
		echo "Toolchain files cleaned." ; \
	else \
		echo "Cleaning aborted." ; \
	fi

distclean:
	$(MAKE) --directory $(COMPILER_SOURCE_DIR) clean


.PHONY: clean-toolchain distclean