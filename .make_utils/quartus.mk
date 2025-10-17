# ============================================
#  -------------QUARTUS FRAGMENT-------------
# ============================================
#  Make fragment with rules to access and  
#  use quartus and other Altera tools
# ============================================


compile-quartus: $(DESIGN_COMPILE_STAMP)


auto-testbench: $(MEM_STAMP) $(TB_COMPILE_STAMP)
	vsim -do $(test_bench_script)


open-quartus: $(MEM_STAMP)
	quartus --64bit $(Q_DIR)/$(PROJECT_NAME).qpf


compile-testbench: $(TB_COMPILE_STAMP)

$(TB_COMPILE_STAMP): $(DESIGN_COMPILE_STAMP) $(TESTBENCH)
	vlog $(TESTBENCH)
	touch $@


open-qsys:
	qsys-edit $(QSYS_SRC)


compile-qsys:
$(QSYS_FILE): $(QSYS_SRC)
	qsys-generate $(QSYS_SRC) --synthesis=VERILOG --simulation=VERILOG


compile-quartus: $(END_SOF)

$(END_SOF): $(DESIGN_COMPILE_STAMP)

$(DESIGN_COMPILE_STAMP): $(VERILOG_SOURCES) $(QSYS_FILE) $(END_QSF)
	cd $(Q_DIR) && quartus_sh --flow compile $(PROJECT_NAME)
	touch $(DESIGN_COMPILE_STAMP)




reload-memory: $(MEM_STAMP)

$(MEM_STAMP): $(MEM).hex $(DESIGN_COMPILE_STAMP)
	@cd $(Q_DIR) && \
	if [ "$$ALTERNATIVE_MEM_RELOAD" = "true" ]; then \
		echo "Using alternative method for reloading memory" ; \
		CACHED_FILE=$$(find ./db -name "$(MEM_NAME)*.hex" | head -n 1) ; \
		echo "Overwriting $$CACHED_FILE with $(MEM).hex" ; \
		cat $(MEM).hex > $$CACHED_FILE ; \
	else \
		quartus_cdb $(PROJECT_NAME) -c $(PROJECT_NAME) --update_mif ; \
	fi && \
	touch $@
		

program-sof: $(END_SOF)
	quartus_pgm -m JTAG -o "p;$(Q_DIR)/output_files/$(PROJECT_NAME).sof"



synthesis: $(SYNTHESIS_STAMP)
	
$(SYNTHESIS_STAMP): $(VERILOG_SOURCES) $(QIP_FILES) $(END_QSF)
	cd $(Q_DIR) && quartus_map $(PROJECT_NAME)
	touch $@



fitting: $(FITTING_STAMP)

$(FITTING_STAMP): $(SYNTHESIS_STAMP)
	cd $(Q_DIR) && quartus_fit $(PROJECT_NAME)
	touch $@


assembly: $(ASSEMBLY_STAMP)

$(ASSEMBLY_STAMP): $(FITTING_STAMP)
	cd $(Q_DIR) && quartus_asm $(PROJECT_NAME)
	touch $@


archive:
	cd $(Q_DIR) && quartus_sh --archive $(PROJECT_NAME)



clean-all-project: clean-project
	rm -rf $(Q_DIR)/incremental_db $(Q_DIR)/output_files
	rm -f $(Q_DIR)/*.rpt $(Q_DIR)/*.summary $(Q_DIR)/*.done



clean-project:
	cd $(Q_DIR) && quartus_sh --clean $(PROJECT_NAME)



list-devices:
	jtagconfig
	quartus_pgm --auto



clean-synthesis:
	rm -rf $(Q_DIR)/db



clean-simulation:
	rm -rf $(QUESTA_DIR)/work $(QUESTA_DIR)/*.wlf $(QUESTA_DIR)/transcript




.PHONY: auto-testbench reload_memory compile-quartus open-qsys \
        timing-analysis check-timing reports power-analysis \
        verify-device quick-check help check-project-exists \
        smart-compile synthesis fitting assembly compile-qsys
