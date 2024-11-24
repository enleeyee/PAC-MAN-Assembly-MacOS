PAC_MOVE:
    push cx
    push dx

    mov cx, [PACX]
    mov dx, [PACY]

    add cl, byte [DIR + 1]
    add dl, byte [DIR]

    cmp cl, 0F7h
    jz OVERFLOW_L
    cmp cx, 207
    jz OVERFLOW_R
    jmp IS_CLEAR_MOVE

OVERFLOW_L:
    mov cx, 198
    jmp PAC_PRINT

OVERFLOW_R:
    mov cx, 0
    jmp PAC_PRINT

IS_CLEAR_MOVE:
    push cx
    push dx
    call CLEAR_MOVE
    jnc CHECK_NEXT_DIR

PAC_PRINT:
    push cx
    push dx
    call PAC_EATDOTS
    call PAC_CLEAR
    mov [PACX], cx
    mov [PACY], dx
    call PAC_ANIMATION

CHECK_NEXT_DIR:
    cmp [NEXTDIR], DIR_N
    jz END_PROC

    mov cx, [PACX]
    mov dx, [PACY]

    add cl, byte [NEXTDIR + 1]
    add dl, byte [NEXTDIR]
    push cx
    push dx
    call CLEAR_MOVE
    jnc END_PROC
    movzx ax, word [NEXTDIR]
    mov [DIR], ax

END_PROC:
    pop dx
    pop cx
    call GAME_INPUT
    ret

PAC_PRINT:
    push PACMAN_0
    push YELLOW
    push word [PACX]
    push word [PACY]
    call GRAPHICS_PRINTIMAGE
    ret

PAC_CLEAR:
    push word [PACX]
    push word [PACY]
    push 9      
    push 9     
    push BLACK     
    call GRAPHICS_PRINTRECT
    ret

PAC_EATDOTS:
    push bp
    mov bp, sp
    push ax
    push bx

    add word [bp + 6], 4
    add word [bp + 4], 4
    push word [bp + 6]
    push word [bp + 4]
    call GRAPHICS_GETCOLOR

    cmp al, BLUE
    jz END_PROC
    cmp al, BLACK
    jz END_PROC
    cmp al, WHITE
    jz DOT
    cmp al, PP_PINK
    jz PP

    sub word [bp + 6], 4
    sub word [bp + 4], 4
    push word [bp + 6]
    push word [bp + 4]
    call G_TRACE
    pop bx
    cmp word [G_OBJ], OBJ_DOT
    jz DOT
    cmp word [G_OBJ], OBJ_PP
    jz PP

DOT:
    call EAT_DOT
    jmp END_PROC

PP:
    call EAT_PP

END_PROC:
    pop bx
    pop ax
    pop bp
    ret 4

PAC_ANIMATION:
    push ax
    push bx
    call PAC_CLEAR

    cmp [PAC_FP], 16
    jnz CHECK_DIR
    mov [PAC_FP], 0

CHECK_DIR:
    cmp [DIR], DIR_U
    jz UP
    cmp [DIR], DIR_D
    jz DOWN
    cmp [DIR], DIR_L
    jz LEFT
    cmp [DIR], DIR_R
    jz RIGHT
    jmp END_PROC

UP:
    mov bx, PAC_ANI_U
    jmp PRINT_PAC

DOWN:
    mov bx, PAC_ANI_D
    jmp PRINT_PAC

LEFT:
    mov bx, PAC_ANI_L
    jmp PRINT_PAC

RIGHT:
    mov bx, PAC_ANI_R

PRINT_PAC:
    add bx, [PAC_FP]
    push [bx]
    push YELLOW
    push word [PACX]
    push word [PACY]
    call GRAPHICS_PRINTIMAGE

END_PROC:
    pop bx
    pop ax
    add word [PAC_FP], 2
    ret

EAT_PP:
    mov [IS_FRIGH], 1
    mov word [CNT_FRI], 0
    mov word [G_BLINK], -1
    mov ax, [SPEED]
    inc ax
    mov [INT_GMOV], ax
    inc word [CNT_DOTS]
    inc word [CNT_DOTS_TEMP]
    push 50
    call UPDATE_SCORE

    mov bx, GHOSTS
TURN_LOOP:
    neg byte [bx + G_DIR]
    neg byte [bx + G_DIR + 1]
    add bx, ARR_JMP
    cmp bx, ARR_END
    jnz TURN_LOOP

    ret

EAT_DOT:
    inc word [CNT_DOTS]
    inc word [CNT_DOTS_TEMP]
    push 10
    call UPDATE_SCORE
    ret
	