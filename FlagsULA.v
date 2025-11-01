// Módulo responsável por gerar as flags de status (Z, OV, COUT, ERR, R) para a ULA de 8 bits.
module FlagsULA(
    output Z,         // Flag Zero: Ativa (1) se o resultado S for 0.
    output OV,        // Flag Overflow: Ativa (1) se ocorrer estouro aritmético.
    output COUT,      // Flag Carry Out: Ativa (1) para o carry (soma) ou borrow (sub).
    output ERR,       // Flag de Erro: Ativa (1) em caso de divisão por zero.
    output R,         // Flag Resto: Ativa (1) se o resto da divisão não for zero.

    // Entradas de 8 bits
    input  [7:0] S,         // Resultado de 8 bits da ULA (usado para flag Z).
    input  [7:0] B,         // Operando B (usado para checar divisão por zero).

    // Sinais de controle e carries/borrows vindos da ULA
    input  soma_cout, // Carry out final (C7) do somador.
    input  sub_bout,  // Borrow out final (B7) do subtrator.
    input  soma_c6,   // Carry da posição 6 para 7 na soma (para OV).
    input  soma_c7,   // Carry out final da soma (para OV) - (equivale a soma_cout).
    input  sub_b6,    // Borrow da posição 6 para 7 na subtração (para OV).
    input  sub_b7,    // Borrow out final da subtração (para OV) - (equivale a sub_bout).
    input  [2:0] Sel,     // Seletor da operação da ULA.
    input  [7:0] resto_div, // Resultado do resto da divisão (para flag R).
	 input  multi_sat  // Sinal de saturação da multiplicação.
);

    //  Flag Z (Zero): Ativa se S for 00000000 
    // Z=1 somente se todos os bits de S forem 0.
    nor NOR_Z(Z, S[7], S[6], S[5], S[4], S[3], S[2], S[1], S[0]);
    
    //  Lógica de Habilitação para Flags Aritméticas (COUT e OV) 
    wire op_aritmetica; // Fio que é '1' se a operação for aritmética (Sel[2] == 0).
    wire nSel1;
    // Inverte Sel[2]. op_aritmetica será '1' para Sel = 0xx (Soma, Sub, Mult, Div).
    not OP_ARITMETICA(op_aritmetica, Sel[2]);
	 not NSEL1 (nSel1, Sel[1]);
	 
    //  Flag COUT: Ativada para soma (Sel=000) ou subtração (Sel=001) 
    wire cout_sel; // Fio para o resultado do MUX (soma_cout ou sub_bout).
    // Seleciona 'soma_cout' (se Sel[0]=0) ou 'sub_bout' (se Sel[0]=1).
    MUX2x1_1B MUX_Cout(cout_sel, soma_cout, sub_bout, Sel[0]);
    // A flag COUT só é ativada se a operação for aritmética E o MUX selecionar um carry/borrow.
    and AND_Cout(COUT, cout_sel, op_aritmetica, nSel1);


    //  Flag OV (Overflow Aritmético para 8 bits) 
    wire ov_soma, ov_sub, ov_sel, ov_sosub; // Fios internos para o cálculo de overflow.
    // Detecta overflow da soma (C6 != C7).
    xor XOR_OV_Soma(ov_soma, soma_c6, soma_c7);
    // Detecta overflow da subtração (B6 != B7).
    xor XOR_OV_Sub(ov_sub, sub_b6, sub_b7);
    // Seleciona o resultado de overflow (soma ou sub) com base em Sel[0].
    MUX2x1_1B MUX_OV(ov_sel, ov_soma, ov_sub, Sel[0]);
    // A flag OV só é ativada se a operação for aritmética E houver overflow.
    and AND_OV(ov_sosub, ov_sel, op_aritmetica, nSel1);
	 
	 wire nSel0;
	 not NSEL0(nSel0, Sel[0]);

	 // Decodifica Sel = 010 (Multiplicação)
	 and DEC_MULT(sel_eh_mult, op_aritmetica, Sel[1], nSel0);
	 // OV da multiplicação = 1 se saturou e Sel = 010
	 and AND_OV_MULT(ov_mult, multi_sat, sel_eh_mult);
	 // Combina todas as origens de overflow (soma/sub/mult)
	 or OR_OV(OV, ov_sosub, ov_mult);


    //  Flag ERR (Divisão por Zero em 8 bits) 
    wire b_eh_zero;  // '1' se o operando B (divisor) for zero.
    wire sel_eh_div; // '1' se a operação selecionada for Divisão (Sel=011).
    // Detecta se B == 0.
    nor NOR_B_eh_zero(b_eh_zero, B[7], B[6], B[5], B[4], B[3], B[2], B[1], B[0]);
    // Decodifica a operação de divisão (Sel = 011).
    // (op_aritmetica=1 -> Sel[2]=0) AND (Sel[1]=1) AND (Sel[0]=1).
    and AND_Sel_eh_div(sel_eh_div, Sel[1], Sel[0], op_aritmetica); 
    // A flag ERR é ativada se B for zero E a operação for divisão.
    and AND_ERR_Final(ERR, b_eh_zero, sel_eh_div);
    
    //  Flag R (Resto): Ativa se o resto da divisão não for zero 
    wire resto_n_zero; // '1' se qualquer bit do 'resto_div' for 1.
    // Detecta se o resto_div é diferente de zero.
    or RES_OR (resto_n_zero, resto_div[7], resto_div[6], resto_div[5], resto_div[4], resto_div[3], resto_div[2], resto_div[1], resto_div[0]);
    // A flag R é ativada se o Resto não for zero E a operação for divisão.
    and AND_R (R, resto_n_zero, sel_eh_div);

endmodule