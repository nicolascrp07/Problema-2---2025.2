// Módulo que implementa um Flip-Flop D comportamental de 1 bit com reset assíncrono.
module FlipFlopD(
    output reg Q, // Saída de 1 bit (valor armazenado).
    input D,      // Entrada de dados de 1 bit.
    input Clk,    // Sinal de clock.
    input Reset   // Sinal de reset assíncrono (nível alto).
);
    // Bloco always sensível à borda de subida do clock ou à borda de subida do reset.
    always @(posedge Clk or posedge Reset) begin
        // O Reset tem prioridade. Se Reset=1, a saída é zerada.
        if (Reset) Q <= 1'b0;
        // Se Reset=0, na borda de subida do clock, a saída Q recebe a entrada D.
        else Q <= D;
    end
endmodule