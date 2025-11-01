// Módulo que implementa uma pilha.
// Expõe os dois valores superiores da pilha: Topo (TDP) e Próximo (PDP).
module Pilha(
    output [7:0] TDP, // Saída do Topo da Pilha.
    output [7:0] PDP, // Saída do Próximo da Pilha.

    input [7:0] D, // Dado de 8 bits a ser empilhado.
    input         Clk,     // Sinal de clock.
    input         Reset,   // Reset assíncrono (limpa a pilha).
    input         PE       // "Pode Empilhar" - Habilita a operação.
);

    // A pilha de 2 níveis é implementada com dois registradores (Reg_A e Reg_B)
    
    // REGISTRADOR A (Armazena o Topo da Pilha, TDP)
    wire [7:0] regA_in; // Entrada do MUX para o registrador A.
    
    // MUX do TDP: Controlado por PE (Pode Empilhar).
    // Se PE=0 (Não empilha), mantém o valor atual (TDP -> regA_in).
    // Se PE=1 (Empilha), carrega o novo dado (Data_In -> regA_in).
    MUX2x1_8B mux_A (.S(regA_in), .A(TDP), .B(D), .Sel(PE));
    // Registrador armazena o valor do Topo (TDP).
    Registrador Reg_A (.S(TDP), .A(regA_in), .Clk(Clk), .Reset(Reset));


    // REGISTRADOR B (Armazena o Próximo da Pilha, PDP)
    wire [7:0] regB_in; // Entrada do MUX para o registrador B.

    // MUX do PDP: Controlado por PE (Pode Empilhar).
    // Se PE=0 (Não empilha), mantém o valor atual (PDP -> regB_in).
    // Se PE=1 (Empilha), o valor antigo do topo (TDP) é "empurrado" para baixo,
    // copiando o valor de TDP para o próximo nível (TDP -> regB_in).
    MUX2x1_8B mux_B (.S(regB_in), .A(PDP), .B(TDP), .Sel(PE));
    // Registrador armazena o valor Próximo (PDP).
    Registrador Reg_B (.S(PDP), .A(regB_in), .Clk(Clk), .Reset(Reset));

endmodule