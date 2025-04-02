`timescale 1ns / 1ps

module BPB( // Branch Prediction Buffer
    input wire              CLK,
    input wire              RST,
    input wire              Branch,           // ID stage
    input wire              Jump,             // ID stage
    input wire       [3:0]  WriteNum,         // ID stage
    input wire       [3:0]  ReadNum,          // IF stage

    input wire       [1:0]  current_state_ID, // ID stage
    output wire      [1:0]  current_state     // IF stage
);
    reg [1:0] Buffer [15:0];
    wire [1:0] next_state;
    
    // buffer write
    integer i;
    always @(posedge CLK, negedge RST) begin
        if (!RST) begin
            for (i = 0; i < 16; i = i + 1) begin
                Buffer[i] <= 2'b01;  // initialization : weakly not taken
            end
        end
        else begin
            if(Branch)
                Buffer[WriteNum] <= next_state;
        end
    end
    
    //output 
    assign current_state = Buffer[ReadNum];
    
endmodule
