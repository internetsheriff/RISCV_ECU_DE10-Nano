//-----------------------------------------------------------------------------
// phase_shifter_carry - Carry-chain delay line for Cyclone V
//-----------------------------------------------------------------------------
// Uses fast carry logic. Each TAP spans STAGES_PER_TAP carry stages.
// 128 taps, tap 127 ≈ 625 ns (1.6 MHz period). ~4.9 ns per tap.
//
// STAGES_PER_TAP ≈ 98 (~50 ps/stage × 98 ≈ 4.9 ns)
// Total: 127 × 98 = 12446 stages.
//
// TAP_SEL 0..NUM_TAPS-1 selects output from stage 0, STAGES_PER_TAP, 2*..., etc.
//-----------------------------------------------------------------------------

(* altera_attribute = "-name AUTO_CARRY_CHAINS ON" *)
module phase_shifter_carry #(
    parameter integer NUM_TAPS       = 128,   // 128 taps (0..127)
    parameter integer TAP_BITS       = 7,     // log2(NUM_TAPS)
    parameter integer STAGES_PER_TAP = 98     // ~4.9 ns per tap @ 50 ps/stage
)(
    input  wire                sig_in,     // input (e.g. 1.6 MHz clock)
    input  wire [TAP_BITS-1:0] tap_sel,    // 0 = min delay, 127 = ~625 ns
    output wire                sig_out     // delayed output
);

    localparam integer NUM_STAGES = (NUM_TAPS - 1) * STAGES_PER_TAP;  // 12446

    // Break clock inference: force sig_in through LUT
    (* keep = 1 *)
    wire sig_in_comb = sig_in ? 1'b1 : 1'b0;

    // Carry chain (Quartus limit 5000 iterations per loop – split into blocks)
    (* keep = 1 *) wire [NUM_STAGES:0] carry;
    assign carry[0] = sig_in_comb;

    localparam integer CHUNK = 4000;  // max iterations per generate loop
    genvar i;
    generate
        for (i = 0; i < CHUNK && i < NUM_STAGES; i = i + 1) begin : gen_carry_0
            wire sum_unused;
            (* keep = 1 *)
            assign {carry[i+1], sum_unused} = 1'b1 + 1'b0 + carry[i];
        end
        for (i = CHUNK; i < 2*CHUNK && i < NUM_STAGES; i = i + 1) begin : gen_carry_1
            wire sum_unused;
            (* keep = 1 *)
            assign {carry[i+1], sum_unused} = 1'b1 + 1'b0 + carry[i];
        end
        for (i = 2*CHUNK; i < 3*CHUNK && i < NUM_STAGES; i = i + 1) begin : gen_carry_2
            wire sum_unused;
            (* keep = 1 *)
            assign {carry[i+1], sum_unused} = 1'b1 + 1'b0 + carry[i];
        end
        for (i = 3*CHUNK; i < NUM_STAGES; i = i + 1) begin : gen_carry_3
            wire sum_unused;
            (* keep = 1 *)
            assign {carry[i+1], sum_unused} = 1'b1 + 1'b0 + carry[i];
        end
    endgenerate

    // Tap index: 0, 98, 196, ..., 12446 (tap 127)
    wire [13:0] tap_idx = tap_sel * STAGES_PER_TAP;
    assign sig_out = carry[tap_idx];

endmodule
