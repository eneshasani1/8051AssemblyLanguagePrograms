ORG 600H
	'8','4','2','0','0','2','0','2','9','0','0','2'
ORG 0
	LJMP MAIN
	
ORG 0023H
	CLR RI
	LJMP SISR
	
ORG 0030H
	MAIN:
		MOV R0,#30H
		MOV TMOD,#20H
		MOV TH1,#-13
		SETB TR1
		MOV SCON,#01010000B
		MOV IE,#10010000B
		SJMP $
	SISR:
		MOV A, SBUF
		MOV @R0, A
		CJNE @R0, #0DH, continueCharReception
		LJMP checkContent
		continueCharReception:
			INC R0
			RETI
		checkContent:
			CJNE R0, #3C, sendQMark
			MOV DPTR, #0600H
			MOV R1, #0
		LOOP:
			MOV A, R1
			MOVC A, @A+DPTR
			DEC R0
			CJNE @R0, A, sendQMark
			INC R1
			CJNE R0, #30H, LOOP
			MOV A, #'O'
			MOV SBUF, A
			JNB TI, $
			CLR TI
			MOV A, #'K'
			MOV SBUF, A
			JNB TI, $
			CLR TI
			MOV A, #0DH
			MOV SBUF, A
			JNB TI, $
			CLR TI
			MOV A, #0AH
			MOV SBUF, A
			JNB TI, $
			CLR TI
			MOV R0, #30H
			RETI
		sendQMark:
			MOV A, #'?'
			MOV SBUF, A
			JNB TI, $
			CLR TI
			MOV A, #0DH
			MOV SBUF, A
			JNB TI, $
			CLR TI
			MOV A,#0AH
			MOV SBUF, A
			JNB TI, $
			CLR TI
			MOV R0, #30H
			RETI