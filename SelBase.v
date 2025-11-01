// Módulo que seleciona a base de exibição (Decimal, Hex, Octal) para um resultado binário.
// Ele calcula as três conversões em paralelo e usa um MUX 4x1 para
// rotear os sinais de 7 segmentos corretos para os 3 displays (HEX0, HEX1, HEX2).
module SelBase (
    input  [1:0] SW,         // Seletor de base (SW[1:0]).
    input  [7:0] R,          // Resultado binário de 8 bits a ser exibido.
    output [6:0] HEX0,       // Display da direita.
    output [6:0] HEX1,       // Display do meio.
    output [6:0] HEX2        // Display da esquerda.
);

    
    // Fios para a conversão Decimal 
    wire [3:0] bcd_c, bcd_d, bcd_u; 
    wire [6:0] seg7_dec_c, seg7_dec_d, seg7_dec_u; 
    
    // Fios para a conversão Hexadecimal 
    wire [6:0] seg7_hex_hi, seg7_hex_lo; 
    
    // Fios para a conversão Octal
    wire [6:0] seg7_oct_2, seg7_oct_1, seg7_oct_0;

    // Constante para desligar um display
    wire [6:0] display_off = 7'b1111111; 
	 
    // Converte o binário de 8 bits (R) em 3 dígitos BCD.
    BinarioParaBCD bcd_conv (
        .binario(R), 
        .bcd_centenas(bcd_c), 
        .bcd_dezenas(bcd_d), 
        .bcd_unidades(bcd_u)
    );
    // Decodifica os 3 dígitos BCD para 7 segmentos.
    Decodificador7Seg dec_u (.seg_a(seg7_dec_u[0]), .seg_b(seg7_dec_u[1]), .seg_c(seg7_dec_u[2]), .seg_d(seg7_dec_u[3]), .seg_e(seg7_dec_u[4]), .seg_f(seg7_dec_u[5]), .seg_g(seg7_dec_u[6]), .entrada_bcd(bcd_u));
    Decodificador7Seg dec_d (.seg_a(seg7_dec_d[0]), .seg_b(seg7_dec_d[1]), .seg_c(seg7_dec_d[2]), .seg_d(seg7_dec_d[3]), .seg_e(seg7_dec_d[4]), .seg_f(seg7_dec_d[5]), .seg_g(seg7_dec_d[6]), .entrada_bcd(bcd_d));
    Decodificador7Seg dec_c (.seg_a(seg7_dec_c[0]), .seg_b(seg7_dec_c[1]), .seg_c(seg7_dec_c[2]), .seg_d(seg7_dec_c[3]), .seg_e(seg7_dec_c[4]), .seg_f(seg7_dec_c[5]), .seg_g(seg7_dec_c[6]), .entrada_bcd(bcd_c));

    // Decodifica R[3:0] para HEX0.
    DecodificadorHexa dec_hex_lo (.seg_a(seg7_hex_lo[0]), .seg_b(seg7_hex_lo[1]), .seg_c(seg7_hex_lo[2]), .seg_d(seg7_hex_lo[3]), .seg_e(seg7_hex_lo[4]), .seg_f(seg7_hex_lo[5]), .seg_g(seg7_hex_lo[6]), .R(R[3:0]));
    // Decodifica R[7:4] para HEX1.
    DecodificadorHexa dec_hex_hi (.seg_a(seg7_hex_hi[0]), .seg_b(seg7_hex_hi[1]), .seg_c(seg7_hex_hi[2]), .seg_d(seg7_hex_hi[3]), .seg_e(seg7_hex_hi[4]), .seg_f(seg7_hex_hi[5]), .seg_g(seg7_hex_hi[6]), .R(R[7:4]));
    
    // Decodifica R[2:0] para HEX0.
    DecodificadorOcta dec_oct_0 (.seg_a(seg7_oct_0[0]), .seg_b(seg7_oct_0[1]), .seg_c(seg7_oct_0[2]), .seg_d(seg7_oct_0[3]), .seg_e(seg7_oct_0[4]), .seg_f(seg7_oct_0[5]), .seg_g(seg7_oct_0[6]), .R(R[2:0]));
    // Decodifica R[5:3] para HEX1.
    DecodificadorOcta dec_oct_1 (.seg_a(seg7_oct_1[0]), .seg_b(seg7_oct_1[1]), .seg_c(seg7_oct_1[2]), .seg_d(seg7_oct_1[3]), .seg_e(seg7_oct_1[4]), .seg_f(seg7_oct_1[5]), .seg_g(seg7_oct_1[6]), .R(R[5:3]));
    // Decodifica R[7:6] para HEX2 (Preenche com 0 MSB para o decodificador de 3 bits).
    DecodificadorOcta dec_oct_2 (.seg_a(seg7_oct_2[0]), .seg_b(seg7_oct_2[1]), .seg_c(seg7_oct_2[2]), .seg_d(seg7_oct_2[3]), .seg_e(seg7_oct_2[4]), .seg_f(seg7_oct_2[5]), .seg_g(seg7_oct_2[6]), .R({1'b0, R[7:6]}));
    


    // Display da Direita (HEX0)
    MUX4x1_7seg mux_hex0 (
        .S(HEX0), 
        .D0(seg7_dec_u),    // Sel=00: Unidade Decimal
        .D1(seg7_hex_lo),   // Sel=01: Hex0
        .D2(seg7_oct_0),    // Sel=10: Octal0
        .D3(display_off),   // Sel=11: Desligado
        .Sel(SW[1:0])
    );

    // Display do Meio (HEX1)
    MUX4x1_7seg mux_hex1 (
        .S(HEX1), 
        .D0(seg7_dec_d),    // Sel=00: Dezena Decimal
        .D1(seg7_hex_hi),   // Sel=01: Hex1
        .D2(seg7_oct_1),    // Sel=10: Octal1
        .D3(display_off),   // Sel=11: Desligado
        .Sel(SW[1:0])
    );

    // Display da Esquerda (HEX2)
    MUX4x1_7seg mux_hex2 (
        .S(HEX2), 
        .D0(seg7_dec_c),    // Sel=00: Centena Decimal
        .D1(display_off),   // Sel=01: Desligado
        .D2(seg7_oct_2),    // Sel=10: Octal2
        .D3(display_off),   // Sel=11: Desligado
        .Sel(SW[1:0])
    );

endmodule