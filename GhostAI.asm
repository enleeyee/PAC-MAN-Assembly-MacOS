RED_AI:
    push bx

    lea bx, [GHOSTS]

    mov ax, [PACX]
    mov [G_TARX], ax

    mov ax, [PACY]
    mov [G_TARY], ax

    pop bx
    ret

PINK_AI:
    push ax
    push bx
    push cx
    push dx

    lea bx, [GHOSTS]
    add bx, [ARR_JMP]

    mov ax, [PACX]
    mov dx, [PACY]
    mov cx, 3

@@TILE_LOOP:
    add al, [DIR + 1]
    add dl, [DIR]

    cmp al, 0F7h
    jz @@OVERFLOW_L

    cmp ax, 207h
    jz @@OVERFLOW_R
    jmp @@END_TILE

@@OVERFLOW_L:
    mov ax, 198h
    jmp @@END_TILE

@@OVERFLOW_R:
    mov ax, 0
    jmp @@END_TILE

@@END_TILE:
    loop @@TILE_LOOP

    mov [G_TARX], ax
    mov [G_TARY], dx

    pop dx
    pop cx
    pop bx
    pop ax
    ret

BLUE_AI:
    push ax
    push bx
    push cx
    push dx

    lea bx, [GHOSTS]

    mov cx, [PACX]
    mov dx, [PACY]

    sub cx, [G_X]
    sub dx, [G_Y]

    add bx, [ARR_JMP]
    add bx, [ARR_JMP]

    mov ax, [PACX]
    add ax, cx
    mov [G_TARX], ax

    mov ax, [PACY]
    add ax, dx
    mov [G_TARY], ax

    pop dx
    pop cx
    pop bx
    pop ax
    ret

ORANGE_AI:
    push ax
    push bx
    push cx

    lea bx, [GHOSTS]
    add bx, [ARR_JMP]
    add bx, [ARR_JMP]
    add bx, [ARR_JMP]

    mov al, [PACX]
    mov ah, [PACY]

    mov cl, [G_X]
    mov ch, [G_Y]

    push ax
    push cx
    call MATH_DIST
    pop ax

    cmp ax, 6
    jbe @@FALLBACK

    mov ax, [PACX]
    mov [G_TARX], ax

    mov ax, [PACY]
    mov [G_TARY], ax
    jmp @@END_PROC

@@FALLBACK:
    mov word [G_TARX], 198h
    mov word [G_TARY], 189h

    pop cx
    pop bx
    pop ax
    ret
