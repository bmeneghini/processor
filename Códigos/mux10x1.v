module mux10x1(R0, R1, R2, R3, R4, R5, R6, R7, G, Din, ctrl, out);
  input [15:0] R0, R1, R2, R3, R4, R5, R6, R7, G, Din;
  input [9:0] ctrl;
  output reg [15:0] out;
  
  always @(R0 or R1 or R2 or R3 or R4 or R5 or R6 or R7 or G or Din or ctrl)
  begin
    case(ctrl)
      10'b0000000001: out = R0;
      10'b0000000010: out = R1;
      10'b0000000100: out = R2;
      10'b0000001000: out = R3;
      10'b0000010000: out = R4;
      10'b0000100000: out = R5;
      10'b0001000000: out = R6;
      10'b0010000000: out = R7;
      10'b0100000000: out = G;
      10'b1000000000: out = Din;
    endcase
  end

endmodule
