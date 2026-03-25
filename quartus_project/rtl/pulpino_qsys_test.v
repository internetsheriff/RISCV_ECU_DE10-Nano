// =============================================================================
// pulpino_qsys_test - TDC fase com sinais externos @ ~160 MHz (DE10-Nano)
// =============================================================================
// Entradas (modo GPIO = input no firmware):
//   GPIO_0[1] (ex.: PIN_E8)  -> PulseA (TDC)
//   GPIO_1[1] (ex.: PIN_AC24) -> PulseB (TDC)
//
// O bloco delta_medida.sv usa enable = PulseA ^ PulseB. Dois clocks quadrados
// mesma frequência f e defasagem φ: o XOR fica alto uma fração do período que
// depende de φ (ambíguo a π rad em relação ao período). Não é necessário outro
// condicionamento — apenas alimente quadradas 3.3-V LVTTL compatíveis com o banco.
// Se f externo ≠ f interno (anel do TDC) mas próximo, a média lida ainda reflete
// principalmente o duty do XOR; pequeno desvio de f entre os dois externos faz a
// leitura variar no tempo (batimento).
//
// PIO_OUT: [7:0]=LED (opcional)
// PIO_IN:  [1:0]=KEY, [16:2]=tdc_end[14:0]
// =============================================================================

module pulpino_qsys_test (
    input  wire        CLOCK_50,
    input  wire [1:0]  KEY,
    output wire [7:0]  LED,
    inout  wire [35:0] GPIO_0,
    inout  wire [35:0] GPIO_1
);

parameter BOOT_ADDR = 32'h00008000;

wire test_mode    = 1'b0;
wire fetch_enable = 1'b1;
wire clock_gating = 1'b0;

wire clk25;
wire clk_160;
wire pll_locked;
wire jtag_reset;
wire reset_n;

assign reset_n = KEY[0] & ~jtag_reset;

pll clock_conversion (
    .refclk   (CLOCK_50),
    .rst      (~reset_n),
    .outclk_0 (clk25),
    .outclk_1 (clk_160),
    .locked   (pll_locked)
);

// Segundo clock do PLL não usado neste modo; evita otimização que retire o PLL
(* keep = 1 *) wire pll_160_unused = clk_160;

// ---------------------------------------------------------------------------
// PIO
// ---------------------------------------------------------------------------
wire [31:0] gpio_out;
assign LED[7:0] = gpio_out[7:0];

wire [14:0] tdc_end;
wire [31:0] debug_wire;

wire [31:0] gpio_in;
assign gpio_in[1:0]    = KEY[1:0];
assign gpio_in[16:2]   = tdc_end;
assign gpio_in[17]     = 1'b0;
assign gpio_in[27:18]  = 10'd0;
assign gpio_in[31:28]  = 4'd0;

// ---------------------------------------------------------------------------
// GPIO Avalon: bidir_port[1] vê o nível do pad com data_dir[1]=0 (entrada)
// ---------------------------------------------------------------------------
wire [31:0] gpio_0_bus;
wire [31:0] gpio_1_bus;
wire [7:0]  gpio_extra_export;

// Sem sincronizadores: preservar defasagem entre os dois geradores externos
wire tdc_pulse_a = gpio_0_bus[1];
wire tdc_pulse_b = gpio_1_bus[1];

tdc_linux128 u_tdc (
    .reset   (reset_n),
    .PulseA  (tdc_pulse_a),
    .PulseB  (tdc_pulse_b),
    .end_soma(tdc_end)
);

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
    .gpio_0_external_connection_export    (gpio_0_bus),
    .gpio_1_external_connection_export    (gpio_1_bus),
    .gpio_extra_external_connection_export(gpio_extra_export),
    .debug_external_connection_export     (debug_wire)
);

assign GPIO_0[31:0] = gpio_0_bus[31:0];
assign GPIO_1[31:0] = gpio_1_bus[31:0];

assign GPIO_1[35:32] = gpio_extra_export[3:0];
assign GPIO_0[35:32] = gpio_extra_export[7:4];

endmodule
