// Módulo que implementa um somador completo de 4 bits.
module Somador4Bits(S, Cout, A, B, Cin);
    output [3:0] S;    // Vetor de 4 bits para o resultado da soma.
    output       Cout; // Carry out final (do bit 3).
    input  [3:0] A, B; // Vetores de 4 bits dos operandos.
    input        Cin;  // Carry de entrada inicial.
    
    wire         c1, c2, c3; // Fios para os carries intermediários.

    // Instancia 4 somadores de 1 bit.
    Somador1Bit s0(S[0], c1,   A[0], B[0], Cin); 
    Somador1Bit s1(S[1], c2,   A[1], B[1], c1);
    Somador1Bit s2(S[2], c3,   A[2], B[2], c2);
    Somador1Bit s3(S[3], Cout, A[3], B[3], c3); 
endmodule