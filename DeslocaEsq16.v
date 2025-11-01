// Módulo que implementa um deslocador lógico de 16 bits para a esquerda.
module DeslocaEsq16 (Y, A);
    output [15:0] Y; // Saída de 16 bits.
    input  [15:0] A; // Entrada de 16 bits.

    wire zero; 
    not INVZ (zero, 1'b1); // Gera a constante '0'.

    // Cada bit de Y recebe o bit à sua direita em A.
    // 'and' com '1'b1' atua como buffer.
    and L0  (Y[15], A[14], 1'b1); // Y[15] = A[14]
    and L1  (Y[14], A[13], 1'b1); 
    and L2  (Y[13], A[12], 1'b1);
    and L3  (Y[12], A[11], 1'b1);
    and L4  (Y[11], A[10], 1'b1);
    and L5  (Y[10], A[9],  1'b1);
    and L6  (Y[9],  A[8],  1'b1);
    and L7  (Y[8],  A[7],  1'b1);
    and L8  (Y[7],  A[6],  1'b1);
    and L9  (Y[6],  A[5],  1'b1);
    and L10 (Y[5],  A[4],  1'b1);
    and L11 (Y[4],  A[3],  1'b1);
    and L12 (Y[3],  A[2],  1'b1);
    and L13 (Y[2],  A[1],  1'b1);
    and L14 (Y[1],  A[0],  1'b1); // Y[1] = A[0]
    // O LSB é preenchido com zero.
    and L15 (Y[0],  zero,  1'b1); // Y[0] = 0
endmodule