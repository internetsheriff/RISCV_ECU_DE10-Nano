module pulpino_qsys_test (
	input CLOCK_50,
	input  [1:0]  KEY,      // DE10-Nano has 2 keys (vs 4 on DE1-SoC)
	// Note: DE10-Nano has no switches, removed SW input
	output [7:0]  LED,      // DE10-Nano has 8 LEDs (vs 10 on DE1-SoC)
	inout  [35:0] GPIO_0,
	inout  [35:0] GPIO_1
);


//========= Pulpino Base Config ============

parameter BOOT_ADDR = 32'h00008000;

wire test_mode;
wire fetch_enable;
wire clock_gating;

assign test_mode = 1'b0;
assign fetch_enable = 1'b1;
assign clock_gating = 1'b0;



//============ Synchronization ==============

wire clk25;
wire jtag_reset;
wire reset_n;

assign reset_n = KEY[0] & ~jtag_reset;



//============ I/O Configuration ============

// PIO_OUT setup - DE10-Nano has 8 LEDs
wire [31:0] gpio_out;
assign LED [7:0] = gpio_out [7:0];

// PIO_IN setup - DE10-Nano has 2 keys, no switches
wire [31:0] gpio_in;
assign gpio_in [1:0] = KEY [1:0];
assign gpio_in [31:2] = 30'b0;  // No switches, pad with zeros


// Wire to debug only in waveforms
wire [31:0] debug_wire;


//============ Component Instantiation ============

// PLL Instantiation
pll clock_conversion(
	.refclk   (CLOCK_50),
	.rst      (~reset_n),
	.outclk_0 (clk25)
);

// Core Instantiation
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
	.gpio_0_external_connection_export     (GPIO_0[31:0]),
	.gpio_1_external_connection_export     (GPIO_1[31:0]),
	.gpio_extra_external_connection_export ({GPIO_1[35:32], GPIO_0[35:32]}),
	.debug_external_connection_export      (debug_wire)
);

endmodule
