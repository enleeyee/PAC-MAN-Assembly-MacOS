section .data
CNT_MOV dw 0
INT_MOV dw 0
CNT_MODE dw 0
INT_MODE dw 0
IS_FRIGH db 0
PREV_MODE dw 0
ARR_JMP dw 0
ARR_END dw 0
G_DIR dw 0
MODE_SCAT dw 0
MODE_CHASE dw 0
MODE_DEAD dw 0
G_BLINK dw 0
G_MODE dw 0
CNT_FRI dw 0
INT_FRI dw 0
EATGHOST dw 0
SPEED dw 0
CNT_GMOV dw 0
INT_GMOV dw 0
CNT_BLINK dw 0
INT_BLINK dw 0

section .text
global TMR_MOVE, TMR_GMODE, TMR_FRIGH, TMR_GMOVE, TMR_BLINK

TMR_MOVE:
    push ax

    inc word [CNT_MOV]

    mov ax, [INT_MOV]
    cmp ax, [CNT_MOV]
    jz TMR_MOVE_TICK
    jmp TMR_MOVE_END

TMR_MOVE_TICK:
    mov word [CNT_MOV], 0
    call PAC_MOVE
    call TESTWIN
    call TESTLOSE

TMR_MOVE_END:
    pop ax
    ret

TMR_GMODE:
    push ax
    push bx

    mov al, [IS_FRIGH]
    dec al
    neg al
    xor ah, ah
    add [CNT_MODE], ax

    mov ax, [INT_MODE]
    cmp ax, [CNT_MODE]
    jz TMR_GMODE_TICK
    jmp TMR_GMODE_END

TMR_GMODE_TICK:
    mov word [CNT_MODE], 0
    mov bx, GHOSTS

    cmp word [PREV_MODE], MODE_SCAT
    jz TMR_GMODE_CHASE
    push word [INT_SCAT]
    pop [INT_MODE]
    mov ax, MODE_SCAT
    mov [PREV_MODE], ax
    jmp TMR_GMODE_LOOP

TMR_GMODE_CHASE:
    push word [INT_CHASE]
    pop [INT_MODE]
    mov ax, MODE_CHASE
    mov [PREV_MODE], ax

TMR_GMODE_LOOP:
    push ax
    mov [G_MODE], ax

    mov ax, [G_DIR]
    neg al
    neg ah
    mov [G_DIR], ax
    pop ax

    add bx, [ARR_JMP]
    cmp bx, [ARR_END]
    jnz TMR_GMODE_LOOP

TMR_GMODE_END:
    pop bx
    pop ax
    ret

TMR_FRIGH:
    push ax
    push bx

    mov al, [IS_FRIGH]
    xor ah, ah
    add [CNT_FRI], ax

    mov ax, [INT_FRI]
    sub ax, [CNT_FRI]
    cmp ax, 20
    ja TMR_FRIGH_DONT_BLINK
    call TMR_BLINK

TMR_FRIGH_DONT_BLINK:
    mov ax, [INT_FRI]
    cmp ax, [CNT_FRI]
    jz TMR_FRIGH_TICK
    jmp TMR_FRIGH_END

TMR_FRIGH_TICK:
    mov word [EATGHOST], 200
    mov word [CNT_FRI], 0
    mov byte [IS_FRIGH], 0
    mov word [G_BLINK], -1
    push word [SPEED]
    pop [INT_GMOV]

    mov bx, GHOSTS

TMR_FRIGH_DEAD_LOOP:
    cmp word [G_MODE], MODE_DEAD
    jnz TMR_FRIGH_DEAD_END
    push word [PREV_MODE]
    pop [G_MODE]

TMR_FRIGH_DEAD_END:
    add bx, [ARR_JMP]
    cmp bx, [ARR_END]
    jnz TMR_FRIGH_DEAD_LOOP

TMR_FRIGH_END:
    pop bx
    pop ax
    ret

TMR_GMOVE:
    push ax

    inc word [CNT_GMOV]

    mov ax, [INT_GMOV]
    cmp ax, [CNT_GMOV]
    jbe TMR_GMOVE_TICK
    jmp TMR_GMOVE_END

TMR_GMOVE_TICK:
    call TESTLOSE
    mov word [CNT_GMOV], 0
    call G_TARGET
    call G_MOVE
    call TESTLOSE

TMR_GMOVE_END:
    pop ax
    ret

TMR_BLINK:
    push ax
    push bx

    inc word [CNT_BLINK]

    mov ax, [INT_BLINK]
    cmp ax, [CNT_BLINK]
    jbe TMR_BLINK_TICK
    jmp TMR_BLINK_END

TMR_BLINK_TICK:
    mov word [CNT_BLINK], 0
    neg word [G_BLINK]

    mov bx, GHOSTS

TMR_BLINK_PRINT_LOOP:
    call G_PRINT
    add bx, [ARR_JMP]
    cmp bx, [ARR_END]
    jnz TMR_BLINK_PRINT_LOOP

TMR_BLINK_END:
    pop bx
    pop ax
    ret
