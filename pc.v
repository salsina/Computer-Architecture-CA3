module pc(inp,PCsel,clk,rst,out);
    input clk,rst,PCsel;
    input [31:0] inp;
    output reg [31:0] out;
    always@(posedge clk,posedge rst)begin
        if(rst) out <= {32'b0};
        else if(PCsel) out <= inp;
    end
endmodule