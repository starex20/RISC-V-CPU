`timescale 1ns / 1ps

//for(i = 0; i < a; i++)
//  for(j = 0; j < b; j++)
//    D[4*j] = i + j;


`define INST_MEMSIZE 14
`define DATA_MEMSIZE 1024

`define A_SIZE 3
`define B_SIZE 4
`define RUN_INST 800//90


module tb_ex225;

	reg CLK;
	reg RST;
	
	wire [31:0] InstMemRAddr;
	wire [31:0] InstMemRData;
		
	wire [31:0] DataMemAddr;
	wire DataMemRead;
	wire DataMemWrite;		
	wire [31:0] DataMemRData;
	wire [31:0] DataMemWData;
	
	localparam  [0:32*`INST_MEMSIZE-1] InstMem  = { // x5 = 3, x6 = 4 
		32'h00000393, //addi x7, x0, 0 (assumes the baseaddr of D is 0)    
		32'h0053AC33, // LOOPI : slt x24 x7 x5                                  
		32'h03800863, // beq x0 x24 48 (ENDI)                  
		32'h00000513, // addi x10, x0, 0                              
		32'h00000E93, // addi x29, x0, 0                                                          
		32'h006EAC33, // LOOPJ : slt x24 x29 x6         
		32'h01800C63, // beq x0 x24 24 (ENDJ)                 
		32'h01D38FB3, // add x31, x7, x29                          
		32'h01F52023, // sw x31, 0(x10)                                                                   
		32'h01050513, // addi x10, x10, 16                                                                                     
		32'h001E8E93, // addi x29, x29, 1                                                                                           
		32'hFE9FF06F, // jal x0, -24(LOOPJ)                                                                                            
		32'h00138393, // ENDJ : addi x7, x7, 1                                                            
		32'hFD1FF06F  // jal x0, -48(LOOPI)                                                                                    
		//ENDI:
	};
	
	RISCV u_RISCV( 
		.CLK(CLK),
		.RST(RST),
		
		.InstMemRAddr(InstMemRAddr),
		.InstMemRData(InstMemRData),
		
		.DataMemAddr(DataMemAddr),
		.DataMemRead(DataMemRead),
		.DataMemWrite(DataMemWrite),
		.DataMemRData(DataMemRData),
		.DataMemWData(DataMemWData)
   );
	
	reg [31:0] DataMem [`DATA_MEMSIZE-1:0];
	
	assign InstMemRData = (InstMemRAddr < `INST_MEMSIZE*4) ? InstMem[InstMemRAddr*8 +:32] : 0;
	
	assign DataMemRData = (DataMemRead == 1) ? DataMem[DataMemAddr] : 32'hX;
	
	always @(posedge CLK) begin
		if( DataMemWrite == 1 ) begin
			DataMem[DataMemAddr] = DataMemWData;
			$display("%d stored in addr : %h at %g ns", DataMemWData, DataMemAddr, $time);
		end
	end	
	
	always begin
		#5 CLK = ~CLK;
	end
   
	integer i, j, error_cnt;
	initial begin
		// Initialize Inputs
		CLK = 1;
		RST = 1;
		
		#5; RST = 0;
		#20; RST = 1;
		u_RISCV.u_RegFiles.Registers[1] = 100; //set return address of init func call to 100
		u_RISCV.u_RegFiles.Registers[2] = `DATA_MEMSIZE; //set SP to the data mem size
		u_RISCV.u_RegFiles.Registers[5] = `A_SIZE;
		u_RISCV.u_RegFiles.Registers[6] = `B_SIZE;
		
		#10;
		
		#(10 * `RUN_INST);
		
		#20;			
		
		error_cnt = 0;
		//note: only check when i== `A_SIZE -1, since the rest is overwritten
		i = `A_SIZE-1;
		//i = 0;
		for(j = 0; j < `B_SIZE; j = j + 1) begin
		    $display("DataMem : %d, Expected : %d",  DataMem[16*j], i + j);
			if(DataMem[16*j] != i + j) begin
				$display("error detected at j = %d. Expected %d, but obtained %d", j, i + j, DataMem[16*j]);
				error_cnt = error_cnt + 1;
			end
		end
		$display("error cnt: %d ", error_cnt);	
		$finish;
	end
      
endmodule