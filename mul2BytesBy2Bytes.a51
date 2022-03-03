
MOV 70H,50H
MOV 71H,60H
MOV 72H,61H
MOV R0,#70H
LCALL mul2Bby1B
MOV 40H,@R0
INC R0
MOV 41H,@R0 // 	e1
INC R0
MOV 42H,@R0 //	e2

//////////////////////////////////////////////////////////////////////
MOV 70H, 51H		//71H e kem vleren e 60H, N'72H e kem vleren 61H
MOV R0, #70H
LCALL mul2Bby1B
MOV 43H,@R0			//h0
INC R0
MOV 44H,@R0			//h1
INC R0
MOV 45H,@R0			//h2

CLR C
MOV R1, 41H
MOV A, 43H
ADD A,R1
MOV 41H,A

MOV R1,42H
MOV A,44H
ADDC A,R1
MOV 42H,A

MOV A, 45H
ADDC A,#0
MOV 43H, A
SJMP $

mul2Bby1B:
		MOV A,@R0
		MOV R1,A
		INC R0
		MOV B,@R0
		MUL AB //		BA
		MOV 73H,A
		MOV R2,B		// R2=C1
		INC R0
		MOV B,@R0
		MOV A,R1
		MUL AB			// BA=d1d0
		CLR C
		ADD A,R2
		MOV 74H, A
		MOV A,B
		ADDC A,#0
		MOV 75H, A
		MOV R0, #73H
		RET
		END
