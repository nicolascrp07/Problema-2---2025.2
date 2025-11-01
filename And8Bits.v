// Módulo que implementa a operação AND bit-a-bit em dois vetores de 8 bits.
module And8Bits (
	output [7:0] S, // Saída de 8 bits.
	
	input [7:0] A,  // Entrada A de 8 bits.
	input [7:0] B   // Entrada B de 8 bits.
);

	// Instanciação de 8 portas AND, uma para cada par de bits.
	and And0 (S[0], A[0], B[0]);
	and And1 (S[1], A[1], B[1]);
	and And2 (S[2], A[2], B[2]);
	and And3 (S[3], A[3], B[3]);
	and And4 (S[4], A[4], B[4]);
	and And5 (S[5], A[5], B[5]);
	and And6 (S[6], A[6], B[6]);
	and And7 (S[7], A[7], B[7]);
	
endmodule