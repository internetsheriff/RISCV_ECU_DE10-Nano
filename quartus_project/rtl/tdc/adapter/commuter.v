module commuter(
	input  wire clock,
	input  wire reset_n,
	input  wire signal,
	output reg sel
);

	reg signal_sync1, signal_sync2;
	reg signal_old;
	reg last_was_pulse1;

	// synchronizer
	always @(posedge clock) begin
		signal_sync1 <= signal;
		signal_sync2 <= signal_sync1;
	end

	always @(posedge clock) begin
		if (!reset_n) begin
			signal_old <= 1'b0;
			sel <= 1'b0;
			last_was_pulse1 <= 1'b0;
		end else begin
			if (signal_sync2 && !signal_old) begin
				if (last_was_pulse1) begin
					last_was_pulse1 <= 1'b0;
				end else begin
					last_was_pulse1 <= 1'b1;
				end
			end
			if (!signal_sync2 && signal_old) begin
				if (last_was_pulse1) begin
					sel <= 1'b0;
				end else begin
					sel <= 1'b1;
				end		
			end

			signal_old <= signal_sync2;
		end
	end
endmodule
