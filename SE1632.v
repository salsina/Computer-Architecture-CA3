module SE1632(inp,out);
    input[15:0] inp;
    output reg [31:0] out;
    always@(inp) begin
        if (inp[15] == 0)
            out = {16'b0,inp};
        else
            out = {16'b1111111111111111,inp};
    end
endmodule