MATH_SQUARE:
    push bp
    mov bp, sp

    mov ax, [bp+4]
    push ax        
    push bx
    
    mov bx, ax
    imul bx
    mov [bp+4], ax
    
    pop bx
    pop ax
    pop bp
    ret

MATH_DIST:
    push bp
    mov bp, sp

    mov si, [bp+6] 
    mov di, [bp+4]  
    push ax
    push bx
    push cx

    xor ah, ah
    mov bl, 9
    mov ax, si
    xchg ah, al
    div bl
    mov cl, al

    mov ax, si
    xor ah, ah
    div bl
    mov ch, al
    mov si, cx

    xor ah, ah
    mov ax, di
    xchg ah, al
    div bl
    mov cl, al

    mov ax, di
    xor ah, ah
    div bl
    mov ch, al
    mov di, cx

    xor ah, ah
    mov ax, si
    xchg ah, al
    sub ax, di
    push ax
    call MATH_SQUARE
    pop ax

    xor bh, bh
    mov bx, si
    sub bx, di
    push bx
    call MATH_SQUARE
    pop si

    add si, ax
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4

FINDNREP_W:
    push bp
    mov bp, sp
    push ax
    push cx
    push di
    mov si, [bp+6]
    mov di, [bp+4]  
    mov ax, [bp+10] 
    mov bx, [bp+8]  

    @@REP_LOOP:
        repnz scasw
        jz @@END_PROC
        sub di, 2
        mov [di], bx
        jmp @@REP_LOOP

    @@END_PROC:
    pop di
    pop cx
    pop ax
    pop bp
    ret 8

FINDMIN_W:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si
    mov si, [bp+4] 
    mov cx, [bp+6] 
    xor bx, bx

    mov ax, [si+bx]
    @@MIN_LOOP:
        add bx, 2
        cmp bx, cx
        jnz @@MIN_LOOP
        cmp [si+bx], ax
        jge @@NEXT
        mov ax, [si+bx]

    @@NEXT:
        shr bx, 1
        mov [bp+6], bx
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2

HEX2DEC:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    mov si, [bp+6]  
    mov ax, [bp+4]  
    mov cx, 10
    xor dx, dx

    @@DIV_LOOP:
        div cx
        mov [si], dl
        dec si
        test ax, ax
        jnz @@DIV_LOOP

    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4

FINDMAX_W:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si
    mov si, [bp+4] 
    mov cx, [bp+6]  
    xor bx, bx

    mov ax, [si+bx]
    @@MAX_LOOP:
        cmp [si+bx], ax
        jle @@NEXT
        mov ax, [si+bx]
        mov cx, bx

    @@NEXT:
        add bx, 2
        cmp bx, cx
        jnz @@MAX_LOOP

        shr cx, 1
        mov [bp+6], cx
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2
	