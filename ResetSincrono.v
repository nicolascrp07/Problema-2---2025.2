// Módulo que gera um sinal de reset síncrono.
module ResetSincrono (
    output reset_out, // Saída do reset.
    input  clock      // Clock de entrada do sistema.
);
    // Fios para os 3 estágios do registrador de deslocamento.
    wire q1, q2, q3;
    // Fio para a constante '1'.
    wire const1;
    
    // A entrada D do primeiro FF deve ser '1'.
    wire not_const1;
    not n1(not_const1, 1'b0); 
    or  b1(const1, not_const1, 1'b0);

    // Usado para atrasar (sincronizar) a propagação da constante '1'.
    // O pino 'Reset' dos FFs está em '0' (desativado).

    // 1º Estágio: q1 recebe '1' no primeiro ciclo de clock.
    FlipFlopD ff_sync1 (.Q(q1), .D(const1), .Clk(clock), .Reset(1'b0)); 
    // 2º Estágio: q2 recebe o valor de q1 no segundo ciclo de clock.
    FlipFlopD ff_sync2 (.Q(q2), .D(q1),     .Clk(clock), .Reset(1'b0));
    // 3º Estágio: q3 recebe o valor de q2 no terceiro ciclo de clock.
    FlipFlopD ff_sync3 (.Q(q3), .D(q2),     .Clk(clock), .Reset(1'b0));

    // A saída é a inversão do último estágio (q3).
    not n_out(reset_out, q3);
endmodule