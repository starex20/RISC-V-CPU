`timescale 1ns / 1ps

module ALUControl(
		output reg [3:0] ALUCtrl,
		input [1:0] ALUOp, 
		input [6:0] funct7,
		input [2:0] funct3,
		input [6:0] OpCode
    );


    always @(*) begin
        case(ALUOp)
            2'b00: ALUCtrl = 4'b0010; // lw, sw
            2'b01: ALUCtrl = 4'b0110; // beq
            2'b10: begin
                if(OpCode == 7'b0110011) begin // R-type 
                    case({funct7, funct3})
                        {7'b0000000, 3'b000}: ALUCtrl = 4'b0010; // ADD 연산
                        {7'b0100000, 3'b000}: ALUCtrl = 4'b0110; // SUB 연산
                        {7'b0000000, 3'b111}: ALUCtrl = 4'b0000; // AND 연산
                        {7'b0000000, 3'b110}: ALUCtrl = 4'b0001; // OR 연산
                        {7'b0000000, 3'b010}: ALUCtrl = 4'b0111; // slt 연산
                        default: ALUCtrl = 4'bxxxx; 
                    endcase
                end
                else begin // I-type , jalr 등
                    case(funct3)
                        3'b000: ALUCtrl = 4'b0010; // ADD 연산
                        3'b111: ALUCtrl = 4'b0000; // AND 연산
                        3'b110: ALUCtrl = 4'b0001; // OR 연산
                        default: ALUCtrl = 4'bxxxx; 
                    endcase
                end
            end
            default: ALUCtrl = 4'bxxxx; 
        endcase
    end

endmodule
