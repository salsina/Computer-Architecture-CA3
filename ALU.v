module ALU(A,B,ALUsrc,zero,ALUresult);
    input [31:0] A,B;
    input [2:0] ALUsrc;
    output reg zero;
    output reg[31:0] ALUresult;
    always@(A,B,ALUsrc) begin
        if (ALUsrc == 3'b0)
            ALUresult = A & B;
        else if (ALUsrc == 3'b001)
            ALUresult = A | B;
        else if (ALUsrc == 3'b010)
            ALUresult = A + B;
        else if (ALUsrc == 3'b110)
            ALUresult = A - B;
        else if (ALUsrc ==3'b111)
            if (A<B) ALUresult = {31'b0,1'b1};
            else ALUresult = 32'b0;
        if (ALUresult == 32'b0)
            zero = 1'b1;
        else
            zero = 1'b0;
    end
endmodule