`timescale 1ns / 1ps

module display_and_drop(
    output[6 : 0] seven_seg1, 
    output[6 : 0] seven_seg2,
    output[6 : 0] seven_seg3,
    output[6 : 0] seven_seg4,
    output[0 : 0] drop_activated,
    input[15: 0]  t_act,
    input[15: 0]  t_lim,
    input drop_en
    );
	 
	/* Variabile in care selvez semnalul pentru afisarea literei
	corespunsatoare pentru fiecare element de tip 7seg */
	reg[6:0] seg1;
	reg[6:0] seg2;
	reg[6:0] seg3;
	reg[6:0] seg4;
	
	
	reg DropActivated;	/* Reg pentru a salva valoarea semnalului care va fi trimis pe
						iesirea drop_activated */
	
	// Assignez iesirile cu variabilele de tip reg corespunzatoare
	assign drop_activated = DropActivated;
	assign seven_seg1 = seg1;
	assign seven_seg2 = seg2;
	assign seven_seg3 = seg3;
	assign seven_seg4 = seg4;
	
	always @(*) begin
		DropActivated=0;
		
		// Afiseaza droP
		if(drop_en == 1 && t_act <= t_lim) begin
			DropActivated = 1;
			seg1 = 7'b101_1110;
			seg2 = 7'b101_0000;
			seg3 = 7'b101_1100;
			seg4 = 7'b111_0011;
		end
		// Afiseaza _Hot
		else if(drop_en == 1 && t_act > t_lim) begin
			seg1 = 7'b000_0000;
			seg2 = 7'b111_0110;
			seg3 = 7'b101_1100;
			seg4 = 7'b111_1000;
		end
		// Afiseaza CoLd
		else if(drop_en == 0) begin
			seg1 = 7'b011_1001;
			seg2 = 7'b101_1100;
			seg3 = 7'b011_1000;
			seg4 = 7'b101_1110;
		end	
	end
endmodule