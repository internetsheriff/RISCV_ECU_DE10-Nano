// =============================================================================
// tdc_min_pulse_gen - Limites mínimos do TDC (clock 160 MHz)
// =============================================================================
// Clock: 160 MHz (6.25 ns/ciclo)
// delay_sel: 0=1cy(6.25ns), 1=2cy(12.5ns), 2=3cy(18.75ns), 3=4cy(25ns),
//            4=5cy(31.25ns), 5=6cy(37.5ns)
// Gera pares (PulseA, PulseB) a cada 1 ms para estabilização
// =============================================================================

module tdc_min_pulse_gen #(
    parameter REPEAT_PERIOD = 160000  // ~1 ms @ 160 MHz
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       enable,
    input  wire [2:0] delay_sel,
    output reg        pulse_a,
    output reg        pulse_b
);

    wire [3:0] delay_cy = {1'b0, delay_sel} + 4'd1;  // 1..6 ciclos
    reg [17:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 18'd0;
            pulse_a <= 1'b0;
            pulse_b <= 1'b0;
        end else if (!enable) begin
            cnt     <= 18'd0;
            pulse_a <= 1'b0;
            pulse_b <= 1'b0;
        end else begin
            pulse_a <= 1'b0;
            pulse_b <= 1'b0;

            if (cnt == 18'd0) begin
                pulse_a <= 1'b1;
                cnt     <= cnt + 18'd1;
            end else if (cnt < {14'd0, delay_cy}) begin
                pulse_a <= 1'b1;
                cnt     <= cnt + 18'd1;
            end else if (cnt == {14'd0, delay_cy}) begin
                pulse_a <= 1'b1;
                pulse_b <= 1'b1;   /* B sobe com A=1 -> XOR=0 */
                cnt     <= cnt + 18'd1;
            end else if (cnt >= REPEAT_PERIOD - 18'd1) begin
                cnt <= 18'd0;
            end else begin
                cnt <= cnt + 18'd1;
            end
        end
    end

endmodule
