/*kontrolloEmrin:
	JB P2.7, kontrolloMbiemrin
kontrolloMbiemrin:
	JB P2.6, kontrolloEmrin
*/

LOOP:
	JB B.0, masEmri
	MOV A,#11
	JNB P2.7, Emri
	masEmri:
	JB B.1, LOOP
	MOV A,#11
	JNB P2.6, Mbiemri
	masMbiemri:
	SJMP LOOP
	
Emri:
	MOV R0, A
	MOVC A, @A+PC
	CJNE A, #00H, dergoDheNdrro1
	SETB B.0
	JB B.1, perfundo
	LJMP masEmri
	DB 'E', 'N', 'E', 'S', 00H
	dergoDheNdrro1:
		LCALL Dergo
		MOV A, R0
		INC A
		LJMP Emri

Mbiemri:
	MOV R0,A
	MOVC A,@A+PC
	CJNE A, #00H, dergoDheNdrro2	//3 Bajta
	SETB B.1 	//2 Bajta
	JB B.0, perfundo		//3 bajta
	LJMP masMbiemri			//3 bajta
	DB 'H', 'A', 'S', 'A', 'N', 'I', 00H
	dergoDheNdrro2:
		LCALL Dergo
		MOV A, R0
		INC A
		LJMP Mbiemri
		
Dergo:
	MOV SBUF, A
	JNB TI, $
	CLR TI
	RET
	
perfundo:
	END