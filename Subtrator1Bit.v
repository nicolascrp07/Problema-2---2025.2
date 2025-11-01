// Módulo que implementa um subtrator completo de 1 bit.
// Ele calcula a diferença (D) e o empréstimo (Bout).
module Subtrator1Bit( D, Bout, A, B, Bin);
    input A;      // Bit do minuendo.
    input B;      // Bit do subtraendo.
    input Bin;    // Bit de borrow.

    output D;      // Saída do bit de Diferença.
    output Bout;   // Saída do bit de Borrow Out.

    wire T1, notA, term1, term2, term3; // Fios para resultados.

    // A diferença é calculada usando a propriedade do XOR.
    xor Xor0(T1, A, B);     
    xor Xor1(D, T1, Bin);   // D é a diferença final, subtraindo o borrow-in do resultado parcial.

    // Bout é 1 se for necessário "emprestar" do próximo bit mais significativo.
    not Not0(notA, A);                         
    and And_Bout1(term1, notA, B);             // Calcula o primeiro termo do produto (~A & B).
    and And_Bout2(term2, notA, Bin);           // Calcula o segundo termo do produto (~A & Bin).
    and And_Bout3(term3, B, Bin);              // Calcula o terceiro termo do produto (B & Bin).
    or  Or_Bout(Bout, term1, term2, term3);     // Une os termos para gerar o borrow out final.

endmodule