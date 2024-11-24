TestWin:
    call SCAN_SCREEN 
    jc @@WIN         
    jmp @@END_PROC   

@@WIN:
    mov bx, GHOSTS
@@CLEAR_LOOP:
    call G_CLEAR
    add bx, [ARR_JMP]
    cmp bx, [ARR_END]
    jnz @@CLEAR_LOOP

    call LAYOUT_BLINK
    call NEW_LEVEL
    jmp @@END_PROC

@@END_PROC:
    ret

TestLose:
    push ax
    push bx
    mov bx, GHOSTS

@@COLL_LOOP:
    cmp [G_ENABLED], TRUE
    jnz @@END_LOSE 

    mov ax, [PACX]
    cmp ax, [G_X]
    jnz @@END_LOSE 

    mov ax, [PACY]
    cmp ax, [G_Y]
    jnz @@END_LOSE 

    cmp [IS_FRIGH], TRUE
    jz @@EAT 

    push 0Eh
    push 4000h
    call DELAY

    call DIE
    xor al, al
    mov ah, 0Ch
    int 21h
    add sp, 10
    jmp GetFirstDir 

@@EAT:
    call EAT_GHOST

@@END_LOSE:
    add bx, [ARR_JMP]
    cmp bx, [ARR_END]
    jnz @@COLL_LOOP

    pop bx
    pop ax
    ret

GAME_INPUT:
    push ax
    push cx
    push dx

    mov ah, 1
    int 16h
    jnz .NEWDATA
    jmp .END_PROC

.NEWDATA:
    mov ah, 0
    int 16h

    mov cx, [PACX]
    mov dx, [PACY]
    add cx, 4
    add dx, 4

    cmp ah, ARR_U
    jz .UP
    cmp ah, ARR_D
    jz .DOWN
    cmp ah, ARR_L
    jz .LEFT
    cmp ah, ARR_R
    jz .RIGHT
    cmp ah, 1   
    jz .PAUSE
    jmp .END_PROC

.PAUSE:
    push 29
    push 5
    call TEXT_SET_CURPOS
    push str_PAUSED
    call TEXT_PRINT_MSG

    push 27
    push 6
    call TEXT_SET_CURPOS
    push str_PAUSED_1
    call TEXT_PRINT_MSG

    push 26
    push 7
    call TEXT_SET_CURPOS
    push str_PAUSED_2
    call TEXT_PRINT_MSG

.PAUSE_LOOP:
    mov ah, 7
    int 21h
    cmp al, 'e'
    jnz .DONT_EXIT
    call END_GAME
    call MAINMENU

.DONT_EXIT:
    cmp al, 'r'
    jnz .PAUSE_LOOP
    push 208
    push 40
    push 96
    push 24
    push BLACK
    call GRAPHICS_PRINTRECT
    jmp .END_PROC

.UP:
    sub dx, 9
    mov ax, DIR_U
    jmp .UPDATE

.DOWN:
    add dx, 9
    mov ax, DIR_D
    jmp .UPDATE

.LEFT:
    sub cx, 9
    mov ax, DIR_L
    jmp .UPDATE

.RIGHT:
    add cx, 9
    mov ax, DIR_R

.UPDATE:
    push cx
    push dx
    call CLEAR_MOVE
    jnc .NEXTDIR
    mov [DIR], ax
    mov word [NEXTDIR], DIR_N
    jmp .END_PROC

.NEXTDIR:
    mov [NEXTDIR], ax

.END_PROC:
    xor al, al
    mov ah, 0Ch
    int 21h

    pop dx
    pop cx
    pop ax
    ret

EAT_GHOST:
    mov [G_ENABLED], 0
    mov [G_MODE], MODE_DEAD

    call G_CLEAR
    call PAC_ANIMATION

    push [EATGHOST]
    call UPDATE_SCORE
    shl word [EATGHOST], 1

    cmp [G_OBJ], OBJ_DOT
    jz .DOT
    cmp [G_OBJ], OBJ_PP
    jnz .END_PROC
    call EAT_PP
    jmp .END_PROC

.DOT:
    call EAT_DOT

.END_PROC:
    push 06h
    push 4000h
    call DELAY

    push 29
    push 13
    call TEXT_SET_CURPOS
    push BLACK
    push PRINT_DEC
    call TEXT_COLORSTR
    ret

UPDATE_SCORE:
    push bp
    mov bp, sp
    push ax

    mov ax, [bp+4]  
    add [SCORE], ax

    cmp byte [HP_FLAG], 1
    jz .PRINT_SCORE
    cmp [SCORE], 10000
    jb .PRINT_SCORE
    inc [LIVES]
    call PRINT_LIVES
    mov [HP_FLAG], 1

.PRINT_SCORE:
    push 29
    push 12
    call TEXT_SET_CURPOS
    push ARR_DEC
    push [SCORE]
    call HEX2DEC
    push ARR_DEC
    call TEXT_PRINTDEC

    cmp [bp+4], 50
    jbe .END_PROC
    push 29
    push 13
    call TEXT_SET_CURPOS
    push ARR_DEC
    push [bp+4]
    call HEX2DEC
    push ARR_DEC
    call TEXT_PRINTDEC

    push 29
    push 13
    call TEXT_SET_CURPOS
    push GREEN
    push PRINT_DEC
    call TEXT_COLORSTR

.END_PROC:
    pop ax
    pop bp
    ret 2

DIE:
    push bx

    mov [G_OBJ], OBJ_VOID

    dec [LIVES]
    call PRINT_LIVES

    mov bx, GHOSTS
.CLEAR:
    call G_CLEAR
    add bx, [ARR_JMP]
    cmp bx, [ARR_END]
    jnz .CLEAR

    call PLAY_LOSE_ANI

    call RESET_LIFE

    cmp [LIVES], 0
    jnz .PRINT_PAC
    call END_GAME
    call MAINMENU

.PRINT_PAC:
    call PAC_PRINT
    pop bx
    ret

PRINT_LIVES:
    push ax
    push cx

    push word 208
    push word 0
    push word 112
    push word 9
    push byte BLACK
    call GRAPHICS_PRINTRECT

    cmp word [LIVES], 0
    jz .end_proc

    mov cx, [LIVES]
    mov ax, 208     

.print_loop:
    push word PACMAN_R_2
    push byte YELLOW
    push word ax
    push word 0
    call GRAPHICS_PRINTIMAGE
    add ax, 10      
    loop .print_loop

.end_proc:
    pop cx
    pop ax
    ret

INPUT_LOOP:
.loop:
    call GAME_INPUT
    jmp .loop
    ret

NEW_LEVEL:
    inc word [LEVEL]

    cmp word [LEVEL], 1
    ja .diff_1
    call SET_DIFFICULTY_0
    jmp .reset_game

.diff_1:
    cmp word [LEVEL], 2
    ja .diff_2
    call SET_DIFFICULTY_1
    jmp .reset_game

.diff_2:
    cmp word [LEVEL], 3
    ja .diff_3
    call SET_DIFFICULTY_2
    jmp .reset_game

.diff_3:
    cmp word [LEVEL], 5
    ja .diff_4
    call SET_DIFFICULTY_3
    jmp .reset_game

.diff_4:
    cmp word [LEVEL], 7
    ja .diff_5
    call SET_DIFFICULTY_4
    jmp .reset_game

.diff_5:
    cmp word [LEVEL], 10
    ja .diff_6
    call SET_DIFFICULTY_5
    jmp .reset_game

.diff_6:
    call SET_DIFFICULTY_6

.reset_game:
    call LAYOUT_CLEAR
    call LAYOUT_PRINT_ALLDOTS
    mov ax, BLUE
    call LAYOUT_PRINT
    call RESET_LIFE
    call PAC_PRINT
    call PRINT_LIVES

    mov word [CNT_DOTS], 0
    mov byte [IS_FRIGH], 0
    mov word [EATGHOST], 200

    push word 29
    push word 11
    call TEXT_SET_CURPOS
    push word STR_SCORE
    call TEXT_PRINT_MSG

    push word 29
    push word 12
    call TEXT_SET_CURPOS
    push word ARR_DEC
    push word [SCORE]
    call HEX2DEC
    push word ARR_DEC
    call TEXT_PRINTDEC

    xor al, al
    mov ah, 0Ch
    int 21h

    add sp, 10     
    jmp GetFirstDir
    ret

PLAY_LOSE_ANI:
    push bx
    push cx

    call PAC_CLEAR
    call PAC_PRINT
    push word 2
    push dword 0BF20h
    call DELAY
    call PAC_CLEAR

    mov bx, LOSE_ANI
    mov cx, 6

.animation_loop:
    push word [bx]
    push byte YELLOW
    push word [PACX]
    push word [PACY]
    call GRAPHICS_PRINTIMAGE

    push word 2
    push dword 0BF20h
    call DELAY

    call PAC_CLEAR
    add bx, 2
    loop .animation_loop

.end_proc:
    pop cx
    pop bx
    ret

RESET_LIFE:
    push ax

    call G_ZERO
    call G_INIT

    mov ax, [SPEED]
    mov [INT_MOV], ax
    mov word [CNT_MOV], 0
    mov [INT_GMOV], ax
    mov word [CNT_GMOV], 0

    mov ax, [DUR_1ST_SCAT]
    mov [INT_MODE], ax
    mov word [CNT_MODE], 0

    mov ax, [DUR_CHASE]
    mov [INT_CHASE], ax
    mov ax, [DUR_SCAT]
    mov [INT_SCAT], ax

    mov ax, [DUR_FRI]
    mov [INT_FRI], ax
    mov word [CNT_FRI], 0
    mov word [CNT_BLINK], 0

    mov word [PACX], 99
    mov word [PACY], 144
    mov word [DIR], DIR_N
    mov word [NEXTDIR], DIR_N
    mov word [CNT_DOTS_TEMP], 0
    mov word [PAC_FP], 0

    pop ax
    ret
	