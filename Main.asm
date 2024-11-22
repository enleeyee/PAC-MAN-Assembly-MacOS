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

    ;Ghosts {
		Ghosts 		DW 56 dup (0)
		ARR_END 	DW 0
		ARR_JMP		DW 28
		IS_FRIGH	DB FALSE
		EATGHOST	DW 200
		PREV_MODE	DW MODE_SCAT
		G_BLINK		DW -1
		G_FRI_COL	DW 86h, 44h, WHITE_1, RED
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

    ;PacMan Vars {
		PACX			DW 99
		PACY			DW 144 
		DIR				DW DIR_N
		NEXTDIR			DW DIR_N
		LIVES			DW 4
	;}
	
;}

	;{
		INCLUDE "Colors.asm" 
	;}

CODESEG
;{
	;PROCEDURES
	;{	
        INCLUDE "Ghost.asm"
		INCLUDE "GhostAI.asm"
        INCLUDE "Graphics.asm"
		INCLUDE "MainMenu.asm"
        INCLUDE "Pacman.asm"
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
	
