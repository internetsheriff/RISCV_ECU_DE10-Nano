`timescale 1ns/10ps

module tbench();

reg clk50;
reg reset_n;
wire [3:0] keys;
wire [9:0] led;
reg [9:0] sw;

assign keys[3:1] = 3'b0;

pulpino_qsys_test dut(
    .CLOCK_50(clk50),
	 .KEY(keys),
    .LEDR(led),
    .SW(sw)
);

initial begin
    // condicoes iniciais 
    clk50 = 0;
    reset_n = 1'b0;
    sw = 10'b0000000000;
    
    
    #10ns 

    // liga o core
    reset_n = 1'b1;

    #19000ns
    sw = 10'b1111111111;
    
    #1000ns

    // Fim
    $stop;

end

always begin
        #10ns clk50 = ~clk50;
end

endmodule
