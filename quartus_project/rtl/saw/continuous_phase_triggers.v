//-----------------------------------------------------------------------------
// continuous_phase_triggers - TDC triggers for continuous phase measurement
//-----------------------------------------------------------------------------
// Each rising edge of TX -> PulseA (TDC start)
// Each rising edge of RX -> PulseB (TDC stop)
//
// Used with CONTINUOUS_TX=1 for 160 MHz on both TX and RX.
// TDC measures the interval (phase) between corresponding edges.
//
// TX edge: use tx_in directly as PulseA when TX=clk (rising edge = start).
//          PulseA high for half period (3.1 ns) -> phase range 0-180°.
// RX edge: 2-FF sync + rising-edge detect (RX is async input)
//-----------------------------------------------------------------------------

module continuous_phase_triggers (
    input  wire clk,        // 160 MHz (same as TX)
    input  wire rst,        // sync active-high reset

    input  wire tx_in,      // TX output (160 MHz, e.g. saw_tx_out)
    input  wire rx_in,      // RX input (async, e.g. saw_rx_p)

    output wire pulse_a,    // TX rising edge marker -> TDC PulseA
    output wire pulse_b     // 1-cycle pulse on each RX rising edge -> TDC PulseB
);

    // =========================================================================
    // 1. PulseA: use TX directly. When TX=clk (continuous mode), the rising
    //    edge is the reference. High for half period covers phase 0-180°.
    //    (For 180-360° would need a stretched pulse; 0-180° suffices for test)
    // =========================================================================
    assign pulse_a = tx_in;

    // =========================================================================
    // 2. RX: 2-FF sync + rising edge detect
    // =========================================================================
    reg rx_ff1, rx_ff2, rx_ff3;

    always @(posedge clk) begin
        if (rst) begin
            rx_ff1 <= 1'b0;
            rx_ff2 <= 1'b0;
            rx_ff3 <= 1'b0;
        end else begin
            rx_ff1 <= rx_in;
            rx_ff2 <= rx_ff1;
            rx_ff3 <= rx_ff2;
        end
    end

    assign pulse_b = rx_ff2 & ~rx_ff3;

endmodule
