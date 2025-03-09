`timescale 1ns / 1ps

//int fact(int n) {
//    if (n == 0) return 1;
//    else return (n * fact(n - 1));
//}


`define INST_MEMSIZE 21
`define DATA_MEMSIZE 1024

`define FAC_N 5
`define RUN_INST 220


module tb_factorial;

	reg CLK;
	reg RST;
	
	wire [31:0] InstMemRAddr;
	wire [31:0] InstMemRData;
		
	wire [31:0] DataMemAddr;
	wire DataMemRead;
	wire DataMemWrite;		
	wire [31:0] DataMemRData;
	wire [31:0] DataMemWData;

	localparam  [0:32*`INST_MEMSIZE-1] InstMem  = {
//FACT: //fact(n)
		32'hFF810113, //addi x2, x2, -8
		32'h00112023, //sw x1, 0(x2)
		32'h00A12223, //sw x10, 4(x2)
		32'h02050E63, //beq x10, x0, 60:RET1
//ELSE: //return (n * fact(n - 1))
		32'hFFF50513, //addi x10, x10, -1
		32'hFEDFF0EF, //jal x1, -20:FACT
		32'h00050313, //addi x6, x10, 0
		32'h00412503, //lw x10, 4(x2)
		32'h00012083, //lw x1, 0(x2)
		32'h00810113, //addi x2, x2, 8
		32'h00000593, //addi x11, x0, 0
		32'h00000613, //addi x12, x0, 0
//MUL: //mul x12, x10, x6
		32'h00658863, //beq x11, x6, 16:END
		32'h00A60633, //add x12, x12, x10
		32'h00158593, //addi x11, x11, 1
		32'hFE000AE3, //beq x0, x0, -12:MUL
//END: //x10 <- x12
		32'h00060513, //addi x10, x12, 0
		32'h00008067, //jalr x0, 0(x1)
//RET1: //return 1
		32'h00100513, //addi x10, x0, 1
		32'h00810113, //addi x2, x2, 8
		32'h00008067  //jalr x0, 0(x1)
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
		end
	end	
	
	always begin
		#5 CLK = ~CLK;
	end
    
	initial begin
		//$dumpfile("test.vcd");
		//$dumpvars();


		// Initialize Inputs
		CLK = 1;
		RST = 1;
		
		#5; RST = 0;
		#20; RST = 1;
		u_RISCV.u_RegFiles.Registers[1] = 100; //set return address of init func call to 100
		u_RISCV.u_RegFiles.Registers[2] = `DATA_MEMSIZE; //set SP to the data mem size
		u_RISCV.u_RegFiles.Registers[10] = `FAC_N; //set N of FAC(N)
		
		#10;
		
		#(10 * `RUN_INST);
		
		#20;			
		
		// 1 2 6 24 120
		$display("Simulation ended at time %d", $time);
		$display("Fac(%d) = %d", `FAC_N, $signed(u_RISCV.u_RegFiles.Registers[10]));
		
		$finish;
	end
      
endmodule