module mux32(inp1,inp2,s,out);
input s;
input[31:0] inp1,inp2;
output reg [31:0] out;
always@(inp1,inp2,s)begin
  if(s) out = inp2;
  else out = inp1;
end
endmodule