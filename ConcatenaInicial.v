// Módulo que gera uma constante de 12 bits zerada (12'b0).
module ConcatenaInicial(
    output [11:0] Saida // Saída de 12 bits.
);
    // Força cada bit da saída para '0' usando portas AND com '1'b0'.
    and A0 (Saida[0],  1'b0, 1'b0);
    and A1 (Saida[1],  1'b0, 1'b0);
    and A2 (Saida[2],  1'b0, 1'b0);
    and A3 (Saida[3],  1'b0, 1'b0);
    and A4 (Saida[4],  1'b0, 1'b0);
    and A5 (Saida[5],  1'b0, 1'b0);
    and A6 (Saida[6],  1'b0, 1'b0);
    and A7 (Saida[7],  1'b0, 1'b0);
    and A8 (Saida[8],  1'b0, 1'b0);
    and A9 (Saida[9],  1'b0, 1'b0);
    and A10(Saida[10], 1'b0, 1'b0);
    and A11(Saida[11], 1'b0, 1'b0);
    
endmodule