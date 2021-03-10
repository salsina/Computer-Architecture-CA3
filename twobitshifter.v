module twobitshifter(inp,out);
    input [31:0] inp;
    output reg[31:0] out;
    always@(inp)
        out = inp * 4;
endmodule 