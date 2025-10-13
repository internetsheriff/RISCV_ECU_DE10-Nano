module pulpino_qsys_test(
    input CLK_50,
    input [3:0] KEY,
    output [9:0] LEDR
);

wire jtag_reset;
wire [9:0] gpio;
wire [2:0] unused_keys;

assign LEDR = gpio;
assign jtag_reset = KEY[0];
assign unused_keys = KEY[3:1];

sys u0 (
    .clk_clk                            (CLK_50),
    .reset_reset_n                      (RESET_N & ~jtag_reset),
    .master_0_master_reset_reset        (jtag_reset),
    .pulpino_0_config_testmode_i        (1'b0),
    .pulpino_0_config_fetch_enable_i    (1'b1),
    .pulpino_0_config_clock_gating_i    (1'b0),
    .pulpino_0_config_boot_addr_i       (32'h00008000),
    .pio_0_external_connection_export   (gpio)
);

endmodule
