//-----------------------------------------------------------------------------
// phase_shifter_fine - Carry-chain com 1 estágio por tap (~50 ps/tap)
//-----------------------------------------------------------------------------
// Mesma topologia que phase_shifter_carry, STAGES_PER_TAP=1.
// 128 taps (0..127) → atraso total ~0 a ~6.4 ns (útil para fase @ 160 MHz).
//-----------------------------------------------------------------------------

(* altera_attribute = "-name AUTO_CARRY_CHAINS ON" *)
module phase_shifter_fine #(
    parameter integer NUM_TAPS       = 128,
    parameter integer TAP_BITS       = 7,
    parameter integer STAGES_PER_TAP = 1
)(
    input  wire                sig_in,
    input  wire [TAP_BITS-1:0] tap_sel,
    output wire                sig_out
);

    localparam integer NUM_STAGES = (NUM_TAPS - 1) * STAGES_PER_TAP;

    (* keep = 1 *)
    wire sig_in_comb = sig_in ? 1'b1 : 1'b0;

    (* keep = 1 *) wire [NUM_STAGES:0] carry;
    assign carry[0] = sig_in_comb;

    genvar i;
    generate
        for (i = 0; i < NUM_STAGES; i = i + 1) begin : gen_fine
            wire sum_unused;
            (* keep = 1 *)
            assign {carry[i+1], sum_unused} = 1'b1 + 1'b0 + carry[i];
        end
    endgenerate

    assign sig_out = carry[tap_sel];

endmodule
