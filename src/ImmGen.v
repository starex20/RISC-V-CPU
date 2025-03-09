`timescale 1ns / 1ps

module ImmGen(
		input [31:0] Instr,
		output reg [31:0] ImmSignExt
   );

    always @(*) begin
        case(Instr[6:0])
            7'b1100011 : ImmSignExt = { {20{Instr[31]}}, Instr[7],
                                Instr[30:25], Instr[11:8], 1'b0 };    // branch
            7'b0100011 : ImmSignExt = { {20{Instr[31]}}, Instr[31:25],
                                Instr[11:7] };                        // store
            7'b1101111 : ImmSignExt = { {12{Instr[31]}}, Instr[19:12], 
                                Instr[20], Instr[30:21], 1'b0 }; // UJ-type
            7'b0110111 : ImmSignExt = { Instr[31:12], 12'b0 }; // U-type
            default : ImmSignExt = { {20{Instr[31]}}, Instr[31:20] }; // load & I-types
        endcase
    end
endmodule
