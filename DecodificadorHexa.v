// Módulo que decodifica uma entrada hexadecimal de 4 bits (0-F) para um display de 7 segmentos.
module DecodificadorHexa (
	// Saídas para os sete segmentos (a-g).
	output seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g,

	// Entrada de 4 bits (Hexadecimal) a ser decodificada.
	input [3:0] R
);

	// Fios para as versões invertidas dos 4 bits de entrada.
	wire not3, not2, not1, not0; // A', B', C', D'

	not Not3 (not3, R[3]);
	not Not2 (not2, R[2]);
	not Not1 (not1, R[1]);
	not Not0 (not0, R[0]);
	
	// Lógica para o segmento 'a'.
	//A'B'C'D+A'BC'D'+AB'CD+ABC'D
	wire a1, a2, a3, a4; 
	and AndA0 (a1, not3, not2, not1, R[0]);
	and AndA1 (a2, not3, R[2], not1, not0);
	and AndA2 (a3, R[3], not2, R[1], R[0]);
	and AndA3 (a4, R[3], R[2], not1, R[0]);
	or OrA (seg_a, a1, a2, a3, a4); 

	// Lógica para o segmento 'b'.
	//A'BC'D+ABD'+ACD+BCD'
	wire b1, b2, b3, b4; 
	and AndB0 (b1, not3, R[2], not1, R[0]);
	and AndB1 (b2, R[3], R[2], not0);
	and AndB2 (b3, R[3], R[1], R[0]);
	and AndB3 (b4, R[2], R[1], not0);
	or OrB (seg_b, b1, b2, b3, b4);
	
	// Lógica para o segmento 'c'.
	//A'B'CD'+ABC+ABD'
	wire c1, c2, c3; 
	and AndC0 (c1, not3, not2, R[1], not0);
	and AndC1 (c2, R[3], R[2], R[1]);
	and AndC2 (c3, R[3], R[2], not0);
	or OrC (seg_c, c1, c2, c3); 

	// Lógica para o segmento 'd'.
	//A'BC'D'+AB'CD'+B'C'D+BCD
	wire d1, d2, d3, d4; 
	and AndD0 (d1, not3, R[2], not1, not0);
	and AndD1 (d2, R[3], not2, R[1], not0);
	and AndD2 (d3, not2, not1, R[0]);
	and AndD3 (d4, R[2], R[1], R[0]);
	or OrD (seg_d, d1, d2, d3, d4); 

	// Lógica para o segmento 'e'.
	//A'BC'+A'D+B'C'D
	wire e1, e2, e3; 
	and AndE0 (e1, not3, R[2], not1);
	and AndE1 (e2, not3, R[0]);
	and AndE2 (e3, not2, not1, R[0]);
	or OrE (seg_e, e1, e2, e3); 

	// Lógica para o segmento 'f'.
	//A'B'C+A'B'D+A'CD+ABC'D
	wire f1, f2, f3, f4; 
	and AndF0 (f1, not3, not2, R[1]);
	and AndF1 (f2, not3, not2, R[0]);
	and AndF2 (f3, not3, R[1], R[0]);
	and AndF3 (f4, R[3], R[2], not1, R[0]);
	or OrF (seg_f, f1, f2, f3, f4); 
	
	// Lógica para o segmento 'g'.
	//A'B'C'+A'BCD+ABC'D'
	wire g1, g2, g3; 
	and AndG0 (g1, not3, not2, not1);
	and AndG1 (g2, not3, R[2], R[1], R[0]);
	and AndG2 (g3, R[3], R[2], not1, not0);
	or OrG (seg_g, g1, g2, g3); 
	
endmodule