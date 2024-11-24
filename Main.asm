section .data
    ; Clock & Timers
    CLOCK_BASE db 0

    INT_MOV dw 3
    CNT_MOV dw 0

    INT_GMOV dw 3
    CNT_GMOV dw 0

    INT_MODE dw 180
    CNT_MODE dw 0
    INT_CHASE dw 126
    INT_SCAT dw 72

    INT_FRI dw 126
    CNT_FRI dw 0

    INT_BLINK dw 5
    CNT_BLINK dw 0

    ; General (Levels and difficulty)
    SPEED dw 4
    DUR_1ST_SCAT dw 108
    DUR_CHASE dw 540
    DUR_SCAT dw 72
    DUR_FRI dw 54
    LEVEL dw 0

    ; Ghosts
    Ghosts dw 56 dup (0)
    ARR_END dw 0
    ARR_JMP dw 28
    IS_FRIGH db 0
    EATGHOST dw 200
    PREV_MODE dw 0
    G_BLINK dw -1
    G_FRI_COL dw 86h, 44h, 0, 4

    ; Images & Animations
    include "Images.asm"
    PAC_ANI_U dw 8 dup(0)
    PAC_ANI_D dw 8 dup(0)
    PAC_ANI_L dw 8 dup(0)
    PAC_ANI_R dw 8 dup(0)
    PAC_FP dw 0

    LOSE_ANI dw 6 dup(0)

    ; Layout & Dots
    CNT_DOTS dw 174
    CNT_DOTS_TEMP dw 0

    ; MAIN MENU
    MENU_PTR db 0
    STR_PLAY db "PLAY$"
    STR_EXIT db "EXIT$"
    STR_INST_1 db "ARROWS = MOVE$"
    STR_INST_3 db " DOTS = EAT$"
    STR_INST_2 db "GHOSTS = BAD$"

    MENU_TXT_OFF dw 0,0,0
    MENU_TXT_COL dw 0,0,0

    ; PacMan Vars
    PACX dw 99
    PACY dw 144
    DIR dw 0
    NEXTDIR dw 0
    LIVES dw 4

    ; UI
    printNumArr db 0,0,0,0,'$'
    Print_Dec db 0,0,0,0,0,'$'
    ARR_DEC db 0,0,0,0,0
    SCORE dw 0
    HP_FLAG db 0
    STR_GAMEOVER db 'GAME OVER!$'
    STR_SCORE db 'SCORE:$'
    STR_PAUSED db 'PAUSED$'
    STR_PAUSED_1 db 27h,'E',27h,' = EXIT$'
    STR_PAUSED_2 db 27h,'R',27h,' = RESUME$'

section .text
    global _start

_start:
    mov ax, 0x0
    mov ds, ax
    call graphics_Mode

    mov [ARR_END], offset Ghosts
    add word [ARR_END], 112

    ; UP
    mov bx, offset PAC_ANI_U
    mov [bx], offset PACMAN_0
    mov [bx + 2], offset PACMAN_U_1
    mov [bx + 4], offset PACMAN_U_2
    mov [bx + 6], offset PACMAN_U_3
    mov [bx + 8], offset PACMAN_U_3
    mov [bx + 10], offset PACMAN_U_2
    mov [bx + 12], offset PACMAN_U_1
    mov [bx + 14], offset PACMAN_0

    ; DOWN
    mov bx, offset PAC_ANI_D
    mov [bx], offset PACMAN_0
    mov [bx + 2], offset PACMAN_D_1
    mov [bx + 4], offset PACMAN_D_2
    mov [bx + 6], offset PACMAN_D_3
    mov [bx + 8], offset PACMAN_D_3
    mov [bx + 10], offset PACMAN_D_2
    mov [bx + 12], offset PACMAN_D_1
    mov [bx + 14], offset PACMAN_0

    ; LEFT
    mov bx, offset PAC_ANI_L
    mov [bx], offset PACMAN_0
    mov [bx + 2], offset PACMAN_L_1
    mov [bx + 4], offset PACMAN_L_2
    mov [bx + 6], offset PACMAN_L_3
    mov [bx + 8], offset PACMAN_L_3
    mov [bx + 10], offset PACMAN_L_2
    mov [bx + 12], offset PACMAN_L_1
    mov [bx + 14], offset PACMAN_0

    ; RIGHT
    mov bx, offset PAC_ANI_R
    mov [bx], offset PACMAN_0
    mov [bx + 2], offset PACMAN_R_1
    mov [bx + 4], offset PACMAN_R_2
    mov [bx + 6], offset PACMAN_R_3
    mov [bx + 8], offset PACMAN_R_3
    mov [bx + 10], offset PACMAN_R_2
    mov [bx + 12], offset PACMAN_R_1
    mov [bx + 14], offset PACMAN_0

    ; LOSE ANIMATION
    mov bx, offset LOSE_ANI
    mov [bx], offset PAC_LOSE_1
    mov [bx + 2], offset PAC_LOSE_2
    mov [bx + 4], offset PAC_LOSE_3
    mov [bx + 6], offset PAC_LOSE_4
    mov [bx + 8], offset PAC_LOSE_5
    mov [bx + 10], offset PAC_LOSE_6

    call MAINMENU

    GetFirstDir:
    call GAME_INPUT
    cmp word [DIR], 0
    jz GetFirstDir

    Update:
    call GAME_INPUT
    call G_CHECK_DOTS
    call CLOCK
    jmp Update

    Exit:
    call text_Mode
    mov ax, 0x4C00
    int 0x21
