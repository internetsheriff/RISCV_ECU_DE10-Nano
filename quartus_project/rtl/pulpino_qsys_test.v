
module pulpino_qsys_test (
    input CLOCK_50,
    input [3:0] KEY,
    input [9:0] SW,
    output [9:0] LEDR
);

parameter BOOT_ADDR = 32'h00008000;

// Pulpino Config
wire test_mode;
wire fetch_enable;
wire clock_gating;

assign test_mode = 1'b0;
assign fetch_enable = 1'b1;
assign clock_gating = 1'b0;


// Reset Setup
wire jtag_reset;
wire reset_n;
assign reset_n = KEY[0] & ~jtag_reset ;


// PIO_OUT setup
wire [31:0] gpio_out;
//wire [21:0] unused_gpio_out;

assign LEDR [9:0] = gpio_out [9:0];
//assign unused_gpio_out[21:0] = gpio_out[31:10]; 


// PIO_IN setup
wire [31:0] gpio_in;
//wire [18:0] unused_gpio_in;

assign gpio_in [3:0] = KEY [3:0];
assign gpio_in [13:4] = SW [9:0];
assign gpio_in [31:14] = 18'b0;




// Core Instantiation
sys u0 (
    .clk_clk                             (CLOCK_50),                             
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