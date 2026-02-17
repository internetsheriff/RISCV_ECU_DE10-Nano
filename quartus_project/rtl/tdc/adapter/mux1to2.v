module mux1to2 (
    input in,       // Entrada 
    input sel,     // Linha de seleção
    output reg a,      // Saída 1
    output reg b       // Saída 2
);
    	always @(*) begin
    		if (!sel) begin
    			a = in;
    			b = 1'b0;
    		end else begin
    			a = 1'b0;
    			b = in;
    		end	
    	end
endmodule
