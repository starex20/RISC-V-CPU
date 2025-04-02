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

    // FSM (00 : strongly not, 01 : weakly not, 10 : weakly taken, 11 : strongly taken)
    always @(*)
        case (current_state_ID)
        	2'b00 : next_state = Jump ? 2'b01 : 2'b00;
         	2'b01 : next_state = Jump ? 2'b10 : 2'b00;
           	2'b10 : next_state = Branch && !Jump ? 2'b01 : 2'b11;
           	2'b11 : next_state = Branch && !Jump ? 2'b10 : 2'b11;
           	default : next_state = 2'bxx;
        endcase
    
    //output 
    assign current_state = Buffer[ReadNum];
    
endmodule
