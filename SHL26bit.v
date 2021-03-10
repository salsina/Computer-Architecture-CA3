
module SHL26bit(inp,out);
    input [25:0] inp;
    output reg[27:0] out;
    always@(inp)
        out = {inp ,2'b00};
endmodule 