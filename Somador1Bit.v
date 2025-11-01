// Módulo que implementa um somador completo de 1 bit.
module Somador1Bit( S, Cout, A, B, Cin);
    input A, B;   // Bits de entrada a serem somados.
    input Cin;    // Bit de carry.

    output S;      // Saída do bit de Soma.
    output Cout;   // Saída do bit de Carry Out.

    wire T1, T2, T3; // Fios para os resultados.

    // A lógica do somador completo é construída a partir de dois meio-somadores.
    // Primeiro meio-somador (A + B):
    xor Xor0(T1, A, B);     
    and And0(T2, A, B);     

    // Segundo meio-somador (Soma_parcial + Cin):
    and And1(T3, T1, Cin);  
    or Or0(Cout, T2, T3);   
    xor Xor1 (S, T1, Cin);  // S é a soma final, somando o carry-in ao resultado parcial T1.
endmodule