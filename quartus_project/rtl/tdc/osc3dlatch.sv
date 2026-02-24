//-----------------------------------------------------
// Design Name : osc3dlatch
// File Name   : osc3dlatch.sv
// Function    : fases multiplas do clock
// Coder      : Wellington Melo
//-----------------------------------------------------

module osc3dlatch (
input  wire reset,         // reset
input  wire enable,        // enable
output reg clk0out      	// OSC output
);

//------declaration ----------


wire data1        /* synthesis keep */;
wire data2        /* synthesis keep */;
wire data3        /* synthesis keep */;
 

reg q1           /* synthesis keep */;
reg q2           /* synthesis keep */;
reg q3           /* synthesis keep */;


always_latch
if (~reset) begin
  q1 <= 1'b0;
end else if (enable) begin
  q1 <= data1;
end

always_latch
if (~reset) begin
  q2 <= 1'b0;
end else if (enable) begin
  q2 <= data2;
end

always_latch
if (~reset) begin
  q3 <= 1'b0;
end else if (enable) begin
  q3 <= data3;
end




assign #(1000ps) data2 = ~q1;
assign #(1000ps) data3 = ~q2;
assign #(1000ps) data1 = ~q3;

assign clk0out = q3;


endmodule //End Of Module multi - phase
