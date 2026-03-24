// =============================================================================
// tdc_cal_pulse_gen - Gerador de pulsos controlados para calibração do TDC
// =============================================================================
// Clock: 25 MHz (40 ns/ciclo)
// delay_sel: 0=1cy(40ns), 1=2cy(80ns), 2=3cy(120ns), 3=4cy(160ns), 4=5cy(200ns)
// Gera pares (PulseA, PulseB) a cada 1 ms para permitir estabilização do TDC
// =============================================================================

module tdc_cal_pulse_gen #(
    parameter REPEAT_PERIOD = 25000  // ciclos entre medições (~1 ms @ 25 MHz)
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       enable,
    input  wire [2:0] delay_sel,
    output reg        pulse_a,
    output reg        pulse_b
);

    wire [3:0] delay_cy = {1'b0, delay_sel} + 4'd1;  // 1, 2, 3, 4, 5 ciclos
    reg [14:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 15'd0;
            pulse_a <= 1'b0;
            pulse_b <= 1'b0;
        end else if (!enable) begin
            cnt     <= 15'd0;
            pulse_a <= 1'b0;
            pulse_b <= 1'b0;
        end else begin
            pulse_a <= 1'b0;
            pulse_b <= 1'b0;

            /* TDC mede XOR(A,B): enable alto enquanto A≠B. A=1,B=0 por N ciclos,
               depois B sobe com A=1 -> XOR=0 (stop). */
            if (cnt == 15'd0) begin
                pulse_a <= 1'b1;
                cnt     <= cnt + 15'd1;
            end else if (cnt < {11'd0, delay_cy}) begin
                pulse_a <= 1'b1;
                cnt     <= cnt + 15'd1;
            end else if (cnt == {11'd0, delay_cy}) begin
                pulse_a <= 1'b1;
                pulse_b <= 1'b1;   /* B sobe com A=1 -> XOR=0, para contagem */
                cnt     <= cnt + 15'd1;
            end else if (cnt >= REPEAT_PERIOD - 15'd1) begin
                cnt <= 15'd0;
            end else begin
                cnt <= cnt + 15'd1;
            end
        end
    end

endmodule
