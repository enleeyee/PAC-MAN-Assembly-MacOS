section .data
    ARR_U db 0x48     
    ARR_D db 0x50          
    SC_SPACE db 0x20      
    SC_ENTER db 0x0D     
    RED db 0x04         
    WHITE db 0x07        
    MENU_PTR dw 0       
    MENU_TXT_COL db 0      

section .text
global _start

MENU_INPUT:
    push ax
    push bx

    mov ah, 1
    int 0x16             
    jnz NEWDATA        
    jmp END_PROC          
NEWDATA:
    mov ah, 0
    int 0x16              

    cmp ah, [ARR_U]        
    jz UP                  
    
    cmp ah, [ARR_D]        
    jz DOWN                 
    
    cmp ah, [SC_SPACE]     
    jz CLICK                
    
    cmp ah, [SC_ENTER]     
    jz CLICK                
    jmp END_PROC           

CLICK:
    call MENU_CLICK
    jmp END_PROC

UP:
    dec word [MENU_PTR]    
    jmp OVERFLOW           

DOWN:
    inc word [MENU_PTR]    
    jmp END_PROC

OVERFLOW:
    cmp word [MENU_PTR], 3
    jz MIN_PTR
    cmp word [MENU_PTR], 0
    jnz COLOR

MAX_PTR:
    mov word [MENU_PTR], 2
    jmp COLOR

MIN_PTR:
    mov word [MENU_PTR], 0

COLOR:
    mov bx, MENU_TXT_COL
    mov word [bx], WHITE
    mov word [bx + 2], WHITE
    mov word [bx + 4], WHITE

    mov bl, [MENU_PTR]
    xor bh, bh
    shl bx, 1
    add bx, MENU_TXT_COL
    mov word [bx], RED

END_PROC:
    xor al, al
    mov ah, 0x0C
    int 0x21               

    pop bx
    pop ax
    ret

MENU_PRINT_TITLE:
    push 113
    push 40
    push 95
    push 20
    push DARK_RED
    call GRAPHICS_PRINTRECT

    push 116
    push 43
    push 89
    push 14
    push 29h
    call GRAPHICS_PRINTRECT

    ; Print 'P'
    push LETTER_P
    push YELLOW
    push 120
    push 45
    call GRAPHICS_PRINTIMAGE

    ; Print 'A'
    push LETTER_A
    push YELLOW
    push 132
    push 45
    call GRAPHICS_PRINTIMAGE

    ; Print 'C'
    push PACMAN_R_2
    push YELLOW
    push 144
    push 45
    call GRAPHICS_PRINTIMAGE

    ; Print '-'
    push 157
    push 48
    push 7
    push 3
    push YELLOW
    call GRAPHICS_PRINTRECT

    ; Print 'M'
    push LETTER_M
    push YELLOW
    push 168
    push 45
    call GRAPHICS_PRINTIMAGE

    ; Print 'A'
    push LETTER_A
    push YELLOW
    push 180
    push 45
    call GRAPHICS_PRINTIMAGE

    ; Print 'N'
    push LETTER_N
    push YELLOW
    push 192
    push 45
    call GRAPHICS_PRINTIMAGE

    ret

MENU_PRINT_TEXT:
    push ax
    push bx
    push si
    push di

    mov ax, 15             
    mov si, MENU_TXT_OFF
    mov di, MENU_TXT_COL
    xor bx, bx

TEXT_LOOP:
    push 18
    push ax
    call TEXT_SET_CURPOS

    push [di + bx]
    push [si + bx]
    call TEXT_COLORSTR

    add ax, 2
    add bx, 2
    cmp bx, 6
    jnz TEXT_LOOP

    pop di
    pop si
    pop bx
    pop ax
    ret

MENU_CLICK:
    cmp word [MENU_PTR], BTN_PLAY
    jz PLAY

    cmp word [MENU_PTR], BTN_HELP
    jz HELP
    jmp EXIT

PLAY:
    call NEW_GAME
    ret

HELP:
    push 14
    push 9
    call TEXT_SET_CURPOS

    push STR_INST_1
    call TEXT_PRINT_MSG

    push 14
    push 10
    call TEXT_SET_CURPOS

    push STR_INST_2
    call TEXT_PRINT_MSG

    push 15
    push 11
    call TEXT_SET_CURPOS

    push STR_INST_3
    call TEXT_PRINT_MSG

    mov ah, 7
    int 0x21              

    push 112
    push 72
    push 104
    push 24
    push BLACK
    call GRAPHICS_PRINTRECT
    ret

MAINMENU:
    ; Menu initialization
    mov bx, MENU_TXT_OFF
    mov word [bx], STR_PLAY
    mov word [bx + 2], STR_HELP
    mov word [bx + 4], STR_EXIT

    mov bx, MENU_TXT_COL
    mov word [bx], RED
    mov word [bx + 2], WHITE
    mov word [bx + 4], WHITE

    ; Print the title
    push 0
    push 0
    push 320
    push 200
    push 68h
    call GRAPHICS_PRINTRECT

    push 85
    push 25
    push 150
    push 150
    push BLACK
    call GRAPHICS_PRINTRECT

    call MENU_PRINT_TITLE

MAINMENU_LOOP:
    call MENU_INPUT
    call MENU_PRINT_TEXT
    jmp MAINMENU_LOOP

    ret
