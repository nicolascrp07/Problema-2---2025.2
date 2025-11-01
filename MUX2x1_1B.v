// Módulo que implementa um multiplexador (MUX) de 2 para 1 para 1 bit.
module MUX2x1_1B(
    output S,
    input  A, B,
    input  Sel
);
    wire T1, T2, notS;

    not NotS(notS, Sel);
    and And0(T1, notS, A);
    and And1(T2, Sel, B);
    or  Or0(S, T1, T2);
endmodule