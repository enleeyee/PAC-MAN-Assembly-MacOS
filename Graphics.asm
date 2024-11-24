section .data
MAX_X dw 0
MAX_Y dw 0

section .text
global GRAPHICS_PRINTRECT

GRAPHICS_PRINTRECT:
    push bp
    mov bp, sp

    sub sp, 4

    mov ax, [bp + 12]   
    add ax, [bp + 8]  
    mov [MAX_X], ax

    mov ax, [bp + 10]   
    add ax, [bp + 6]   
    mov [MAX_Y], ax

    mov ax, [bp + 4] 
    xor bx, bx
    mov ah, 0Ch
    mov dx, [bp + 10]   

@Yloop:
    mov cx, [bp + 12]

@Xloop:
    int 10h
    inc cx
    cmp cx, [MAX_X]
    jnz @Xloop

    inc dx
    cmp dx, [MAX_Y]
    jnz @Yloop

    pop bp
    ret 10

GRAPHICS_GETCOLOR:
    push bp
    mov bp, sp

    push cx
    push dx

    mov cx, [bp + 6]   
    mov dx, [bp + 4]   
    mov ah, 0Dh
    int 10h

    xor ah, ah

    pop dx
    pop cx
    pop bp
    ret 4

GRAPHICS_PRINTIMAGE:
    push bp
    mov bp, sp

    push ax
    push bx
    push cx
    push dx
    push si

    mov si, [bp + 10]  
    mov ax, [bp + 8]   
    add si, 9

    mov cx, [bp + 6]  
    mov dx, [bp + 4]  
    mov ah, 0Ch

@LOAD_BYTE:
    mov bh, 7
@PRINT_LOOP:
    push cx
    mov bl, [si]
    mov cl, bh
    shr bl, cl
    pop cx
    and bl, 1
    jz @EXIT_PRINT_LOOP
    int 10h

@EXIT_PRINT_LOOP:
    inc cx
    dec bh
    cmp bh, 0
    jnz @PRINT_LOOP

    inc dx
    inc si
    cmp si, [bp + 10] + 9
    jnz @LOAD_BYTE

    mov dx, [bp + 4]
    add cx, 8
    mov bh, 7
@PRINT_LASTCOL:
    push cx
    mov bl, [si]
    mov cl, bh
    shr bl, cl
    pop cx
    and bl, 1
    jz @EXIT_PRINT_LASTCOL
    int 10h

@EXIT_PRINT_LASTCOL:
    inc dx
    dec bh
    cmp bh, 0
    jnz @PRINT_LASTCOL

    cmp byte [si + 1], 0
    jz @@END_PROC
    int 10h

@@END_PROC:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 8

GRAPHICS_MODE:
    push ax
    mov ax, 13h
    int 10h
    pop ax
    ret
