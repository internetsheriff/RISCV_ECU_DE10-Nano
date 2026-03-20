//-----------------------------------------------------------------------------
// event_fifo - Buffers SAW events for CPU readout
//-----------------------------------------------------------------------------
// Data format: { step[7:0], phase[31:0], tdc[14:0] } = 55 bits (padded to 64)
// Proper FIFO with wr_en, rd_en, empty, full. Single-clock (200 MHz).
//-----------------------------------------------------------------------------

module event_fifo #(
    parameter DEPTH      = 256,
    parameter ADDR_WIDTH = 8
)(
    input  wire         clk,
    input  wire         rst,

    input  wire         wr_en,
    input  wire [7:0]   step,
    input  wire [31:0]  phase,
    input  wire [14:0]  tdc,

    input  wire         rd_en,
    output reg  [63:0]  data_out,
    output reg          valid,
    output wire         empty,
    output wire         full
);

    reg [63:0] mem [0:DEPTH-1];
    reg [ADDR_WIDTH:0] wr_ptr;   // one extra bit for full/empty
    reg [ADDR_WIDTH:0] rd_ptr;

    wire [63:0] wr_data = { 9'b0, tdc, phase, step };

    assign empty = (wr_ptr == rd_ptr);
    assign full  = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) &&
                   (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);

    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 9'b0;
            rd_ptr <= 9'b0;
            valid  <= 1'b0;
            data_out <= 64'b0;
        end else begin
            if (wr_en && !full) begin
                mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
                wr_ptr <= wr_ptr + 1;
            end

            if (rd_en && !empty) begin
                data_out <= mem[rd_ptr[ADDR_WIDTH-1:0]];
                valid    <= 1'b1;
                rd_ptr   <= rd_ptr + 1;
            end else begin
                valid <= 1'b0;
            end
        end
    end

endmodule
