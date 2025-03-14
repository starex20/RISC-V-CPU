# RISC-V CPU
Verilog로 설계한 RISC-V 기반 32-bit CPU 입니다. 먼저 단일 사이클(single-cycle) 구조로 구현한 뒤, 파이프라인(pipeline) 구조로 확장했습니다.

<br/><br/>

# This project includes..
+ ### PC, Instruction MEM, ALU, Register File (Data MEM은 testbench에서 구현)
+ ### 5-stage pipeline structure
  + Data Hazard -> EX-stage Forwarding Unit, Load-use Hazard Detection Unit
  + Control Hazard -> ID-stage branch target computation, ID-stage Forwarding Unit, Branch Hazard Detection Unit
+ ### Dynamic branch prediction using 2bit counter
+ ### TestBench (이중 for문, factorial 함수)

<br/><br/>

### Block Diagram
![Image](https://github.com/user-attachments/assets/73cced7f-772a-4a1f-aa00-b05213553efa)

<br/>

### 구현 명령어 set
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

### Simulation Result
![Image](https://github.com/user-attachments/assets/9acf7ef1-58ce-4fd7-adab-f67b2ae1018f)


+ factorial 예제,  N = 5 -> 120( = 5!)

