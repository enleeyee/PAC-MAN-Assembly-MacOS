.286
IDEAL
MODEL small
stack 600h
DATASEG
;{
    ;Clock & Timers {
		CLOCK_BASE 	DB 0
	
		INT_MOV		DW 3
		CNT_MOV		DW 0 
		
		INT_GMOV	DW 3
		CNT_GMOV	DW 0
		
		INT_MODE	DW 180
		CNT_MODE	DW 0
		INT_CHASE	DW 126
		INT_SCAT	DW 72
		
		INT_FRI		DW 126
		CNT_FRI		DW 0
		
		INT_BLINK	DW 5
		CNT_BLINK	DW 0
	;}

	;MAIN MENU {
		MENU_PTR	DB 0
		STR_PLAY	DB "PLAY$"
		STR_EXIT	DB "EXIT$"
		STR_INST_1	DB "ARROWS = MOVE$"
		STR_INST_3	DB " DOTS = EAT$"
		STR_INST_2	DB "GHOSTS = BAD$"
	
		MENU_TXT_OFF	DW 0,0,0
		MENU_TXT_COL	DW 0,0,0
	;}
	
;}

	;{
		INCLUDE "Colors.asm" 
	;}

CODESEG
;{
	;PROCEDURES
	;{	
        INCLUDE "Graphics.asm"
		INCLUDE "MainMenu.asm"
        INCLUDE "Time.asm"
		INCLUDE "Timers.asm"
	;}

	;CODE:
		Start:

        ;INIT{ 		
			call graphics_Mode
		;}
		
		CALL MAINMENU
		
		;WAITS UNTIL YOU CHOOSE A DIRECTION {
			GetFirstDir:
			CALL GAME_INPUT
			CMP [DIR], DIR_N
			JZ  GetFirstDir
		;}
		
		Update:
		;{
			CALL GAME_INPUT	

            CALL CLOCK
		;}
		JMP  Update			
	
		Exit:
		call text_Mode
		
		MOV AX, 4C00H
		INT 21H
		
	END Start
	
