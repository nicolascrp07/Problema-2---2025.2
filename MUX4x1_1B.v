// Módulo que implementa um multiplexador (MUX) 4 para 1 de 1 bit.
module MUX4x1_1B(
    output S,     // Saída de 1 bit selecionada.
    input  D0,    // Entrada 0.
    input  D1,    // Entrada 1.
    input  D2,    // Entrada 2.
    input  D3,    // Entrada 3.
    input  [1:0] Sel // Sinal de seleção de 2 bits.
);
    // Sinais internos
    wire nSel0, nSel1;   // Versões invertidas dos bits de seleção.
    wire t0, t1, t2, t3; // Fios para os 4 termos.

    // Inverte os bits de seleção (Sel[0]' e Sel[1]')
    not N0(nSel0, Sel[0]);
    not N1(nSel1, Sel[1]);

    // Lógica de seleção
    and A0(t0, D0, nSel1, nSel0); 
    and A1(t1, D1, nSel1, Sel[0]); 
    and A2(t2, D2, Sel[1], nSel0); 
    and A3(t3, D3, Sel[1], Sel[0]);

    // Apenas um dos termos (t0-t3) será o valor da entrada D selecionada.
    or FinalOr(S, t0, t1, t2, t3);
endmodule