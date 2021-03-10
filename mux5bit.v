module mux5bit(inp1,inp2,s,out);
input s;
input[4:0] inp1,inp2;
output reg [4:0] out;
always@(inp1,inp2,s) 
if (s) out = inp2;
else out = inp1;
endmodule