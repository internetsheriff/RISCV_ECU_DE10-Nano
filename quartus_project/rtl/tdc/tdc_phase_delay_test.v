// =============================================================================
// tdc_phase_delay_test - Medição de defasagem sub-ns (carry chain fina @ 160 MHz)
// =============================================================================
// PulseA = janela; PulseB = mesma janela atrasada pela linha phase_shifter_fine.
// XOR(PulseA,PulseB) ≈ largura do atraso (fase) — adequado ao TDC linux128.
// Janela larga (> 6 ns) para cobrir tap máximo.
// =============================================================================

module tdc_phase_delay_test #(
    parameter PULSE_CYCLES  = 64,    // ~400 ns @ 160 MHz (> 6 ns)
    parameter REPEAT_PERIOD = 160000 // ~1 ms @ 160 MHz
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       enable,
    input  wire [6:0] tap_sel,
    output wire       pulse_a,
    output wire       pulse_b
);

    reg [17:0] cnt;
    reg        win;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 18'd0;
            win <= 1'b0;
        end else if (!enable) begin
            cnt <= 18'd0;
            win <= 1'b0;
        end else begin
            if (cnt >= REPEAT_PERIOD - 18'd1)
                cnt <= 18'd0;
            else
                cnt <= cnt + 18'd1;
            win <= (cnt < PULSE_CYCLES);
        end
    end

    assign pulse_a = win;

    phase_shifter_fine u_fine (
        .sig_in  (win),
        .tap_sel (tap_sel),
        .sig_out (pulse_b)
    );

endmodule
