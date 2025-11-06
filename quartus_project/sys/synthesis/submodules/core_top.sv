// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


`include "axi_bus.sv"
//`include "debug_bus.sv"
`include "config.sv"
`include "adbg_config.sv"

module core_top
#(
    parameter AXI_ADDR_WIDTH       = 32,
    parameter AXI_DATA_WIDTH       = 32,
    parameter AXI_ID_MASTER_WIDTH  = 10,
    parameter AXI_ID_SLAVE_WIDTH   = 10,
    parameter AXI_USER_WIDTH       = 0,
    parameter USE_ZERO_RISCY       = 1,
    parameter RISCY_RV32F          = 0,
    parameter ZERO_RV32M           = 1,
    parameter ZERO_RV32E           = 0,
    parameter DEBUG_SLAVE          = 0
  )
(
    // Clock and Reset
    input logic         clk,
    input logic         rst_n,

    input  logic        testmode_i,
    input  logic        fetch_enable_i,
    input  logic [31:0] irq_i,
    input  logic        clock_gating_i,
    input  logic [31:0] boot_addr_i,

`ifdef ENABLE_ADV_DBG_IF
`ifdef DBG_AXI4_SUPPORTED
    AXI_BUS.Master      dbg_master,
`endif

`ifdef DBG_WISHBONE_SUPPORTED
    output [31:0]       wb_adr_o,
    output [31:0]       wb_dat_o,
    input [31:0]        wb_dat_i,
    output              wb_cyc_o,
    output              wb_stb_o,
    output [3:0]        wb_sel_o,
    output              wb_we_o,
    input               wb_ack_i,
    output              wb_cab_o,
    input               wb_err_i,
    output [2:0]        wb_cti_o,
    output [1:0]        wb_bte_o,
`endif

    // JTAG signals
    input  logic        tck_i,
    input  logic        trstn_i,
    input  logic        tms_i,
    input  logic        tdi_i,
    output logic        tdo_o,
`endif // ENABLE_ADV_DBG_IF

    output logic        instr_read,
    input logic         instr_busy,
    input logic         instr_rvalid,
    output logic [31:0] instr_addr,
    input logic [31:0]  instr_rdata,

    output logic        lsu_read,
    input logic         lsu_busy,
    input logic         lsu_rvalid,
    output logic [31:0] lsu_addr,
    output logic        lsu_write,
    output logic [3:0]  lsu_be,
    input logic [31:0]  lsu_rdata,
    output logic [31:0] lsu_wdata,
    input logic [1:0]   lsu_resp,
    input logic         lsu_wrespvalid,

    input  logic        debug_read,
    output logic        debug_busy,
    output logic        debug_rvalid,
    input  logic [14:0] debug_addr,
    input  logic        debug_write,
    input  logic [31:0] debug_wdata,
    output logic [31:0] debug_rdata
  );

  // signals from/to core
  logic         core_instr_req;
  logic         core_instr_gnt;
  logic         core_instr_rvalid;
  logic [31:0]  core_instr_addr;
  logic [31:0]  core_instr_rdata;

  logic         core_lsu_req;
  logic         core_lsu_gnt;
  logic         core_lsu_rvalid;
  logic [31:0]  core_lsu_addr;
  logic         core_lsu_we;
  logic [3:0]   core_lsu_be;
  logic [31:0]  core_lsu_rdata;
  logic [31:0]  core_lsu_wdata;

  logic         core_debug_req;
  logic         core_debug_gnt;
  logic         core_debug_rvalid;
  logic [14:0]  core_debug_addr;
  logic         core_debug_we;
  logic [31:0]  core_debug_wdata;
  logic [31:0]  core_debug_rdata;

  assign instr_read = core_instr_req;
  assign instr_addr = core_instr_addr;
  assign core_instr_gnt = ~instr_busy & core_instr_req;
  assign core_instr_rvalid = instr_rvalid;
  assign core_instr_rdata = instr_rdata;

  assign lsu_read = core_lsu_req & ~core_lsu_we;
  assign lsu_addr = core_lsu_addr;
  assign lsu_write = core_lsu_req & core_lsu_we;
  assign lsu_be = core_lsu_be;
  assign lsu_wdata = core_lsu_wdata;
  assign core_lsu_gnt = ~lsu_busy & core_lsu_req;
  assign core_lsu_rvalid = lsu_rvalid | lsu_wrespvalid;
  assign core_lsu_rdata = lsu_rdata;
  
  assign core_debug_req = debug_read | debug_write;
  assign debug_busy = ~core_debug_gnt;
  assign debug_rvalid = core_debug_rvalid;
  assign core_debug_addr = debug_addr;
  assign core_debug_we = debug_write;
  assign core_debug_wdata = debug_wdata;
  assign debug_rdata = core_debug_rdata;

  //----------------------------------------------------------------------------//
  // Core Instantiation
  //----------------------------------------------------------------------------//

  logic [4:0] irq_id;
  always_comb begin
    irq_id = '0;
    for (int i = 0; i < 32; i+=1) begin
      if(irq_i[i]) begin
        irq_id = i[4:0];
      end
    end
  end

  zeroriscy_core
  #(
    .N_EXT_PERF_COUNTERS (     0      ),
    .RV32E               ( ZERO_RV32E ),
    .RV32M               ( ZERO_RV32M )
  )
  RISCV_CORE
  (
    .clk_i           ( clk               ),
    .rst_ni          ( rst_n             ),

    .clock_en_i      ( clock_gating_i    ),
    .test_en_i       ( testmode_i        ),

    .boot_addr_i     ( boot_addr_i       ),
    .core_id_i       ( 4'h0              ),
    .cluster_id_i    ( 6'h0              ),

    .instr_addr_o    ( core_instr_addr   ),
    .instr_req_o     ( core_instr_req    ),
    .instr_rdata_i   ( core_instr_rdata  ),
    .instr_gnt_i     ( core_instr_gnt    ),
    .instr_rvalid_i  ( core_instr_rvalid ),

    .data_addr_o     ( core_lsu_addr     ),
    .data_wdata_o    ( core_lsu_wdata    ),
    .data_we_o       ( core_lsu_we       ),
    .data_req_o      ( core_lsu_req      ),
    .data_be_o       ( core_lsu_be       ),
    .data_rdata_i    ( core_lsu_rdata    ),
    .data_gnt_i      ( core_lsu_gnt      ),
    .data_rvalid_i   ( core_lsu_rvalid   ),
    .data_err_i      ( 1'b0              ),

    .irq_i           ( (|irq_i)          ),
    .irq_id_i        ( irq_id            ),
    .irq_ack_o       (                   ),
    .irq_id_o        (                   ),

    .debug_req_i     ( core_debug_req    ),
    .debug_gnt_o     ( core_debug_gnt    ),
    .debug_rvalid_o  ( core_debug_rvalid ),
    .debug_addr_i    ( core_debug_addr   ),
    .debug_we_i      ( core_debug_we     ),
    .debug_wdata_i   ( core_debug_wdata  ),
    .debug_rdata_o   ( core_debug_rdata  ),
    .debug_halted_o  (                   ),
    .debug_halt_i    ( 1'b0              ),
    .debug_resume_i  ( 1'b0              ),

    .fetch_enable_i  ( fetch_enable_i    ),
    .ext_perf_counters_i (               )
  );
 

  //----------------------------------------------------------------------------//
  // Advanced Debug Unit
  //----------------------------------------------------------------------------//

`ifdef ENABLE_ADV_DBG_IF
  // TODO: remove the debug connections to the core
  adv_dbg_if
  #(
    .NB_CORES           ( 1                   ),
    .AXI_ADDR_WIDTH     ( AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH     ( AXI_DATA_WIDTH      ),
    .AXI_USER_WIDTH     ( AXI_USER_WIDTH      ),
    .AXI_ID_WIDTH       ( AXI_ID_MASTER_WIDTH )
    )
  adv_dbg_if_i
  (
    .tms_pad_i   ( tms_i           ),
    .tck_pad_i   ( tck_i           ),
    .trstn_pad_i ( trstn_i         ),
    .tdi_pad_i   ( tdi_i           ),
    .tdo_pad_o   ( tdo_o           ),

    .test_mode_i ( testmode_i      ),

    .cpu_addr_o  (                 ),
    .cpu_data_i  ( '0              ),
    .cpu_data_o  (                 ),
    .cpu_bp_i    ( '0              ),
    .cpu_stall_o (                 ),
    .cpu_stb_o   (                 ),
    .cpu_we_o    (                 ),
    .cpu_ack_i   ( '1              ),
    .cpu_rst_o   (                 ),

`ifdef DBG_AXI4_SUPPORTED
    .axi_aclk             ( clk                  ),
    .axi_aresetn          ( rst_n                ),

    .axi_master_aw_valid  ( dbg_master.aw_valid  ),
    .axi_master_aw_addr   ( dbg_master.aw_addr   ),
    .axi_master_aw_prot   ( dbg_master.aw_prot   ),
    .axi_master_aw_region ( dbg_master.aw_region ),
    .axi_master_aw_len    ( dbg_master.aw_len    ),
    .axi_master_aw_size   ( dbg_master.aw_size   ),
    .axi_master_aw_burst  ( dbg_master.aw_burst  ),
    .axi_master_aw_lock   ( dbg_master.aw_lock   ),
    .axi_master_aw_cache  ( dbg_master.aw_cache  ),
    .axi_master_aw_qos    ( dbg_master.aw_qos    ),
    .axi_master_aw_id     ( dbg_master.aw_id     ),
    .axi_master_aw_user   ( dbg_master.aw_user   ),
    .axi_master_aw_ready  ( dbg_master.aw_ready  ),

    .axi_master_ar_valid  ( dbg_master.ar_valid  ),
    .axi_master_ar_addr   ( dbg_master.ar_addr   ),
    .axi_master_ar_prot   ( dbg_master.ar_prot   ),
    .axi_master_ar_region ( dbg_master.ar_region ),
    .axi_master_ar_len    ( dbg_master.ar_len    ),
    .axi_master_ar_size   ( dbg_master.ar_size   ),
    .axi_master_ar_burst  ( dbg_master.ar_burst  ),
    .axi_master_ar_lock   ( dbg_master.ar_lock   ),
    .axi_master_ar_cache  ( dbg_master.ar_cache  ),
    .axi_master_ar_qos    ( dbg_master.ar_qos    ),
    .axi_master_ar_id     ( dbg_master.ar_id     ),
    .axi_master_ar_user   ( dbg_master.ar_user   ),
    .axi_master_ar_ready  ( dbg_master.ar_ready  ),

    .axi_master_w_valid   ( dbg_master.w_valid   ),
    .axi_master_w_data    ( dbg_master.w_data    ),
    .axi_master_w_strb    ( dbg_master.w_strb    ),
    .axi_master_w_user    ( dbg_master.w_user    ),
    .axi_master_w_last    ( dbg_master.w_last    ),
    .axi_master_w_ready   ( dbg_master.w_ready   ),

    .axi_master_r_valid   ( dbg_master.r_valid   ),
    .axi_master_r_data    ( dbg_master.r_data    ),
    .axi_master_r_resp    ( dbg_master.r_resp    ),
    .axi_master_r_last    ( dbg_master.r_last    ),
    .axi_master_r_id      ( dbg_master.r_id      ),
    .axi_master_r_user    ( dbg_master.r_user    ),
    .axi_master_r_ready   ( dbg_master.r_ready   ),

    .axi_master_b_valid   ( dbg_master.b_valid   ),
    .axi_master_b_resp    ( dbg_master.b_resp    ),
    .axi_master_b_id      ( dbg_master.b_id      ),
    .axi_master_b_user    ( dbg_master.b_user    ),
    .axi_master_b_ready   ( dbg_master.b_ready   )
`endif

`ifdef DBG_WISHBONE_SUPPORTED
    .wb_clk_i             (clk),
    .wb_rst_i             (~rst_n),
    .wb_adr_o             (wb_adr_o),
    .wb_dat_o             (wb_dat_o),
    .wb_dat_i             (wb_dat_i),
    .wb_cyc_o             (wb_cyc_o),
    .wb_stb_o             (wb_stb_o),
    .wb_sel_o             (wb_sel_o),
    .wb_we_o              (wb_we_o),
    .wb_ack_i             (wb_ack_i),
    .wb_cab_o             (wb_cab_o),
    .wb_err_i             (wb_err_i),
    .wb_cti_o             (wb_cti_o),
    .wb_bte_o             (wb_bte_o)
`endif
    );
`endif // ENABLE_ADV_DBG_IF

endmodule
