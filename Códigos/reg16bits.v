module reg16bits(in, enable, clock, out);
  input [15:0] in;
  input enable, clock;
  output reg [15:0] out;
  
  always @(posedge clock)
    if (enable)
      out <= in;
      
endmodule
