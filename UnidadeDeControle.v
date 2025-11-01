// Módulo que implementa a Unidade de Controle.
// Gerencia a sequência de operações: empilhar dados, iniciar a ULA e empilhar o resultado.
module UnidadeDeControle(
    // Saídas de Controle
    output       pilha_empilha,   // '1' para habilitar a operação empilhar na pilha.
    output       pilha_sel_sw,    // '1' para selecionar a entrada SW (dados) como fonte para a pilha.
    output       ula_inicia,      // '1' para iniciar/resetar a ULA.
    output [2:0] ula_op_code,     // Código da operação (Sel) para a ULA.
    output       empilha_resultado, // '1' para selecionar o resultado da ULA como fonte para a pilha.

    // Entradas
    input        Clk,         // Clock principal.
    input        Reset,       // Reset assíncrono.
    input        KEY0,        // Botão de entrada.
    input        KEY1,        // Botão de entrada.
    input  [7:0] SW,          // Chaves de entrada.
    input        ula_pronto   // Sinal '1' da ULA indicando que a operação terminou.
);

    wire [2:0] s_atual, s_prox; // Fios para o estágio atual (Q) e o próximo estágio (D).
    wire estagio_transicao_inicia; // Fio auxiliar para a transição de início da ULA.
    
    // 3 Flip-Flops D armazenam o estágio atual.
    FlipFlopD FF0 (.Q(s_atual[0]), .D(s_prox[0]), .Clk(Clk), .Reset(Reset));
    FlipFlopD FF1 (.Q(s_atual[1]), .D(s_prox[1]), .Clk(Clk), .Reset(Reset));
    FlipFlopD FF2 (.Q(s_atual[2]), .D(s_prox[2]), .Clk(Clk), .Reset(Reset));

    wire s2_n, s1_n, s0_n; // Fios para os bits de estágio invertidos.
    not(s2_n, s_atual[2]); not(s1_n, s_atual[1]); not(s0_n, s_atual[0]);
    
    // Fios de decodificação. Cada fio é '1' apenas no estágio correspondente.
    wire EST_OCIOSO, EST_EMPILHA_DADO, EST_INICIA_ULA, EST_AGUARDA_ULA, EST_EMPILHA_RES;
    and(EST_OCIOSO,        s2_n, s1_n, s0_n);         // Estágio 000
    and(EST_EMPILHA_DADO,  s2_n, s1_n, s_atual[0]);   // Estágio 001
    and(EST_INICIA_ULA,    s2_n, s_atual[1], s0_n);   // Estágio 010
    and(EST_AGUARDA_ULA,   s2_n, s_atual[1], s_atual[0]); // Estágio 011
    and(EST_EMPILHA_RES,   s_atual[2], s1_n, s0_n);   // Estágio 100
    
    // 'estagio_transicao_inicia' é '1' se estamos em OCIOSO e KEY1 é pressionado.
    and(estagio_transicao_inicia, EST_OCIOSO, KEY1);
        
    // 'pilha_empilha' é ativo nos estágios EMPILHA_DADO (001) ou EMPILHA_RES (100).
    or(pilha_empilha, EST_EMPILHA_DADO, EST_EMPILHA_RES);
    // 'pilha_sel_sw' seleciona a entrada SW apenas no estágio EMPILHA_DADO.
    or(pilha_sel_sw, EST_EMPILHA_DADO, 1'b0);
    // 'ula_inicia' é '1' durante a transição de OCIOSO para INICIA_ULA (quando KEY1 é pressionado).
    or(ula_inicia, estagio_transicao_inicia, 1'b0);
    // 'ula_op_code' é 000, exceto no estágio INICIA_ULA (010), quando copia SW[2:0].
    and(ula_op_code[0], SW[0], EST_INICIA_ULA);
    and(ula_op_code[1], SW[1], EST_INICIA_ULA);
    and(ula_op_code[2], SW[2], EST_INICIA_ULA);

    wire T_OCIOSO_para_EMPILHA, T_OCIOSO_para_INICIA;
    wire T_AGUARDA_para_EMPILHA_RES, T_FICA_AGUARDANDO;

    // Transição 000 (OCIOSO) -> 001 (EMPILHA_DADO) se KEY0=1.
    and(T_OCIOSO_para_EMPILHA, EST_OCIOSO, KEY0);
    // Transição 000 (OCIOSO) -> 010 (INICIA_ULA) se KEY1=1.
    and(T_OCIOSO_para_INICIA, EST_OCIOSO, KEY1);
    // Transição 011 (AGUARDA_ULA) -> 100 (EMPILHA_RES) se ula_pronto=1.
    and(T_AGUARDA_para_EMPILHA_RES, EST_AGUARDA_ULA, ula_pronto);
    // Fio auxiliar para a condição 'ula_pronto == 0'.
    wire not_ula_pronto;
    not(not_ula_pronto, ula_pronto);
    // Transição 011 (AGUARDA_ULA) -> 011 (fica aguardando) se ula_pronto=0.
    and(T_FICA_AGUARDANDO, EST_AGUARDA_ULA, not_ula_pronto);

    // Equações de próximo estágio
    // s_prox[0] (LSB) = 1 nos estágios 001 (EMPILHA_DADO) e 011 (AGUARDA_ULA).
    or(s_prox[0], T_OCIOSO_para_EMPILHA, EST_INICIA_ULA, T_FICA_AGUARDANDO);

    // s_prox[1] = 1 nos estágios 010 (INICIA_ULA) e 011 (AGUARDA_ULA).
    or(s_prox[1], T_OCIOSO_para_INICIA, EST_INICIA_ULA, T_FICA_AGUARDANDO);
    
    // s_prox[2] (MSB) = 1 no estágio 100 (EMPILHA_RES).
    or(s_prox[2], T_AGUARDA_para_EMPILHA_RES, 1'b0);
    
    // Ativo apenas no estágio EMPILHA_RES (100).
    or flags_out (empilha_resultado, EST_EMPILHA_RES, 1'b0);
    
endmodule