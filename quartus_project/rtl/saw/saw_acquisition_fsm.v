//-----------------------------------------------------------------------------
// saw_acquisition_fsm - SAW Sensor Burst Interrogation Controller
//-----------------------------------------------------------------------------
// Generates a fixed-frequency RF burst (160 MHz gated clock) to excite the
// SAW sensor, then opens a receive window and timestamps the echo with the
// tdc_linux128 (PulseA / PulseB).
//
// Clock: 160 MHz (outclk_1 from PLL).
// TX output: glitch-free gated 160 MHz clock using negedge latch technique.
// RX input : asynchronous; internally synchronized with 2-FF + edge detect.
// Trigger  : KEY[1] active-low button (falling edge = start acquisition).
//-----------------------------------------------------------------------------

module saw_acquisition_fsm #(
    parameter integer BURST_CYCLES  = 16,     // RF burst length (cycles @ 160 MHz = 100 ns)
    parameter integer DEAD_CYCLES   = 2000,   // blanking after burst  (cycles @ 160 MHz = 12.5 us)
    parameter integer WINDOW_CYCLES = 20000,  // RX timeout window     (cycles @ 160 MHz = 125 us)
    parameter integer CONTINUOUS_TX = 0       // 0=burst mode (gated), 1=160 MHz always on
)(
    input  wire clk,        // 160 MHz PLL clock (outclk_1)
    input  wire rst,        // synchronous active-high reset

    input  wire key_n,      // KEY[1] – active-low pushbutton (DE10-Nano)
    input  wire rx_in,      // async echo: output of envelope detector / comparator

    output wire tx_out,     // gated 160 MHz burst  → GPIO → BPF → SAW
    output reg  tdc_start,  // PulseA to tdc_linux128 (end of last burst cycle)
    output reg  tdc_stop,   // PulseB to tdc_linux128 (echo arrival)
    output reg  done        // 1-cycle pulse: acquisition finished (hit or timeout)
);

    // =========================================================================
    // 1. KEY[1] edge detector  (active-low: press = 1→0, detect falling edge)
    // =========================================================================
    reg key_d1, key_d2;

    always @(posedge clk) begin
        if (rst) begin
            key_d1 <= 1'b1;
            key_d2 <= 1'b1;
        end else begin
            key_d1 <= key_n;
            key_d2 <= key_d1;
        end
    end

    // start_pulse = single-cycle high on falling edge of key_n (button press)
    wire start_pulse = key_d2 & ~key_d1;

    // =========================================================================
    // 2. RX input synchronizer (2-FF) + rising-edge detector
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

    wire rx_edge = rx_ff2 & ~rx_ff3;   // 1-cycle pulse on echo rising edge

    // =========================================================================
    // 3. TX output: burst (gated) or continuous 160 MHz
    //    CONTINUOUS_TX=1: tx_out = clk (always on)
    //    CONTINUOUS_TX=0: glitch-free gated burst (negedge latch technique)
    // =========================================================================
    reg  tx_enable;
    reg  tx_gate;

    always @(negedge clk)
        tx_gate <= tx_enable;

    assign tx_out = (CONTINUOUS_TX != 0) ? clk : (tx_gate & clk);

    // =========================================================================
    // 4. FSM
    // =========================================================================
    localparam [2:0]
        IDLE      = 3'd0,
        BURST     = 3'd1,
        DEAD_TIME = 3'd2,
        RX_WAIT   = 3'd3,
        DONE_ST   = 3'd4;

    reg [2:0]  state;
    reg [$clog2(BURST_CYCLES)-1:0] burst_cnt;
    reg [31:0] counter;
    reg        captured;

    always @(posedge clk) begin
        if (rst) begin
            state     <= IDLE;
            tdc_start <= 1'b0;
            tdc_stop  <= 1'b0;
            done      <= 1'b0;
            tx_enable <= 1'b0;
            burst_cnt <= {($clog2(BURST_CYCLES)){1'b0}};
            counter   <= 32'd0;
            captured  <= 1'b0;
        end else begin

            // single-cycle default
            tdc_start <= 1'b0;
            tdc_stop  <= 1'b0;
            done      <= 1'b0;

            case (state)

                // ----------------------------------------------------------
                IDLE: begin
                    tx_enable <= 1'b0;
                    if (start_pulse) begin
                        burst_cnt <= BURST_CYCLES - 1;
                        state     <= BURST;
                    end
                end

                // ----------------------------------------------------------
                // Transmit BURST_CYCLES cycles of 160 MHz.
                // On the last cycle (burst_cnt == 0):
                //   - fire tdc_start as TDC reference
                //   - disable TX
                //   - enter dead-time blanking
                // ----------------------------------------------------------
                BURST: begin
                    tx_enable <= 1'b1;
                    if (burst_cnt == 0) begin
                        tdc_start <= 1'b1;
                        tx_enable <= 1'b0;
                        counter   <= 32'd0;
                        state     <= DEAD_TIME;
                    end else begin
                        burst_cnt <= burst_cnt - 1'b1;
                    end
                end

                // ----------------------------------------------------------
                // Blanking: wait DEAD_CYCLES before opening RX window.
                // Prevents TX feed-through from triggering the TDC.
                // ----------------------------------------------------------
                DEAD_TIME: begin
                    counter <= counter + 1'b1;
                    if (counter >= DEAD_CYCLES - 1) begin
                        counter  <= 32'd0;
                        captured <= 1'b0;
                        state    <= RX_WAIT;
                    end
                end

                // ----------------------------------------------------------
                // Listen for echo. First rising edge fires tdc_stop.
                // Timeout after WINDOW_CYCLES if no echo received.
                // ----------------------------------------------------------
                RX_WAIT: begin
                    counter <= counter + 1'b1;
                    if (rx_edge && !captured) begin
                        tdc_stop <= 1'b1;
                        captured <= 1'b1;
                        state    <= DONE_ST;
                    end else if (counter >= WINDOW_CYCLES - 1) begin
                        state <= DONE_ST;
                    end
                end

                // ----------------------------------------------------------
                DONE_ST: begin
                    done  <= 1'b1;
                    state <= IDLE;
                end

                default: state <= IDLE;

            endcase
        end
    end

endmodule
