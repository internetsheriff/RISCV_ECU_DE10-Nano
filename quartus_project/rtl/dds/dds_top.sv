//-----------------------------------------------------------------------------
// DDS Top - Integration of Sweep + Core
//-----------------------------------------------------------------------------
// Instantiates dds_sweep and dds_core for SAW interrogation.
// Parameters:
//   - Clock: 200 MHz
//   - Center: 60 MHz, Span: ±100 kHz, Step: 5 kHz
//   - 41 sweep points, dwell configurable
//-----------------------------------------------------------------------------

module dds_top (
    input  wire clk_200,
    input  wire rst,
    input  wire start,

    output wire dds_out
);

    wire [31:0] ftw;
    wire        valid;
    wire        done;

    // FTW = (f_out / f_clk) × 2^32
    // FTW_CENTER: 60e6 / 200e6 × 2^32 = 1288490189
    // FTW_STEP:   5e3  / 200e6 × 2^32 = 107374
    localparam logic [31:0] FTW_CENTER = 32'd1288490189;
    localparam logic [31:0] FTW_STEP   = 32'd107374;

    dds_sweep #(
        .PHASE_WIDTH (32),
        .STEP_WIDTH  (32)
    ) u_sweep (
        .clk         (clk_200),
        .rst         (rst),
        .start       (start),
        .ftw_center  (FTW_CENTER),
        .ftw_step    (FTW_STEP),
        .num_steps   (6'd41),
        .dwell_cycles(32'd20_000),   // 100 µs per step @ 200 MHz
        .ftw_out     (ftw),
        .valid       (valid),
        .done        (done)
    );

    dds_core #(
        .PHASE_WIDTH (32)
    ) u_dds (
        .clk     (clk_200),
        .rst     (rst),
        .ftw     (ftw),
        .enable  (valid),
        .dds_out (dds_out),
        .phase   ()
    );

endmodule
