section .data
printNumArr db 4 dup (0)

section .bss
print_dec resb 6

section .text
global TEXT_PRINT_NUM, TEXT_NEWLINE, TEXT_PRINT_MSG, TEXT_SET_CURPOS, TEXT_MODE, TEXT_PRINTDEC, TEXT_COLORSTR

TEXT_PRINT_NUM:
    push bp
    mov bp, sp

    sub sp, 2
    mov word [bp - 2], 0 

    pusha

    mov bx, printNumArr
    mov cx, 16
    mov ax, [bp + 4] 
    mov [bp - 2], bx
    add bx, 3

breakNum:
    xor dx, dx
    div cx
    mov [bx], dl
    dec bx
    cmp bx, [bp - 2]
    jge breakNum

    mov bx, printNumArr
    add bx, 3

ToAscii:
    cmp byte [bx], 9
    ja toLetter
    add byte [bx], '0'
    jmp exitToAscii

toLetter:
    add byte [bx], 37h 

exitToAscii:
    dec bx
    cmp bx, [bp - 2]
    jge ToAscii

    push printNumArr
    call TEXT_PRINT_MSG

    popa

    add sp, 2
    pop bp
    ret 2

TEXT_NEWLINE:
    push ax
    push dx

    mov dl, 0Ah
    mov ah, 2
    int 21h
    mov dl, 0Dh
    int 21h

    pop dx
    pop ax
    ret

TEXT_PRINT_MSG:
    push bp
    mov bp, sp

    push ax
    push dx

    mov dx, [bp + 4]
    mov ah, 9
    int 21h

    pop dx
    pop ax
    pop bp
    ret 2

TEXT_SET_CURPOS:
    push bp
    mov bp, sp

    push ax
    push bx
    push dx

    mov ah, 2
    mov dl, [bp + 6] 
    mov dh, [bp + 4] 
    xor bh, bh     
    int 10h

    pop dx
    pop bx
    pop ax
    pop bp
    ret 4

TEXT_MODE:
    push ax
    mov ax, 3
    int 10h
    pop ax
    ret

TEXT_PRINTDEC:
    push bp
    mov bp, sp

    push ax
    push bx
    push si
    push di

    mov si, [bp + 4]
    mov di, print_dec
    xor bx, bx

CopyArr:
    mov al, [si + bx]
    mov [di + bx], al
    inc bx
    cmp bx, 5
    jne CopyArr

    xor bx, bx

ToAscii:
    add byte [di + bx], '0'
    inc bx
    cmp bx, 5
    jne ToAscii

    xor bx, bx

CheckZero:
    cmp byte [di + bx], '0'
    jne PrintNum
    mov byte [di + bx], ' '
    inc bx
    cmp bx, 4
    jne CheckZero

PrintNum:
    push di
    call TEXT_PRINT_MSG

EndProc:
    pop di
    pop si
    pop bx
    pop ax
    pop bp
    ret 2

TEXT_COLORSTR:
    push bp
    mov bp, sp

    sub sp, 2
    mov word [bp - 2], 0 

    push ax
    push bx
    push cx
    push dx
    push si

    mov si, [bp + 4]
    mov bl, [bp + 6]
    xor bh, bh

TxtLoop:
    mov al, [si]
    cmp al, '$'
    jz EndProc
    mov ah, 9
    mov cx, 1
    int 10h
    inc si
    inc dx
    jmp TxtLoop

EndProc:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    add sp, 2
    pop bp
    ret 4
