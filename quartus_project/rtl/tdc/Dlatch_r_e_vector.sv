//-----------------------------------------------------
// Design Name : Dlatch_r_e_vector
// File Name   : dlatch_r_e_vector.sv
// Function    : DLATCH async reset and enable
// Coder      : Deepak Kumar Tala - wrmelo
//-----------------------------------------------------
module dlatch_r_e_vector (
input  logic [15:0] data   , // Data Input
input  wire en     , // LatchInput enable
input  wire reset  , // Reset input
input  wire clk    , // CLK input
output wire rst_sync, // reset sincrono
output reg [15:0]  q        // Q output
);

//-------------Code Starts Here---------

reg rst_int;

always_ff @(posedge clk)
if (~reset) begin
  rst_int <= 1'b0;
end else begin
  rst_int <= ~en;
end

assign rst_sync = rst_int & reset;

always_ff @(posedge clk)
if (~reset) begin
  q[0] <= 1'b0;
end else if (en) begin
  q[0] <= data[0];
end

always_ff @(posedge clk)
if (~reset) begin
  q[1] <= 1'b0;
end else if (en) begin
  q[1] <= data[1];
end

always_ff @(posedge clk)
if (~reset) begin
  q[2] <= 1'b0;
end else if (en) begin
  q[2] <= data[2];
end

always_ff @(posedge clk)
if (~reset) begin
  q[3] <= 1'b0;
end else if (en) begin
  q[3] <= data[3];
end

always_ff @(posedge clk)
if (~reset) begin
  q[4] <= 1'b0;
end else if (en) begin
  q[4] <= data[4];
end

always_ff @(posedge clk)
if (~reset) begin
  q[5] <= 1'b0;
end else if (en) begin
  q[5] <= data[5];
end

always_ff @(posedge clk)
if (~reset) begin
  q[6] <= 1'b0;
end else if (en) begin
  q[6] <= data[6];
end

always_ff @(posedge clk)
if (~reset) begin
  q[7] <= 1'b0;
end else if (en) begin
  q[7] <= data[7];
end

always_ff @(posedge clk)
if (~reset) begin
  q[8] <= 1'b0;
end else if (en) begin
  q[8] <= data[8];
end

always_ff @(posedge clk)
if (~reset) begin
  q[9] <= 1'b0;
end else if (en) begin
  q[9] <= data[9];
end

always_ff @(posedge clk)
if (~reset) begin
  q[10] <= 1'b0;
end else if (en) begin
  q[10] <= data[10];
end

always_ff @(posedge clk)
if (~reset) begin
  q[11] <= 1'b0;
end else if (en) begin
  q[11] <= data[11];
end

always_ff @(posedge clk)
if (~reset) begin
  q[12] <= 1'b0;
end else if (en) begin
  q[12] <= data[12];
end

always_ff @(posedge clk)
if (~reset) begin
  q[13] <= 1'b0;
end else if (en) begin
  q[13] <= data[13];
end

always_ff @(posedge clk)
if (~reset) begin
  q[14] <= 1'b0;
end else if (en) begin
  q[14] <= data[14];
end

always_ff @(posedge clk)
if (~reset) begin
  q[15] <= 1'b0;
end else if (en) begin
  q[15] <= data[15];
end

endmodule //End Of Module dlatch_reset