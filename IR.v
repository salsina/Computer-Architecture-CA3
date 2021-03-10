module IR(clk,IRWrite,inp,out);
	input clk,IRWrite;
	input [31:0] inp;
	output reg [31:0] out;
	always@(posedge clk)
		if (IRWrite) out <= inp;
endmodule
