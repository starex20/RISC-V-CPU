
module pipeline_register #(
    parameter N = 4
) (
    input  CLK,             
    input  RST,
    input  en,   
    input  Flush,        
    input  [N-1:0] D,       
    output reg [N-1:0] Q        
);

    always @(posedge CLK or negedge RST) begin
        if (!RST) 
            Q <= 0;            // 리셋 시 출력 0으로 초기화
        else if(Flush) 
            Q <= 0;            // 모든 signal 0으로 만듬
        else if(en)
            Q <= D;        // 입력을 출력으로 전달
    end

endmodule
