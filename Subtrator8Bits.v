// Módulo que implementa um subtrator completo de 8 bits.
module Subtrator8Bits(
    output [7:0] D,      // Vetor de 8 bits para o resultado final da subtração.
    output       Bout,   // Borrow out final.
    output       B7,     // Borrow intermediário do bit 7.
    
    input  [7:0] A,      // Vetor de 8 bits do minuendo.
    input  [7:0] B,      // Vetor de 8 bits do subtraendo.
    input        Bin     // Borrow de entrada.
);

    // Fios para propagar os borrows entre os subtratores de 1 bit.
    wire b1, b2, b3, b4, b5, b6, b7;

    // P0: LSB (bit 0)
    Subtrator1Bit P0 (
        .D(D[0]),
        .Bout(b1),
        .A(A[0]),
        .B(B[0]),
        .Bin(Bin)
    );

    // P1
    Subtrator1Bit P1 (
        .D(D[1]),
        .Bout(b2),
        .A(A[1]),
        .B(B[1]),
        .Bin(b1)
    );

    // P2
    Subtrator1Bit P2 (
        .D(D[2]),
        .Bout(b3),
        .A(A[2]),
        .B(B[2]),
        .Bin(b2)
    );

    // P3
    Subtrator1Bit P3 (
        .D(D[3]),
        .Bout(b4),
        .A(A[3]),
        .B(B[3]),
        .Bin(b3)
    );

    // P4
    Subtrator1Bit P4 (
        .D(D[4]),
        .Bout(b5),
        .A(A[4]),
        .B(B[4]),
        .Bin(b4)
    );

    // P5
    Subtrator1Bit P5 (
        .D(D[5]),
        .Bout(b6),
        .A(A[5]),
        .B(B[5]),
        .Bin(b5)
    );

    // P6
    Subtrator1Bit P6 (
        .D(D[6]),
        .Bout(b7),
        .A(A[6]),
        .B(B[6]),
        .Bin(b6)
    );

    // P7: MSB (bit 7)
    Subtrator1Bit P7 (
        .D(D[7]),
        .Bout(Bout),
        .A(A[7]),
        .B(B[7]),
        .Bin(b7)
    );

    // Repassa o borrow intermediário do bit 7
    and AND_C7(B7, b7, 1'b1);

endmodule
