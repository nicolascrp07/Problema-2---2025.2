// Módulo que implementa um divisor combinacional de 8 bits (A / B).
module Divisor8Bits(
    output [7:0] Quociente, // Vetor de 8 bits para o resultado do quociente.
    output [7:0] Resto,     // Vetor de 8 bits para o resultado do resto.

    input  [7:0] A, // Dividendo de 8 bits.
    input  [7:0] B  // Divisor de 8 bits.
);

    wire [7:0] calc_quociente; // Armazena o quociente calculado.
    wire [7:0] calc_resto;     // Armazena o resto calculado.

    // Detecção de Divisão por Zero
    wire B_Zero; // Flag que é '1' se o divisor B for igual a zero.
    nor NB_Zero(B_Zero, B[7], B[6], B[5], B[4], B[3], B[2], B[1], B[0]); // Se qualquer bit de B for 1, B_Zero é 0.

    // Fios para os 8 estágios da divisão
    wire [7:0] sub_out_1, sub_out_2, sub_out_3, sub_out_4, sub_out_5, sub_out_6, sub_out_7, sub_out_8; // Saída da subtração de cada estágio.
    wire bout_1, bout_2, bout_3, bout_4, bout_5, bout_6, bout_7, bout_8; // Sinal de borrow-out de cada subtrator.
    wire [7:0] resto_1, resto_2, resto_3, resto_4, resto_5, resto_6, resto_7; // Resto parcial (saída do MUX) de cada estágio.

    // Estágio 1: Calcula Quociente[7]
    // Tenta subtrair B do dividendo parcial (A[7] com zeros à esquerda).
    Subtrator8Bits sub1(.D(sub_out_1), .Bout(bout_1), .A({7'b0, A[7]}), .B(B));
    not inv_q7(calc_quociente[7], bout_1); // O bit do quociente é '1' se não houver borrow (bout_1 == 0).
    // Seleciona o resto: se Q[7]=1, usa o resultado da subtração; senão, restaura o valor original.
    MUX2x1_8B mux1(.S(resto_1), .A({7'b0, A[7]}), .B(sub_out_1), .Sel(calc_quociente[7]));

    // Estágio 2: Calcula Quociente[6]  
    // Tenta subtrair B do novo dividendo parcial (resto_1 shiftado + A[6]).
    Subtrator8Bits sub2(.D(sub_out_2), .Bout(bout_2), .A({resto_1[6:0], A[6]}), .B(B));
    not inv_q6(calc_quociente[6], bout_2); // O bit do quociente é '1' se não houver borrow.
    // Seleciona o resto_2 (restaura ou usa o resultado da subtração).
    MUX2x1_8B mux2(.S(resto_2), .A({resto_1[6:0], A[6]}), .B(sub_out_2), .Sel(calc_quociente[6]));

    // Estágio 3: Calcula Quociente[5]  
    // Tenta subtrair B do novo dividendo parcial (resto_2 shiftado + A[5]).
    Subtrator8Bits sub3(.D(sub_out_3), .Bout(bout_3), .A({resto_2[6:0], A[5]}), .B(B));
    not inv_q5(calc_quociente[5], bout_3); // O bit do quociente é '1' se não houver borrow.
    // Seleciona o resto_3.
    MUX2x1_8B mux3(.S(resto_3), .A({resto_2[6:0], A[5]}), .B(sub_out_3), .Sel(calc_quociente[5]));

    // Estágio 4: Calcula Quociente[4]  
    // Tenta subtrair B do novo dividendo parcial (resto_3 shiftado + A[4]).
    Subtrator8Bits sub4(.D(sub_out_4), .Bout(bout_4), .A({resto_3[6:0], A[4]}), .B(B));
    not inv_q4(calc_quociente[4], bout_4); // O bit do quociente é '1' se não houver borrow.
    // Seleciona o resto_4.
    MUX2x1_8B mux4(.S(resto_4), .A({resto_3[6:0], A[4]}), .B(sub_out_4), .Sel(calc_quociente[4]));

    // Estágio 5: Calcula Quociente[3] 
    // Tenta subtrair B do novo dividendo parcial (resto_4 shiftado + A[3]).
    Subtrator8Bits sub5(.D(sub_out_5), .Bout(bout_5), .A({resto_4[6:0], A[3]}), .B(B));
    not inv_q3(calc_quociente[3], bout_5); // O bit do quociente é '1' se não houver borrow.
    // Seleciona o resto_5.
    MUX2x1_8B mux5(.S(resto_5), .A({resto_4[6:0], A[3]}), .B(sub_out_5), .Sel(calc_quociente[3]));

    // Estágio 6: Calcula Quociente[2] 
    // Tenta subtrair B do novo dividendo parcial (resto_5 shiftado + A[2]).
    Subtrator8Bits sub6(.D(sub_out_6), .Bout(bout_6), .A({resto_5[6:0], A[2]}), .B(B));
    not inv_q2(calc_quociente[2], bout_6); // O bit do quociente é '1' se não houver borrow.
    // Seleciona o resto_6.
    MUX2x1_8B mux6(.S(resto_6), .A({resto_5[6:0], A[2]}), .B(sub_out_6), .Sel(calc_quociente[6]));

    // Estágio 7: Calcula Quociente[1] 
    // Tenta subtrair B do novo dividendo parcial (resto_6 shiftado + A[1]).
    Subtrator8Bits sub7(.D(sub_out_7), .Bout(bout_7), .A({resto_6[6:0], A[1]}), .B(B));
    not inv_q1(calc_quociente[1], bout_7); // O bit do quociente é '1' se não houver borrow.
    // Seleciona o resto_7.
    MUX2x1_8B mux7(.S(resto_7), .A({resto_6[6:0], A[1]}), .B(sub_out_7), .Sel(calc_quociente[1]));
    
    // Estágio 8: Calcula Quociente[0] e o Resto final 
    // Tenta subtrair B do último dividendo parcial (resto_7 shiftado + A[0]).
    Subtrator8Bits sub8(.D(sub_out_8), .Bout(bout_8), .A({resto_7[6:0], A[0]}), .B(B));
    not inv_q0(calc_quociente[0], bout_8); // O bit do quociente é '1' se não houver borrow.
    // Seleciona o Resto final (calc_resto).
    MUX2x1_8B mux8(.S(calc_resto), .A({resto_7[6:0], A[0]}), .B(sub_out_8), .Sel(calc_quociente[0]));

    // Se B for zero (B_Zero=1), a saída do quociente é forçada para 0. Senão, usa o valor calculado.
    MUX2x1_8B final_mux_quociente(
        .S(Quociente), 
        .A(calc_quociente), // A é selecionado se Sel=0 (B não é zero)
        .B(8'b00000000),    // B é selecionado se Sel=1 (B é zero)
        .Sel(B_Zero)
    );

    // Se B for zero (B_Zero=1), a saída do resto também é forçada para 0.
    MUX2x1_8B final_mux_resto(
        .S(Resto), 
        .A(calc_resto),     // A é selecionado se Sel=0 (B não é zero)
        .B(8'b00000000),    // B é selecionado se Sel=1 (B é zero)
        .Sel(B_Zero)
    );

endmodule