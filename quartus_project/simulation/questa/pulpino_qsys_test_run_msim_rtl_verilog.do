transcript on
if ![file isdirectory pulpino_qsys_test_iputf_libs] {
	file mkdir pulpino_qsys_test_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
vlib pulpino_qsys_test_iputf_libs/error_adapter_0
vmap error_adapter_0 ./pulpino_qsys_test_iputf_libs/error_adapter_0
vlib pulpino_qsys_test_iputf_libs/avalon_st_adapter
vmap avalon_st_adapter ./pulpino_qsys_test_iputf_libs/avalon_st_adapter
vlib pulpino_qsys_test_iputf_libs/rsp_mux_001
vmap rsp_mux_001 ./pulpino_qsys_test_iputf_libs/rsp_mux_001
vlib pulpino_qsys_test_iputf_libs/rsp_mux
vmap rsp_mux ./pulpino_qsys_test_iputf_libs/rsp_mux
vlib pulpino_qsys_test_iputf_libs/rsp_demux_004
vmap rsp_demux_004 ./pulpino_qsys_test_iputf_libs/rsp_demux_004
vlib pulpino_qsys_test_iputf_libs/rsp_demux
vmap rsp_demux ./pulpino_qsys_test_iputf_libs/rsp_demux
vlib pulpino_qsys_test_iputf_libs/cmd_mux_004
vmap cmd_mux_004 ./pulpino_qsys_test_iputf_libs/cmd_mux_004
vlib pulpino_qsys_test_iputf_libs/cmd_mux
vmap cmd_mux ./pulpino_qsys_test_iputf_libs/cmd_mux
vlib pulpino_qsys_test_iputf_libs/cmd_demux_001
vmap cmd_demux_001 ./pulpino_qsys_test_iputf_libs/cmd_demux_001
vlib pulpino_qsys_test_iputf_libs/cmd_demux
vmap cmd_demux ./pulpino_qsys_test_iputf_libs/cmd_demux
vlib pulpino_qsys_test_iputf_libs/pulpino_0_avalon_master_lsu_limiter
vmap pulpino_0_avalon_master_lsu_limiter ./pulpino_qsys_test_iputf_libs/pulpino_0_avalon_master_lsu_limiter
vlib pulpino_qsys_test_iputf_libs/router_007
vmap router_007 ./pulpino_qsys_test_iputf_libs/router_007
vlib pulpino_qsys_test_iputf_libs/router_006
vmap router_006 ./pulpino_qsys_test_iputf_libs/router_006
vlib pulpino_qsys_test_iputf_libs/router_002
vmap router_002 ./pulpino_qsys_test_iputf_libs/router_002
vlib pulpino_qsys_test_iputf_libs/router_001
vmap router_001 ./pulpino_qsys_test_iputf_libs/router_001
vlib pulpino_qsys_test_iputf_libs/router
vmap router ./pulpino_qsys_test_iputf_libs/router
vlib pulpino_qsys_test_iputf_libs/jtag_uart_0_avalon_jtag_slave_agent
vmap jtag_uart_0_avalon_jtag_slave_agent ./pulpino_qsys_test_iputf_libs/jtag_uart_0_avalon_jtag_slave_agent
vlib pulpino_qsys_test_iputf_libs/pulpino_0_avalon_master_lsu_agent
vmap pulpino_0_avalon_master_lsu_agent ./pulpino_qsys_test_iputf_libs/pulpino_0_avalon_master_lsu_agent
vlib pulpino_qsys_test_iputf_libs/onchip_memory2_0_s1_translator
vmap onchip_memory2_0_s1_translator ./pulpino_qsys_test_iputf_libs/onchip_memory2_0_s1_translator
vlib pulpino_qsys_test_iputf_libs/pulpino_0_avalon_master_instr_translator
vmap pulpino_0_avalon_master_instr_translator ./pulpino_qsys_test_iputf_libs/pulpino_0_avalon_master_instr_translator
vlib pulpino_qsys_test_iputf_libs/p2b_adapter
vmap p2b_adapter ./pulpino_qsys_test_iputf_libs/p2b_adapter
vlib pulpino_qsys_test_iputf_libs/b2p_adapter
vmap b2p_adapter ./pulpino_qsys_test_iputf_libs/b2p_adapter
vlib pulpino_qsys_test_iputf_libs/transacto
vmap transacto ./pulpino_qsys_test_iputf_libs/transacto
vlib pulpino_qsys_test_iputf_libs/p2b
vmap p2b ./pulpino_qsys_test_iputf_libs/p2b
vlib pulpino_qsys_test_iputf_libs/b2p
vmap b2p ./pulpino_qsys_test_iputf_libs/b2p
vlib pulpino_qsys_test_iputf_libs/fifo
vmap fifo ./pulpino_qsys_test_iputf_libs/fifo
vlib pulpino_qsys_test_iputf_libs/timing_adt
vmap timing_adt ./pulpino_qsys_test_iputf_libs/timing_adt
vlib pulpino_qsys_test_iputf_libs/jtag_phy_embedded_in_jtag_master
vmap jtag_phy_embedded_in_jtag_master ./pulpino_qsys_test_iputf_libs/jtag_phy_embedded_in_jtag_master
vlib pulpino_qsys_test_iputf_libs/rst_controller
vmap rst_controller ./pulpino_qsys_test_iputf_libs/rst_controller
vlib pulpino_qsys_test_iputf_libs/irq_mapper
vmap irq_mapper ./pulpino_qsys_test_iputf_libs/irq_mapper
vlib pulpino_qsys_test_iputf_libs/mm_interconnect_1
vmap mm_interconnect_1 ./pulpino_qsys_test_iputf_libs/mm_interconnect_1
vlib pulpino_qsys_test_iputf_libs/mm_interconnect_0
vmap mm_interconnect_0 ./pulpino_qsys_test_iputf_libs/mm_interconnect_0
vlib pulpino_qsys_test_iputf_libs/timer_0
vmap timer_0 ./pulpino_qsys_test_iputf_libs/timer_0
vlib pulpino_qsys_test_iputf_libs/pulpino_0
vmap pulpino_0 ./pulpino_qsys_test_iputf_libs/pulpino_0
vlib pulpino_qsys_test_iputf_libs/pio_out
vmap pio_out ./pulpino_qsys_test_iputf_libs/pio_out
vlib pulpino_qsys_test_iputf_libs/pio_in
vmap pio_in ./pulpino_qsys_test_iputf_libs/pio_in
vlib pulpino_qsys_test_iputf_libs/onchip_memory2_0
vmap onchip_memory2_0 ./pulpino_qsys_test_iputf_libs/onchip_memory2_0
vlib pulpino_qsys_test_iputf_libs/master_0
vmap master_0 ./pulpino_qsys_test_iputf_libs/master_0
vlib pulpino_qsys_test_iputf_libs/jtag_uart_0
vmap jtag_uart_0 ./pulpino_qsys_test_iputf_libs/jtag_uart_0
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 

file copy -force /home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_onchip_memory2_0.hex ./
file copy -force /home/jvctr/0/POLIno_qsys/quartus_project/sw/mem_init/sys_onchip_memory2_0.hex ./

vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_avalon_st_adapter_error_adapter_0.sv" -work error_adapter_0                         
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_avalon_st_adapter.v"                  -work avalon_st_adapter                       
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_rsp_mux_001.sv"                       -work rsp_mux_001                             
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_arbitrator.sv"                                -work rsp_mux_001                             
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_rsp_mux.sv"                           -work rsp_mux                                 
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_arbitrator.sv"                                -work rsp_mux                                 
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_rsp_demux_004.sv"                     -work rsp_demux_004                           
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_rsp_demux.sv"                         -work rsp_demux                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_cmd_mux_004.sv"                       -work cmd_mux_004                             
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_arbitrator.sv"                                -work cmd_mux_004                             
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_cmd_mux.sv"                           -work cmd_mux                                 
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_arbitrator.sv"                                -work cmd_mux                                 
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_cmd_demux_001.sv"                     -work cmd_demux_001                           
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_cmd_demux.sv"                         -work cmd_demux                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_traffic_limiter.sv"                           -work pulpino_0_avalon_master_lsu_limiter     
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_reorder_memory.sv"                            -work pulpino_0_avalon_master_lsu_limiter     
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_sc_fifo.v"                                    -work pulpino_0_avalon_master_lsu_limiter     
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_pipeline_base.v"                           -work pulpino_0_avalon_master_lsu_limiter     
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_router_007.sv"                        -work router_007                              
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_router_006.sv"                        -work router_006                              
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_router_002.sv"                        -work router_002                              
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_router_001.sv"                        -work router_001                              
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1_router.sv"                            -work router                                  
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_slave_agent.sv"                               -work jtag_uart_0_avalon_jtag_slave_agent     
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_burst_uncompressor.sv"                        -work jtag_uart_0_avalon_jtag_slave_agent     
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_master_agent.sv"                              -work pulpino_0_avalon_master_lsu_agent       
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_slave_translator.sv"                          -work onchip_memory2_0_s1_translator          
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_merlin_master_translator.sv"                         -work pulpino_0_avalon_master_instr_translator
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_master_0_p2b_adapter.sv"                                -work p2b_adapter                             
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_master_0_b2p_adapter.sv"                                -work b2p_adapter                             
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_packets_to_master.v"                          -work transacto                               
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_packets_to_bytes.v"                        -work p2b                                     
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_bytes_to_packets.v"                        -work b2p                                     
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_sc_fifo.v"                                    -work fifo                                    
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_master_0_timing_adt.sv"                                 -work timing_adt                              
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_jtag_interface.v"                          -work jtag_phy_embedded_in_jtag_master        
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_jtag_dc_streaming.v"                                 -work jtag_phy_embedded_in_jtag_master        
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_jtag_sld_node.v"                                     -work jtag_phy_embedded_in_jtag_master        
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_jtag_streaming.v"                                    -work jtag_phy_embedded_in_jtag_master        
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_clock_crosser.v"                           -work jtag_phy_embedded_in_jtag_master        
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_std_synchronizer_nocut.v"                            -work jtag_phy_embedded_in_jtag_master        
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_pipeline_base.v"                           -work jtag_phy_embedded_in_jtag_master        
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_idle_remover.v"                            -work jtag_phy_embedded_in_jtag_master        
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_idle_inserter.v"                           -work jtag_phy_embedded_in_jtag_master        
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_st_pipeline_stage.sv"                         -work jtag_phy_embedded_in_jtag_master        
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_reset_controller.v"                                  -work rst_controller                          
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_reset_synchronizer.v"                                -work rst_controller                          
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_irq_mapper.sv"                                          -work irq_mapper                              
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_1.v"                                    -work mm_interconnect_1                       
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_mm_interconnect_0.v"                                    -work mm_interconnect_0                       
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_timer_0.v"                                              -work timer_0                                 
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/adbg_config.sv"                                             -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/config.sv"                                                  -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_config.sv"                                        -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/apb_bus.sv"                                                 -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/axi_bus.sv"                                                 -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/debug_bus.sv"                                               -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/cluster_clock_gating.sv"                                    -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/cluster_clock_inverter.sv"                                  -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/cluster_clock_mux2.sv"                                      -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_defines.sv"                                       -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_alu.sv"                                           -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_compressed_decoder.sv"                            -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_controller.sv"                                    -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_core.sv"                                          -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_cs_registers.sv"                                  -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_debug_unit.sv"                                    -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_decoder.sv"                                       -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_ex_block.sv"                                      -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_fetch_fifo.sv"                                    -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_id_stage.sv"                                      -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_if_stage.sv"                                      -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_int_controller.sv"                                -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_load_store_unit.sv"                               -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_multdiv_fast.sv"                                  -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_multdiv_slow.sv"                                  -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_prefetch_buffer.sv"                               -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/zeroriscy_register_file_ff.sv"                              -work pulpino_0                               
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/core_top.sv"                                                -work pulpino_0                               
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_pio_out.v"                                              -work pio_out                                 
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_pio_in.v"                                               -work pio_in                                  
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_onchip_memory2_0.v"                                     -work onchip_memory2_0                        
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/sys_master_0.v"                                             -work master_0                                
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_jtag_uart.sv"                                 -work jtag_uart_0                             
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_jtag_uart_log_module.sv"                      -work jtag_uart_0                             
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_jtag_uart_scfifo_r.sv"                        -work jtag_uart_0                             
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_jtag_uart_scfifo_w.sv"                        -work jtag_uart_0                             
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_jtag_uart_sim_scfifo_r.sv"                    -work jtag_uart_0                             
vlog -sv "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/submodules/altera_avalon_jtag_uart_sim_scfifo_w.sv"                    -work jtag_uart_0                             
vlog     "/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/sys.v"                                                                                                               

vlog -sv -work work +incdir+/home/jvctr/0/POLIno_qsys/quartus_project {/home/jvctr/0/POLIno_qsys/quartus_project/ppl_sim/ppl.vo}
vlog -sv -work work +incdir+/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation {/home/jvctr/0/POLIno_qsys/quartus_project/sys/simulation/sys.v}
vlog -sv -work work +incdir+/home/jvctr/0/POLIno_qsys/quartus_project/rtl {/home/jvctr/0/POLIno_qsys/quartus_project/rtl/pulpino_qsys_test.v}
vlib ppl
vmap ppl ppl
vlog -sv -work ppl +incdir+/home/jvctr/0/POLIno_qsys/quartus_project/ppl {/home/jvctr/0/POLIno_qsys/quartus_project/ppl/ppl_0002.v}
vlog -sv -work work +incdir+/home/jvctr/0/POLIno_qsys/quartus_project/rtl/tb {/home/jvctr/0/POLIno_qsys/quartus_project/rtl/tb/tbench.sv}
vlib sys
vmap sys sys

vlog -sv -work work +incdir+/home/jvctr/0/POLIno_qsys/quartus_project/rtl/tb {/home/jvctr/0/POLIno_qsys/quartus_project/rtl/tb/tbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -L ppl -L sys -L error_adapter_0 -L avalon_st_adapter -L rsp_mux_001 -L rsp_mux -L rsp_demux_004 -L rsp_demux -L cmd_mux_004 -L cmd_mux -L cmd_demux_001 -L cmd_demux -L pulpino_0_avalon_master_lsu_limiter -L router_007 -L router_006 -L router_002 -L router_001 -L router -L jtag_uart_0_avalon_jtag_slave_agent -L pulpino_0_avalon_master_lsu_agent -L onchip_memory2_0_s1_translator -L pulpino_0_avalon_master_instr_translator -L p2b_adapter -L b2p_adapter -L transacto -L p2b -L b2p -L fifo -L timing_adt -L jtag_phy_embedded_in_jtag_master -L rst_controller -L irq_mapper -L mm_interconnect_1 -L mm_interconnect_0 -L timer_0 -L pulpino_0 -L pio_out -L pio_in -L onchip_memory2_0 -L master_0 -L jtag_uart_0 -voptargs="+acc"  tbench

add wave *
view structure
view signals
run 100 us
