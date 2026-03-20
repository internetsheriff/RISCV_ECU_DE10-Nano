//-----------------------------------------------------------------------------
// tx_reference - Generates PulseA for TDC (TX timing reference)
//-----------------------------------------------------------------------------
// PulseA = first rising edge of dds_out when transmitting (dds_valid high).
// One pulse per frequency step (per dwell). Resets when dds_valid goes low.
//-----------------------------------------------------------------------------
// tdc_linux128 measures interval: PulseA (TX ref) → PulseB (echo). This module
// provides PulseA so the TDC has a proper start reference.
//-----------------------------------------------------------------------------

module tx_reference (
    input  wire clk,
    input  wire rst,
    input  wire dds_out,
    input  wire dds_valid,
    output reg  pulse_a
);

    reg dds_out_d1;
    reg first_edge_sent;

    always @(posedge clk) begin
        if (rst) begin
            dds_out_d1     <= 1'b0;
            first_edge_sent<= 1'b0;
            pulse_a        <= 1'b0;
        end else begin
            dds_out_d1 <= dds_out;

            // Clear flag when we leave a dwell (valid goes low)
            if (!dds_valid)
                first_edge_sent <= 1'b0;

            // First rising edge of dds_out when valid and not yet sent
            pulse_a <= dds_out & ~dds_out_d1 & dds_valid & !first_edge_sent;

            if (pulse_a)
                first_edge_sent <= 1'b1;
        end
    end

endmodule
