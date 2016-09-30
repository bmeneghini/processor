module topLevel(pClock, mClock, reset, run, bus, data, done, step);
  input pClock, mClock, reset, run;  
  output [15:0] bus, data;
  output [1:0] step;
  output done;  
   
  wire [4:0] address;

  counter contador(reset, mClock, address);
  memoryROM rom0(address, mClock, data);
  processor proc(data, reset, pClock, run, done, step, bus);  
  
endmodule
