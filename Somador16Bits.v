// Módulo que implementa um somador completo de 16 bits.
module Somador16Bits(
    output [15:0] S,
    output        Cout,  // Carry out final (do bit 15)
    output        C15,   // Carry intermediário da posição 14 para 15
    input  [15:0] A,
    input  [15:0] B,
    input         Cin
);
    // Fios para os carries intermediários
    wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15;

    // Instanciação de 16 somadores de 1 bit
    Somador1Bit P0  (.S(S[0]),  .Cout(c1),  .A(A[0]),  .B(B[0]),  .Cin(Cin));
    Somador1Bit P1  (.S(S[1]),  .Cout(c2),  .A(A[1]),  .B(B[1]),  .Cin(c1));
    Somador1Bit P2  (.S(S[2]),  .Cout(c3),  .A(A[2]),  .B(B[2]),  .Cin(c2));
    Somador1Bit P3  (.S(S[3]),  .Cout(c4),  .A(A[3]),  .B(B[3]),  .Cin(c3));
    Somador1Bit P4  (.S(S[4]),  .Cout(c5),  .A(A[4]),  .B(B[4]),  .Cin(c4));
    Somador1Bit P5  (.S(S[5]),  .Cout(c6),  .A(A[5]),  .B(B[5]),  .Cin(c5));
    Somador1Bit P6  (.S(S[6]),  .Cout(c7),  .A(A[6]),  .B(B[6]),  .Cin(c6));
    Somador1Bit P7  (.S(S[7]),  .Cout(c8),  .A(A[7]),  .B(B[7]),  .Cin(c7));
    Somador1Bit P8  (.S(S[8]),  .Cout(c9),  .A(A[8]),  .B(B[8]),  .Cin(c8));
    Somador1Bit P9  (.S(S[9]),  .Cout(c10), .A(A[9]),  .B(B[9]),  .Cin(c9));
    Somador1Bit P10 (.S(S[10]), .Cout(c11), .A(A[10]), .B(B[10]), .Cin(c10));
    Somador1Bit P11 (.S(S[11]), .Cout(c12), .A(A[11]), .B(B[11]), .Cin(c11));
    Somador1Bit P12 (.S(S[12]), .Cout(c13), .A(A[12]), .B(B[12]), .Cin(c12));
    Somador1Bit P13 (.S(S[13]), .Cout(c14), .A(A[13]), .B(B[13]), .Cin(c13));
    Somador1Bit P14 (.S(S[14]), .Cout(c15), .A(A[14]), .B(B[14]), .Cin(c14));
    Somador1Bit P15 (.S(S[15]), .Cout(Cout),.A(A[15]), .B(B[15]), .Cin(c15));

    // Expõe o carry c15 (saída de P14) na porta de saída C15.
    and AND_C15(C15, c15, 1'b1);
endmodule