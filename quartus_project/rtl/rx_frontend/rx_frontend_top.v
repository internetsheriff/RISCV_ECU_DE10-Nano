//-----------------------------------------------------------------------------
// rx_frontend_top - SAW RX frontend for tdc_linux128
//-----------------------------------------------------------------------------
// Integrates: sync → edge detect → phase capture → event FIFO.
// Generates PulseA (TX ref) and PulseB (echo) for tdc_linux128.
// Pipeline: echo → capture phase/step → wait for TDC → write to FIFO.
//-----------------------------------------------------------------------------
// Clock: 200 MHz (same as DDS). TDC (tdc_linux128) has internal oscillator.
//-----------------------------------------------------------------------------

module rx_frontend_top (
    input  wire        clk,
    input  wire        rst,

    input  wire        rx_in,              // async, from GPIO (envelope detector)
    input  wire [31:0] dds_phase,
    input  wire signed [7:0] dds_step,
    input  wire        dds_out,
    input  wire        dds_valid,
    input  wire [14:0] tdc_result,         // from tdc_linux128 end_soma

    output wire        pulse_a,            // to TDC PulseA
    output wire        pulse_b,            // to TDC PulseB

    input  wire        fifo_rd_en,
    output wire        fifo_full,
    output wire [63:0] fifo_data_out,
    output wire        fifo_valid,
    output wire        fifo_empty
);

    //----- Sync + Edge -----
    wire sync_sig;
    wire edge_rise;

    sync_2ff u_sync (
        .clk      (clk),
        .async_in (rx_in),
        .sync_out (sync_sig)
    );

    edge_detect u_edge (
        .clk  (clk),
        .sig  (sync_sig),
        .rise (edge_rise)
    );

    assign pulse_b = edge_rise;

    //----- TX Reference (PulseA) -----
    wire tx_pulse_a;
    tx_reference u_tx_ref (
        .clk       (clk),
        .rst       (rst),
        .dds_out   (dds_out),
        .dds_valid (dds_valid),
        .pulse_a   (tx_pulse_a)
    );
    assign pulse_a = tx_pulse_a;

    //----- Phase capture on echo -----
    wire [31:0] phase_sample;
    wire        phase_valid;

    phase_capture u_phase (
        .clk          (clk),
        .rst          (rst),
        .trigger      (edge_rise),
        .phase_in     (dds_phase),
        .phase_sample (phase_sample),
        .valid        (phase_valid)
    );

    //----- Pipeline: wait for TDC result, then write to FIFO -----
    localparam TDC_LATENCY = 4;   // cycles for tdc_linux128 to settle
    reg [2:0]  pipe_cnt;
    reg [31:0] phase_hold;
    reg [7:0]  step_hold;
    reg        pipe_active;

    always @(posedge clk) begin
        if (rst) begin
            pipe_cnt    <= 3'b0;
            phase_hold  <= 32'b0;
            step_hold   <= 8'b0;
            pipe_active <= 1'b0;
        end else if (phase_valid) begin
            phase_hold  <= phase_sample;
            step_hold   <= dds_step[7:0];   // signed to unsigned for storage
            pipe_cnt    <= 3'b0;
            pipe_active <= 1'b1;
        end else if (pipe_active) begin
            if (pipe_cnt >= TDC_LATENCY - 1)
                pipe_active <= 1'b0;
            else
                pipe_cnt <= pipe_cnt + 1;
        end
    end

    wire fifo_wr_en = pipe_active && (pipe_cnt == TDC_LATENCY - 1) && !fifo_full;

    //----- Event FIFO -----
    event_fifo u_fifo (
        .clk      (clk),
        .rst      (rst),
        .wr_en    (fifo_wr_en),
        .step     (step_hold),
        .phase    (phase_hold),
        .tdc      (tdc_result),
        .rd_en    (fifo_rd_en),
        .data_out (fifo_data_out),
        .valid    (fifo_valid),
        .empty    (fifo_empty),
        .full     (fifo_full)
    );

endmodule
