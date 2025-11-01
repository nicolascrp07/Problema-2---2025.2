// Módulo que implementa a conversão de Binário para BCD (Algoritmo "Double Dabble").
// Converte um número de 8 bits (0-255) em três dígitos BCD (Centenas, Dezenas, Unidades).
module BinarioParaBCD(
    input  [7:0] binario,        // O valor binário de 8 bits a ser convertido.

    output [3:0] bcd_centenas,   // O dígito BCD das centenas.
    output [3:0] bcd_dezenas,    // O dígito BCD das dezenas.
    output [3:0] bcd_unidades    // O dígito BCD das unidades.
);
    // Fios expandidos para 12 bits para acomodar os 3 dígitos BCD (Centenas[11:8], Dezenas[7:4], Unidades[3:0]).
    // 'estagion' armazena o resultado após o shift; 'estagio_ajustadon' armazena o resultado após o "SomaMais3".
    wire [11:0] estagio0, estagio1, estagio2, estagio3, estagio4, estagio5, estagio6, estagio7, estagio8;
    wire [11:0] estagio_ajustado0, estagio_ajustado1, estagio_ajustado2, estagio_ajustado3;
    wire [11:0] estagio_ajustado4, estagio_ajustado5, estagio_ajustado6, estagio_ajustado7;

    // 'estagio0' é inicializado com 12 bits em zero.
    ConcatenaInicial inicializador (estagio0);

    // O algoritmo consiste em 8 estágios (um para cada bit da entrada binária).
    // Em cada estágio:
    // 1. Ajusta (SomaMais3): Se qualquer dígito BCD (Centena, Dezena, Unidade) for >= 5, soma 3 a ele.
    // 2. Desloca (DeslocaConcatena): Desloca o valor ajustado de 12 bits para a esquerda e insere o próximo bit binário.

    // Estágio 1: Processa o bit binario[7] (MSB)
    SomaMais3 Ajuste_Centena_E1(estagio_ajustado0[11:8], estagio0[11:8]);
    SomaMais3 Ajuste_Dezena_E1 (estagio_ajustado0[7:4],  estagio0[7:4]);
    SomaMais3 Ajuste_Unidade_E1(estagio_ajustado0[3:0],  estagio0[3:0]);
    DeslocaConcatena Desloca_E1(estagio1, estagio_ajustado0, binario[7]);

    // Estágio 2: Processa o bit binario[6]
    SomaMais3 Ajuste_Centena_E2(estagio_ajustado1[11:8], estagio1[11:8]);
    SomaMais3 Ajuste_Dezena_E2 (estagio_ajustado1[7:4],  estagio1[7:4]);
    SomaMais3 Ajuste_Unidade_E2(estagio_ajustado1[3:0],  estagio1[3:0]);
    DeslocaConcatena Desloca_E2(estagio2, estagio_ajustado1, binario[6]);

    // Estágio 3: Processa o bit binario[5]
    SomaMais3 Ajuste_Centena_E3(estagio_ajustado2[11:8], estagio2[11:8]);
    SomaMais3 Ajuste_Dezena_E3 (estagio_ajustado2[7:4],  estagio2[7:4]);
    SomaMais3 Ajuste_Unidade_E3(estagio_ajustado2[3:0],  estagio2[3:0]);
    DeslocaConcatena Desloca_E3(estagio3, estagio_ajustado2, binario[5]);

    // Estágio 4: Processa o bit binario[4]
    SomaMais3 Ajuste_Centena_E4(estagio_ajustado3[11:8], estagio3[11:8]);
    SomaMais3 Ajuste_Dezena_E4 (estagio_ajustado3[7:4],  estagio3[7:4]);
    SomaMais3 Ajuste_Unidade_E4(estagio_ajustado3[3:0],  estagio3[3:0]);
    DeslocaConcatena Desloca_E4(estagio4, estagio_ajustado3, binario[4]);

    // Estágio 5: Processa o bit binario[3]
    SomaMais3 Ajuste_Centena_E5(estagio_ajustado4[11:8], estagio4[11:8]);
    SomaMais3 Ajuste_Dezena_E5 (estagio_ajustado4[7:4],  estagio4[7:4]);
    SomaMais3 Ajuste_Unidade_E5(estagio_ajustado4[3:0],  estagio4[3:0]);
    DeslocaConcatena Desloca_E5(estagio5, estagio_ajustado4, binario[3]);

    // Estágio 6: Processa o bit binario[2]
    SomaMais3 Ajuste_Centena_E6(estagio_ajustado5[11:8], estagio5[11:8]);
    SomaMais3 Ajuste_Dezena_E6 (estagio_ajustado5[7:4],  estagio5[7:4]);
    SomaMais3 Ajuste_Unidade_E6(estagio_ajustado5[3:0],  estagio5[3:0]);
    DeslocaConcatena Desloca_E6(estagio6, estagio_ajustado5, binario[2]);

    // Estágio 7: Processa o bit binario[1]
    SomaMais3 Ajuste_Centena_E7(estagio_ajustado6[11:8], estagio6[11:8]);
    SomaMais3 Ajuste_Dezena_E7 (estagio_ajustado6[7:4],  estagio6[7:4]);
    SomaMais3 Ajuste_Unidade_E7(estagio_ajustado6[3:0],  estagio6[3:0]);
    DeslocaConcatena Desloca_E7(estagio7, estagio_ajustado6, binario[1]);

    // Estágio 8: Processa o bit binario[0] (LSB)
    SomaMais3 Ajuste_Centena_E8(estagio_ajustado7[11:8], estagio7[11:8]);
    SomaMais3 Ajuste_Dezena_E8 (estagio_ajustado7[7:4],  estagio7[7:4]);
    SomaMais3 Ajuste_Unidade_E8(estagio_ajustado7[3:0],  estagio7[3:0]);
    DeslocaConcatena Desloca_E8(estagio8, estagio_ajustado7, binario[0]);

    // Após 8 estágios, o fio 'estagio8' contém os três dígitos BCD.
    // As portas 'or' com '1'b0' atuam como buffers, atribuindo os fios de saída.

    // Conecta o barramento das centenas (bits 11-8) à saída bcd_centenas.
    or out_c3(bcd_centenas[3], estagio8[11], 1'b0);
    or out_c2(bcd_centenas[2], estagio8[10], 1'b0);
    or out_c1(bcd_centenas[1], estagio8[9], 1'b0);
    or out_c0(bcd_centenas[0], estagio8[8], 1'b0);

    // Conecta o barramento das dezenas (bits 7-4) à saída bcd_dezenas.
    or out_d3(bcd_dezenas[3], estagio8[7], 1'b0);
    or out_d2(bcd_dezenas[2], estagio8[6], 1'b0);
    or out_d1(bcd_dezenas[1], estagio8[5], 1'b0);
    or out_d0(bcd_dezenas[0], estagio8[4], 1'b0);

    // Conecta o barramento das unidades (bits 3-0) à saída bcd_unidades.
    or out_u3(bcd_unidades[3], estagio8[3], 1'b0);
    or out_u2(bcd_unidades[2], estagio8[2], 1'b0);
    or out_u1(bcd_unidades[1], estagio8[1], 1'b0);
    or out_u0(bcd_unidades[0], estagio8[0], 1'b0);

endmodule