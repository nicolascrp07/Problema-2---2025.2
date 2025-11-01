// Módulo que implementa um multiplexador 2x1 de 8 bits.
module MUX2x1_8B(
    output [7:0] S, // Saída de 8 bits selecionada.
    input  [7:0] A, // Entrada A de 8 bits.
    input  [7:0] B, // Entrada B de 8 bits.
    input  Sel      // Sinal de seleção: 0 seleciona A, 1 seleciona B.
);

    // O MUX de 8 bits é construído instanciando 8 MUXes 2x1 de 1 bit,
    // um para cada bit correspondente das entradas A e B.

    MUX2x1_1B mux_bit0 ( .S(S[0]), .A(A[0]), .B(B[0]), .Sel(Sel) );
    MUX2x1_1B mux_bit1 ( .S(S[1]), .A(A[1]), .B(B[1]), .Sel(Sel) );
    MUX2x1_1B mux_bit2 ( .S(S[2]), .A(A[2]), .B(B[2]), .Sel(Sel) );
    MUX2x1_1B mux_bit3 ( .S(S[3]), .A(A[3]), .B(B[3]), .Sel(Sel) );
    MUX2x1_1B mux_bit4 ( .S(S[4]), .A(A[4]), .B(B[4]), .Sel(Sel) );
    MUX2x1_1B mux_bit5 ( .S(S[5]), .A(A[5]), .B(B[5]), .Sel(Sel) );
    MUX2x1_1B mux_bit6 ( .S(S[6]), .A(A[6]), .B(B[6]), .Sel(Sel) );
    MUX2x1_1B mux_bit7 ( .S(S[7]), .A(A[7]), .B(B[7]), .Sel(Sel) );

endmodule