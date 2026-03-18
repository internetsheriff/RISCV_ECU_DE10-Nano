//-----------------------------------------------------------------------------
// DDS Sweep - Frequency Step Generator
//-----------------------------------------------------------------------------
// Generates FTW sequence for linear frequency sweep:
//   FTW_i = FTW_center + step_index * FTW_step
// step_index runs from -((num_steps-1)/2) to +((num_steps-1)/2)
//-----------------------------------------------------------------------------
// Fixes applied:
//   - STEP_WIDTH = 32 (107374 requires >16 bits)
//   - $signed(step_index) for correct negative offset multiplication
//   - $signed() in comparison to avoid unsigned/signed mismatch
//-----------------------------------------------------------------------------

module dds_sweep #(
    parameter PHASE_WIDTH = 32,
    parameter STEP_WIDTH  = 32      // 107374 needs 17+ bits; use 32 for consistency
)(
    input  wire                     clk,
    input  wire                     rst,
    input  wire                     start,
    input  wire [PHASE_WIDTH-1:0]   ftw_center,
    input  wire [STEP_WIDTH-1:0]    ftw_step,
    input  wire [5:0]               num_steps,
    input  wire [31:0]              dwell_cycles,

    output reg  [PHASE_WIDTH-1:0]   ftw_out,
    output reg                      valid,
    output reg                      done
);

    reg signed [7:0] step_index;
    reg [31:0] dwell_cnt;

    localparam logic [1:0] IDLE  = 2'd0;
    localparam logic [1:0] RUN   = 2'd1;
    localparam logic [1:0] NEXT  = 2'd2;
    localparam logic [1:0] DONE  = 2'd3;

    reg [1:0] state;

    always_ff @(posedge clk) begin
        if (rst) begin
            state      <= IDLE;
            step_index <= -$signed((num_steps-1)>>1);
            dwell_cnt  <= '0;
            valid      <= 1'b0;
            done       <= 1'b0;
        end else begin
            case (state)

                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        step_index <= -$signed(((num_steps-1)>>1));
                        state      <= RUN;
                    end
                end

                RUN: begin
                    ftw_out   <= ftw_center + $signed(step_index) * ftw_step;
                    valid     <= 1'b1;
                    dwell_cnt <= dwell_cnt + 1;

                    if (dwell_cnt >= dwell_cycles) begin
                        dwell_cnt <= '0;
                        state     <= NEXT;
                    end
                end

                NEXT: begin
                    valid <= 1'b0;
                    if ($signed(step_index) < $signed((num_steps-1)>>1)) begin
                        step_index <= step_index + 1;
                        state      <= RUN;
                    end else begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    done  <= 1'b1;
                    state <= IDLE;
                end

                default: state <= IDLE;

            endcase
        end
    end

endmodule
