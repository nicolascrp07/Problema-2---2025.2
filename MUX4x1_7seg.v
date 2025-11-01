// Módulo que implementa um MUX 4x1 para barramentos de 7 bits (displays 7-seg).
module MUX4x1_7seg(
    output [6:0] S,     // Barramento de 7 bits de saída (para o display).
    input  [6:0] D0,    // Barramento de entrada 0.
    input  [6:0] D1,    // Barramento de entrada 1.
    input  [6:0] D2,    // Barramento de entrada 2.
    input  [6:0] D3,    // Barramento de entrada 3.
    input  [1:0] Sel    // Sinal de seleção de 2 bits.
);

    // O MUX de 7 bits é construído instanciando 7 MUXes 4x1 de 1 bit.

    MUX4x1_1B mux_seg0 (.S(S[0]), .D0(D0[0]), .D1(D1[0]), .D2(D2[0]), .D3(D3[0]), .Sel(Sel));
    MUX4x1_1B mux_seg1 (.S(S[1]), .D0(D0[1]), .D1(D1[1]), .D2(D2[1]), .D3(D3[1]), .Sel(Sel));
    MUX4x1_1B mux_seg2 (.S(S[2]), .D0(D0[2]), .D1(D1[2]), .D2(D2[2]), .D3(D3[2]), .Sel(Sel));
    MUX4x1_1B mux_seg3 (.S(S[3]), .D0(D0[3]), .D1(D1[3]), .D2(D2[3]), .D3(D3[3]), .Sel(Sel));
    MUX4x1_1B mux_seg4 (.S(S[4]), .D0(D0[4]), .D1(D1[4]), .D2(D2[4]), .D3(D3[4]), .Sel(Sel));
    MUX4x1_1B mux_seg5 (.S(S[5]), .D0(D0[5]), .D1(D1[5]), .D2(D2[5]), .D3(D3[5]), .Sel(Sel));
    MUX4x1_1B mux_seg6 (.S(S[6]), .D0(D0[6]), .D1(D1[6]), .D2(D2[6]), .D3(D3[6]), .Sel(Sel));
endmodule