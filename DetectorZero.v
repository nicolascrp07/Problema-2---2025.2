// Módulo que detecta se uma entrada de 8 bits é igual a zero.
module DetectorZero(
    output Z,       // Saída '1' se B == 8'b00000000.
    input  [7:0] B  // Entrada de 8 bits a ser verificada.
);

    // A porta NOR resulta em '1' (Z=1) somente se todos os bits de entrada (B[7] a B[0]) forem '0'.
    nor D0 (Z, B[7], B[6], B[5], B[4], B[3], B[2], B[1], B[0]);

endmodule