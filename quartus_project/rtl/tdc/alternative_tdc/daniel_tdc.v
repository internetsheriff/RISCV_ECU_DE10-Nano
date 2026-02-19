module daniel_tdc #(
    parameter N_TAPS  = 128,   // Fine resolution taps
    parameter N_COARSE = 7     // Coarse counter bits (7+7=14 bits total)
)(
    input  wire clk,       // system clock
    input  wire rst,
    input  wire start,
    input  wire stop,
    output reg  [N_COARSE-1:0] coarse_out,
    output reg  [$clog2(N_TAPS)-1:0] fine_out,
    output reg  valid
);

    //---------------------------------------------------------
    // 1️⃣ Coarse Counter
    //---------------------------------------------------------

    reg [N_COARSE-1:0] coarse_counter;

    always @(posedge clk or posedge rst) begin
        if (rst)
            coarse_counter <= 0;
        else
            coarse_counter <= coarse_counter + 1'b1;
    end

    //---------------------------------------------------------
    // 2️⃣ Fine Delay Line (Carry Chain)
    //---------------------------------------------------------

    wire [N_TAPS-1:0] carry_chain;
    wire [N_TAPS-1:0] start_vector;

    // Only first bit receives start pulse
    assign start_vector = {{(N_TAPS-1){1'b0}}, start};

    // Arithmetic addition forces carry-chain inference
    assign carry_chain = {N_TAPS{1'b0}} + start_vector;

    //---------------------------------------------------------
    // 3️⃣ Capture on STOP (synchronous)
    //---------------------------------------------------------

    reg [N_TAPS-1:0] sampled;
    reg [N_COARSE-1:0] coarse_sampled;

    reg stop_sync1, stop_sync2;

    // Synchronize stop to clk domain
    always @(posedge clk) begin
        stop_sync1 <= stop;
        stop_sync2 <= stop_sync1;
    end

    wire stop_rising = stop_sync1 & ~stop_sync2;

    always @(posedge clk) begin
        if (stop_rising) begin
            sampled        <= carry_chain;
            coarse_sampled <= coarse_counter;
            valid          <= 1'b1;
        end
        else begin
            valid <= 1'b0;
        end
    end

    //---------------------------------------------------------
    // 4️⃣ Bubble-Tolerant Thermometer Encoder
    //---------------------------------------------------------

    integer i;
    reg [$clog2(N_TAPS)-1:0] fine_code;

    always @(*) begin
        fine_code = 0;
        for (i = 0; i < N_TAPS; i = i + 1) begin
            if (sampled[i])
                fine_code = i[$clog2(N_TAPS)-1:0];
        end
    end

    //---------------------------------------------------------
    // 5️⃣ Output Register
    //---------------------------------------------------------

    always @(posedge clk) begin
        if (valid) begin
            fine_out   <= fine_code;
            coarse_out <= coarse_sampled;
        end
    end

endmodule
