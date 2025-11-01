// Módulo que implementa a operação OR bit-a-bit em dois vetores de 8 bits.
module Or8Bits (
	output [7:0] S, // Saída de 8 bits.
	
	input [7:0] A,  // Entrada A de 8 bits.
	input [7:0] B   // Entrada B de 8 bits.
);

	// Instanciação de 8 portas OR, uma para cada par de bits.
	or Or0 (S[0], A[0], B[0]);
	or Or1 (S[1], A[1], B[1]);
	or Or2 (S[2], A[2], B[2]);
	or Or3 (S[3], A[3], B[3]);
	or Or4 (S[4], A[4], B[4]);
	or Or5 (S[5], A[5], B[5]);
	or Or6 (S[6], A[6], B[6]);
	or Or7 (S[7], A[7], B[7]);
	
endmodule