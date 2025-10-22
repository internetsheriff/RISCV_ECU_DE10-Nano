
file copy -force /home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_onchip_memory2_0.hex ./
file copy -force /home/jvctr/0/POLIno_qsys/quartus_project/sw/mem_init/sys_onchip_memory2_0.hex ./

vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_avalon_st_adapter_error_adapter_0.sv" -work error_adapter_0                         
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_avalon_st_adapter.v"                  -work avalon_st_adapter                       
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_rsp_mux_001.sv"                       -work rsp_mux_001                             
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_arbitrator.sv"                                -work rsp_mux_001                             
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_rsp_mux.sv"                           -work rsp_mux                                 
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_arbitrator.sv"                                -work rsp_mux                                 
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_rsp_demux_004.sv"                     -work rsp_demux_004                           
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_rsp_demux.sv"                         -work rsp_demux                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_cmd_mux_004.sv"                       -work cmd_mux_004                             
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_arbitrator.sv"                                -work cmd_mux_004                             
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_cmd_mux.sv"                           -work cmd_mux                                 
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_arbitrator.sv"                                -work cmd_mux                                 
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_cmd_demux_001.sv"                     -work cmd_demux_001                           
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_cmd_demux.sv"                         -work cmd_demux                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_traffic_limiter.sv"                           -work pulpino_0_avalon_master_lsu_limiter     
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_reorder_memory.sv"                            -work pulpino_0_avalon_master_lsu_limiter     
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_sc_fifo.v"                                    -work pulpino_0_avalon_master_lsu_limiter     
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_pipeline_base.v"                           -work pulpino_0_avalon_master_lsu_limiter     
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_router_007.sv"                        -work router_007                              
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_router_006.sv"                        -work router_006                              
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_router_002.sv"                        -work router_002                              
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_router_001.sv"                        -work router_001                              
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_router.sv"                            -work router                                  
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_slave_agent.sv"                               -work jtag_uart_0_avalon_jtag_slave_agent     
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_burst_uncompressor.sv"                        -work jtag_uart_0_avalon_jtag_slave_agent     
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_master_agent.sv"                              -work pulpino_0_avalon_master_lsu_agent       
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_slave_translator.sv"                          -work onchip_memory2_0_s1_translator          
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_master_translator.sv"                         -work pulpino_0_avalon_master_instr_translator
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_master_0_p2b_adapter.sv"                                -work p2b_adapter                             
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_master_0_b2p_adapter.sv"                                -work b2p_adapter                             
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_packets_to_master.v"                          -work transacto                               
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_packets_to_bytes.v"                        -work p2b                                     
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_bytes_to_packets.v"                        -work b2p                                     
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_sc_fifo.v"                                    -work fifo                                    
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_master_0_timing_adt.sv"                                 -work timing_adt                              
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_jtag_interface.v"                          -work jtag_phy_embedded_in_jtag_master        
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_jtag_dc_streaming.v"                                 -work jtag_phy_embedded_in_jtag_master        
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_jtag_sld_node.v"                                     -work jtag_phy_embedded_in_jtag_master        
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_jtag_streaming.v"                                    -work jtag_phy_embedded_in_jtag_master        
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_clock_crosser.v"                           -work jtag_phy_embedded_in_jtag_master        
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_std_synchronizer_nocut.v"                            -work jtag_phy_embedded_in_jtag_master        
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_pipeline_base.v"                           -work jtag_phy_embedded_in_jtag_master        
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_idle_remover.v"                            -work jtag_phy_embedded_in_jtag_master        
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_idle_inserter.v"                           -work jtag_phy_embedded_in_jtag_master        
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_pipeline_stage.sv"                         -work jtag_phy_embedded_in_jtag_master        
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_reset_controller.v"                                  -work rst_controller                          
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_reset_synchronizer.v"                                -work rst_controller                          
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_irq_mapper.sv"                                          -work irq_mapper                              
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1.v"                                    -work mm_interconnect_1                       
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_0.v"                                    -work mm_interconnect_0                       
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_timer_0.v"                                              -work timer_0                                 
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/adbg_config.sv"                                             -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/config.sv"                                                  -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_config.sv"                                        -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/apb_bus.sv"                                                 -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/axi_bus.sv"                                                 -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/debug_bus.sv"                                               -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/cluster_clock_gating.sv"                                    -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/cluster_clock_inverter.sv"                                  -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/cluster_clock_mux2.sv"                                      -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_defines.sv"                                       -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_alu.sv"                                           -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_compressed_decoder.sv"                            -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_controller.sv"                                    -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_core.sv"                                          -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_cs_registers.sv"                                  -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_debug_unit.sv"                                    -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_decoder.sv"                                       -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_ex_block.sv"                                      -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_fetch_fifo.sv"                                    -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_id_stage.sv"                                      -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_if_stage.sv"                                      -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_int_controller.sv"                                -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_load_store_unit.sv"                               -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_multdiv_fast.sv"                                  -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_multdiv_slow.sv"                                  -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_prefetch_buffer.sv"                               -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_register_file_ff.sv"                              -work pulpino_0                               
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/core_top.sv"                                                -work pulpino_0                               
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_pio_out.v"                                              -work pio_out                                 
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_pio_in.v"                                               -work pio_in                                  
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_onchip_memory2_0.v"                                     -work onchip_memory2_0                        
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_master_0.v"                                             -work master_0                                
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_jtag_uart.sv"                                 -work jtag_uart_0                             
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_jtag_uart_log_module.sv"                      -work jtag_uart_0                             
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_jtag_uart_scfifo_r.sv"                        -work jtag_uart_0                             
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_jtag_uart_scfifo_w.sv"                        -work jtag_uart_0                             
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_jtag_uart_sim_scfifo_r.sv"                    -work jtag_uart_0                             
vlog       "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_jtag_uart_sim_scfifo_w.sv"                    -work jtag_uart_0                             
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/sys.v"                                                                                                               
vlog -v2k5 "/home/jvctr/0/POLIno_qsys/quartus_project/pll_sim/pll.vo"                                                                                                                     
