module memory(clk,rst,adr,WriteData,MemRead,MemWrite,ReadData);
    input[31:0] adr,WriteData;
    input MemRead,MemWrite,clk,rst;
    output reg[31:0] ReadData;
    reg[31:0] memory[0:16000];

    always@(posedge clk,posedge rst)begin
      if (rst)  $readmemb("test2.txt",memory);//enter file name
      else if (MemWrite) 
        begin
      	  memory[adr] = WriteData;
      	  $writememb("test2.txt",memory);//enter file name
        end
    end
    
    always@(MemRead,adr)begin
	    if (MemRead) begin
          ReadData = memory[adr];
      end
     end
endmodule