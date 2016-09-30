module board(SW, KEY, LEDR, LEDG, HEX6, HEX4, HEX3, HEX2, HEX1, HEX0);
input [17:0] SW;
input [3:0] KEY;

output [17:0] LEDR;
output [7:0] LEDG;
output [6:0] HEX6, HEX4, HEX3, HEX2, HEX1, HEX0;

wire [15:0] data, bus;

//instrucao
assign LEDR[2:0] = data[15:13];
display d0(data[12:10], HEX6);
display d1(data[9:7], HEX4);

topLevel placa(KEY[2], KEY[1], (~KEY[0]), SW[17], bus, data, LEDR[17], LEDR[5:4]);

//saida
display d2(bus[15:12], HEX3);
display d3(bus[11:8], HEX2);
display d4(bus[7:4], HEX1);
display d5(bus[3:0], HEX0);

assign LEDG[0] = SW[17];

endmodule
