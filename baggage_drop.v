`timescale 1ns / 1ps

module baggage_drop(
	output   [6 : 0]   seven_seg1, 
	output   [6 : 0]   seven_seg2,
	output   [6 : 0]   seven_seg3,
	output   [6 : 0]   seven_seg4,
	output   [0 : 0]   drop_activated,
	input    [7 : 0]   sensor1,
	input    [7 : 0]   sensor2,
	input    [7 : 0]   sensor3,
	input    [7 : 0]   sensor4,
	input    [15: 0]   t_lim,
	input              drop_en);
	
	wire[7:0] height; // Pentru inaltime (calculata in primul modul 'sensors_input')
	wire[15:0] sqrt; // Pentru radacina patrata
	
	/* sqrtDiv are valoarea lui sqrt dar cu o deplasare a bitilor spre dreapta
	pentru a facilita imparirea la 2 din formula */
	wire[15:0] sqrtDiv2 = {1'b0, sqrt[15:1]}; // Prescurtarea lui sqrt diveded by 2
	
	// Apelarea modulelor pentru implementarea functionalitatii
	sensors_input sensors(height, sensor1, sensor2, sensor3, sensor4);
	square_root SQRT(sqrt, height);
	display_and_drop displayDrop(seven_seg1, seven_seg2, seven_seg3, seven_seg4, drop_activated, sqrtDiv2, t_lim, drop_en);
	 
endmodule