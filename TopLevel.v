// Módulo TopLevel (Módulo Principal).
module TopLevel (
    input         CLOCK_50, // Clock principal de 50MHz da FPGA.
    input  [1:0]  KEY,      // Entradas dos botões (KEY[0], KEY[1]).
    input  [9:0]  SW,       // Entradas das chaves (SW[9:0]).

    output [9:0]  LEDR,     // Saídas para os LEDs vermelhos.
    output [6:0]  HEX0,     // Display (unidades/LSB)
    output [6:0]  HEX1,     // Display (meio)
    output [6:0]  HEX2,     // Display (esquerda/MSB)
    output [6:0]  HEX5      // Display (símbolo da operação)
);

    wire clk_lento; // Clock lento (dividido) para a lógica síncrona.
    wire reset_keys, reset_global, reset_power_on; // Sinais de reset: manual (keys), global (lógico) e power-on.
    wire flag_pronto; // Sinal para a saída das flags.

    // Gera um clock mais lento a partir dos 50MHz para operar o sistema.
    DivisorDeClock divisor (.clock_saida(clk_lento), .clock_entrada(CLOCK_50), .reset(reset_global));
    
    // Gera um pulso de reset (ativo baixo) na inicialização (power-on).
    ResetSincrono resetador_automatico (.reset_out(reset_power_on), .clock(clk_lento));

    // O reset global é ativado (ativo baixo) pelo power-on OU pelo reset manual (keys).
    or gate_reset_global(reset_global, reset_power_on , reset_keys);
    
    wire botao_sfinal0, botao_sfinal1; // Pulsos de 1 ciclo enviados para a UC após detecção de borda.
    wire key0_pressionado, key1_pressionado; // Sinais invertidos: '1' quando o botão está pressionado.
    
    // Converte lógica ativa baixa para ativa alta.
    not Not_KEY0 (key0_pressionado, KEY[0]);
    not Not_KEY1 (key1_pressionado, KEY[1]);
    
    // Decodificação das Ações dos Botões
    wire acao_reset, acao_key0, acao_key1;
    
    // Reset ativo quando ambos os botões são pressionados simultaneamente.
    and gate_acao_reset(reset_keys, key0_pressionado, key1_pressionado); 
    
    wire not_key1_pressionado, not_key0_pressionado;
    not(not_key1_pressionado, key1_pressionado);
    not(not_key0_pressionado, key0_pressionado);
    
    // Ação KEY0 ativa apenas quando KEY0 está pressionado E KEY1 não está.
    and gate_acao_key0(acao_key0, key0_pressionado, not_key1_pressionado); 
    
    // Ação KEY1 ativa apenas quando KEY1 está pressionado E KEY0 não está.
    and gate_acao_key1(acao_key1, key1_pressionado, not_key0_pressionado); 
    
    // Gera um pulso de 1 ciclo de clock quando o botão passa de não pressionado para pressionado.
    // Isso evita que a UC processe o sinal continuamente enquanto o botão está pressionado.
    
    wire acao_key0_dly, acao_key1_dly; // Estados anteriores das ações (atrasados em 1 ciclo).
    
    // Flip-flops armazenam o valor anterior de cada ação.
    FlipFlopD ff_delay_acao0 (.Q(acao_key0_dly), .D(acao_key0), .Clk(clk_lento), .Reset(reset_global));
    FlipFlopD ff_delay_acao1 (.Q(acao_key1_dly), .D(acao_key1), .Clk(clk_lento), .Reset(reset_global));
    
    wire not_acao0_dly, not_acao1_dly;
    not Not_adly0(not_acao0_dly, acao_key0_dly);
    not Not_adly1(not_acao1_dly, acao_key1_dly);
    
    // Detecção de borda quando acao_atual='1' E acao_anterior='0'.
    and detecta_borda0(botao_sfinal0, acao_key0, not_acao0_dly); 
    and detecta_borda1(botao_sfinal1, acao_key1, not_acao1_dly);
    
    wire pilha_empilha, pilha_sel_sw, ula_inicia; // Sinais de controle da UC.
    wire [2:0] ula_op_code; // Código de operação vindo da UC para a ULA.
    wire ula_pronto; // Sinal da ULA indicando que a operação foi concluída.
    
    // A UC orquestra as operações da ULA e da Pilha com base nos sinais dos botões.
    UnidadeDeControle uc (
        .pilha_empilha(pilha_empilha), .pilha_sel_sw(pilha_sel_sw), .ula_inicia(ula_inicia), .ula_op_code(ula_op_code), 
        .Clk(clk_lento), .Reset(reset_global), .KEY0(botao_sfinal0), .KEY1(botao_sfinal1), .SW(SW[7:0]), .ula_pronto(ula_pronto), 
        .empilha_resultado(flag_pronto)
    );
    
    // Fios para o OpCode registrado (para ULA)
    wire [2:0] ula_op_code_registrado, op_code_d;
    wire ula_start_dly; // Atraso de 1 ciclo do 'ula_inicia' para lógica de MUX.
    
    // Barramentos de dados principais
    wire [7:0] resultado_ula, resultado_ula_flags, tos_out, nos_out, data_in_pilha;
    
    // Fios de status da ULA (para Flags)
    wire soma_cout, soma_c6, sub_bout, sub_b6, res_div_r, multi_sat;

    // O OpCode deve ser mantido durante operações longas.
    FlipFlopD ff_start_dly (.Q(ula_start_dly), .D(ula_inicia), .Clk(clk_lento), .Reset(reset_global));

    // MUX do OpCode: Se 'ula_start_dly'=1 (iniciando), carrega o novo OpCode (ula_op_code).
    // Senão (ula_start_dly=0), mantém o OpCode antigo (ula_op_code_registrado).
    MUX2x1_1B mux_op0 (.S(op_code_d[0]), .A(ula_op_code_registrado[0]), .B(ula_op_code[0]), .Sel(ula_start_dly));
    MUX2x1_1B mux_op1 (.S(op_code_d[1]), .A(ula_op_code_registrado[1]), .B(ula_op_code[1]), .Sel(ula_start_dly));
    MUX2x1_1B mux_op2 (.S(op_code_d[2]), .A(ula_op_code_registrado[2]), .B(ula_op_code[2]), .Sel(ula_start_dly));

    // Registrador que armazena o OpCode para a ULA.
    FlipFlopD reg_op0 (.Q(ula_op_code_registrado[0]), .D(op_code_d[0]), .Clk(clk_lento), .Reset(reset_global));
    FlipFlopD reg_op1 (.Q(ula_op_code_registrado[1]), .D(op_code_d[1]), .Clk(clk_lento), .Reset(reset_global));
    FlipFlopD reg_op2 (.Q(ula_op_code_registrado[2]), .D(op_code_d[2]), .Clk(clk_lento), .Reset(reset_global));

    // MUX de entrada da Pilha: Seleciona SW[7:0] (se pilha_sel_sw=1) ou o resultado da ULA (se=0).
    MUX2x1_8B mux_pilha_entrada (.S(data_in_pilha), .A(resultado_ula), .B(SW[7:0]), .Sel(pilha_sel_sw));

    // Instancia a pilha.
    Pilha pilha (.TDP(tos_out), .PDP(nos_out), .D(data_in_pilha), .Clk(clk_lento), .Reset(reset_global), .PE(pilha_empilha));

    // Instancia a ULA.
    ULA_8Bits ula (
        .S(resultado_ula_flags), .SS(resultado_ula), .Soma_Cout(soma_cout), .Soma_C7(soma_c6), .Sub_Bout(sub_bout), .Sub_B7(sub_b6),
        .ula_pronto(ula_pronto), .A(nos_out), .B(tos_out), .Sel(ula_op_code_registrado),
        .Clk(clk_lento), .Reset(reset_global), .ula_start(ula_inicia), .res_div_res(res_div_r), .multi_sat(multi_sat)
    );
    
    wire flag_z, flag_ov, flag_cout, flag_err, flag_r; // Flags calculadas
    wire flag_zR, flag_ovR, flag_coutR, flag_errR, flag_rR; // Flags Registradas
    
    // Calcula as flags (Z, OV, COUT, ERR, R) com base no resultado da ULA.
    FlagsULA flags (
        .Z(flag_z), .OV(flag_ov), .COUT(flag_cout), .ERR(flag_err), .R(flag_r), .S(resultado_ula_flags), .B(tos_out),
        .soma_cout(soma_cout), .sub_bout(sub_bout), .soma_c6(soma_c6), .soma_c7(soma_cout),
        .sub_b6(sub_b6), .sub_b7(sub_bout), .Sel(ula_op_code_registrado), .resto_div(res_div_r), .multi_sat(multi_sat)
    );
    
    // As flags só devem ser atualizadas quando a UC comanda o "empilha_resultado".
    wire d_flag_z, d_flag_ov, d_flag_cout, d_flag_err, d_flag_r; // Entradas D dos FFs das flags.

    // MUX das Flags: Se 'flag_pronto'=1, carrega as novas flags. Senão, mantém as antigas.
    MUX2x1_1B mux_flag_z    (.S(d_flag_z),    .A(flag_zR),    .B(flag_z),    .Sel(flag_pronto));
    MUX2x1_1B mux_flag_ov   (.S(d_flag_ov),   .A(flag_ovR),   .B(flag_ov),   .Sel(flag_pronto));
    MUX2x1_1B mux_flag_cout (.S(d_flag_cout), .A(flag_coutR), .B(flag_cout), .Sel(flag_pronto));
    MUX2x1_1B mux_flag_err  (.S(d_flag_err),  .A(flag_errR),  .B(flag_err),  .Sel(flag_pronto));
    MUX2x1_1B mux_flag_r    (.S(d_flag_r),    .A(flag_rR),    .B(flag_r),    .Sel(flag_pronto));

    // Registradores (FFs) que armazenam o valor final das flags (Z, ER, OV, COUT, R).
    FlipFlopD flagZ    (.Q(flag_zR),    .D(d_flag_z),    .Clk(clk_lento), .Reset(reset_global));
    FlipFlopD flagER   (.Q(flag_errR),   .D(d_flag_err),   .Clk(clk_lento), .Reset(reset_global));
    FlipFlopD flagOV   (.Q(flag_ovR),    .D(d_flag_ov),    .Clk(clk_lento), .Reset(reset_global));
    FlipFlopD flagCOUT (.Q(flag_coutR),  .D(d_flag_cout),  .Clk(clk_lento), .Reset(reset_global));
    FlipFlopD flagR    (.Q(flag_rR),     .D(d_flag_r),     .Clk(clk_lento), .Reset(reset_global));
    
    
    // Conecta as flags registradas (Z, OV, COUT, ERR, R) aos LEDs 0-4.
    or led_z    (LEDR[0], flag_zR, 1'b0);
    or led_ov   (LEDR[1], flag_ovR, 1'b0);
    or led_cout (LEDR[2], flag_coutR, 1'b0);
    or led_err  (LEDR[3], flag_errR, 1'b0);
    or led_r    (LEDR[4], flag_rR, 1'b0); 
    // Desliga os LEDs 5-9.
    and led_off5(LEDR[5], 1'b0, 1'b0); 
    and led_off6(LEDR[6], 1'b0, 1'b0);
    and led_off7(LEDR[7], 1'b0, 1'b0); 
    and led_off8(LEDR[8], 1'b0, 1'b0); 
    and led_off9(LEDR[9], 1'b0, 1'b0);

    // Unidade de Display: Converte o Topo da Pilha para a base selecionada por SW[9:8].
    // Envia para os displays HEX0, HEX1, HEX2.
    SelBase unidade_de_display (.SW(SW[9:8]), .R(tos_out), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2));
    
    // Exibe o símbolo da operação atual (op_code_registrado) no display HEX5.
    DecodificadorOperacao operacao (.SW9(ula_op_code_registrado[2]), .KEY1(ula_op_code_registrado[1]), .KEY0(ula_op_code_registrado[0]), .HEX(HEX5));

endmodule
