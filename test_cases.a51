	;Testing NOR
	;NOR(0,1)
	MOV 00H, C
	SETB C
	MOV 01H, C 
	
	;NOR(1,1)
	MOV 02H, C
	MOV 03H,C 
	
	;NOR(0,0)
	CLR C
	MOV 04H, C
	MOV 05H, C
	
	;NOR(1,0)
	MOV 07H, C
	SETB C
	MOV 06H, C
	
	
	CALL c74ls02
	
	MOV C, 08H
	MOV P1.0, C
	MOV C, 09H
	MOV P1.1, C
	MOV C, 0AH
	MOV P1.2, C
	MOV C, 0BH
	MOV P1.3, C
	;End of NOR Testing
	
	;74LS04 Testing
	MOV 10H, C
	MOV 12H, C
	MOV 14H ,C
	SETB C
	MOV 11H, C
	MOV 13H, C
	MOV 15H, C
	
	CALL c74ls04
	
	MOV C, 18H
	MOV P1.0, C
	MOV C, 19H
	MOV P1.1, C
	MOV C, 1AH
	MOV P1.2, C
	MOV C, 1BH
	MOV P1.3, C
	MOV C, 1CH
	MOV P1.4, C
	MOV C, 1DH
	MOV P1.5, C
	;74LS04 END OF TESTING
	
	;testing D flip-flop as an inverting T flip flop
	SETB C
	MOV 29H, C
	

      
test_loop:
	 

	SETB C
	MOV 20H, C
	MOV 21H, C
	MOV C, P2.0
	MOV 22H, C
	MOV C, 29H
	MOV 23H, C
	CALL c74ls74
	
	MOV C, 28H
	MOV P1.6, C
	MOV C, 29H
	MOV P1.7, C
	sjmp test_loop
	;END OF 74ls74 testing as an inverting T flip flop
	
	;c74ls74
	;input L H x x
	CLR C
	MOV 20H, C
	SETB C
	MOV 21H, C
	MOV C, 08H
	MOV 22H, C
	MOV C, 29H
	MOV 23H, C
	CALL c74ls74
	
	MOV C, 28H
	MOV P1.0, C
	MOV C, 29H
	MOV P1.1, C
	
	;input H L x x
	SETB C
	MOV 20H, C
	CLR C
	MOV 21H, C
	MOV 22H, C
	MOV 23H, C
	CALL c74ls74
	
	
	MOV C, 28H
	MOV P1.2, C
	MOV C, 29H
	MOV P1.3, C
	
	;L L x x
	CLR C
	MOV 20H, C
	MOV 21H, C
	SETB C
	MOV 22H, C
	MOV C, 29H
	MOV 23H, C
	CALL c74ls74
	
	MOV C, 28H
	MOV P1.4, C
	MOV C, 29H
	MOV P1.5, C
	
	;H H risingCLK H
	SETB C
	MOV 20H, C
	MOV 21H, C
	MOV 22H, C
	MOV 23H, C
	CALL c74ls74

	;MOV C, 28H
	;MOV P1.6, C
	;MOV C, 29H
	;MOV P1.7, C	
	
	;H H risingCLK l
	SETB C
	MOV 20H, C
	MOV 21H, C
	MOV 22H, C
	CLR C
	MOV 23H, C
	CALL c74ls74
	
	;MOV C, 28H
	;MOV P1.6, C
	;MOV C, 29H
	;MOV P1.7, C
	
	;H H L x
	SETB C
	MOV 20H, C
	MOV 21H, C
	CLR C
	MOV 22H, C
	MOV 23H, C
	CALL c74ls74
	
	MOV C, 28H
	MOV P1.6, C
	MOV C, 29H
	MOV P1.7, C
	;c74ls74
	
	;this function checks if the state of the clock has changed for c74ls90
bool_clock_changed:
      JB 34H, check_2nd_bit
      JB 35H, set_c
      SJMP set_clk
      CLR C
      RET
      
      check_2nd_bit:
      JNB 35H, set_c
      SJMP set_clk
      CLR C
      RET
      
set_c:
      SETB C
      CALL set_clk
      RET

set_clk:
      MOV C, 34H
      MOV 35H, C
      RET
;end of bool_clock_changed

	;c74ls90
	;H H L X
	SETB C
	MOV 30H, C
	MOV 31H, C
	MOV 32H, C 
	CLR C
	MOV 33H, C
	MOV C, P2.1
	MOV 34H, C
	LCALL c74ls90
	
	MOV C, 38H
	MOV P1.0, C
	MOV C, 39H
	MOV P1.1, C 
	MOV C, 3AH
	MOV P1.2, C
	MOV C, 3BH
	MOV P1.3, C 
	
	;c74ls90 test as a BCD counter
	;X L L X
	SETB C
	MOV 30H, C
	CLR C
	MOV 31H, C
	MOV 32H, C 
	MOV 33H, C
	MOV C, P2.1
	MOV 34H, C
	LCALL c74ls90
	
	MOV C, 3BH
	MOV P1.0, C
	MOV C, 3AH
	MOV P1.1, C 
	MOV C, 39H
	MOV P1.2, C
	MOV C, 38H
	MOV P1.3, C 
	
	;X L X L
	SETB C
	MOV 30H, C
	CLR C
	MOV 31H, C
	SETB C
	MOV 32H, C 
	CLR C
	MOV 33H, C
	MOV C, P2.1
	MOV 34H, C
	LCALL c74ls90
	
	MOV C, 3BH
	MOV P1.4, C
	MOV C, 3AH
	MOV P1.5, C 
	MOV C, 39H
	MOV P1.6, C
	MOV C, 38H
	MOV P1.7, C 
	;end of test as BCD counter
	
	;c74ls90 test as a bi-quinary counter
	;X L X L
	SETB B.0
	SETB C
	MOV 30H, C
	CLR C
	MOV 31H, C
	SETB C
	MOV 32H, C 
	CLR C
	MOV 33H, C
	MOV C, P2.1
	MOV 34H, C
	LCALL c74ls90
	
	MOV C, 3BH
	MOV P1.4, C
	MOV C, 3AH
	MOV P1.5, C 
	MOV C, 39H
	MOV P1.6, C
	MOV C, 38H
	MOV P1.7, C 
	;end of test as a bi-quinary counter
	