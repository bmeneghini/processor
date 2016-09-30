module counter(clear, clock, out);
  input clear, clock;
  output reg [4:0] out;

  always @(posedge clock)
    if (clear)
		out <= 5'b00000;
    else
      out <= out + 5'b00001;

endmodule
