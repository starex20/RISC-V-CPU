# RISC-V CPU

![image](https://github.com/user-attachments/assets/01ca048b-f84e-4882-ad56-5858d8f4390d)







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

