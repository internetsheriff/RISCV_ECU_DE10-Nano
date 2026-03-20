//-----------------------------------------------------------------------------
// phase_capture - Captures DDS phase on trigger (echo edge)
//-----------------------------------------------------------------------------
// When trigger (PulseB) fires, samples phase_in and asserts valid for 1 cycle.
// Phase is the DDS accumulator value at echo arrival (with ~1 clk uncertainty).
//-----------------------------------------------------------------------------

module phase_capture (
    input  wire        clk,
    input  wire        rst,
    input  wire        trigger,
    input  wire [31:0] phase_in,
    output reg  [31:0] phase_sample,
    output reg         valid
);

    always @(posedge clk) begin
        if (rst) begin
            phase_sample <= 32'b0;
            valid        <= 1'b0;
        end else if (trigger) begin
            phase_sample <= phase_in;
            valid        <= 1'b1;
        end else begin
            valid <= 1'b0;
        end
    end

endmodule
