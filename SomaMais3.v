// Módulo que a entrada (um dígito BCD) for >= 5, ele soma 3. Senão, mantém o valor.
module SomaMais3(
    output [3:0] Saida,    // O resultado final.

    input  [3:0] Entrada   // O valor BCD de 4 bits a ser avaliado.
);
    wire maior_igual_5;   // Flag '1' se a Entrada for >= 5.
    wire [3:0] soma_com_3; // Armazena o resultado da soma Entrada + 3.
    wire vai_um;           // Carry out do somador (não utilizado).

    // Compara se a entrada é >= 5.
    ComparadorMaiorIgual5 comparador(maior_igual_5, Entrada);

    // Calcula a soma (Entrada + 3) em paralelo.
    Somador4Bits somador(.S(soma_com_3), .Cout(vai_um), .A(Entrada), .B(4'b0011), .Cin(1'b0));

    // Seleciona a saída:
    // Se (maior_igual_5 = 1), Saida = soma_com_3.
    // Se (maior_igual_5 = 0), Saida = Entrada.
    MUX2x1_4B mux(.S(Saida), .A(Entrada), .B(soma_com_3), .Sel(maior_igual_5));
    
endmodule