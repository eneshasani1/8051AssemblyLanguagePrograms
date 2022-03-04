# 8051 Assembly Language Programs
#### 1) ANLBYTES
This program performs the following logical function: **((R0 and R1)_ or ((R2 and R3) or R4_))_**
##### Note: "_" represents negation
#### 2) LogicalOpOnBitsUsingBytes
This program performs the following logical function: **P3.7 = ((P0.0 and (P1.1 or P0.4)_) or (P1.2 and P2.3)_)_**. It is not permissable to use bit operand intructions and it is not permittable to change the state of any port except for the bit 7 of port 3(P3.7).
