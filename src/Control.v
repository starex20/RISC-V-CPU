`timescale 1ns / 1ps

module Control(
	 input [6:0] OpCode,
	 output JAL,
	 output JALR,
	 output Branch,
	 output MemRead,
	 output MemToReg,
	 output reg [1:0] ALUOp,
	 output MemWrite,
	 output ALUSrc,
	 output RegWrite
    );
	
	assign JAL     = (OpCode == 7'b1101111) ? 1 : 0;	
	assign JALR    = (OpCode == 7'b1100111) ? 1 : 0;
	assign Branch  = (OpCode == 7'b1100011) ? 1 : 0;	
	assign MemRead = (OpCode == 7'b0000011) ? 1 : 0;
	assign MemToReg = MemRead;
	assign MemWrite = (OpCode == 7'b0100011) ? 1 : 0;
	assign ALUSrc = (OpCode == 7'b0000011 ||
	                 OpCode == 7'b0010011 || 
	                 OpCode == 7'b0100011 ||
	                 OpCode == 7'b1101111
	                );
	assign RegWrite = (OpCode == 7'b0110011 ||
	                   OpCode == 7'b0101111 ||
	                   OpCode == 7'b0000011 ||
	                   OpCode == 7'b0010011 ||
	                   OpCode == 7'b1100111 ||
	                   OpCode == 7'b1101111
	                  );
	                   
	
	always @(*) begin
	   case(OpCode)
	       7'b0000011 : ALUOp = 2'b00; // load
	       7'b0100011 : ALUOp = 2'b00; // store
	       7'b1100011 : ALUOp = 2'b01; // branch
	       default : ALUOp = 2'b10; // R-type
	   endcase
	end
	
	

endmodule
