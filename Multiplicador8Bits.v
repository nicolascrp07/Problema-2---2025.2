// Módulo que implementa um multiplicador sequencial.
// Calcula o resultado completo de 16 bits internamente para garantir a precisão.
// Fornece uma saída de 8 bits (P) que satura em 0 se o resultado exceder 255.
module Multiplicador8Bits (
    input  [7:0] A_in,  // Multiplicando (Operando A) de 8 bits.
    input  [7:0] B_in,  // Multiplicador (Operando B) de 8 bits.
    input  Clk,         // Clock síncrono.
    input  Reset,       // Reset assíncrono.
    output [7:0] P,     // Saída do Produto.
    output Fim,         // Flag '1' quando a multiplicação termina.
	 output multi_sat
);
    // O Multiplicando (A) e o Produto (P) usam 16 bits internamente.
    wire [15:0] A, P_out_16b; // Saídas dos regs A (multiplicando) e P (produto).
    wire [15:0] A_shift, P_in_16b; // Sinais de deslocamento e entrada do MUX do Produto.
    wire [15:0] Soma_16b; // Resultado do somador de 16 bits.
    wire [15:0] A_reg_in, P_reg_in; // Entradas dos regs A e P.

    // O Multiplicador (B) permanece com 8 bits.
    wire [7:0] B, B_shift; // Reg B (multiplicador) e seu sinal de deslocamento.
    wire [7:0] B_reg_in; // Entrada do reg B.
    
    wire Zero;       // Flag '1' se B_in == 0.
    wire EndCount;   // Flag '1' do contador (após 8 ciclos).
    wire [2:0] Count;  // Saída do contador de 3 bits.
    wire Load;       // Sinal '1' no ciclo 0 para carregar operandos.
    
    // Módulos de Controle
    Contador3Bits cont (.Q(Count), .Fim(EndCount), .Clk(Clk), .Reset(Reset));
    DetectorEstadoZero det_load (.Z(Load), .A(Count)); // 'Load' = 1 no ciclo 0.
    DetectorZero det0 (.Z(Zero), .B(B_in)); // 'Zero' = 1 se B_in == 0.

    wire [15:0] A_in_16b; // Fio para {8'b0, A_in[7:0]}
    // Conecta A_in[7:0] aos bits baixos [7:0] de A_in_16b.
    and bA0 (A_in_16b[0], A_in[0], 1'b1);
    and bA1 (A_in_16b[1], A_in[1], 1'b1);
    and bA2 (A_in_16b[2], A_in[2], 1'b1);
    and bA3 (A_in_16b[3], A_in[3], 1'b1);
    and bA4 (A_in_16b[4], A_in[4], 1'b1);
    and bA5 (A_in_16b[5], A_in[5], 1'b1);
    and bA6 (A_in_16b[6], A_in[6], 1'b1);
    and bA7 (A_in_16b[7], A_in[7], 1'b1);
    // Preenche os bits altos [15:8] de A_in_16b com '0'.
    and bA8  (A_in_16b[8],  1'b0, 1'b1);
    and bA9  (A_in_16b[9],  1'b0, 1'b1);
    and bA10 (A_in_16b[10], 1'b0, 1'b1);
    and bA11 (A_in_16b[11], 1'b0, 1'b1);
    and bA12 (A_in_16b[12], 1'b0, 1'b1);
    and bA13 (A_in_16b[13], 1'b0, 1'b1);
    and bA14 (A_in_16b[14], 1'b0, 1'b1);
    and bA15 (A_in_16b[15], 1'b0, 1'b1);

    // --- MUXes de Carga (A e P são 16 BITS, B é 8 BITS) ---
    // No ciclo 'Load', carrega A_in_16b. Senão, usa A deslocado.
    MUX2x1_16B muxA_load (.S(A_reg_in), .A(A_shift), .B(A_in_16b), .Sel(Load));
    // No ciclo 'Load', carrega B_in. Senão, usa B deslocado.
    MUX2x1_8B  muxB_load (.S(B_reg_in), .A(B_shift), .B(B_in), .Sel(Load));
    // MUX do Produto (P) sempre seleciona P_in (o Reset limpa o reg).
    MUX2x1_16B muxP_load (.S(P_reg_in), .A(P_in_16b), .B(P_in_16b), .Sel(Load));
    
    Registrador16B regA (.A(A_reg_in), .Clk(Clk), .S(A), .Reset(Reset)); // Armazena o Multiplicando (16b).
    Registrador    regB (.A(B_reg_in), .Clk(Clk), .S(B), .Reset(Reset)); // Armazena o Multiplicador (8b).
    Registrador16B regP (.A(P_reg_in), .Clk(Clk), .S(P_out_16b), .Reset(Reset)); // Armazena o Produto Parcial (16b).
    
    // 'A' (multiplicando) desloca para a esquerda 16 bits.
    DeslocaEsq16 deslA (.Y(A_shift), .A(A));
    // 'B' (multiplicador) desloca para a direita 8 bits.
    DeslocaDir8  deslB (.Y(B_shift), .A(B));
    
    // Soma o produto parcial (P_out) com o multiplicando (A).
    Somador16Bits soma1 (.S(Soma_16b), .A(P_out_16b), .B(A), .Cin(1'b0));
    
    // Se B[0] == 1, seleciona a soma (P + A).
    // Se B[0] == 0, mantém o valor atual de P (P_out_16b).
    MUX2x1_16B mux_p_logic (.S(P_in_16b), .A(P_out_16b), .B(Soma_16b), .Sel(B[0]));
        
    // 'Fim' = 1 se B_in for 0 (Zero=1) OU o contador terminar (EndCount=1).
    or OR1 (Fim, Zero, EndCount);

    // Verifica se qualquer bit da parte alta do resultado é '1'.
    wire nor_sat;
    // nor_sat será '1' SOMENTE se todos os bits altos [15:8] forem '0' (sem estouro).
    // nor_sat será '0' se houver estouro (overflow) para a parte alta.
    nor NOR1 (nor_sat, P_out_16b[15], P_out_16b[14], P_out_16b[13], P_out_16b[12], P_out_16b[11], P_out_16b[10], P_out_16b[9], P_out_16b[8]); 
    
    // Sel (nor_sat) = 1 -> Sem estouro -> Saída = .B (P_out_16b[7:0])
    // Sel (nor_sat) = 0 -> Com estouro -> Saída = .A (Saturado em 0)
    MUX2x1_8B mux_final_out (
        .S(P), 
        .A(8'b00000000),       // Valor 'A', selecionado se Sel=0 (Estouro)
        .B(P_out_16b[7:0]),    // Valor 'B', selecionado se Sel=1 (Normal)
        .Sel(nor_sat)
    );
	 
	 not SAT (multi_sat, nor_sat);
    
endmodule