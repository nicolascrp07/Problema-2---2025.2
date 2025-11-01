// Módulo que implementa um multiplexador (MUX) 2x1 para barramentos de 4 bits.
module MUX2x1_4B(S, A, B, Sel);
    output [3:0] S;    // Saída de 4 bits selecionada.
    input  [3:0] A, B; // Entradas A e B.
    input        Sel;  // Sinal de seleção.

    // O MUX de 4 bits é construído instanciando 4 MUXes 2x1 de 1 bit.
    MUX2x1_1B m0(S[0], A[0], B[0], Sel);
    MUX2x1_1B m1(S[1], A[1], B[1], Sel);
    MUX2x1_1B m2(S[2], A[2], B[2], Sel);
    MUX2x1_1B m3(S[3], A[3], B[3], Sel);
endmodule