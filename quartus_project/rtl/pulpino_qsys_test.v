module pulpino_qsys_test (
	input CLOCK_50,
	input  [1:0]  KEY,
	output [7:0]  LED,
	inout  [35:0] GPIO_0,
	inout  [35:0] GPIO_1
);

parameter BOOT_ADDR = 32'h00008000;

wire test_mode;
wire fetch_enable;
wire clock_gating;

assign test_mode = 1'b0;
assign fetch_enable = 1'b1;
assign clock_gating = 1'b0;

wire clk25;
wire jtag_reset;
wire reset_n;

assign reset_n = KEY[0] & ~jtag_reset;

pll clock_conversion (
	.refclk   (CLOCK_50),
	.rst      (~reset_n),
	.outclk_0 (clk25)
);

wire [31:0] gpio_out;
assign LED[7:0] = gpio_out[7:0];

wire [31:0] gpio_0_bus;
wire [31:0] gpio_1_bus;
wire [31:0] debug_wire;

wire [15:0] freq_hz_meas;
wire        freq_ready_meas;

wire [31:0] gpio_in;
assign gpio_in[1:0]    = KEY[1:0];
assign gpio_in[17:2]  = freq_hz_meas;
assign gpio_in[18]    = freq_ready_meas;
assign gpio_in[31:19] = 13'd0;

sys u0 (
	.clk_clk                               (clk25),
	.master_0_master_reset_reset           (jtag_reset),
	.pio_out_external_connection_export    (gpio_out),
	.pio_in_external_connection_export     (gpio_in),
	.pulpino_0_config_testmode_i           (test_mode),
	.pulpino_0_config_fetch_enable_i       (fetch_enable),
	.pulpino_0_config_clock_gating_i       (clock_gating),
	.pulpino_0_config_boot_addr_i          (BOOT_ADDR),
	.reset_reset_n                         (reset_n),
	.gpio_0_external_connection_export     (gpio_0_bus),
	.gpio_1_external_connection_export     (gpio_1_bus),
	.gpio_extra_external_connection_export ({GPIO_1[35:32], GPIO_0[35:32]}),
	.debug_external_connection_export     (debug_wire)
);

// Detecção de borda em PIO_OUT[30]=start, [29]=ack (1 ciclo cada)
reg [31:0] gpio_out_d;
always @(posedge clk25 or negedge reset_n) begin
	if (!reset_n)
		gpio_out_d <= 32'd0;
	else
		gpio_out_d <= gpio_out;
end

wire start_pulse = gpio_out[30] & ~gpio_out_d[30];
wire ack_pulse   = gpio_out[29] & ~gpio_out_d[29];

simple_reciprocal_counter #(
	.CLK_HZ(25_000_000),
	.N_PERIODS(2000)
) u_freq_rec (
	.clk            (clk25),
	.rst_n          (reset_n),
	/* Mesmo net que o header, à entrada do IO pad (evita qualquer separação no barramento interno). */
	.signal_in      (GPIO_0[0]),
	.start_pulse    (start_pulse),
	.ack_pulse      (ack_pulse),
	.frequency_hz   (freq_hz_meas),
	.ready          (freq_ready_meas)
);

assign GPIO_0[31:0] = gpio_0_bus[31:0];
assign GPIO_1[31:0] = gpio_1_bus[31:0];

endmodule
