//-----------------------------------------------------------------------------
// edge_detect - Rising edge detector
//-----------------------------------------------------------------------------
// Outputs 1-cycle pulse when input transitions 0→1.
// Input must be synchronous to clk (use sync_2ff before this).
//-----------------------------------------------------------------------------

module edge_detect (
    input  wire clk,
    input  wire sig,
    output reg  rise
);

    reg sig_d;

    always @(posedge clk) begin
        sig_d <= sig;
        rise  <= sig & ~sig_d;
    end

endmodule
