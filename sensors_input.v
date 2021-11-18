`timescale 1ns / 1ps

module sensors_input(
	output[7 : 0]   height,
	input[7 : 0]   sensor1,
	input[7 : 0]   sensor2,
	input[7 : 0]   sensor3,
	input[7 : 0]   sensor4);

	reg[9:0] sum;
	reg flag;	/* Ia valoarea 0 daca exista o pereche de senzori a caror
				valoare nu este valida sau 1 daca toti senzorii au valori valide */
				
	assign height = sum;
	
	always @(*) begin
		flag = 1;
		
		// Testez daca perechea (1,3) are valori invalide
		if(sensor1==0 || sensor3==0) begin
			flag = 0;
			sum = sensor2 + sensor4;
		end
		// Testez daca perechea (2,4) are valori invalide
		else if(sensor2==0 || sensor4==0) begin
			flag = 0;
			sum = sensor1 + sensor3;
		end
		// Se executa daca toti senzorii au valori valide
		else begin
		sum = sensor1 + sensor2 + sensor3 + sensor4;
		end
		
		// Cazul 1: doar o pereche de senzori are valori valide a caror suma e impara
		if(flag==0 && sum[0]==1) begin
			sum = (sum>>1) + 1;
		end
		// Cazul 1: doar o pereche de senzori are valori valide a caror suma e para
		else if(flag==0 && sum[0]==0) begin
			sum = sum>>1;
		end
		// Cazul 1: toti senzorii au valori valide a caror suma e para
		else if(flag==1 && sum[0]==0) begin
			// Suma nu este divizibila cu 4
			if(sum[1]==1) begin
				sum = (sum>>2) + 1;
			end
			// Suma este divizibila cu 4
			else begin
				sum = sum>>2;
			end
		end
		// Cazul 1: toti senzorii au valori valide a caror suma e impara
		else if(flag==1 && sum[0]==1) begin
			// Suma se termina cu 11 (in binar)
			if(sum[1]==1) begin
				sum = (sum>>2) + 1;
			end
			// Suma se termina cu 01 (in binar)
			else begin
				sum = sum>>2;
			end
		end
	end
endmodule