`timescale 1ns / 1ps

module ALU(
		input [31:0] A,
		input [31:0] B,
		output [31:0] Result,
		input [3:0] ALUCtrl, //{Ainvert, Bnegate, Op[1:0]}
		output Zero,
		output Overflow
    );
	 
	 wire [31:0] Cout;
	 wire Set;
	 
	
	 
	 ALU1b ALU0to30 [30:0] (.A(A[30:0]), .B(B[30:0]), .Result(Result[30:0]), .Cin({Cout[29:0],ALUCtrl[2]}), .Cout(Cout[30:0]), 
	               .Ainvert({31{ALUCtrl[3]}}), .Binvert({31{ALUCtrl[2]}}), .Op({31{ALUCtrl[1:0]}}), .Less({{30{1'b0}},Set}) );
	  
	  
	  
	 ALU1b_MSB ALU31(.A(A[31]), .B(B[31]), .Result(Result[31]), .Cin(Cout[30]), .Cout(Cout[31]), 
	               .Ainvert(ALUCtrl[3]), .Binvert(ALUCtrl[2]), .Op(ALUCtrl[1:0]), .Less(1'b0), .Set(Set), .Overflow(Overflow));
					 
	 assign Zero = ~(|Result); 
	 
endmodule
