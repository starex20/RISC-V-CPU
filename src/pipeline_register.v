
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
        if (!RST) begin
            Q <= 0;            // ���� �� ��� 0���� �ʱ�ȭ
        end 
        else begin
            if(Flush) 
                Q <= 0;        // ��� signal 0���� ����
            else if(en)
                Q <= D;        // �Է��� ������� ����
            else 
                Q <= Q;        // en = 0�̸� ���� ��� ����
        end
    end

endmodule
