# ============================================
#  -------------QUARTUS FRAGMENT-------------
# ============================================
#  Make fragment with rules to access and  
#  use quartus and other Altera tools
# ============================================


# WARNING!!!!
# Do not remove cd $(Q_DIR) && \ from targets or hte files will be all 
# generated in the parent directory of the project!!!
#
# It might be a bad makefile practice, but having a mangled repo is worse


quartus-gui:
	cd $(Q_DIR) && \
	quartus --64bit $(Q_DIR)/$(PROJECT_NAME).qpf


rtl-sim-gui: $(RELOAD_STAMP) $(TB_COMPILE_STAMP)
	cd $(Q_DIR) && \
	vsim -do "source $(rtl_sim_file); run -all"


gate-sim-gui: $(RELOAD_STAMP) $(TB_COMPILE_STAMP)
	cd $(Q_DIR) && \
	quartus_eda --simulation --tool=questa_oem --format=verilog $(PROJECT_NAME) -c $(PROJECT_NAME) && \
		vsim -do "source $(gate_sim_file); run -all"


rtl-sim: $(RELOAD_STAMP) $(TB_COMPILE_STAMP)
	cd $(Q_DIR) && \
	vsim -c -do "source $(rtl_sim_file); run -all"


gate-sim: $(RELOAD_STAMP) $(TB_COMPILE_STAMP)
	cd $(Q_DIR) && \
	quartus_eda --simulation --tool=questa_oem --format=verilog $(PROJECT_NAME) -c $(PROJECT_NAME) && \
	vsim -c -do "source $(gate_sim_file); run -all"




compile-testbench: $(TB_COMPILE_STAMP)

$(TB_COMPILE_STAMP): $(DESIGN_COMPILE_STAMP) $(TESTBENCH)
	vlog $(TESTBENCH)
	touch $@


qsys-gui:
	qsys-edit $(QSYS_SRC)


compile-qsys: $(QSYS_FILE)

$(QSYS_FILE): $(QSYS_SRC)
	qsys-generate $(QSYS_SRC) --synthesis=VERILOG --simulation=VERILOG


compile-quartus: $(END_SOF)

$(END_SOF): $(DESIGN_COMPILE_STAMP)

$(DESIGN_COMPILE_STAMP): $(VERILOG_SOURCES) $(QSYS_FILE) $(END_QSF) $(SDC_FILES)
	cd $(Q_DIR) && quartus_sh --flow compile $(PROJECT_NAME)
	touch $(DESIGN_COMPILE_STAMP)



reload-memory: $(RELOAD_STAMP)

$(RELOAD_STAMP): $(MEM_STAMP) $(DESIGN_COMPILE_STAMP)
	@cd $(Q_DIR) && \
	if [ "$$ALTERNATIVE_MEM_RELOAD" = "true" ]; then \
		echo "Using alternative method for reloading memory" ; \
		QUARTUS_PROJECT_FILE=$$(find ./sys/synthesis/submodules/ -name "$(MEM_NAME)*.hex" | head -n 1) ; \
		CACHED_FILE=$$(find ./db -name "$(MEM_NAME)*.hex" | head -n 1) ; \
		SIM_FILE=$$(find ./sys/simulation/submodules/ -name "$(MEM_NAME)*.hex" | head -n 1) ; \
		echo "Using $(MEM).hex to override memory files" ; \
		echo "Overwriting $$CACHED_FILE" ; \
		cat $(MEM).hex > $$CACHED_FILE ; \
		echo "Overwriting $$QUARTUS_PROJECT_FILE" ; \
		cat $(MEM).hex > $$QUARTUS_PROJECT_FILE ; \
		echo "Overwriting $$SIM_FILE" ; \
		cat $(MEM).hex > $$SIM_FILE ; \
		echo "Removing stale .vo files to force regeneration" ; \
		rm -f ./simulation/questa/*.vo ; \
else \
		quartus_cdb $(PROJECT_NAME) -c $(PROJECT_NAME) --update_mif ; \
	fi && \
	quartus_asm $(PROJECT_NAME) -c $(PROJECT_NAME) ; \
	touch $@
		

program-sof: $(END_SOF)
	quartus_pgm -m JTAG -o "p;$(Q_DIR)/output_files/$(PROJECT_NAME).sof@2"



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



clean-altera-full: clean-project clean-synthesis clean-qsys clean-simulation clean-hardware-stamps


clean-project:
	cd $(Q_DIR) && quartus_sh --clean $(PROJECT_NAME)


list-devices:
	jtagconfig
	quartus_pgm --auto


$(MEM_STAMP): $(MEM).hex
	touch $@

# Intel/Altera tools are a pain in the ass
clean-altera: clean-hardware-stamps
	rm -rf $(Q_DIR)/db
	rm -rf $(Q_DIR)/incremental_db
	rm -rf $(Q_DIR)/*.rpt
	rm -rf $(Q_DIR)/*.qws
	rm -rf $(Q_DIR)/output_files
	rm -rf $(Q_DIR)/sys/synthesis/
	rm -rf $(Q_DIR)/sys/simulation/
	rm -rf $(Q_DIR)/sys.sopcinfo
	rm -rf $(QUESTA_DIR)/work
	rm -rf $(QUESTA_DIR)/*.wlf
	rm -rf $(QUESTA_DIR)/transcript
	rm -rf $(Q_DIR)/*.summary
	rm -rf $(Q_DIR)/*.done
	rm -rf $(Q_DIR)/sys/


clean-hardware-stamps:
	rm -f $(DESIGN_COMPILE_STAMP) $(MEM_STAMP) $(RELOAD_STAMP) $(TB_COMPILE_STAMP) $(SYNTHESIS_STAMP) $(FITTING_STAMP) $(ASSEMBLY_STAMP)


.PHONY: 
	rtl-sim gate-sim rtl-sim-gui gate-sim-gui quartus-gui \
	timing-analysis compile-qsys reload-memory \
	qsys-gui clean-qsys clean-hardware-stamps archive \
	clean-simulation clean-qsys clean-synthesis \
	list-devices clean-all-project clean-project
