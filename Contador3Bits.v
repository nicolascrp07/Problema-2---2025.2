// Módulo que implementa um contador síncrono de 3 bits (0 a 7).
module Contador3Bits (Q, Fim, Clk, Reset);
    output [2:0] Q;     // Saída de 3 bits com o valor atual da contagem.
    output Fim;        // Flag quando a contagem atinge 111.
    input Clk, Reset;  // Clock síncrono e Reset.

    // Fios para a lógica de incremento.
    wire [7:0] A, B, S; // Entradas (A, B) e Saída (S) do somador.
    wire Cout, C7;      // Saídas de carry do somador (não utilizadas).
    wire const1, const0; // Constantes lógicas '1' e '0'.

    // Geração de constantes
    not N1 (const0, 1'b1); // const0 = 0
    not N2 (const1, const0); // const1 = 1

    // Prepara a entrada A do somador: A = {5'b0, Q[2:0]}
    // O valor atual Q é estendido para 8 bits (usando AND 1) para alimentar o somador.
    and A0 (A[0], Q[0], const1);
    and A1 (A[1], Q[1], const1);
    and A2 (A[2], Q[2], const1);
    // O restante dos bits de A são forçados em 0 (usando AND 0).
    and A3 (A[3], const0, const1);
    and A4 (A[4], const0, const1);
    and A5 (A[5], const0, const1);
    and A6 (A[6], const0, const1);
    and A7 (A[7], const0, const1);

    // Prepara a entrada B do somador: B = 8'b00000001
    // O valor '1' (B[0]) é usado para incrementar o contador (A + 1).
    and B0 (B[0], const1, const1);
    and B1 (B[1], const0, const1);
    and B2 (B[2], const0, const1);
    and B3 (B[3], const0, const1);
    and B4 (B[4], const0, const1);
    and B5 (B[5], const0, const1);
    and B6 (B[6], const0, const1);
    and B7 (B[7], const0, const1);

    // O somador calcula S = A + B + Cin (Q + 1 + 0).
    // S[2:0] conterá o próximo estado do contador.
    Somador8Bits somaCont (S, Cout, C7, A, B, const0);

    // Flip-flops D para armazenar o estado (Q) do contador.
    // No Reset, Q é zerado. A cada pulso de clock, Q recebe S (Q+1).
    FlipFlopD FF0 (.Q(Q[0]), .D(S[0]), .Clk(Clk), .Reset(Reset));
    FlipFlopD FF1 (.Q(Q[1]), .D(S[1]), .Clk(Clk), .Reset(Reset));
    FlipFlopD FF2 (.Q(Q[2]), .D(S[2]), .Clk(Clk), .Reset(Reset));

    // Detecta o fim da contagem.
    // Fim = 1 quando Q = 3'b111.
    and F1 (Fim, Q[0], Q[1], Q[2]);
endmodule