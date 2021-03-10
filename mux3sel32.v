module mux3sel32(inp1,inp2,inp3,s,out);
input [31:0] inp1,inp2,inp3;
input [1:0] s;
output reg [31:0] out;
always@(inp1,inp2,inp3,s) begin
	if (s == 2'b00)
		out = inp1;
	if (s == 2'b01)
		out = inp2;
	if (s == 2'b10)
		out = inp3;
end
endmodule
