//-----------------------------------------------------------------------------
// sync_2ff - Double flip-flop synchronizer for async input
//-----------------------------------------------------------------------------
// Reduces metastability when sampling asynchronous signal (e.g. RX from GPIO).
// Standard 2-FF synchronizer pattern.
//-----------------------------------------------------------------------------

module sync_2ff (
    input  wire clk,
    input  wire async_in,
    output reg  sync_out
);

    reg ff1;

    always @(posedge clk) begin
        ff1      <= async_in;
        sync_out <= ff1;
    end

endmodule
