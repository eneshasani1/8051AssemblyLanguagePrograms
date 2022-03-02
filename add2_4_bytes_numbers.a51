MOV R2,#4
CLR C

label:
	MOV A,@R0
	ADDC A,@R1
	MOV @R0, A
	INC R0
	INC R1

	
DJNZ R2,label
JNC label2
MOV @R0,#1
LJMP label3
label2:
	MOV @R0,#0
	
label3:
/* 	s
	MOV R2,#5
	MOV R1,#44H
	label4:
		MOV A, @R0
		MOV @R1,A
		DEC R0
		DEC R1
	DJNZ R2, label4
*/
//		Nese sdojna me bo me loop rreshtin 20-27 e zevendesojme me rreshtat ne vazhdim
MOV 44H,@R0
DEC R0
MOV 43H, @R0
DEC R0
MOV 42H, @R0
DEC R0
MOV 41H, @R0
DEC R0
MOV 40H, @R0

end
