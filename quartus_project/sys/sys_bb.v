
module sys (
	clk_clk,
	master_0_master_reset_reset,
	pio_0_external_connection_export,
	pulpino_0_config_testmode_i,
	pulpino_0_config_fetch_enable_i,
	pulpino_0_config_clock_gating_i,
	pulpino_0_config_boot_addr_i,
	reset_reset_n);	

	input		clk_clk;
	output		master_0_master_reset_reset;
	output	[9:0]	pio_0_external_connection_export;
	input		pulpino_0_config_testmode_i;
	input		pulpino_0_config_fetch_enable_i;
	input		pulpino_0_config_clock_gating_i;
	input	[31:0]	pulpino_0_config_boot_addr_i;
	input		reset_reset_n;
endmodule
