MOV A, R0
ANL A, R1
MOV R0, A
MOV A, #11111111B
XRL A, R0
MOV R0, A		//(R0 AND R1)_

MOV A, R2
ANL A, R3
MOV R1, A		//(R2 AND R3)

MOV A, #11111111B
XRL A, R4
ORL A, R1 		//((R2 AND R3) OR R4_)
ORL A, R0
MOV R0, A 		//(R0 AND R1)_ OR ((R2 AND R3) OR R4_)
MOV A, #11111111B
XRL A, R0
MOV R5, A
END