# ============================================
#  ----------SOURCE CODE FRAGMENTS-----------
# ============================================
#  Make fragment for compiling, linking and 
#  assemblying all source code files and
#  generating the necessary memory file 
# ============================================

-include $(C_OBJS:.o=.d)

generate-memory: $(MEM).hex

$(MEM).hex: $(MEM).bin
	$(BIN2HEX) $(MEM).bin $(MEM).hex



generate-binary: $(MEM).bin

$(MEM).bin: $(ELF_INTERMEDIATE)
	$(OBJCOPY) --change-addresses -0x00008000 -O binary --gap-fill 0 $(ELF_INTERMEDIATE) $(MEM).bin



link-executable: $(ELF_INTERMEDIATE)

$(ELF_INTERMEDIATE): $(OBJS)
	cd $(SW_DIR) && \
	$(CC) -o $@ $(OBJS) -T $(LINKER_SCRIPT) $(LDFLAGS) && \
	$(ELFSIZE) $@


compile-source-code: $(OBJS) 

$(SRC_DIR)/%.o: $(SRC_DIR)/%.c $(DEPS)
	cd $(SW_DIR) && \
	$(CC) -c $(CFLAGS) -o $@ $<

$(SRC_DIR)/%.o: $(SRC_DIR)/%.s $(DEPS)
	cd $(SW_DIR) && \
	$(CC) -c $(CFLAGS) -o $@ $<

$(SRC_DIR)/%.o: $(SRC_DIR)/%.S $(DEPS)
	cd $(SW_DIR) && \
	$(CC) -c $(CFLAGS) -o $@ $<


clean-program-files:
	rm -f $(ELF_INTERMEDIATE) $(MEM_DIR)/*.hex $(MEM_DIR)/*.bin && \
	rm -f $(MEM_STAMP) && \
	rm -f $(SW_DIR)/*.o $(SW_DIR)/*.d 



.PHONY: clean-memory-files compile-source-code link-executable generate-memory generate-binary