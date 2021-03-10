module controller(clk,rst,zero,selPc,OPC,sel31,regwrite,RegDst,alu_op,MemRead,MemWrite,MemToReg,IorD,IRWrite,ALUSrcA,ALUSrcB,PCSrc,PCsel,Jrsel);
    input [5:0] OPC;
    input clk,rst,zero;
    output reg IorD,IRWrite,ALUSrcA,RegDst,sel31,regwrite,MemRead,MemWrite,MemToReg,selPc,Jrsel;

    output reg [1:0] alu_op,ALUSrcB,PCSrc;
    reg PCWriteCond,PCWrite,not_branch;
    output wire PCsel;
    parameter[3:0] IF = 4'b0000,ID = 4'b0001,RT = 4'b0010,J = 4'b0011,BEQ = 4'b0100,MemoryAccess = 4'b0101,MemRef = 4'b0110,SW = 4'b0111,LW = 4'b1000,LWCompletion = 4'b1001,ADDI = 4'b1010,ANDI = 4'b1011,JAL = 4'b1100,BNE = 4'b1101,JR= 4'b1110;
    reg [3:0] ps,ns;

    always@(posedge clk,posedge rst)begin
      if(rst) ps <= 4'b0000;
      else ps<=ns;
    end

    always@(ps,OPC)begin
    case(ps)
        IF:ns = ID;
        ID:begin
            if(OPC == 6'b000010) //j 
                ns = J;
            else if(OPC == 6'b000100)//beq
                ns = BEQ;
            else if(OPC == 6'b000101)//bne
                ns = BNE;
            else if(OPC == 6'b000000) //Rtype
                ns = RT;
            else if(OPC == 6'b101011 || OPC == 6'b100011 || OPC == 6'b001000 || OPC == 6'b001100)//sw or lw or addi od andi
                ns = MemRef;
            else if(OPC == 6'b000011)//jal
                ns = JAL;
            else if (OPC == 6'b111111)//Jr
                ns = RT;
            end
        J:ns = IF;
        BEQ:ns = IF;
        RT:begin
            if (OPC == 6'b000000)
                ns = MemoryAccess;
            else if(OPC == 6'b111111)
                ns = JR;
        end
        MemoryAccess:ns = IF;
        MemRef:begin
            if (OPC == 6'b101011)
                ns = SW;
            else if(OPC == 6'b100011)
                ns = LW;
            else if(OPC == 6'b001000)
                ns = ADDI;
            else if(OPC == 6'b001100)
                ns = ANDI;
        end
        SW:ns = IF;
        LW:ns = LWCompletion;
        LWCompletion:ns = IF;
        ADDI:ns = IF;
        ANDI:ns = IF;
        JAL:ns = IF;
        BNE:ns = IF;
        JR:ns = IF;
    endcase
    end

    always@(ps)begin
    {IRWrite,PCWrite,PCWriteCond,IorD,ALUSrcA,sel31,regwrite,RegDst,MemRead,MemWrite,MemToReg,not_branch,selPc,Jrsel} = 14'b0;
    ALUSrcB = 2'b11; PCSrc = 2'b00; alu_op = 2'b00;
    case(ps)
        IF:begin
            {MemRead,IRWrite,PCWrite} = 3'b111;
            ALUSrcB = 2'b01;
        end

        ID: ;

        J:begin
            PCWrite = 1'b1;
            PCSrc = 2'b01;
        end

        BEQ:begin
            {ALUSrcA,PCWriteCond} = 2'b11;
            ALUSrcB = 2'b00;
            alu_op = 2'b01;
            PCSrc = 2'b10;
        end

        BNE:begin
            {ALUSrcA,not_branch} = 2'b11;
            ALUSrcB = 2'b00;
            alu_op = 2'b01;
            PCSrc = 2'b10;
        end

        RT:begin
            ALUSrcA = 1'b1;
            ALUSrcB = 2'b00;
            alu_op = 2'b10;
        end

        MemoryAccess: {RegDst,regwrite} = 2'b11;
        
        MemRef:begin
            ALUSrcA = 1'b1;
            ALUSrcB = 2'b10;
        end

        SW: {IorD,MemWrite} = 2'b11;
        
        LW:{IorD,MemRead} = 2'b11;

        LWCompletion: {MemToReg,regwrite} = 2'b11;

        ADDI:regwrite = 1'b1;

        ANDI:begin
            regwrite = 1'b1;
            alu_op = 2'b11;
        end

        JAL:begin
            {selPc,sel31,regwrite,PCWrite} = 4'b1111;
            PCSrc = 2'b01;
        end

        JR:begin
            PCWrite = 1'b1;
            Jrsel = 1'b1;
        end

    endcase
    end
    assign PCsel = PCWrite | (PCWriteCond & zero ) | (not_branch & (~zero)) ;

endmodule