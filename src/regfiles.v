`timescale 1ns / 1ps

module RegFiles(
		input CLK,
		input RST,
		input RegWrite,
		input [4:0] ReadNum1,
		input [4:0] ReadNum2,
		output [31:0] ReadData1,
		output [31:0] ReadData2,
		input [4:0] WriteNum,
		input [31:0] WriteData
    );

	reg [31:0] Registers [31:0];
	
	// register
	always @(posedge CLK, negedge RST) begin
	   if(!RST) begin
	       Registers[0] <= 0;
	   end
	   else begin
	       if(RegWrite && WriteNum) begin
	           Registers[WriteNum] <= WriteData;
	       end
	   end
	end


    // output
    assign ReadData1 = RegWrite && (ReadNum1 == WriteNum) ? WriteData : Registers[ReadNum1];
    assign ReadData2 = RegWrite && (ReadNum2 == WriteNum) ? WriteData : Registers[ReadNum2];
    
endmodule
