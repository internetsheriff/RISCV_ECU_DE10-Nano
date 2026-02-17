module adapter(
	input clock,
	input reset_n,
	input signal,
	output pulse1,
	output pulse2
);
	
	wire last;
	wire mux_out1, mux_out2;
	
	commuter COM (
		.clock(clock),
		.reset_n(reset_n),
		.signal(signal),
		.sel(last)
	);
	
	mux1to2 MUX (
		.in(signal),
		.sel(last),
		.a(mux_out1),
		.b(mux_out2)
	);
	
	assign pulse1 = mux_out1;
	assign pulse2 = mux_out2;
	
endmodule
