// simple_reciprocal_counter.sv
// Mede N períodos completos do sinal (1ª borda -> t_start; após N períodos -> t_end):
//   f_hz ≈ N * CLK_HZ / (t_end - t_start)
//
// clk: domínio único (ex. 25 MHz). signal_in assíncrono (2 FF).
// start_pulse / ack_pulse: pulsos de 1 ciclo em clk.
//
// Se não houver primeira borda de subida em FIRST_EDGE_TIMEOUT_TICKS ciclos de clk,
// termina com frequency_hz=0 e ready=1 (evita bloqueio com entrada DC/flutuante).

`timescale 1ns/1ps

module simple_reciprocal_counter #(
    parameter int unsigned CLK_HZ                   = 25_000_000,
    parameter int unsigned N_PERIODS                = 2000,
    parameter int unsigned FIRST_EDGE_TIMEOUT_TICKS = 100_000_000  // ~4 s @ 25 MHz (1.ª borda; sinais lentos)
) (
    input  logic        clk,
    input  logic        rst_n,

    input  logic        signal_in,

    input  logic        start_pulse,
    input  logic        ack_pulse,

    output logic [15:0] frequency_hz,
    output logic        ready
);

    logic sig_sync1, sig_sync2, sig_prev;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sig_sync1 <= 1'b0;
            sig_sync2 <= 1'b0;
        end else begin
            sig_sync1 <= signal_in;
            sig_sync2 <= sig_sync1;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sig_prev <= 1'b0;
        else
            sig_prev <= sig_sync2;
    end

    wire rising_sig = sig_sync2 & ~sig_prev;

    logic [31:0] time_counter;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            time_counter <= '0;
        else
            time_counter <= time_counter + 1'b1;
    end

    typedef enum logic [1:0] {
        ST_IDLE,
        ST_MEAS,
        ST_DONE
    } state_t;

    state_t state;
    logic [31:0] t_start, t_end, t_meas_arm;
    logic        have_t0;
    logic [31:0] edge_cnt;

    logic [31:0] delta_t;
    logic [63:0] numer;
    logic [63:0] quot;
    logic [15:0] freq_calc;

    always_comb begin
        delta_t = t_end - t_start;
        numer   = 64'(N_PERIODS) * 64'(CLK_HZ);
        if (delta_t == 32'd0) begin
            quot      = 64'd0;
            freq_calc = 16'd0;
        end else begin
            quot      = numer / 64'(delta_t);
            freq_calc = (quot > 64'd65535) ? 16'hFFFF : quot[15:0];
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= ST_IDLE;
            t_start      <= '0;
            t_end        <= '0;
            t_meas_arm   <= '0;
            have_t0      <= 1'b0;
            edge_cnt     <= '0;
            frequency_hz <= '0;
            ready        <= 1'b0;
        end else begin
            case (state)
                ST_IDLE: begin
                    ready <= 1'b0;
                    if (start_pulse) begin
                        state      <= ST_MEAS;
                        t_start    <= '0;
                        t_end      <= '0;
                        t_meas_arm <= time_counter;
                        have_t0    <= 1'b0;
                        edge_cnt   <= '0;
                    end
                end

                ST_MEAS: begin
                    if (!have_t0
                        && (time_counter - t_meas_arm) >= 32'(FIRST_EDGE_TIMEOUT_TICKS)) begin
                        state <= ST_DONE;
                    end else if (rising_sig) begin
                        if (!have_t0) begin
                            t_start  <= time_counter;
                            have_t0  <= 1'b1;
                            edge_cnt <= '0;
                        end else if (edge_cnt == N_PERIODS - 1) begin
                            t_end <= time_counter;
                            state <= ST_DONE;
                        end else begin
                            edge_cnt <= edge_cnt + 1'b1;
                        end
                    end
                end

                ST_DONE: begin
                    frequency_hz <= freq_calc;
                    ready        <= 1'b1;
                    if (ack_pulse) begin
                        state <= ST_IDLE;
                        ready <= 1'b0;
                    end
                end

                default: state <= ST_IDLE;
            endcase
        end
    end

endmodule
