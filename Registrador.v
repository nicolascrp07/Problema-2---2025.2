// Módulo que implementa um registrador de 8 bits.
module Registrador(
    input [7:0] A,    // Entrada de dados de 8 bits.
    input Clk,        // Sinal de clock.
    input Reset,      // Sinal de reset.
    output [7:0] S    // Saída de 8 bits (valor armazenado).
);
    // O registrador é construído instanciando 8 Flip-Flops D de 1 bit.
    // Cada FF armazena um bit da entrada A, compartilhando o mesmo clock e reset.
    FlipFlopD A0 (.Q(S[0]), .D(A[0]), .Clk(Clk), .Reset(Reset));
    FlipFlopD A1 (.Q(S[1]), .D(A[1]), .Clk(Clk), .Reset(Reset));
    FlipFlopD A2 (.Q(S[2]), .D(A[2]), .Clk(Clk), .Reset(Reset));
    FlipFlopD A3 (.Q(S[3]), .D(A[3]), .Clk(Clk), .Reset(Reset));
    FlipFlopD A4 (.Q(S[4]), .D(A[4]), .Clk(Clk), .Reset(Reset));
    FlipFlopD A5 (.Q(S[5]), .D(A[5]), .Clk(Clk), .Reset(Reset));
    FlipFlopD A6 (.Q(S[6]), .D(A[6]), .Clk(Clk), .Reset(Reset));
    FlipFlopD A7 (.Q(S[7]), .D(A[7]), .Clk(Clk), .Reset(Reset));
endmodule