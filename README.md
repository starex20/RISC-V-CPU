# RISC-V CPU
Verilog로 설계한 RISC-V 기반 32-bit CPU 입니다. 먼저 단일 사이클(single-cycle) 구조로 구현한 뒤, 파이프라인(pipeline) 구조로 확장했습니다.

<table style="width: 50%; border-collapse: collapse;">
  <tr style="background-color: #FFC1CC;"> <!-- 분홍색 헤더 -->
    <th style="border: 1px solid black; padding: 8px;">항목</th>
    <th style="border: 1px solid black; padding: 8px; background-color: white;">내용</th>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px; background-color: #FFC1CC;">프로젝트명</td> <!-- 분홍색 -->
    <td style="border: 1px solid black; padding: 8px; background-color: white;">CPU 설계</td> <!-- 하얀색 -->
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px; background-color: #FFC1CC;">주관 기관</td>
    <td style="border: 1px solid black; padding: 8px; background-color: white;">xx대학교</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px; background-color: #FFC1CC;">개발 기간</td>
    <td style="border: 1px solid black; padding: 8px; background-color: white;">2025.06~2025.09</td>
  </tr>
</table>



<br/><br/>

# This project includes..
+ ### PC, Instruction MEM, ALU, Register File (Data MEM은 testbench에서 구현)
+ ### 5-stage pipeline structure
  + Data Hazard -> EX-stage Forwarding Unit, Load-use Hazard Detection Unit
  + Control Hazard -> ID-stage branch target computation, ID-stage Forwarding Unit, Branch Hazard Detection Unit
+ ### Dynamic branch prediction using 2bit counter
+ ### TestBench (이중 for문, factorial 함수)

<br/><br/>

# Block Diagram
![image](https://github.com/user-attachments/assets/21809222-f1fd-4055-8cce-6e37049a8fba)


<br/>

# 구현 명령어 set
<table>
  <tr>
    <th>Format</th>
    <th>Instruction</th>
  </tr>
  <tr>
    <td rowspan="5">R-type</td>
    <td>add</td>
  </tr>
  <tr>
    <td>sub</td>
  </tr>
  <tr>
    <td>and</td>
  </tr>
  <tr>
    <td>or</td>
  </tr>
  <tr>
    <td>slt</td>
  </tr>
  <tr>
    <td rowspan="7">I-type</td>
    <td>lw</td>
  </tr>
  <tr>
    <td>addi</td>
  </tr>
  <tr>
    <td>subi</td>
  </tr>
  <tr>
    <td>andi</td>
  </tr>
  <tr>
    <td>ori</td>
  </tr>
  <tr>
    <td>slti</td>
  </tr>
  <tr>
    <td>jalr</td>
  </tr>
  <tr>
    <td rowspan="1">S-type</td>
    <td>sw</td>
  </tr>
  <tr>
    <td rowspan="1">SB-type</td>
    <td>beq</td>
  </tr>
  <tr>
    <td rowspan="1">UJ-type</td>
    <td>jal</td>
  </tr>
</table>

<br/>

# Simulation Result
![Image](https://github.com/user-attachments/assets/9acf7ef1-58ce-4fd7-adab-f67b2ae1018f)


+ factorial 예제,  N = 5 -> 120( = 5!)

