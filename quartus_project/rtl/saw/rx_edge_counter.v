//-----------------------------------------------------------------------------
// rx_edge_counter - Diagnostic: count rising edges on RX over fixed window
//-----------------------------------------------------------------------------
// Counts rising edges of rx_sync (RX after 2-FF sync) for WINDOW_CYCLES.
// At 160 MHz: 320 cycles = 2 µs, expect ~320 edges if RX has 160 MHz.
// Use to verify if RX pin is receiving the SAW/comparator signal.
//
// Output: edge_count (10 bits) = number of rising edges in last 2 µs window.
//-----------------------------------------------------------------------------

module rx_edge_counter #(
    parameter integer WINDOW_CYCLES = 320   // 320 @ 160 MHz = 2 µs
)(
    input  wire       clk,         // 160 MHz
    input  wire       rst,         // sync active-high reset

    input  wire       rx_in,      // async RX input (saw_rx_p)

    output reg [9:0]  edge_count  // edges in last 2 µs window (read by CPU)
);

    // Sync + edge detect (same as continuous_phase_triggers)
    reg rx_ff1, rx_ff2, rx_ff3;
    wire rx_edge = rx_ff2 & ~rx_ff3;

    // Window and edge counters
    reg [15:0] cyc_cnt;
    reg [9:0]  edge_cnt;
    localparam [15:0] WINDOW = WINDOW_CYCLES;

    always @(posedge clk) begin
        if (rst) begin
            rx_ff1   <= 1'b0;
            rx_ff2   <= 1'b0;
            rx_ff3   <= 1'b0;
            cyc_cnt  <= 10'd0;
            edge_cnt <= 10'd0;
            edge_count <= 10'd0;
        end else begin
            rx_ff1 <= rx_in;
            rx_ff2 <= rx_ff1;
            rx_ff3 <= rx_ff2;

            if (cyc_cnt >= WINDOW - 1) begin
                edge_count <= edge_cnt + (rx_edge ? 10'd1 : 10'd0);
                cyc_cnt    <= 16'd0;
                edge_cnt   <= 10'd0;
            end else begin
                cyc_cnt  <= cyc_cnt + 16'd1;
                edge_cnt <= edge_cnt + (rx_edge ? 10'd1 : 10'd0);
            end
        end
    end

endmodule
