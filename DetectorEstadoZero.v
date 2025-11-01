// Módulo que detecta se uma entrada de 3 bits é igual a zero.
module DetectorEstadoZero(
    output Z,       // Saída '1' se A == 3'b000.
    input [2:0] A  // Entrada de 3 bits a ser verificada.
);
    // A porta NOR resulta em '1' (Z=1) somente se todos os bits de entrada (A[2], A[1], A[0]) forem '0'.
    nor NOR1 (Z, A[2], A[1], A[0]);
endmodule