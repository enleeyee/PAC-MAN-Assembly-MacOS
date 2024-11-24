section .data
CLOCK_BASE db 0 

section .bss
Clock_Base resb 1  

section .text
global Clock, getMill, DELAY

Clock:
    call getMill
    sub dl, [CLOCK_BASE]
    cmp dl, 1
    jae @@Clock
    jmp @@END_PROC

@@Clock:
    call TMR_MOVE
    call PAC_ANIMATION
    call TMR_GMODE
    call TMR_FRIGH
    call TMR_GMOVE

    call getMill
    xchg [Clock_Base], dl

@@END_PROC:
    ret

getMill:
    push ax
    push bx
    push cx

    mov ah, 2Ch
    int 21h
    xor dh, dh

    pop cx
    pop bx
    pop ax
    ret

DELAY:
    push bp
    mov bp, sp

    push ax
    push cx
    push dx

    mov cx, [bp + 6]
    mov dx, [bp + 4] 
    mov ah, 86h
    int 15h

    pop dx
    pop cx
    pop ax
    pop bp
    ret 4
	