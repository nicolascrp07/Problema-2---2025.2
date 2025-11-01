// Módulo que implementa um deslocador lógico de 8 bits para a direita.
module DeslocaDir8 (Y, A);
    output [7:0] Y; // Saída de 8 bits.
    input  [7:0] A; // Entrada de 8 bits a ser deslocada.

    wire zero; // Fio para a constante '0'.
    not INVZ (zero, 1'b1); // Gera a constante '0'.

    // Cada bit de Y recebe o bit à sua esquerda em A.
    // As portas AND com '1'b1' atuam como buffers, apenas repassando o sinal.
    and L0 (Y[0], A[1], 1'b1); // Y[0] = A[1]
    and L1 (Y[1], A[2], 1'b1); // Y[1] = A[2]
    and L2 (Y[2], A[3], 1'b1); // Y[2] = A[3]
    and L3 (Y[3], A[4], 1'b1); // Y[3] = A[4]
    and L4 (Y[4], A[5], 1'b1); // Y[4] = A[5]
    and L5 (Y[5], A[6], 1'b1); // Y[5] = A[6]
    and L6 (Y[6], A[7], 1'b1); // Y[6] = A[7]
    // O bit mais significativo (MSB) é preenchido com zero.
    and L7 (Y[7], zero, 1'b1); // Y[7] = 0
endmodule