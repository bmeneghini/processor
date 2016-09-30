module processor(Din, reset, clock, run, done, step, busWire);

  input [15:0] Din;  //instrucao
  input clock, reset, run;
  
  output reg done;
  output [15:0] busWire;  
  output [1:0] step;
  
  reg Gctrl, DINout, Ain, Gin, IRin;
  reg [2:0] ulaCtrl;  
  reg [7:0] Rin, Rout;  
  
  wire [2:0] opcode;
  wire [7:0] Xreg, Yreg;
  wire [8:0] IR;
  wire [9:0] ctrl;
  wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7, ulaIn, ulaOut, Gout;  
  
  wire clear = done || reset; // reseta contador 
  upCount contador (clear, clock, step);
  
  assign opcode = IR[8:6];  // define o opcode     
  dec3x8 dec0(IR[5:3], Xreg); // valor do reg X
  dec3x8 dec1(IR[2:0], Yreg); // valor do reg Y  

  
  always @(step or opcode or Xreg or Yreg)
  begin
	
	done = 1'b0; //operacao terminou
   Rin[7:0] = 8'b00000000; // enable regs R
	Ain = 1'b0; // enable reg A, guarda um operando em A
	Gin = 1'b0; // enable reg G, guarda resultado da ula
   IRin = 1'b0; // enable reg IR, guarda Din em IR
	 
   Rout[7:0] = 8'b00000000; // define enable do mux	
   DINout = 1'b0; // enable mvi
   Gctrl = 1'b0; //define enable para calculos na ula   
	ulaCtrl = 3'b000;
    
    case(step)
      2'b00: // passo 0 - busca de instrucao
      begin
        IRin = 1'b1 & run;
      end
		
      2'b01: // passo 1 - leitura de operandos
      begin
        case(opcode)
          3'b000: //mv
          begin
            Rin = Xreg;
            Rout = Yreg;
            done = 1'b1;
          end
          3'b001: //mvi
          begin
            Rin = Xreg;
            DINout = 1'b1;
            done = 1'b1;
          end
          3'b010: //add
          begin
            Ain = 1'b1;
            Rout = Xreg;
          end
          3'b011: //sub
          begin
            Ain = 1'b1;
            Rout = Xreg;
          end
          3'b100: //or
          begin
            Ain = 1'b1;
            Rout = Xreg;
          end
          3'b101: //slt
          begin
            Ain = 1'b1;
            Rout = Xreg;
          end
          3'b110: //shift left
          begin
            Ain = 1'b1;
            Rout = Xreg;
          end
          3'b111: //shift right
          begin
            Ain = 1'b1;
            Rout = Xreg;
          end
        endcase
      end
		
      2'b10: // passo 2 - operacoes da ula
      begin
        case(opcode)
          3'b010: //add
          begin
            Rout = Yreg;
			ulaCtrl = 3'b000;
            Gin = 1'b1;
          end
          3'b011: //sub
          begin
            Rout = Yreg;
            ulaCtrl = 3'b001;
            Gin = 1'b1;
          end
          3'b100: //or
          begin
            Rout = Yreg;
            ulaCtrl = 3'b010;
            Gin = 1'b1;
          end
          3'b101: //slt
          begin
            Rout = Yreg;
            ulaCtrl = 3'b101;
            Gin = 1'b1;
          end
          3'b110: //shift left
          begin
            Rout = Yreg;
            ulaCtrl = 3'b110;
            Gin = 1'b1;
          end
          3'b111: //shift right
          begin
            Rout = Yreg;
            ulaCtrl = 3'b111;
            Gin = 1'b1;
          end
        endcase
      end
		
      2'b11: // passo 3 - escrita do resultado
      begin
        case(opcode)
          3'b010: //add
          begin
            Gctrl = 1'b1;
            Rin = Xreg;
            done = 1'b1;
          end
          3'b011: //sub
          begin
            Gctrl = 1'b1;
            Rin = Xreg;
            done = 1'b1;
          end
          3'b100: //or
          begin
            Gctrl = 1'b1;
            Rin = Xreg;
            done = 1'b1;
          end
          3'b101: //slt
          begin
            Gctrl = 1'b1;
            Rin = Xreg;
            done = 1'b1;
          end
          3'b110: //shift left
          begin
            Gctrl = 1'b1;
            Rin = Xreg;
            done = 1'b1;
          end
          3'b111: //shift right
          begin
            Gctrl = 1'b1;
            Rin = Xreg;
            done = 1'b1;
          end
        endcase
      end
    endcase
  end
  
  //registradores
  reg16bits reg0(busWire, Rin[0], clock, R0);
  reg16bits reg1(busWire, Rin[1], clock, R1);
  reg16bits reg2(busWire, Rin[2], clock, R2);
  reg16bits reg3(busWire, Rin[3], clock, R3);
  reg16bits reg4(busWire, Rin[4], clock, R4);
  reg16bits reg5(busWire, Rin[5], clock, R5);
  reg16bits reg6(busWire, Rin[6], clock, R6);
  reg16bits reg7(busWire, Rin[7], clock, R7);
  
  reg16bits regA(busWire, Ain, clock, ulaIn); // guarda entrada da ula  
  reg16bits regG(ulaOut, Gin, clock, Gout); // guarda resultado da ula
  
  reg9bits regIR(Din[15:7], IRin, clock, IR); // guarda a instrucao     
  
  ula ula0(ulaIn, busWire, ulaCtrl, ulaOut); // ULA
  
  mux10x1 mux(R0, R1, R2, R3, R4, R5, R6, R7, Gout, Din, ctrl, busWire); // define o bus
  assign ctrl = {DINout,Gctrl,Rout};
  
endmodule
