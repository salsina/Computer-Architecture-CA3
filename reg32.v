module reg32(clk,inp,out);
input clk;
input [31:0] inp;
output reg [31:0] out;
always@(posedge clk)
	out <= inp;
endmodule

