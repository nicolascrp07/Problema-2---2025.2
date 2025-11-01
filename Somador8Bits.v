// Módulo que implementa um somador completo de 8 bits.
module Somador8Bits(
    output [7:0] S,     // Vetor de 8 bits para o resultado final da soma.
    output         Cout,    // Carry out final (do bit 7).
    output         C7,      // Carry intermediário da posição 6 para 7.
    
    input  [7:0] A,     // Vetor de 8 bits do primeiro operando.
    input  [7:0] B,     // Vetor de 8 bits do segundo operando.
    input          Cin     // Carry de entrada inicial.
);
    wire c1, c2, c3, c4, c5, c6, c7; // Fios para conectar o carry out de um estágio ao carry in do próximo.

    // Instanciação de 8 somadores de 1 bit para construir o somador de 8 bits.
    // Cada instância calcula a soma de um par de bits e propaga o carry.

    // P0: Soma o bit 0 (LSB) e gera o primeiro carry (c1).
    Somador1Bit P0 (
        .S(S[0]),
        .Cout(c1),
        .A(A[0]),
        .B(B[0]),
        .Cin(Cin)
    );

    // P1: Soma o bit 1, usando o carry c1 do estágio anterior. Gera o carry c2.
    Somador1Bit P1 (
        .S(S[1]),
        .Cout(c2),
        .A(A[1]),
        .B(B[1]),
        .Cin(c1)
    );

    // P2: Soma o bit 2, usando o carry c2 do estágio anterior. Gera o carry c3.
    Somador1Bit P2 (
        .S(S[2]),
        .Cout(c3),
        .A(A[2]),
        .B(B[2]),
        .Cin(c2)
    );

    // P3: Soma o bit 3, usando o carry c3 do estágio anterior. Gera o carry c4.
    Somador1Bit P3 (
        .S(S[3]),
        .Cout(c4),
        .A(A[3]),
        .B(B[3]),
        .Cin(c3)
    );

    // P4: Soma o bit 4, usando o carry c4. Gera o carry c5.
    Somador1Bit P4 (
        .S(S[4]),
        .Cout(c5),
        .A(A[4]),
        .B(B[4]),
        .Cin(c4)
    );
    
    // P5: Soma o bit 5, usando o carry c5. Gera o carry c6.
    Somador1Bit P5 (
        .S(S[5]),
        .Cout(c6),
        .A(A[5]),
        .B(B[5]),
        .Cin(c5)
    );
    
    // P6: Soma o bit 6, usando o carry c6. Gera o carry c7.
    Somador1Bit P6 (
        .S(S[6]),
        .Cout(c7),
        .A(A[6]),
        .B(B[6]),
        .Cin(c6)
    );
    
    // P7: Soma o bit 7 (MSB), usando o carry c7. Gera o Cout final.
    Somador1Bit P7 (
        .S(S[7]),
        .Cout(Cout),
        .A(A[7]),
        .B(B[7]),
        .Cin(c7)
    );

    // Expõe o carry c7 (saída de P6) na porta de saída C7.
    and AND_C3(C7, c7, 1'b1);
    
endmodule