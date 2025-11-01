// Módulo que desloca um barramento de 12 bits para a esquerda e insere um novo bit na posição LSB.
module DeslocaConcatena(
    output [11:0] Saida,       // Saída de 12 bits.

    input  [11:0] Ajustado,    // O barramento de 12 bits a ser deslocado.
    input         NovoBit      // O novo bit a ser inserido no LSB.
);

    // O bit MSB original é descartado.
    // As portas 'or' com '1'b0' atuam como buffers para a atribuição.
    or o11(Saida[11], Ajustado[10], 1'b0); 
    or o10(Saida[10], Ajustado[9],  1'b0);
    or o9 (Saida[9],  Ajustado[8],  1'b0);
    or o8 (Saida[8],  Ajustado[7],  1'b0);
    or o7 (Saida[7],  Ajustado[6],  1'b0);
    or o6 (Saida[6],  Ajustado[5],  1'b0);
    or o5 (Saida[5],  Ajustado[4],  1'b0);
    or o4 (Saida[4],  Ajustado[3],  1'b0);
    or o3 (Saida[3],  Ajustado[2],  1'b0);
    or o2 (Saida[2],  Ajustado[1],  1'b0);
    or o1 (Saida[1],  Ajustado[0],  1'b0);
    or o0 (Saida[0],  NovoBit, 1'b0); // Saida[0] = NovoBit
    
endmodule