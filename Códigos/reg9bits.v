module reg9bits(in, enable, clock, out);
  input [8:0] in;
  input enable, clock;
  output reg [8:0] out;
  
  always @(posedge clock)
    if (enable)
      out <= in;
      
endmodule
