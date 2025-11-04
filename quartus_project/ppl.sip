set_global_assignment -entity "ppl" -library "lib_ppl" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "ppl" -library "lib_ppl" -name IP_TOOL_VERSION "24.1"
set_global_assignment -entity "ppl" -library "lib_ppl" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_ppl" -name SPD_FILE [file join $::quartus(sip_path) "ppl.spd"]

set_global_assignment -library "lib_ppl" -name MISC_FILE [file join $::quartus(sip_path) "ppl_sim/ppl.vo"]
