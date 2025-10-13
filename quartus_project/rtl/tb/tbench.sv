`timescale 1ns/10ps

module tbench();

reg clk50;
reg reset_n;
wire [3:0] keys;
wire [9:0] led;
wire [9:0] sw;

assign keys[0] = reset_n;

pulpino_qsys_test dut(
    .CLK_50(clk50),
	.KEY(keys),
    .LEDR(led),
    .SW(sw)
);

initial begin
    reset_n = 1'b0;
    #10ns reset_n = 1'b1;
end

initial begin
    clk50 = 0;

    forever begin
        #10ns clk50 = ~clk50;
    end
end

endmodule
