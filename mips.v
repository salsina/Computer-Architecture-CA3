module mips(clk,rst,Jrsel,sel31,selPc,ALU_operation,PCsel,ALUSrcA,ALUSrcB,RegDst,MemToReg,IRWrite,MemRead,MemWrite,IorD,RegWrite,PCSrc,zero,OPC,Func);
	input clk,rst,sel31,selPc,PCsel,RegDst,MemToReg,IRWrite,ALUSrcA,MemRead,MemWrite,IorD,RegWrite,Jrsel;
	input [1:0] PCSrc,ALUSrcB;
	output wire zero;
	output reg[5:0] OPC,Func;
	input [2:0]ALU_operation;
	wire[31:0] muxeightout,muxfourOut,pcinput,pcoutput,aluoutWire,adr,WriteDataRF,ReadData,IRout,readdata1,readdata2,MDRout,Aout,Bout,SEout,SHLout,muxsixout,muxsevenout,ALUresult;
	wire [27:0] SHL26out;
	wire[4:0] writereg,muxTwoOut;
	pc PC(pcinput,PCsel,clk,rst,pcoutput);
	mux32 MUXone({2'b00,pcoutput[31:2]},aluoutWire,IorD,adr);
	memory Memory(clk,rst,adr,Bout,MemRead,MemWrite,ReadData);
	IR ir(clk,IRWrite,ReadData,IRout);
	always@(IRout) begin
		OPC = IRout[31:26];
		Func = IRout[5:0];
	end
	mux5bit MUXtwo(IRout[20:16],IRout[15:11],RegDst,muxTwoOut);
	mux5bit MUXthree(muxTwoOut,5'b11111,sel31,writereg);
	mux32 MUXfour(aluoutWire,MDRout,MemToReg,muxfourOut);
	mux32 MUXfive(muxfourOut,pcoutput,selPc,WriteDataRF);
	reg32 MDR(clk,ReadData,MDRout);
	RegisterFile RF(clk,rst,RegWrite,IRout[25:21],IRout[20:16],writereg,WriteDataRF,readdata1,readdata2);
	reg32 A(clk,readdata1,Aout);
	reg32 B(clk,readdata2,Bout);
	SE1632 SE(IRout[15:0],SEout);
	twobitshifter SHL2(SEout,SHLout);
	mux32 MUXsix(pcoutput,Aout,ALUSrcA,muxsixout);
	mux4sel32 MUXseven(Bout,4,SEout,SHLout,ALUSrcB,muxsevenout);
	ALU alu(muxsixout,muxsevenout,ALU_operation,zero,ALUresult);
	reg32 ALUOut(clk,ALUresult,aluoutWire);
	SHL26bit shl26(IRout[25:0],SHL26out);
	mux3sel32 MUXeight(ALUresult,{pcoutput[31:28],SHL26out},aluoutWire,PCSrc,muxeightout);
	mux32 MUXnine(muxeightout,Aout,Jrsel,pcinput);
endmodule