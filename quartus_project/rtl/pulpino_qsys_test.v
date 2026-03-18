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
wire clk_200;
wire pll_locked;
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
assign gpio_in [16:2] = tdc_end;
assign gpio_in [31:18] = daniel_packed;
assign gpio_in [17] = 1'b0;  // pad


// Wire to debug only in waveforms
wire [31:0] debug_wire;

// TDC wiring (GPIO_0[2]=adapter input, GPIO_0[3]=adapter enable,
// GPIO_0[4]=PulseA direct, GPIO_0[5]=PulseB direct)
wire [14:0] tdc_end;
wire tdc_pulse_a;
wire tdc_pulse_b;
wire tdc_adapter_pulse_a;
wire tdc_adapter_pulse_b;
wire tdc_adapter_en;
wire tdc_adapter_signal;

// Daniel TDC wiring (GPIO_0[6]=adapter input, GPIO_0[7]=adapter enable,
// GPIO_0[8]=start direct, GPIO_0[9]=stop direct)
wire [6:0] daniel_coarse;
wire [6:0] daniel_fine;
wire [13:0] daniel_packed;
wire daniel_start;
wire daniel_stop;
wire daniel_adapter_start;
wire daniel_adapter_stop;
wire daniel_adapter_en;
wire daniel_adapter_signal;

assign tdc_adapter_signal = GPIO_0[2];
assign tdc_adapter_en = GPIO_0[3];
assign tdc_pulse_a = tdc_adapter_en ? tdc_adapter_pulse_a : GPIO_0[4];
assign tdc_pulse_b = tdc_adapter_en ? tdc_adapter_pulse_b : GPIO_0[5];

assign daniel_adapter_signal = GPIO_0[6];
assign daniel_adapter_en = GPIO_0[7];
assign daniel_start = daniel_adapter_en ? daniel_adapter_start : GPIO_0[8];
assign daniel_stop = daniel_adapter_en ? daniel_adapter_stop : GPIO_0[9];
assign daniel_packed = {daniel_coarse, daniel_fine};
//============ Component Instantiation ============

// PLL Instantiation (25 MHz for Pulpino, 200 MHz for DDS/TDC)
pll clock_conversion(
	.refclk   (CLOCK_50),
	.rst      (~reset_n),
	.outclk_0 (clk25),
	.outclk_1 (clk_200),
	.locked   (pll_locked)
);

// TDC Instantiation
tdc_linux128 u_tdc (
	.reset  (reset_n),
	.PulseA (tdc_pulse_a),
	.PulseB (tdc_pulse_b),
	.end_soma(tdc_end)
);

// Adapter Instantiation (square-wave -> alternating pulses)
adapter AD (
	.clock (CLOCK_50),
	.reset_n (reset_n),
	.signal (tdc_adapter_signal),
	.pulse1 (tdc_adapter_pulse_a),
	.pulse2 (tdc_adapter_pulse_b)
);

// Daniel TDC Instantiation
daniel_tdc u_daniel_tdc (
	.clk        (CLOCK_50),
	.rst        (~reset_n),
	.start      (daniel_start),
	.stop       (daniel_stop),
	.coarse_out (daniel_coarse),
	.fine_out   (daniel_fine),
	.valid      ()
);

// Adapter Instantiation (square-wave -> alternating pulses)
adapter AD2 (
	.clock (CLOCK_50),
	.reset_n (reset_n),
	.signal (daniel_adapter_signal),
	.pulse1 (daniel_adapter_start),
	.pulse2 (daniel_adapter_stop)
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
