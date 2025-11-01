// Módulo que implementa um registrador de 16 bits.
module Registrador16B(
    input [15:0] A,    // Entrada de dados de 16 bits.
    input Clk,         // Sinal de clock.
    input Reset,       // Sinal de reset.
    output [15:0] S   // Saída de 16 bits (valor armazenado).
);
    // Instancia 16 Flip-Flops D de 1 bit.
    FlipFlopD A0  (.Q(S[0]),  .D(A[0]),  .Clk(Clk), .Reset(Reset));
    FlipFlopD A1  (.Q(S[1]),  .D(A[1]),  .Clk(Clk), .Reset(Reset));
    FlipFlopD A2  (.Q(S[2]),  .D(A[2]),  .Clk(Clk), .Reset(Reset));
    FlipFlopD A3  (.Q(S[3]),  .D(A[3]),  .Clk(Clk), .Reset(Reset));
    FlipFlopD A4  (.Q(S[4]),  .D(A[4]),  .Clk(Clk), .Reset(Reset));
    FlipFlopD A5  (.Q(S[5]),  .D(A[5]),  .Clk(Clk), .Reset(Reset));
    FlipFlopD A6  (.Q(S[6]),  .D(A[6]),  .Clk(Clk), .Reset(Reset));
    FlipFlopD A7  (.Q(S[7]),  .D(A[7]),  .Clk(Clk), .Reset(Reset));
    FlipFlopD A8  (.Q(S[8]),  .D(A[8]),  .Clk(Clk), .Reset(Reset));
    FlipFlopD A9  (.Q(S[9]),  .D(A[9]),  .Clk(Clk), .Reset(Reset));
    FlipFlopD A10 (.Q(S[10]), .D(A[10]), .Clk(Clk), .Reset(Reset));
    FlipFlopD A11 (.Q(S[11]), .D(A[11]), .Clk(Clk), .Reset(Reset));
    FlipFlopD A12 (.Q(S[12]), .D(A[12]), .Clk(Clk), .Reset(Reset));
    FlipFlopD A13 (.Q(S[13]), .D(A[13]), .Clk(Clk), .Reset(Reset));
    FlipFlopD A14 (.Q(S[14]), .D(A[14]), .Clk(Clk), .Reset(Reset));
    FlipFlopD A15 (.Q(S[15]), .D(A[15]), .Clk(Clk), .Reset(Reset));
endmodule