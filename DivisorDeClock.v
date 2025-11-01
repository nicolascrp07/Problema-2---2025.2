// Módulo que implementa um divisor de clock por 4.
module DivisorDeClock (
    output clock_saida,   // Saída do clock dividido.
    input  clock_entrada, // Clock de entrada original.
    input  reset          // Reset assíncrono.
);

    wire cont_q;     // Saída Q (estado) do contador de 1 bit.
    wire cont_d;     // Entrada D (próximo estado) do contador de 1 bit.
    
    wire habilita_inversao;   // Sinal de habilitação para o 2º estágio
    wire saida_d;           // Entrada D do flip-flop de saída.
    wire saida_q;           // Saída Q do flip-flop de saída.

    // A entrada D é a saída Q invertida.
    not inv_cont(cont_d, estado_cont_q);

    // Registrador que armazena o estado do contador de 1 bit.
    FlipFlopD reg_cont (
        .Q(cont_q), 
        .D(cont_d), 
        .Clk(clock_entrada), 
        .Reset(reset)
    );

    // O 'habilita_inversao' é '1' sempre que o contador (estado_cont_q) estiver em '1'.
    or buf_habilita(habilita_inversao, cont_q, 1'b0);

    // A entrada 'saida_d' só inverte o valor de 'saida_q' quando 'habilita_inversao' for '1'.
    xor logica_inversao_saida(saida_d, saida_q, habilita_inversao);

    // Flip-flop que armazena o estado do clock de saída.
    FlipFlopD reg_saida (
        .Q(saida_q), 
        .D(saida_d), 
        .Clk(clock_entrada), 
        .Reset(reset)
    );

    // Conecta a saída Q do registrador final à porta de saída do módulo.
    or buf_saida(clock_saida, saida_q, 1'b0);

endmodule