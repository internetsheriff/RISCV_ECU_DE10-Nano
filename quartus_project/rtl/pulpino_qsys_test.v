// =============================================================================
// pulpino_qsys_test - SAW Interrogator Top-Level (DE10-Nano)
// =============================================================================
// Active components:
//   - Pulpino RISC-V soft core (sys, 25 MHz)
//   - PLL: 25 MHz (Pulpino) + 160 MHz (SAW FSM / TDC)
//   - tdc_linux128: ring-oscillator TDC, no external clock
//   - saw_acquisition_fsm: burst generator + echo receiver
//
// SAW I/O (DE10-Nano GPIO JP6):
//   saw_tx_p → PIN_V12  (pin 1) – 160 MHz, single-ended LVTTL
//   saw_rx_p → PIN_AH13 (pin 6) – single-ended LVTTL (~2V threshold)
//
// CPU result readout (via PIO_IN):
//   gpio_in[1:0]   = KEY[1:0]
//   gpio_in[16:2]  = tdc_end[14:0]   (15-bit ToF result)
//   gpio_in[17]    = saw_done         (1-cycle acquisition complete flag)
//   gpio_in[27:18] = rx_edge_count    (10-bit, edges in last 2 µs @ 160 MHz)
//   gpio_in[31:28] = 0 (reserved)
//
// TDC trigger modes (CONTINUOUS_PHASE_TDC):
//   0 = burst mode: PulseA at end of burst, PulseB at first echo edge
//   1 = continuous phase: PulseA per TX rising edge, PulseB per RX rising edge
//
// Phase-shifter test: set via software (PIO_OUT)
//   gpio_out[7:0]   = LED[7:0]
//   gpio_out[14:8]  = tap_sel (0..127) – barramento do phase shifter
//   gpio_out[15]    = phase_test_en (1 = 1.6 MHz TX + delay_line)
//   gpio_out[16]    = tdc_cal_mode (1 = PulseA/PulseB por ciclos 25 MHz)
//   gpio_out[19:17] = delay_sel (cal: 40-200ns; min: 6.25-37.5ns)
//   gpio_out[20]    = tdc_min_mode (1 = limites mínimos @ 160 MHz)
//   gpio_out[21]    = tdc_phase_mode (1 = defasagem 60 ps–6 ns via carry fina)
//
// Scope debug (phase_test_en | tdc_cal | tdc_min | tdc_phase):
//   GPIO_1[34] = PulseA (TDC start)   – observar no osciloscópio
//   GPIO_1[35] = PulseB (TDC stop)    – observar no osciloscópio
// =============================================================================

module pulpino_qsys_test #(
    parameter integer CONTINUOUS_PHASE_TDC = 1  // 1 = edge-per-edge phase measurement
)(
    input  wire        CLOCK_50,
    input  wire [1:0]  KEY,       // KEY[0]=reset, KEY[1]=start burst
    output wire [7:0]  LED,
    inout  wire [35:0] GPIO_0,
    inout  wire [35:0] GPIO_1,

    // SAW TX: single-ended 3.3-V LVTTL output (160 MHz gated burst)
    output wire        saw_tx_p,  // PIN_V12  – JP6 pin 1

    // SAW RX: single-ended LVTTL (add external comparator for 700 mV pp)
    input  wire        saw_rx_p   // PIN_AH13 – JP6 pin 6
);

// =============================================================================
// Pulpino configuration
// =============================================================================
parameter BOOT_ADDR = 32'h00008000;

wire test_mode    = 1'b0;
wire fetch_enable = 1'b1;
wire clock_gating = 1'b0;

// =============================================================================
// Clocks and reset
// =============================================================================
wire clk25;
wire clk_160;
wire pll_locked;
wire jtag_reset;
wire reset_n;

assign reset_n = KEY[0] & ~jtag_reset;

pll clock_conversion (
    .refclk   (CLOCK_50),
    .rst      (~reset_n),
    .outclk_0 (clk25),    // 25 MHz  → Pulpino
    .outclk_1 (clk_160),  // 160 MHz → SAW FSM + TDC
    .locked   (pll_locked)
);

// Clock 1.6 MHz (160/100) para phase test – período 625 ns, margem máxima
reg [6:0] div_cnt;
reg       clk_16;
always @(posedge clk_160 or negedge reset_n) begin
    if (!reset_n) begin
        div_cnt <= 7'd0;
        clk_16  <= 1'b0;
    end else begin
        div_cnt <= (div_cnt == 7'd99) ? 7'd0 : (div_cnt + 7'd1);
        clk_16  <= (div_cnt < 7'd50);   // 50% duty
    end
end

// =============================================================================
// PIO wiring (Pulpino software interface)
// =============================================================================
wire [31:0] gpio_out;
assign LED[7:0] = gpio_out[7:0];

wire [14:0] tdc_end;
wire        saw_done;
wire [31:0] debug_wire;
wire [9:0]  rx_edge_count;

wire [31:0] gpio_in;
assign gpio_in[1:0]    = KEY[1:0];
assign gpio_in[16:2]   = tdc_end;       // ToF measurement (15 bits)
assign gpio_in[17]     = saw_done;      // acquisition complete flag
assign gpio_in[27:18]  = rx_edge_count; // RX edges in 2 µs (diagnostic)
assign gpio_in[31:28]  = 4'd0;

// RX edge counter: counts rising edges over 2 µs @ 160 MHz (diagnostic)
rx_edge_counter #(.WINDOW_CYCLES(320)) u_rx_cnt (
    .clk        (clk_160),
    .rst        (~reset_n),
    .rx_in      (saw_rx_p),
    .edge_count (rx_edge_count)
);

// =============================================================================
// SAW acquisition FSM
// =============================================================================
wire saw_tx_out;
wire saw_tdc_start;
wire saw_tdc_stop;

// Phase test: 16 MHz (TX + phase shifter); normal: 160 MHz
wire tx_for_output = gpio_out[15] ? clk_16 : saw_tx_out;
assign saw_tx_p    = tx_for_output;

// Phase shifter (carry-chain grosso): tap em [14:8]; em tdc_phase_mode usar tap=0
wire [6:0] tap_coarse = gpio_out[21] ? 7'd0 : gpio_out[14:8];

wire phase_shifter_clk = gpio_out[15] ? clk_16 : clk_160;  // 1.6 MHz só quando test
wire phase_shifted_clk;
phase_shifter_carry #(
    .NUM_TAPS       (128),
    .TAP_BITS       (7),
    .STAGES_PER_TAP (98)
) u_phs (
    .sig_in  (phase_shifter_clk),
    .tap_sel (tap_coarse),
    .sig_out (phase_shifted_clk)
);

// RX source: phase test (gpio_out[15]=1) → delayed clk, else → saw_rx_p
wire tdc_rx_src = gpio_out[15] ? phase_shifted_clk : saw_rx_p;

// TDC cal mode: PulseA/PulseB por ciclos 25 MHz (40-200 ns)
wire tdc_cal_pulse_a;
wire tdc_cal_pulse_b;

tdc_cal_pulse_gen u_tdc_cal (
    .clk       (clk25),
    .rst_n     (reset_n),
    .enable    (gpio_out[16] & ~gpio_out[20] & ~gpio_out[21]),
    .delay_sel (gpio_out[19:17]),
    .pulse_a   (tdc_cal_pulse_a),
    .pulse_b   (tdc_cal_pulse_b)
);

// TDC min mode: limites mínimos @ 160 MHz (6.25-37.5 ns)
wire tdc_min_pulse_a;
wire tdc_min_pulse_b;

tdc_min_pulse_gen u_tdc_min (
    .clk       (clk_160),
    .rst_n     (reset_n),
    .enable    (gpio_out[20] & ~gpio_out[21]),
    .delay_sel (gpio_out[19:17]),
    .pulse_a   (tdc_min_pulse_a),
    .pulse_b   (tdc_min_pulse_b)
);

// TDC fase @ 160 MHz: linha fina ~50 ps/tap, tap em PIO_OUT[14:8]
wire tdc_phase_pulse_a;
wire tdc_phase_pulse_b;

tdc_phase_delay_test u_tdc_phase (
    .clk       (clk_160),
    .rst_n     (reset_n),
    .enable    (gpio_out[21]),
    .tap_sel   (gpio_out[14:8]),
    .pulse_a   (tdc_phase_pulse_a),
    .pulse_b   (tdc_phase_pulse_b)
);

// Continuous phase triggers: PulseA per TX edge, PulseB per RX edge
// Em phase test: tx_in=clk_16, rx_in=phase_shifted_clk (ambos 16 MHz)
wire tdc_pulse_a_cont;
wire tdc_pulse_b_cont;

continuous_phase_triggers u_phase_trig (
    .clk     (clk_160),
    .rst     (~reset_n),
    .tx_in   (tx_for_output),   // clk_16 em phase test
    .rx_in   (tdc_rx_src),
    .pulse_a (tdc_pulse_a_cont),
    .pulse_b (tdc_pulse_b_cont)
);

// TDC inputs: phase > min > cal > continuous > burst
wire tdc_pulse_a = gpio_out[21] ? tdc_phase_pulse_a : (gpio_out[20] ? tdc_min_pulse_a : (gpio_out[16] ? tdc_cal_pulse_a : ((CONTINUOUS_PHASE_TDC != 0) ? tdc_pulse_a_cont : saw_tdc_start)));
wire tdc_pulse_b = gpio_out[21] ? tdc_phase_pulse_b : (gpio_out[20] ? tdc_min_pulse_b : (gpio_out[16] ? tdc_cal_pulse_b : ((CONTINUOUS_PHASE_TDC != 0) ? tdc_pulse_b_cont : saw_tdc_stop)));

saw_acquisition_fsm #(
    .BURST_CYCLES  (16),    // 100 ns burst @ 160 MHz (ignored if CONTINUOUS_TX=1)
    .DEAD_CYCLES   (2000),  // 12.5 µs blanking
    .WINDOW_CYCLES (20000), // 125 µs RX timeout
    .CONTINUOUS_TX (1)      // 1=160 MHz always on; 0=burst mode (gated)
) u_saw (
    .clk       (clk_160),
    .rst       (~reset_n),
    .key_n     (KEY[1]),    // active-low trigger
    .rx_in     (saw_rx_p),  // LVDS RX differential input
    .tx_out    (saw_tx_out),
    .tdc_start (saw_tdc_start),
    .tdc_stop  (saw_tdc_stop),
    .done      (saw_done)
);

// =============================================================================
// TDC linux128 (ring-oscillator, no external clock)
// =============================================================================
tdc_linux128 u_tdc (
    .reset   (reset_n),
    .PulseA  (tdc_pulse_a),
    .PulseB  (tdc_pulse_b),
    .end_soma(tdc_end)
);

// =============================================================================
// Pulpino RISC-V core (sys)
// =============================================================================
// gpio_extra: sys drives {GPIO_1[35:32], GPIO_0[35:32]}; mux GPIO_1[34:35]
// para PulseA/PulseB quando phase_test_en (scope debug)
wire [7:0] gpio_extra_export;
sys u0 (
    .clk_clk                               (clk25),
    .master_0_master_reset_reset           (jtag_reset),
    .pio_out_external_connection_export   (gpio_out),
    .pio_in_external_connection_export   (gpio_in),
    .pulpino_0_config_testmode_i           (test_mode),
    .pulpino_0_config_fetch_enable_i       (fetch_enable),
    .pulpino_0_config_clock_gating_i       (clock_gating),
    .pulpino_0_config_boot_addr_i          (BOOT_ADDR),
    .reset_reset_n                         (reset_n),
    .gpio_0_external_connection_export    (GPIO_0[31:0]),
    .gpio_1_external_connection_export    (GPIO_1[31:0]),
    .gpio_extra_external_connection_export(gpio_extra_export),
    .debug_external_connection_export     (debug_wire)
);

assign GPIO_1[32]   = gpio_extra_export[0];
assign GPIO_1[33]   = gpio_extra_export[1];
assign GPIO_1[34]   = (gpio_out[15] | gpio_out[16] | gpio_out[20] | gpio_out[21]) ? tdc_pulse_a : gpio_extra_export[2];
assign GPIO_1[35]   = (gpio_out[15] | gpio_out[16] | gpio_out[20] | gpio_out[21]) ? tdc_pulse_b : gpio_extra_export[3];
assign GPIO_0[35:32]= gpio_extra_export[7:4];

endmodule
