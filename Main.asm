.286
IDEAL
MODEL small
stack 600h
DATASEG
;{
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

CODESEG
;{
	;PROCEDURES
	;{	
		INCLUDE "MainMenu.asm"
	;}

	;CODE:
		Start:
		
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
		;}
		JMP  Update			
	
		Exit:
		call text_Mode
		
		MOV AX, 4C00H
		INT 21H
		
	END Start
	
