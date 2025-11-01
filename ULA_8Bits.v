// Módulo que implementa a Unidade Lógica e Aritmética (ULA) de 8 bits.
// Centraliza 8 operações (Soma, Sub, Mult, Div, AND, OR, XOR, NOT).
module ULA_8Bits(
    // Saídas
    output [7:0] S,          // Saída BRUTA (não-saturada), usada para cálculo de flags.
    output [7:0] SS,         // Saída SATURADA (principal resultado da operação).
    output         Soma_Cout,  // Carry Out da Soma (para Flags).
    output         Soma_C7,    // Carry entre bit 6 e 7 da Soma (para Flags).
    output         Sub_Bout,   // Borrow Out da Subtração (para Flags).
    output         Sub_B7,     // Borrow entre bit 6 e 7 da Subtração (para Flags).
    output         ula_pronto, // Sinal 'pronto'.
    output [7:0] res_div_res, // Saída do Resto da divisão.
	 output 			 multi_sat,

    // Entradas
    input [7:0] A, B,    // Operandos de entrada de 8 bits.
    input [2:0] Sel,     // Seletor de operação de 3 bits.
    input         Clk,       // Clock (usado pelo Multiplicador).
    input         Reset,     // Reset (não utilizado diretamente).
    input         ula_start  // Sinal de início/reset para o Multiplicador.
);

    // Fios para os resultados de cada unidade de operação
    wire [7:0] res_soma, res_sub, res_mult, res_div_q, res_somas, res_subs; 
    wire [7:0] res_and, res_or, res_xor, res_not; 
    wire         mult_fim; // Flag vinda do multiplicador.

    // Todas as unidades recebem as mesmas entradas A e B e calculam em paralelo.
    // O seletor (Sel) apenas escolhe qual resultado será enviado às saídas S e SS.

    // Operações Aritméticas
    Somador8Bits       unidade_soma     (.S(res_soma), .Cout(Soma_Cout), .C7(Soma_C7), .A(A), .B(B), .Cin(1'b0)); // Soma A+B (Cin=0)
    Subtrator8Bits     unidade_sub      (.D(res_sub), .Bout(Sub_Bout), .B7(Sub_B7), .A(A), .B(B)); // Subtração A-B
    // Multiplicador usa 'ula_start' como seu sinal de Reset para carregar os operandos.
    Multiplicador8Bits unidade_mult     (.P(res_mult), .Fim(mult_fim), .A_in(A), .B_in(B), .Clk(Clk), .Reset(ula_start), .multi_sat(multi_sat)); // Multiplicação A*B
    Divisor8Bits       unidade_div      (.Quociente(res_div_q), .Resto(res_div_res), .A(A), .B(B)); // Divisão A/B (Quociente e Resto)
    
    // Operações Lógicas
    And8Bits           unidade_and      (.S(res_and), .A(A), .B(B)); // A & B
    Or8Bits            unidade_or       (.S(res_or), .A(A), .B(B));  // A | B
    Xor8Bits           unidade_xor      (.S(res_xor), .A(A), .B(B)); // A ^ B
    Not8Bits           unidade_not      (.S(res_not), .A(A));        // ~A

    
    // Lógica de Saturação para Soma e Subtração (para a saída SS).
    // Se houver overflow (Cout=1) ou underflow (Bout=1), o resultado é forçado a 0.
    MUX2x1_8B mux_soma_sat (.S(res_somas), .A(res_soma), .B(8'b00000000), .Sel(Soma_Cout));
    MUX2x1_8B mux_sub_sat  (.S(res_subs),  .A(res_sub),  .B(8'b00000000), .Sel(Sub_Bout));

    // A ULA está "pronta" (1) imediatamente para operações combinacionais.
    // Para a multiplicação (Sel=010), ela só está pronta quando o multiplicador sinaliza 'mult_fim' = 1.
    wire op_eh_mult; // Flag '1' se a operação selecionada for 010 (MULT).
    wire nSel2, nSel0;
    not N_Sel2(nSel2, Sel[2]);
    not N_Sel0(nSel0, Sel[0]);
    // Decodifica Sel = 010 (Multiplicação)
    and DEC_MULT(op_eh_mult, nSel2, Sel[1], nSel0);
    
    // MUX para selecionar o sinal de pronto:
    // Se Sel=010 (op_eh_mult=1), ula_pronto = mult_fim.
    // Senão (op_eh_mult=0), ula_pronto = 1'b1 (sempre pronto).
    MUX2x1_1B mux_pronto(.S(ula_pronto), .A(1'b1), .B(mult_fim), .Sel(op_eh_mult));

    
    // Saída SATURADA (SS) 
    // Seleciona o resultado para a saída principal SS, com base no seletor 'Sel'.
    MUX8x1_8B mux_saida_final (
        .S(SS),
        .D0(res_somas), // Sel = 000 (Soma Saturada)
        .D1(res_subs),  // Sel = 001 (Subtração Saturada)
        .D2(res_mult),  // Sel = 010 (Mult)
        .D3(res_div_q), // Sel = 011 (Div)
        .D4(res_and),   // Sel = 100 (AND)
        .D5(res_or),    // Sel = 101 (OR)
        .D6(res_xor),   // Sel = 110 (XOR)
        .D7(res_not),   // Sel = 111 (NOT)
        .Sel(Sel)
    );

    // Saída BRUTA (S)
    // Seleciona o resultado para a saída S, usada para geração de flags.
    MUX8x1_8B mux_flags (
        .S(S),
        .D0(res_soma),  // Sel = 000 (Soma Bruta)
        .D1(res_sub),   // Sel = 001 (Subtração Bruta)
        .D2(res_mult),  // Sel = 010 (Mult)
        .D3(res_div_q), // Sel = 011 (Div)
        .D4(res_and),   // Sel = 100 (AND)
        .D5(res_or),    // Sel = 101 (OR)
        .D6(res_xor),   // Sel = 110 (XOR)
        .D7(res_not),   // Sel = 111 (NOT)
        .Sel(Sel)
    );

endmodule