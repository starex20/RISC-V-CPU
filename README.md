# RISC-V CPU
Verilog로 설계한 RISC-V 기반 32-bit CPU 입니다. 먼저 단일 사이클(single-cycle) 구조로 구현한 뒤, 파이프라인(pipeline) 구조로 확장했습니다.

<br/><br/>

# This project includes..
+ ### PC(Program Counter), Instruction MEM, ALU, Register File (Data MEM은 testbench에서 구현)
+ ### 5-stage pipeline structure
  + Data hazard -> forwarding unit, load-stall detection unit 

<br/><br/>

### Block Diagram
![Image](https://github.com/user-attachments/assets/73cced7f-772a-4a1f-aa00-b05213553efa)

<br/>

### 구현 명령어 set



