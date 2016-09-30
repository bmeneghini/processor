module upCount(clear, clock, out);
  input clear, clock;
  output reg [1:0] out;
  
  always @(posedge clock)
    if (clear)
		out <= 2'b0;
    else
		out <= out + 1'b1;
  
endmodule
