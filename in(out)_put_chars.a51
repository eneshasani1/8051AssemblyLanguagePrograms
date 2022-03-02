ORG 0
	LJMP MAIN
	
ORG 0023H
	CLR RI
	LJMP SISR
	
ORG 0030H
	MAIN:
		MOV R0,#30H
		MOV TMOD,#20H
		MOV TL1,#-13
		MOV TH1,#-13
		SETB TR1
		MOV SCON,#01010000B
		MOV IE,#10010000B
		SJMP $
	SISR:
		MOV A, SBUF
		MOV @R0, A
		CJNE @R0, #0AH, vazhdoPranoKaraktere1
		DEC R0
		CJNE @R0, #0DH, vazhdoPranoKaraktere2
		LJMP KontrolloPermbajtjen
		vazhdoPranoKaraktere1:
			INC R0
			RETI
		vazhdoPranoKaraktere2:
			INC R0
			INC R0
			RETI
		KontrolloPermbajtjen:
		CJNE R0, #30H, KontrolloPermbajtjen2
		MOV A, #0DH
		MOV SBUF, A
		JNB TI, $
		CLR TI
		MOV A, #0AH
		MOV SBUF, A
		JNB TI, $
		CLR TI
		//A me kthy R0 ne 30H qe me ja nis mi ru karakteret qe vijn ne 30H e tutje
		RETI
		KontrolloPermbajtjen2:
		DEC R0
		CJNE @R0, #'T', DergoPikepyetje
		DEC R0
		CJNE @R0, #'A', DergoPikepyetje
		CJNE R0, #30H, DergoPikepyetje
		// degojme O+K+CR+LF
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
		//A me kthy R0 ne 30H qe me ja nis mi ru karakteret qe vijn ne 30H e tutje
		RETI 
		DergoPikepyetje:
		MOV A, #3FH
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
		//A me kthy R0 ne 30H qe me ja nis mi ru karakteret qe vijn ne 30H e tutje
		RETI
		END
		