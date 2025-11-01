// Módulo que decodifica uma entrada octal de 3 bits (0-7) para um display de 7 segmentos.
module DecodificadorOcta (
	// Saídas para os sete segmentos (a-g).
	output seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g,

	// Entrada de 3 bits (Octal) a ser decodificada.
	input [2:0] R
);

	// Fios para as versões invertidas dos 3 bits de entrada.
	wire not2, not1, not0; // A', B', C'

	not Not2 (not2, R[2]);
	not Not1 (not1, R[1]);
	not Not0 (not0, R[0]);
	

	// Lógica para o segmento 'a': A'B'C+AB'C'
	wire a1, a2; 
	and AndA0 (a1, not2, not1, R[0]); // A'B'C
	and AndA1 (a2, R[2], not1, not0); // AB'C'
	or OrA (seg_a, a1, a2); 
	
	// Lógica para o segmento 'b': AB'C+ABC'
	wire b1, b2; 
	and AndB0 (b1, R[2], not1, R[0]); // AB'C
	and AndB1 (b2, R[2], R[1], not0); // ABC'
	or OrB (seg_b, b1, b2); 

	// Lógica para o segmento 'c': A'BC'
	and AndC0 (seg_c, not2, R[1], not0); 

	// Lógica para o segmento 'd': A'B'C+AB'C'+ABC
	wire d1, d2, d3; 
	and AndD0 (d1, not2, not1, R[0]); // A'B'C
	and AndD1 (d2, R[2], not1, not0); // AB'C'
	and AndD2 (d3, R[2], R[1], R[0]); // ABC
	or OrD (seg_d, d1, d2, d3); 

	// Lógica para o segmento 'e': AB'+ C
	wire e1; 
	and AndE0 (e1, R[2], not1); // AB'
	or OrE (seg_e, e1, R[0]); 

	// Lógica para o segmento 'f': A'B+A'C+BC
	wire f1, f2, f3; 
	and AndF0 (f1, not2, R[1]); // A'B
	and AndF1 (f2, not2, R[0]); // A'C
	and AndF2 (f3, R[1], R[0]); // BC
	or OrF (seg_f, f1, f2, f3); 

	// Lógica para o segmento 'g': A'B'+ABC
	wire g1, g2; 
	and AndG0 (g1, not2, not1); // A'B'
	and AndG1 (g2, R[2], R[1], R[0]); // ABC
	or OrG (seg_g, g1, g2); 
	
endmodule