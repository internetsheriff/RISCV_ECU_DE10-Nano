//-----------------------------------------------------------------------------
// DDS Core - Phase Accumulator + Square Wave Output
//-----------------------------------------------------------------------------
// Accumulates phase and outputs MSB as square wave.
// Used for SAW sensor interrogation with simple RF envelope.
//-----------------------------------------------------------------------------

module dds_core #(
    parameter PHASE_WIDTH = 32
)(
    input  wire                     clk,
    input  wire                     rst,
    input  wire [PHASE_WIDTH-1:0]   ftw,
    input  wire                     enable,
    output wire                     dds_out,
    output reg  [PHASE_WIDTH-1:0]   phase
);

    always_ff @(posedge clk) begin
        if (rst)
            phase <= '0;
        else if (enable)
            phase <= phase + ftw;
    end

    assign dds_out = phase[PHASE_WIDTH-1];

endmodule
