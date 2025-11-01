// Módulo que decodifica o seletor de 3 bits da ULA para exibir um símbolo de operação em um display de 7 segmentos.
module DecodificadorOperacao (
    // Entradas do seletor.
    input  SW9,     
    input  KEY0,    
    input  KEY1,    

    output [6:0] HEX // Barramento de 7 bits para acionar o display (a-g).
);
    // Gera as versões invertidas (A', B', C') dos sinais de entrada.
    wire nSW9, nKEY0, nKEY1;
    not inv_sw9(nSW9, SW9);   
    not inv_key0(nKEY0, KEY0); 
    not inv_key1(nKEY1, KEY1); 

    // Lógica para o segmento 'a' (HEX[0]).
    // Expressão: C
    or seg_a(HEX[0], KEY0, 1'b0);

    // Lógica para o segmento 'b' (HEX[1]).
    // Expressão: A'B' + AB + B'C
    wire b_t1, b_t2, b_t3;
    and b_term1(b_t1, nSW9, nKEY1);  // A'B'
    and b_term2(b_t2, SW9, KEY1);    // AB
    and b_term3(b_t3, nKEY1, KEY0);  // B'C
    or  seg_b(HEX[1], b_t1, b_t2, b_t3);

    // Lógica para o segmento 'c' (HEX[2]).
    // Expressão: A'B'C + A'BC'
    wire c_t1, c_t2;
    and c_term1(c_t1, nSW9, nKEY1, KEY0);  // A'B'C
    and c_term2(c_t2, nSW9, KEY1, nKEY0);  // A'BC'
    or seg_c(HEX[2], c_t1, c_t2);

    // Lógica para o segmento 'd' (HEX[3]).
    // Expressão: A'B'C + A'BC' + AB'C' + ABC
    wire d_t1, d_t2, d_t3, d_t4;
    and d_term1(d_t1, nSW9, nKEY1, KEY0);   // A'B'C
    and d_term2(d_t2, nSW9, KEY1, nKEY0);   // A'BC'
    and d_term3(d_t3, SW9, nKEY1, nKEY0);   // AB'C'
    and d_term4(d_t4, SW9, KEY1, KEY0);     // ABC
    or  seg_d(HEX[3], d_t1, d_t2, d_t3, d_t4);

    // Lógica para o segmento 'e' (HEX[4]).
    // Expressão: A'B'
    and seg_e(HEX[4], nSW9, nKEY1);

    // Lógica para o segmento 'f' (HEX[5]).
    // Expressão: AB + C
    wire f_t1;
    and f_term1(f_t1, SW9, KEY1);  // AB
    or  seg_f(HEX[5], KEY0, f_t1); // C + (AB)
    
    // Lógica para o segmento 'g' (HEX[6]).
    // O segmento 'g' é forçado a '0' (ligado).
    and seg_g(HEX[6], 1'b0, 1'b0);

endmodule
