module RegisterFile(clk,rst,regwrite,readreg1,readreg2,writereg,writedata,readdata1,readdata2);
input clk,rst,regwrite;
input[4:0] readreg1,readreg2,writereg;
input [31:0] writedata;
output reg[31:0] readdata1,readdata2;
reg[31:0] registers[0:31];
integer i;
always@(posedge clk)begin
  registers[0] <=32'b0;
    if(regwrite)begin
        registers[writereg] <= writedata;
        for (i = 0 ;i < 32; i = i + 1)
            $display("reg%d%d",i,registers[i]);
        $display("****************************************************");
    end
end
always@(readreg1,readreg2)begin
    registers[0] =32'b0;
    readdata1 = registers[readreg1];
    readdata2 = registers[readreg2];
end
endmodule