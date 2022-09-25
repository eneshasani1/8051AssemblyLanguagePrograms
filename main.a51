

	LJMP main
	
	MOV 2CH, C
	MOV 2DH, C

	
loop:
	;P2.0_
	MOV C, P2.0
	MOV 10H, C
	CALL c74ls04
	
	
	;NOR
	MOV C, 18H
	MOV 01H, C
	MOV C, P0.0
	MOV 00H, C
	CALL c74ls02
	
	;c74ls74
	MOV C, P2.2
	MOV 20H, C
	MOV C, P2.3
	MOV 21H, C
	MOV C, 08H
	MOV 22H, C
	MOV C, 29H
	MOV 23H, C
	CALL c74ls74
	
	;c74ls90
	SETB C
	MOV 34H, C
	MOV C, P2.1
	MOV 30H, C
	MOV 31H, C
	MOV 32H, C
	MOV 33H, C
	CALL c74ls90
	
	;OUTPUT
	MOV C, 38H
	MOV P1.7, C
	MOV C, 39H
	MOV P1.6, C
	MOV C, 3AH
	MOV P1.5, C
	MOV C, 3BH
	MOV P1.4, C
	
	SJMP loop
	
;NOR
c74ls02:
	MOV C, 00H
	ORL C, 01H
	CPL C
	MOV 08H, C
	
	MOV C, 02H
	ORL C, 03H
	CPL C
	MOV 09H, C
	
	MOV C, 04H
	ORL C, 05H
	CPL C
	MOV 0AH, C
	
	MOV C, 06H
	ORL C, 07H
	CPL C
	MOV 0BH, C
	 
	RET
	
;negation
c74ls04:
      MOV C, 10H
      CPL C
      MOV 18H, C
      
      MOV C, 11H
      CPL C
      MOV 19H, C
      
      MOV C, 12H
      CPL C
      MOV 1AH, C
      
      MOV C, 13H
      CPL C
      MOV 1BH, C
      
      MOV C, 14H
      CPL C
      MOV 1CH, C
      
      MOV C, 15H
      CPL C
      MOV 1DH, C

      RET
      
;D flip flops
c74ls74:
      ;first D flip flop
      MOV C, 20H
      ANL C, 21H
      JC pr_clr_high
      JNB 20H, check_clr
      CLR C
      MOV 28H, C
      SETB C
      MOV 29H, C
      CALL save_clock_state
      SJMP second_part
check_clr:
      JB 21H, return_HL
      SETB C
      MOV 28H, C
      MOV 29H, C
      CALL save_clock_state
      SJMP second_part
return_HL:
      SETB C
      MOV 28H, C
      CLR C
      MOV 29H, C
      CALL save_clock_state
      SJMP second_part
pr_clr_high:
      JB 22H, check_previous_clk
      CALL save_clock_state
      SJMP second_part
check_previous_clk:
      JNB 2CH, check_D
      CALL save_clock_state
      SJMP second_part
check_D:
      JB 23H, return_HL
      CLR C
      MOV 28H, C
      SETB C
      MOV 29H, C
      CALL save_clock_state
      SJMP second_part

save_clock_state: 
      MOV C, 22H
      MOV 2CH, C
      RET
      
      ;second D flip flop
second_part:
      MOV C, 24H
      ANL C, 25H
      JC pr_clr_high_1
      JNB 24H, check_clr_1
      CLR C
      MOV 2AH, C
      SETB C
      MOV 2BH, C
      CALL save_clock_state_1
      RET
check_clr_1:
      JB 25H, return_HL_1
      SETB C
      MOV 2AH, C
      MOV 2BH, C
      CALL save_clock_state_1
      RET
return_HL_1:
      SETB C
      MOV 2AH, C
      CLR C
      MOV 2BH, C
      CALL save_clock_state_1
      RET
pr_clr_high_1:
      JB 26H, check_previous_clk_1
      CALL save_clock_state_1
      RET
check_previous_clk_1:
      JNB 2DH, check_D_1
      CALL save_clock_state_1
      RET
check_D_1:
      JB 27H, return_HL_1
      CLR C
      MOV 2AH, C
      SETB C
      MOV 2BH, C
      CALL save_clock_state_1
      RET

save_clock_state_1:
      MOV C, 26H
      MOV 2DH, C

      
;counter
c74ls90:
      MOV C, 32H
      ANL C, 33H
      JNC check_r0
      MOV 27H, #09H
      RET
check_r0:
      MOV C, 30H
      ANL C, 31H
      JNC count
      MOV 27H, #00H
      RET
count:
      CALL bool_keep_counting
      JB PSW.5, keep_counting
      RET
keep_counting:
      JNB B.0, bcd_count
      SJMP bi_quinary_count
bcd_count:
      MOV A, 27H
      CJNE A, #09H, add_one
      MOV 27H, #00H
      RET
bi_quinary_count:
      MOV A, 27H
      CJNE A, #12, check_for_four
      MOV 27H, #00
      RET
check_for_four:
      MOV A, 27H
      CJNE A, #4, add_one
      MOV 27H, #8
      RET
add_one:
      ADD A, #01H
      MOV 27H, A
      RET
        
bool_keep_counting:
      JB 34H, set_clk
      JB 35H, set_F0
      CLR PSW.5
      SJMP set_clk
      
set_F0:
      SETB PSW.5

set_clk:
      MOV C, 34H
      MOV 35H, C
      RET
      
END 

