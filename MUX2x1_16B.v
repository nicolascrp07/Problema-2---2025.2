// Módulo que implementa um MUX 2x1 de 16 bits.
module MUX2x1_16B(
    output [15:0] S,
    input  [15:0] A, 
    input  [15:0] B,
    input  Sel
);
    // Instancia 16 MUXes de 1 bit.
    MUX2x1_1B M0  (.S(S[0]),  .A(A[0]),  .B(B[0]),  .Sel(Sel));
    MUX2x1_1B M1  (.S(S[1]),  .A(A[1]),  .B(B[1]),  .Sel(Sel));
    MUX2x1_1B M2  (.S(S[2]),  .A(A[2]),  .B(B[2]),  .Sel(Sel));
    MUX2x1_1B M3  (.S(S[3]),  .A(A[3]),  .B(B[3]),  .Sel(Sel));
    MUX2x1_1B M4  (.S(S[4]),  .A(A[4]),  .B(B[4]),  .Sel(Sel));
    MUX2x1_1B M5  (.S(S[5]),  .A(A[5]),  .B(B[5]),  .Sel(Sel));
    MUX2x1_1B M6  (.S(S[6]),  .A(A[6]),  .B(B[6]),  .Sel(Sel));
    MUX2x1_1B M7  (.S(S[7]),  .A(A[7]),  .B(B[7]),  .Sel(Sel));
    MUX2x1_1B M8  (.S(S[8]),  .A(A[8]),  .B(B[8]),  .Sel(Sel));
    MUX2x1_1B M9  (.S(S[9]),  .A(A[9]),  .B(B[9]),  .Sel(Sel));
    MUX2x1_1B M10 (.S(S[10]), .A(A[10]), .B(B[10]), .Sel(Sel));
    MUX2x1_1B M11 (.S(S[11]), .A(A[11]), .B(B[11]), .Sel(Sel));
    MUX2x1_1B M12 (.S(S[12]), .A(A[12]), .B(B[12]), .Sel(Sel));
    MUX2x1_1B M13 (.S(S[13]), .A(A[13]), .B(B[13]), .Sel(Sel));
    MUX2x1_1B M14 (.S(S[14]), .A(A[14]), .B(B[14]), .Sel(Sel));
    MUX2x1_1B M15 (.S(S[15]), .A(A[15]), .B(B[15]), .Sel(Sel));
endmodule