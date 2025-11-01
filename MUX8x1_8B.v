// Módulo que implementa um multiplexador (MUX) de 8 para 1 para barramentos de 8 bits.
module MUX8x1_8B(
    output [7:0] S,     // Barramento de 8 bits de saída com o dado selecionado.
    
    input [7:0] D0,     // Barramentos de 8 bits para as 8 fontes de dados (D0 a D7).
    input [7:0] D1,
    input [7:0] D2,
    input [7:0] D3,
    input [7:0] D4,
    input [7:0] D5,
    input [7:0] D6,
    input [7:0] D7,
    input [2:0] Sel     // Vetor de 3 bits que determina qual entrada (D0-D7) será selecionada.
);

    // A implementação utiliza 8 instâncias do MUX8x1_1B.

    // MUX_bit0: Seleciona qual bit 0 (de D0[0] a D7[0]) vai para S[0].
    MUX8x1_1B MUX_bit0 (
        .S(S[0]),
        .A(D0[0]), .B(D1[0]), .C(D2[0]), .D(D3[0]),
        .E(D4[0]), .F(D5[0]), .G(D6[0]), .H(D7[0]),
        .Sel0(Sel[0]), .Sel1(Sel[1]), .Sel2(Sel[2])
    );

    // MUX_bit1: Seleciona qual bit 1 (de D0[1] a D7[1]) vai para S[1].
    MUX8x1_1B MUX_bit1 (
        .S(S[1]),
        .A(D0[1]), .B(D1[1]), .C(D2[1]), .D(D3[1]),
        .E(D4[1]), .F(D5[1]), .G(D6[1]), .H(D7[1]),
        .Sel0(Sel[0]), .Sel1(Sel[1]), .Sel2(Sel[2])
    );

    // MUX_bit2: Seleciona qual bit 2 (de D0[2] a D7[2]) vai para S[2].
    MUX8x1_1B MUX_bit2 (
        .S(S[2]),
        .A(D0[2]), .B(D1[2]), .C(D2[2]), .D(D3[2]),
        .E(D4[2]), .F(D5[2]), .G(D6[2]), .H(D7[2]),
        .Sel0(Sel[0]), .Sel1(Sel[1]), .Sel2(Sel[2])
    );

    // MUX_bit3: Seleciona qual bit 3 (de D0[3] a D7[3]) vai para S[3].
    MUX8x1_1B MUX_bit3 (
        .S(S[3]),
        .A(D0[3]), .B(D1[3]), .C(D2[3]), .D(D3[3]),
        .E(D4[3]), .F(D5[3]), .G(D6[3]), .H(D7[3]),
        .Sel0(Sel[0]), .Sel1(Sel[1]), .Sel2(Sel[2])
    );

    // MUX_bit4: Seleciona qual bit 4 (de D0[4] a D7[4]) vai para S[4].
    MUX8x1_1B MUX_bit4 (
        .S(S[4]),
        .A(D0[4]), .B(D1[4]), .C(D2[4]), .D(D3[4]),
        .E(D4[4]), .F(D5[4]), .G(D6[4]), .H(D7[4]),
        .Sel0(Sel[0]), .Sel1(Sel[1]), .Sel2(Sel[2])
    );

    // MUX_bit5: Seleciona qual bit 5 (de D0[5] a D7[5]) vai para S[5].
    MUX8x1_1B MUX_bit5 (
        .S(S[5]),
        .A(D0[5]), .B(D1[5]), .C(D2[5]), .D(D3[5]),
        .E(D4[5]), .F(D5[5]), .G(D6[5]), .H(D7[5]),
        .Sel0(Sel[0]), .Sel1(Sel[1]), .Sel2(Sel[2])
    );

    // MUX_bit6: Seleciona qual bit 6 (de D0[6] a D7[6]) vai para S[6].
    MUX8x1_1B MUX_bit6 (
        .S(S[6]),
        .A(D0[6]), .B(D1[6]), .C(D2[6]), .D(D3[6]),
        .E(D4[6]), .F(D5[6]), .G(D6[6]), .H(D7[6]),
        .Sel0(Sel[0]), .Sel1(Sel[1]), .Sel2(Sel[2])
    );

    // MUX_bit7: Seleciona qual bit 7 (de D0[7] a D7[7]) vai para S[7].
    MUX8x1_1B MUX_bit7 (
        .S(S[7]),
        .A(D0[7]), .B(D1[7]), .C(D2[7]), .D(D3[7]),
        .E(D4[7]), .F(D5[7]), .G(D6[7]), .H(D7[7]),
        .Sel0(Sel[0]), .Sel1(Sel[1]), .Sel2(Sel[2])
    );

endmodule