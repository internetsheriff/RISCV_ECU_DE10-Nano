`timescale 1ns/10ps

module tbench(
	// so empty :3
);

//==================================================
//                 BASIC SETUP
//==================================================

	// fixed during simulation
	parameter BOOT_ADDR = 32'h00008000;
	parameter clk_period = 20; // 50MHz
	
	wire test_mode;
	wire fetch_enable;
	wire clock_gating;
	
	assign test_mode = 1'b0;
	assign fetch_enable = 1'b1;
	assign clock_gating = 1'b0;
	
	
	// changing during the simulation
	reg  tb_clk;
	reg  jtag_reset;
	reg  key_reset; //KEY[0]
	reg  [2:0] KEY_r; //remaining KEY[*]
	reg  [9:0] sw_in;
	wire [9:0] ledr_out;


//==================================================
//                TRI-STATE SETUP
//==================================================

	//first bank delcarations
	wire [35:0] gpio_0;
	reg  [35:0] gpio_0_drive;
	reg  [35:0] gpio_0_en;

	//second bank delcarations
	wire [35:0] gpio_1;
	reg  [35:0] gpio_1_drive;
	reg  [35:0] gpio_1_en;


	// Tristate logic
	assign gpio_0 = gpio_0_en ? gpio_0_drive : 36'hz;
	assign gpio_1 = gpio_1_en ? gpio_1_drive : 36'hz;



//==================================================
//                   Instantiation
//==================================================

	pulpino_qsys_test dut (
		.CLOCK_50  (tb_clk),
		.KEY       ({KEY_r[2:0], key_reset}),
		.SW        (sw_in),
		.LEDR      (ledr_out),
		.GPIO_0    (gpio_0),
		.GPIO_1    (gpio_1)
	);

	wire [31:0] debug_wire;
	assign debug_wire = dut.pulpino_qsys_test.debug_wire;

//==================================================
//                   SIMULATION
//==================================================

	initial begin

		// Initial Conditions
		tb_clk = 0;
		key_reset = 1'b0;
		KEY_r = 3'b1;
		sw_in = 10'b0;
		gpio_0_en = 36'b0;
		gpio_1_en = 36'b0;


	 
	 
		#100 //---------------------

	
	
		// Turning on the core
		key_reset = 1'b1;

	
		// Waiting for end of setup
		#7000 //----------------


		// Waiting for interrupt
		#1ms//----------------------- 
 

		// End simulation
		$stop;
	end


	// Clock Generation
	always begin
		#(clk_period/2) tb_clk = ~tb_clk;
	end

endmodule
