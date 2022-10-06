	org	0000h
	ljmp	main
	org	030h

      	;b.0 ? bi-quinary : 74ls90 BCD 
	;b.1 ? p2 : p0
	;b.2 ? pressed : just_pressed
	;b.3 ? MOV C, 08H : MOV 00H, C
	;b.4 ? select_pin : MOV P1.0, C
	
main:
	 MOV P1, #01
	 SETB C
	 MOV 29H, C
	 MOV 2BH, C
	 MOV P2.0, C
	 ;Nese supozojme qe pi dergohet inputi 
	 ;MOV 2CH, C
	 ;MOV 2DH, C
select_device:
      ;Ask user to select a device
      CALL listen_to_keyboard_key
      MOV R0, A
      CJNE A, #03, $ + 11
      ;Ask b.0 ? 74ls90 bi-quinary : 74ls90 BCD
      LCALL listen_to_keyboard_key
      CJNE A, #01, $ + 5
      SETB B.0
      
      
      CLR B.3
      continue_io:
      CALL inputOutput
      ;Ask user to continue configuring ports or not
      CALL listen_to_keyboard_key
      CJNE A, #00, continue_io
      
      CJNE R0, #00, check_for_74LS04
      CALL c74ls02
      SJMP add_user_to_add_device
      
      check_for_74LS04:
      CJNE R0, #01, check_for_74LS74
      CALL c74ls04
      SJMP add_user_to_add_device
      
      check_for_74LS74:
      CJNE R0, #02, check_for_74LS90
      CALL c74ls74
      SJMP add_user_to_add_device
      
      check_for_74LS90:
      CJNE R0, #03, select_device	;ni gabim qitu
      CALL c74ls90
      SJMP add_user_to_add_device
      
      add_user_to_add_device:
      ;Ask user to add other devices to this circuit or not
      CALL listen_to_keyboard_key
      CJNE A, #00, select_device
      
      
      SETB B.3
      select_output_pins:
      CALL select_port
      ;Ask user to continue configuring ports or not
      CALL listen_to_keyboard_key
      CJNE A, #00, select_output_pins
      JMP loop
   
loop:
      CALL listen_to_keyboard_key
      CJNE A, #00, select_device
      SJMP loop
  
      	;b.0 ? bi-quinary : 74ls90 BCD 
	;b.1 ? p2 : p0
	;b.2 ? pressed : just_pressed
	;b.3 ? MOV C, 08H : MOV 00H, C
	;b.4 ? select_pin : MOV P1.0, C
	
;routine(Device, B.3)
inputOutput:
      ;listen for input type for new device
      CALL listen_to_keyboard_key
      CJNE A, #00, check_for_device_input
      CALL select_port
      RET
      
      check_for_device_input:
      CJNE A, #01, inputOutput
      CALL select_devices
      RET
      
select_port:
      ;Listen for port
      CALL listen_to_keyboard_key
      CJNE A, #01, check_port0
      JB B.3, $ + 11
      MOV C, P1.0
      MOV B.7, C
      LCALL select_device_pin
      RET
      CALL select_device_pin
      MOV C, B.7
      MOV P1.0, C
      RET
      check_port0:
      CJNE A, #00, check_port2
      CLR B.1
      SJMP $ + 7
      check_port2:
      CJNE A, #02, select_port
      SETB B.1
      JB B.3, $ + 10
      LCALL select_pin
      LCALL select_device_pin
      RET
      CALL select_device_pin
      CALL select_pin
      RET
      
select_devices:
      SETB B.3
      ;ask which device do you want to take the output from and put that on R0
      MOV A, R0
      MOV R2, A
      CALL listen_to_keyboard_key
      MOV R0, A
      ;which pin of the device you want to take the outpot from
      CALL select_device_pin
      MOV A, R2
      MOV R0, A
      CLR B.3
      ;which pin do you want to input it
      CALL select_device_pin
      RET


	
;MOV 2CH, C clock
;MOV 2DH, C clock

;This routine asks the user which pin of the device do you want to use
;select_device_pin(inputOrOutput, deviceId)
select_device_pin:
      CALL listen_to_keyboard_key
      
      CJNE A, #00, check_first_pin
      CJNE R0, #00, check_74ls04
      MOV R1, #08H
      JB B.3, out_to_c_1
      MOV C, B.7
      MOV 00H, C
      RET
      
      check_74ls04:
      CJNE R0, #01, check_74ls74
      MOV R1, #18H
      JB B.3, out_to_c_1
      MOV C, B.7
      MOV 10H, C
      RET
      
      check_74ls74:
      CJNE R0, #02, check_74ls90
      MOV R1, #28H
      JB B.3, out_to_c_1
      MOV C, B.7
      MOV 20H, C
      RET
      
      check_74ls90:
      MOV R1, #38H
      JB B.3, out_to_c_1
      MOV C, B.7
      MOV 30H, C
      RET
      
out_to_c_1:
      LJMP out_to_c
      
check_first_pin:
      CJNE A, #01, check_second_pin
      CJNE R0, #00, $ + 13			;3 bytes
      MOV R1, #09H				;2 
      JB B.3, out_to_c_2			;3 bytes
      MOV C, B.7
      MOV 01H, C				;2
      RET					;1
      

      CJNE R0, #01, $ + 13
      MOV R1, #19H
      JB B.3, out_to_c_2
      MOV C, B.7
      MOV 11H, C
      RET
      
      CJNE R0, #02, $ + 13
      MOV R1, #29H
      JB B.3, out_to_c_2
      MOV C, B.7
      MOV 21H, C
      RET
      
      MOV R1, #39H
      JB B.3, out_to_c_2
      MOV C, B.7
      MOV 31H, C
      RET

check_second_pin:
      CJNE A, #02, check_third_pin
      CJNE R0, #00, $ + 13
      MOV R1, #0AH
      JB B.3, out_to_c_2
      MOV C, B.7
      MOV 02H, C
      RET

      CJNE R0, #01, $ + 13
      MOV R1, #1AH
      JB B.3, out_to_c_2
      MOV C, B.7
      MOV 12H, C
      RET
      
      CJNE R0, #02, $ + 13
      MOV R1, #2AH
      JB B.3, out_to_c_2
      MOV C, B.7
      MOV 22H, C
      RET
      
      MOV R1, #3AH
      JB B.3, out_to_c_2
      MOV C, B.7
      MOV 32H, C
      RET
      
      out_to_c_2:
      LJMP out_to_c
      
check_third_pin:
      CJNE A, #03, check_fourth_pin
      CJNE R0, #00, $ + 13
      MOV R1, #0BH
      JB B.3, out_to_c_2
      MOV C, B.7
      MOV 03H, C
      RET
      
      CJNE R0, #01, $ + 13
      MOV R1, #1BH
      JB B.3, out_to_c_2
      MOV C, B.7
      MOV 13H, C
      RET
      
      CJNE R0, #02, $ + 13
      MOV R1, #2BH
      JB B.3, out_to_c_2
      MOV C, B.7
      MOV 23H, C
      RET
      
      MOV R1, #3BH
      JB B.3, out_to_c_2
      MOV C, B.7
      MOV 33H, C
      RET
      

      
check_fourth_pin:
      CJNE A, #04, check_fifth_pin
      CJNE R0, #00, $ + 11
      JB B.3, ret_label
      MOV C, B.7
      MOV 04H, C
      RET
      
      CJNE R0, #01, $ + 13
      MOV R1, #1CH
      JB B.3, out_to_c_2
      MOV C, B.7
      MOV 14H, C
      RET
      
      CJNE R0, #02, $ + 11
      JB B.3, ret_label
      MOV C, B.7
      MOV 24H, C
      RET
      
      JB B.3, ret_label
      MOV C, B.7
      MOV 34H, C
      RET
      
ret_label:
      RET 
      
check_fifth_pin:
      CJNE A, #05, check_sixth_pin
      CJNE R0, #00, $ + 11
      JB B.3, ret_label
      MOV C, B.7
      MOV 05H, C
      RET
      
      CJNE R0, #01, $ + 13
      MOV R1, #1DH
      JB B.3, out_to_c_2
      MOV C, B.7
      MOV 15H, C
      RET
      
      CJNE R0, #02, ret_label
      JB B.3, ret_label
      MOV C, B.7
      MOV 25H, C
      RET
      
      
check_sixth_pin:
      JB B.3, ret_label
      CJNE A, #06, check_seventh_pin
      CJNE R0, #00, $ + 8
      MOV C, B.7
      MOV 06H, C
      RET
      
      CJNE R0, #02, ret_label
      MOV 26H, C
      RET
      
check_seventh_pin:
      JB B.3, ret_label
      CJNE A, #07, go_to_select_device_pin
      CJNE R0, #00, $ + 8
      MOV C, B.7
      MOV 07H, C
      RET
      
      CJNE R0, #02, ret_label
      MOV C, B.7
      MOV 27H, C
      RET
      
go_to_select_device_pin:
      LJMP select_device_pin
 ;end of select_device_pin routine
 
out_to_c:
   CJNE R1, #08H, check_09H
   MOV C, 08H
   MOV B.7, C
   RET
   check_09H:
   CJNE R1, #09H, check_0AH
   MOV C, 09H
   MOV B.7, C
   RET
   check_0AH:
   CJNE R1, #0AH, check_0BH
   MOV C, 0AH
   MOV B.7, C
   RET
   check_0BH:
   CJNE R1, #0BH, check_18H
   MOV C, 0BH
   MOV B.7, C
   RET
   check_18H:
   CJNE R1, #18H, check_19H
   MOV C, 18H
   MOV B.7, C
   RET
   check_19H:
   CJNE R1, #19H, check_1AH
   MOV C, 19H
   MOV B.7, C
   RET
   check_1AH:
   CJNE R1, #1AH, check_1BH
   MOV C, 1AH
   MOV B.7, C
   RET
   check_1BH:
   CJNE R1, #1BH, check_1CH
   MOV C, 1BH
   MOV B.7, C
   RET
   check_1CH:
   CJNE R1, #1CH, check_1DH
   MOV C, 1CH
   MOV B.7, C
   RET
   check_1DH:
   CJNE R1, #1DH, check_28H
   MOV C, 1DH
   MOV B.7, C
   RET
   check_28H:
   CJNE R1, #28H, check_29H
   MOV C, 28H
   MOV B.7, C
   RET
   check_29H:
   CJNE R1, #29H, check_2AH
   MOV C, 29H
   MOV B.7, C
   RET
   check_2AH:
   CJNE R1, #2AH, check_2BH
   MOV C, 2AH
   MOV B.7, C
   RET
   check_2BH:
   CJNE R1, #2BH, check_38H
   MOV C, 2BH
   MOV B.7, C
   RET
   check_38H:
   CJNE R1, #38H, check_39H
   MOV C, 38H
   MOV B.7, C
   RET
   check_39H:
   CJNE R1, #39H, check_3AH
   MOV C, 39H
   MOV B.7, C
   RET
   check_3AH:
   CJNE R1, #3AH, check_3BH
   MOV C, 3AH
   MOV B.7, C
   RET
   check_3BH:
   CJNE R1, #3BH, return
   MOV C, 3BH
   MOV B.7, C
   RET
   return:
   RET
 
;This method asks the user from which 8051 MC pin should the device take the input
select_pin:
      CALL listen_to_keyboard_key
      
      CJNE A, #00, check_pin_1
      JB B.1, p2_pin2c
      JB B.3, $ + 8
      MOV C, P0.0
      MOV B.7, C
      RET
      MOV C, B.7
      MOV P0.0, C
      RET
      p2_pin2c:
      JB B.3, $ + 8
      MOV C, P2.0
      MOV B.7, C
      RET
      MOV C, B.7
      MOV P2.0, C
      RET
check_pin_1:
      CJNE A, #01, check_pin_2
      JB B.1, $ + 16			;3
      JB B.3, $ + 8			;3
      MOV C, P0.1			;2
      MOV B.7, C
      RET				;1
      MOV C, B.7
      MOV P0.1, C			;2
      RET				;1

      JB B.3, $ + 8
      MOV C, P2.1
      MOV B.7, C
      RET
      MOV C, B.7
      MOV P2.1, C
      RET
check_pin_2:
      CJNE A, #02, check_pin_3
      JB B.1, $ + 16
      JB B.3, $ + 8
      MOV C, P0.2
      MOV B.7, C
      RET
      MOV C, B.7
      MOV P0.2, C
      RET

      JB B.3, $ + 8
      MOV C, P2.2
      MOV B.7, C
      RET
      MOV C, B.7
      MOV P2.2, C
      RET
check_pin_3:
      CJNE A, #03, check_pin_4
      JB B.1, $ + 16
      JB B.3, $ + 8
      MOV C, P0.3
      MOV B.7, C
      RET
      MOV C, B.7
      MOV P0.3, C
      RET

      JB B.3, $ + 8
      MOV C, P2.3
      MOV B.7, C
      RET
      MOV C, B.7
      MOV P2.3, C
      RET
check_pin_4:
      CJNE A, #04, check_pin_5
      JB B.1, $ + 16
      JB B.3, $ + 8
      MOV C, P0.4
      MOV B.7, C
      RET
      MOV C, B.7
      MOV P0.4, C
      RET

      JB B.3, $ + 8
      MOV C, P2.4
      MOV B.7, C
      RET
      MOV C, B.7
      MOV P2.4, C
      RET
check_pin_5:
      CJNE A, #05, check_pin_6
      JB B.1, $ + 16
      JB B.3, $ + 8
      MOV C, P0.5
      MOV B.7, C
      RET
      MOV C, B.7
      MOV P0.5, C
      RET

      JB B.3, $ + 8
      MOV C, P2.5
      MOV B.7, C
      RET
      MOV C, B.7
      MOV P2.5, C
      RET
check_pin_6:
      CJNE A, #06, check_pin_7
      JB B.1, $ + 16
      JB B.3, $ + 8
      MOV C, P0.6
      MOV B.7, C
      RET
      MOV C, B.7
      MOV P0.6, C
      RET

      JB B.3, $ + 8
      MOV C, P2.6
      MOV B.7, C
      RET
      MOV C, B.7
      MOV P2.6, C
      RET
check_pin_7:
      CJNE A, #07, go_to_select_pin
      JB B.1, $ + 16
      JB B.3, $ + 8
      MOV C, P0.7
      MOV B.7, C
      RET
      MOV C, B.7
      MOV P0.7, C
      RET

      JB B.3, $ + 8
      MOV C, P2.7
      MOV B.7, C
      RET
      MOV C, B.7
      MOV P2.7, C
      RET
;end of the select_pin routine  

go_to_select_pin:
      LJMP select_pin
 

listen_to_keyboard_key:
MOV DPTR,#look_up_table 

MOV A,#0FFh

reverse:MOV P3,#0FFh 
     CLR P3.0 
     JB P3.4,next_find_1  
     MOV A,#0D
     CALL disp_000 
     MOV A, #7
     CLR B.2
     LJMP reverse 
next_find_1:JB P3.5,next_find_2 
      MOV A,#1D
      CALL disp_000
      MOV A, #8
      CLR B.2
      LJMP reverse
next_find_2:JB P3.6,next_find_3
      MOV A,#2D
      CALL disp_000
      MOV A, #9
      CLR B.2
      LJMP reverse
next_find_3:JB P3.7,next_find_4
      MOV A,#3D
      CALL disp_000
      MOV A, #10
      CLR B.2
      LJMP reverse
next_find_4:SETB P3.0
      CLR P3.1
      JB P3.4,next_find_5
      MOV A,#4D
      CALL disp_000
      MOV A, #4
      CLR B.2
      LJMP reverse
next_find_5:JB P3.5,next_find_6
      MOV A,#5D
      CALL disp_000
      MOV A, #5
      CLR B.2
      LJMP reverse
next_find_6:JB P3.6,next_find_7
      MOV A,#6D
      CALL disp_000
      MOV A, #6
      CLR B.2
      LJMP reverse
next_find_7:JB P3.7,next_find_8
      MOV A,#7D
      MOV A, #11
      CALL disp_000
      CLR B.2
      LJMP reverse
next_find_8:SETB P3.1
      CLR P3.2
      JB P3.4,NEXT9
      MOV A,#8D
      CALL disp_000
      MOV A, #1
      CLR B.2
      LJMP reverse
NEXT9:JB P3.5,next_find_10
      MOV A,#9D
      CALL disp_000
      MOV A, #2
      CLR B.2
      LJMP reverse
next_find_10:JB P3.6,next_find_11
       MOV A,#10D
       CALL disp_000
       MOV A, #3
       CLR B.2
       LJMP reverse
next_find_11:JB P3.7,next_find_12
       MOV A,#11D
       CALL disp_000
       MOV A, #12
       CLR B.2
       LJMP reverse
next_find_12:SETB P3.2
       CLR P3.3
       JB P3.4,next_find_13
       MOV A,#12D
       CALL disp_000
       MOV A, #13
       CLR B.2
       LJMP reverse
next_find_13:JB P3.5,next_find_14
       MOV A,#13D
       CALL disp_000
       MOV A, #0
       CLR B.2
       LJMP reverse
next_find_14:JB P3.6,next_find_15
       MOV R3, A
       MOV A,#14D
       CALL disp_000
       JB B.2, go_to_reverse
       SETB B.2
       MOV A, R3
       RET
next_find_15:JB P3.7, go_to_reverse
       MOV A,#15D
       CALL disp_000
       MOV A, #15
       CLR B.2
       LJMP reverse

go_to_reverse:
   LJMP reverse
   
disp_000:
	MOVC A,@A+DPTR 
        MOV P1,A   
        RET

look_up_table: 
		
	DB 11100000B
	DB 11111110B
	DB 11110110B
	DB 10011100B
	DB 01100110B
	DB 10110110B
	DB 10111110B
	DB 00111110B
	DB 01100000B 
	DB 11011010B
	DB 11110010B
	DB 11101110B
	DB 10011110B
	DB 11111100B
	DB 10000010B
	DB 01111010B
	

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
      CLR PSW.5
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

