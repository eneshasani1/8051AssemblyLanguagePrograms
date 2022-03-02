//Pjesa ku i shumezojme 2 bajt me 1 bajt edhe rezultatin e ruajme ne 40h,41h,42h
MOV A,33H
MOV B,A
MOV A,30H
MUL AB // BA = P1 
MOV 40H,A  // LSB(A*B) paraqet LSB te prodhimit 3 bajtesh
MOV R0,B // ---> E ruajme MSB(A*B) ne R0
CLR C
MOV 0F0H,33H    // Ne B(0F0H) vendose vleren qe gjendet ne adresen 33H
MOV A,31H		// Ne A vendose vleren qe gjendet ne adresen 31H
MUL AB //	BA = P2
ADD A,R0
MOV 41H,A   // E ruajme A ne ne adresen 41H
MOV A,B
ADDC A,#00H
MOV 42H,A
CLR C	//Pjesa ku rezultatin e mesiperm e mbledhim me konstanetn 2019H - Munem me bo edhe me loop, veqse niher duhet me qit konstanten ne dy adresa te memories
MOV A,40H
ADDC A,#19H
MOV 40H,A
MOV A,41H
ADDC A,#20H
MOV 41H,A
MOV A,42H
ADDC A,#0
MOV 42H,A
END


