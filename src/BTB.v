`timescale 1ns / 1ps

module BTB( // Branch Target Buffer
    input wire              CLK,
    input wire              Jump,           // ID stage
    input wire       [31:0] PC_jump,        // ID stage
    input wire       [3:0]  WriteNum,       // ID stage
    input wire       [3:0]  ReadNum,        // IF stage
    output wire      [31:0] Target          // IF stage
    );
    reg [31:0] Buffer [15:0];
    
    // buffer write
    always @(posedge CLK) begin
        if(Jump)
            Buffer[WriteNum] <= PC_jump;
    end
    
    // output
    assign Target = Buffer[ReadNum];
  
endmodule
