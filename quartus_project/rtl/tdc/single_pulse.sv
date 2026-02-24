//-----------------------------------------------------
// Design Name : s_pulse_async_reset
// File Name   : s_pulse_async_reset.sv
// Function    : Single Pulse async reset
// Coder      : Wellington Melo
//-----------------------------------------------------
module single_pulse (
input  wire data  , // Data Input
input  wire clk   , // Clock Input
input  wire reset , // Reset input 
output reg  q,      // Q output
output reg  qn,	  // QN output inverse
output reg  s_pulse // Single Pulse
);
//-------------Code Starts Here---------
always_ff @(posedge clk)
if (~reset) begin
  q <= 1'b0;
  
end else begin
  q <= data;

end
assign qn = ~q;
and i1 (s_pulse, data, qn);

endmodule //End Of Module Single Pulse