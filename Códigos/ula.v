module ula(in1, in2, ctrl, out);
  input [15:0] in1, in2;
  input [2:0] ctrl;
  output reg [15:0] out;
  reg overflow;
    
  always @(in1 or in2 or ctrl)
  begin
    case(ctrl)
		3'b000: begin //add
		  {overflow , out } = in1 + in2;
		  end
		3'b001: begin //sub
			out = in1 - in2;
		  end
        3'b010: begin //or
            out = in1 | in2;
          end
        3'b011: begin //slt
            out = in1 < in2;
          end
        3'b100: begin //sll
            out = in1 << in2;
          end
        3'b101: begin //srl
            out = in1 >> in2;
          end
    endcase
  end
  
endmodule
