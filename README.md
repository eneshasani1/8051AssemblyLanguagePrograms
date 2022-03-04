# 8051 Assembly Language Programs
#### 1) ANLBYTES
This program performs the following logical function: **((R0 and R1)_ or ((R2 and R3) or R4_))_**
##### Note:
"_" represents negation
#### 2) LogicalOpOnBitsUsingBytes
This program performs the following logical function: **P3.7 = ((P0.0 and (P1.1 or P0.4)__) or (P1.2 and P2.3)__)_**. It is not permissible to use bit operand instructions and it is not permissible to change the state of any port except for bit 7 of port 3(P3.7).
#### 3) add2_4_bytes_numbers
This program adds 2 four-byte positive numbers. Address of the least significant byte(LSB) of the first number is found in the register R0 and the address of the LSB of the second number is found in R1. Since the result might at most be 5 bytes, addresses 40H up to 44H(5 addresses) are used to save the result.
#### 4) dergoEmrinDheMbiemrin
This program sends my name to the serial port the first time the push-button switch connected to P2.7 is pressed(8051 is interfaced to all the switches using negative logic, so when the push button is pressed input to P1.7 is low). Whereas when the P2.6 push-button switch is pressed for the first time the program sends my surname to the serial port. 
##### Note: 
We've got to make sure that only the first time push-button switches are pressed we send name or surname.
##### Contributors:
[Artin Sermaxhaj](https://github.com/artini123), [Donat Sinani](https://github.com/donats1n), [Enes Hasani](https://github.com/eneshasani1), [Erlis Lushtaku](https://github.com/erlis-lushtaku)
#### 5) mul2ByteBy1Byte
Firstly this program multiplies 2 positive numbers, one of them is 2 bytes found in addresses [30H(LSB), 31H(MSB)] and the other one is one byte found in address 33H. To this result, the 2019H constant is added. Multiplication is carried out using MUL AB instruction. The result is placed in addresses 40H up to 42H. . 
#### 6) mul2ByteBy2Bytes_noFunction
This program multiplies 2 positive 2-byte numbers found in addresses [30H(LSB),31H(MSB)] and [32H(LSB),33H(MSB)]. Multiplication is carried out using MUL AB instruction. The result is placed in addresses 40H up to 43H.
#### 7) mul2BytesBy2Bytes 
This program multiplies 2 positive 2-byte numbers found in addresses [50H(LSB),51H(MSB)] and [60H(LSB),61H(MSB)]. To carry this multiplication it uses the "mul2Bby1B" routine which implements the same logic implemented in the "mul2ByteBy1Byte" program.
