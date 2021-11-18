`timescale 1ns / 1ps

module square_root(
	output [15:0] out,
    input  [7:0] in);

	reg[15:0] sqrt; // Folosit pentru calculul radacinii lui in
	reg[15:0] base; // Baza folosita (detalii in README)
	reg[4:0] i; // Indexul pentru for
		
	assign out = sqrt;

	always @(*) begin
		base = 16'h8000;
		sqrt = 16'd0;
		
		// Caclculul radacinii prin metoda CORDIC (explicat in detaliu in README)
		for(i=1; i<=16; i = i+1) begin
			sqrt = sqrt + base;
			if(sqrt*sqrt > {8'd0,in,16'd0}) begin
				sqrt = sqrt-base;
			end
			base = base >> 1;
		end
	end
endmodule