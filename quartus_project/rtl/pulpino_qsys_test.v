
module pulpino_qsys_test (
    input CLOCK_50,
    input [3:0] KEY,
    input [9:0] SW,
    output [9:0] LEDR
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
wire reset_p;

assign reset_n = KEY[0] & ~jtag_reset ;
assign reset_p = ~reset_n;



//============ I/O Configuration ============

// PIO_OUT setup
wire [31:0] gpio_out;
assign LEDR [9:0] = gpio_out [9:0];

// PIO_IN setup
wire [31:0] gpio_in;
assign gpio_in [3:0] = KEY [3:0];
assign gpio_in [13:4] = SW [9:0];
assign gpio_in [31:14] = 18'b0;



// PLL Instantiation
pll clock_conversion(
	.refclk(CLOCK_50),
	.rst(reset_p),
	.outclk_0(clk25)
);

// Core Instantiation
sys u0 (
    .clk_clk                             (clk25),                             
    .master_0_master_reset_reset         (jtag_reset),         
    .pio_out_external_connection_export  (gpio_out),  
    .pio_in_external_connection_export   (gpio_in),  
    .pulpino_0_config_testmode_i         (test_mode),         
    .pulpino_0_config_fetch_enable_i     (fetch_enable),
    .pulpino_0_config_clock_gating_i     (clock_gating),     
    .pulpino_0_config_boot_addr_i        (BOOT_ADDR),        
    .reset_reset_n                       (reset_n)                        
);

endmodule