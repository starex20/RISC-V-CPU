`timescale 1ns / 1ps

module ALU1b_MSB(
		input A,
		input B,
		output reg Result,
		input Cin,		
		output Cout,
		input Ainvert,
		input Binvert,
		input [1:0] Op,
		input Less,
		output Set,
		output Overflow
    );
	 
	wire AFinal= Ainvert ? ~A : A;
	wire BFinal= Binvert ? ~B : B;
	
	wire ANDResult = AFinal & BFinal;
	wire ORResult = AFinal | BFinal;
	wire ADDResult;
	
	
	full_adder Adder(
	.a(AFinal),
	.b(BFinal),
	.cin(Cin),
	.sum(ADDResult),
	.cout(Cout)
	);
	 
	 // output
	 always @(*) begin
	   // 4 to 1 mux
        case (Op)
            2'b00: Result = ANDResult; 
            2'b01: Result = ORResult; 
            2'b10: Result = ADDResult; 
            2'b11: Result = Less; 
            //default: Result = 1'b0; 
        endcase
     end
	
	// MSB ALU의 추가된 output
    assign Set = ADDResult;
    assign Overflow = Cin ^ Cout;

endmodule