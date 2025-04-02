`timescale 1ns / 1ps

module RISCV(
		input CLK,
		input RST,
		
		output [31:0] InstMemRAddr,
		input [31:0] InstMemRData,
		
		output [31:0] DataMemAddr,
		output DataMemRead,
		output DataMemWrite,		
		input [31:0] DataMemRData,
		output [31:0] DataMemWData
   );
	 
	//PC & Instruction
	reg [31:0] PC;
	wire [31:0] PC_ID, PC_EX;	
	wire [31:0] PCplus4, PCplus4_ID, PCplus4_EX, PCplus4_MEM, PCplus4_WB;
	wire [31:0] Instruction, Inst_ID;
	 
	//Control signals	 
	wire JAL, JAL_EX, JAL_MEM, JAL_WB;
	wire JALR, JALR_EX, JALR_MEM, JALR_WB;
	wire Branch, Branch_EX, Branch_MEM;
	wire MemRead, MemRead_EX, MemRead_MEM;
	wire MemToReg, MemToReg_EX, MemToReg_MEM, MemToReg_WB;
	wire [1:0] ALUOp, ALUOp_EX;
	wire MemWrite, MemWrite_EX, MemWrite_MEM;
	wire ALUSrc, ALUSrc_EX;
	wire RegWrite, RegWrite_EX, RegWrite_MEM, RegWrite_WB;
	wire [3:0] ALUCtrl;	
	wire load_stall, branch_stall;
	wire en_IF_ID;  
	wire Mispredict;
	wire taken, taken_ID;
	
	//Operands
	wire [4:0] RS1Num, RS1Num_EX;
	wire [4:0] RS2Num, RS2Num_EX;
	wire [4:0] RDNum, RDNum_EX, RDNum_MEM, RDNum_WB;
	wire [31:0] RS1Data, RS1Data_EX;
	wire [31:0] RS2Data, RS2Data_EX, RS2Data_MEM;
	wire [31:0] RDData_WB;
	
	//ALU status registers
	wire Zero, Zero_MEM;
	wire Overflow;
	
	// comparator & branch signal in ID-stage
	wire Jump = Branch && (RS1Data_final == RS2Data_final); 
	
    	// flush signal
    	wire IF_Flush, ID_Flush, EX_Flush, MEM_Flush; 
    	assign IF_Flush = (!branch_stall && Jump) || JAL || JALR_MEM || Mispredict;
    	assign ID_Flush = JALR_MEM || load_stall || branch_stall;
    	assign EX_Flush = JALR_MEM;
   
   	// pipeline register enable signal
    	assign en_IF_ID = ~(load_stall | branch_stall); 
    
	//ALU data
	wire [31:0] ImmSignExt, ImmSignExt_EX;
	wire [31:0] ALUB;
	wire [31:0] ALUResult, ALUResult_MEM, ALUResult_WB;	 
		    
    	wire [31:0] DataMemWData_MEM;
    	wire [31:0] DataMemRData_WB;
   
    	wire [31:0] PC_jump_ID = PC_ID +ImmSignExt;
	//wire [31:0] PC_jump_EX = PC_EX + ImmSignExt_EX;
	//wire [31:0] PC_jump_MEM;
	wire [31:0] Target; 
	
	//PC
	assign PCplus4 = PC + 4;
	
	always @(posedge CLK or negedge RST) begin
		if( RST == 0 ) begin
			PC <= 0;
		end
		
		else begin
			if( JALR_MEM ) begin 
				PC <= ALUResult_MEM;
		    	end
		    	else if( Mispredict ) begin
		        	PC <= PCplus4_ID;
		    	end
		    	else if( load_stall || branch_stall ) begin // load/branch stall (ID-stage)
		        	PC <= PC;
	            	end
		    	else if( JAL || Jump ) begin 
		        	PC <= PC_jump_ID; 
		    	end
		    	else if( taken && Instruction[6:0] == 7'b1100011 ) begin // IF stage
		        	PC <= Target;
		    	end
		    	else begin
				PC <= PCplus4;
		    	end
		end
	end
	
	wire [1:0] current_state, current_state_ID;
	reg [1:0]  next_state;
	assign taken = current_state[1];
	assign taken_ID = current_state_ID[1];
	assign Mispredict = Branch && taken_ID && !Jump; 
	
	// Branch Prediction Buffer
	BPB bpb (.CLK(CLK), .RST(RST), .Branch(Branch), .Jump(Jump), .WriteNum(PC_ID[5:2]), .ReadNum(PC[5:2]), .current_state_ID(current_state_ID), .current_state(current_state) );
	
	// Branch Target Buffer
	BTB btb (.CLK(CLK), .Jump(Jump), .ReadNum(PC[5:2]), .WriteNum(PC_ID[5:2]), .PC_jump(PC_jump_ID), .Target(Target) ); 
	
	assign InstMemRAddr = PC;
	assign Instruction = InstMemRData;
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// IF/ID register
	pipeline_register #(.N(98)) IF_ID (.CLK(CLK), .RST(RST), .en(en_IF_ID), .Flush(IF_Flush),
	           .D({PC, PCplus4, Instruction, current_state}), .Q({PC_ID, PCplus4_ID, Inst_ID, current_state_ID})); 
	
	Control u_Control ( .OpCode(Inst_ID[6:0]), .JAL(JAL), .JALR(JALR), .Branch(Branch), .MemRead(MemRead),
	           .MemToReg(MemToReg), .ALUOp(ALUOp), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite) );

	assign RS1Num = Inst_ID[19:15];
	assign RS2Num = Inst_ID[24:20];
	assign RDNum = Inst_ID[11:7];
	assign RDData_WB = (JAL_WB==1 || JALR_WB==1) ? PCplus4_WB : ((MemToReg_WB == 1) ? DataMemRData_WB : ALUResult_WB); //*
	
	RegFiles u_RegFiles( .CLK(CLK), .RST(RST), .RegWrite(RegWrite_WB), .ReadNum1(RS1Num), .ReadNum2(RS2Num),
	              .ReadData1(RS1Data), .ReadData2(RS2Data), .WriteNum(RDNum_WB), .WriteData(RDData_WB) );
	 
	ImmGen u_ImmGen( .Instr(Inst_ID), .ImmSignExt(ImmSignExt) );
	
	// load stall detection unit	
	assign load_stall = MemRead_EX && (RDNum_EX == RS1Num || RDNum_EX == RS2Num) ? 1 : 0;
	
    	// ID-stage forwarding unit
    	wire  [31:0] RS1Data_final = Branch && RegWrite_MEM && RDNum_MEM && RDNum_MEM == RS1Num ? ALUResult_MEM :
	                            (Branch && RegWrite_WB && RDNum_WB && RDNum_WB == RS1Num ? RDData_WB : RS1Data);
    	wire  [31:0] RS2Data_final = Branch && RegWrite_MEM && RDNum_MEM && RDNum_MEM == RS2Num ? ALUResult_MEM :
	                            (Branch && RegWrite_WB && RDNum_WB && RDNum_WB == RS2Num ? RDData_WB : RS2Data);
	
	// brach stall detection unit 
	assign branch_stall = (Branch && RegWrite_EX && (RDNum_EX == RS1Num || RDNum_EX == RS2Num)) ||  
	                      (Branch && MemRead_MEM && (RDNum_MEM == RS1Num || RDNum_MEM == RS2Num)) ? 1 : 0;
	
    	wire  [6:0] funct7, funct7_EX;
    	wire  [2:0] funct3, funct3_EX;
    	wire  [6:0] OpCode, OpCode_EX;
    
    	assign funct7 = Inst_ID[31:25];
    	assign funct3 = Inst_ID[14:12];
    	assign OpCode = Inst_ID[6:0];
    

	// -------------------------------------------------------------------------------------------------------------
	// ID/EX register
	pipeline_register #(.N(204)) ID_EX (.CLK(CLK), .RST(RST), .en(1), .Flush(ID_Flush), 
	 .D({PC_ID, PCplus4_ID, funct7, funct3, OpCode, RS1Num, RS2Num, RDNum, ImmSignExt, JAL, JALR, Branch, MemRead, MemToReg, ALUOp, MemWrite, ALUSrc, RegWrite, RS1Data_final, RS2Data_final}),
	 .Q({PC_EX, PCplus4_EX, funct7_EX, funct3_EX, OpCode_EX, RS1Num_EX, RS2Num_EX, RDNum_EX, ImmSignExt_EX, JAL_EX, JALR_EX, Branch_EX, MemRead_EX, MemToReg_EX, ALUOp_EX, MemWrite_EX, ALUSrc_EX, RegWrite_EX, RS1Data_EX, RS2Data_EX})
	 );
	
	ALUControl u_ALUControl( .ALUCtrl(ALUCtrl), .ALUOp(ALUOp_EX), .funct7(funct7_EX), .funct3(funct3_EX), .OpCode(OpCode_EX) );
								 
	 
	// forwarding unit (alu)
	wire [31:0] A_final, B_final;	
	 
	assign A_final = RegWrite_MEM && RDNum_MEM && RDNum_MEM == RS1Num_EX ? ALUResult_MEM :
	                    (RegWrite_WB && RDNum_WB && RDNum_WB == RS1Num_EX ? RDData_WB : RS1Data_EX);
	assign ALUB = RegWrite_MEM && RDNum_MEM && RDNum_MEM == RS2Num_EX ? ALUResult_MEM :
	                    (RegWrite_WB && RDNum_WB && RDNum_WB == RS2Num_EX ? RDData_WB : RS2Data_EX);
	         
	assign B_final =  ALUSrc_EX ? ImmSignExt_EX : ALUB;
	    
   
	
	
	ALU u_ALU( .A(A_final), .B(B_final), .Result(ALUResult), .ALUCtrl(ALUCtrl), .Zero(Zero), .Overflow(Overflow) );
	
	
	//  -------------------------------------------------------------------------------------------------------------------
	// EX/MEM register
	pipeline_register #(.N(143)) EX_MEM (.CLK(CLK), .RST(RST), .en(1), .Flush(EX_Flush),
	 .D({ALUResult, PCplus4_EX, PC_jump_EX, JAL_EX, JALR_EX, Branch_EX, Zero, MemRead_EX, MemWrite_EX, MemToReg_EX, RegWrite_EX, ALUB, RDNum_EX}),
	 .Q({ALUResult_MEM, PCplus4_MEM, PC_jump_MEM, JAL_MEM, JALR_MEM, Branch_MEM, Zero_MEM, MemRead_MEM, MemWrite_MEM, MemToReg_MEM, RegWrite_MEM, DataMemWData_MEM, RDNum_MEM})
	 );  
	
	assign DataMemAddr = ALUResult_MEM;
	assign DataMemRead = MemRead_MEM;
	assign DataMemWrite = MemWrite_MEM;
	assign DataMemWData = DataMemWData_MEM;
	
	
	// ---------------------------------------------------------------------------------------------------
	// MEM/WB register
	pipeline_register #(.N(107)) MEM_WB (.CLK(CLK), .RST(RST), .en(1), .Flush(0),
	 .D({PCplus4_MEM, JAL_MEM, JALR_MEM, DataMemRData, ALUResult_MEM, MemToReg_MEM, RegWrite_MEM, RDNum_MEM}),
	 .Q({PCplus4_WB, JAL_WB, JALR_WB, DataMemRData_WB, ALUResult_WB, MemToReg_WB, RegWrite_WB, RDNum_WB})
	 );  
	
	 
endmodule
