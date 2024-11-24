section .text
global G_TARGET, G_PRINT, G_CLEAR, G_GETPOSDIR, CLEAR_MOVE, G_NORMAL_AI, G_FRIGH_AI, G_MOVE, G_FINDOBJ, G_INIT, G_ENABLE, G_CHECK_DOTS, G_TRACE, G_ZERO

G_TARGET:
    push bx

    lea bx, [GHOSTS]

    cmp word [G_MODE], MODE_CHASE
    jz chase

    mov word [G_TARX], 198
    mov word [G_TARY], 0

    add bx, ARR_JMP
    mov word [G_TARX], 0
    mov word [G_TARY], 0

    add bx, ARR_JMP
    mov word [G_TARX], 198
    mov word [G_TARY], 189

    add bx, ARR_JMP
    mov word [G_TARX], 0
    mov word [G_TARY], 189
    jmp end_proc

chase:
    call RED_AI
    call PINK_AI
    call BLUE_AI
    call ORANGE_AI

end_proc:
    pop bx
    ret

G_PRINT:
    push cx
    push dx

    cmp word [G_ENABLED], FALSE
    jnz print_ghost
    jmp end_proc

print_ghost:
    cmp byte [IS_FRIGH], TRUE
    jz print_frightened

    push word GHOST_0
    push word [G_COLOR]
    push word [G_X]
    push word [G_Y]
    call GRAPHICS_PRINTIMAGE

    mov cx, [G_X]
    mov dx, [G_Y]

    inc cx
    add dx, 2
    push cx
    push dx
    push 3
    push 3
    push WHITE
    call GRAPHICS_PRINTRECT

    add cx, 4
    push cx
    push dx
    push 3
    push 3
    push WHITE
    call GRAPHICS_PRINTRECT

    cmp word [G_DIR], DIR_U
    jz eye_up

    cmp word [G_DIR], DIR_D
    jz eye_down

    cmp word [G_DIR], DIR_L
    jz eye_left

    jmp eye_right

eye_up:
    inc cx
    jmp eyeballs

eye_down:
    inc cx
    add dx, 2
    jmp eyeballs

eye_left:
    inc dx
    jmp eyeballs

eye_right:
    add cx, 2
    inc dx

eyeballs:
    push cx
    push dx
    push 1
    push 1
    push BLACK
    call GRAPHICS_PRINTRECT

    sub cx, 4
    push cx
    push dx
    push 1
    push 1
    push BLACK
    call GRAPHICS_PRINTRECT
    jmp end_proc

print_frightened:
    push si
    mov si, [G_BLINK]
    inc si
    shl si, 1
    add si, G_FRI_COL

    push word GHOST_0
    push word [si]
    push word [G_X]
    push word [G_Y]
    call GRAPHICS_PRINTIMAGE

    push word FRIGH_EYES
    push word [si + 2]
    push word [G_X]
    push word [G_Y]
    call GRAPHICS_PRINTIMAGE

    pop si

end_proc:
    pop dx
    pop cx
    ret

G_CLEAR:
    cmp word [G_ENABLED], TRUE
    jz enabled
    jmp end_proc

enabled:
    cmp word [G_X], 0
    jnz clear

    cmp word [G_Y], 0
    jnz clear
    jmp end_proc

clear:
    push word [G_X]
    push word [G_Y]
    push 9
    push 9
    push BLACK
    call GRAPHICS_PRINTRECT

    cmp word [G_OBJ], OBJ_DOT
    jz print_dot

    cmp word [G_OBJ], OBJ_PP
    jz print_pp

    jmp end_proc

print_dot:
    push word [G_X]
    push word [G_Y]
    call LAYOUT_PRINT_DOT
    jmp end_proc

print_pp:
    push word [G_X]
    push word [G_Y]
    call LAYOUT_PRINT_PP

end_proc:
    mov word [G_OBJ], OBJ_VOID
    ret

G_GETPOSDIR:
    push ax
    push cx
    push dx

    mov cx, [G_X]
    mov dx, [G_Y]
    
    cmp dx, 144
    je .check_x_up
    cmp dx, 72
    je .check_x_up
    jmp .down

.check_x_up:
    cmp cx, 90
    je .set_up_null
    cmp cx, 108
    jne .down

.set_up_null:
    mov word [G_PDIR_U], LOC_N
    jmp .down

.up_clear_check:
    sub dx, 9
    push cx
    push dx
    call CLEAR_MOVE
    jnc .down
    mov ah, cl
    mov al, dl
    mov [G_PDIR_U], ax

.down:
    mov cx, [G_X]
    mov dx, [G_Y]
    add dx, 9
    mov word [G_PDIR_D], LOC_N
    push cx
    push dx
    call CLEAR_MOVE
    jnc .left
    mov ah, cl
    mov al, dl
    mov [G_PDIR_D], ax

.left:
    mov cx, [G_X]
    mov dx, [G_Y]
    sub cx, 9
    cmp cx, 0xFFF7
    jne .no_overflow_left
    mov cx, 198
.no_overflow_left:
    push cx
    push dx
    call CLEAR_MOVE
    jnc .right
    mov ah, cl
    mov al, dl
    mov [G_PDIR_L], ax

.right:
    mov cx, [G_X]
    mov dx, [G_Y]
    add cx, 9
    cmp cx, 207
    jne .no_overflow_right
    mov cx, 0
.no_overflow_right:
    push cx
    push dx
    call CLEAR_MOVE
    jnc .back
    mov ah, cl
    mov al, dl
    mov [G_PDIR_R], ax

.back:
    mov ax, [G_DIR]
    neg al
    neg ah
    mov ch, byte [G_X]
    mov cl, byte [G_Y]
    add cl, al
    add ch, ah
    cmp ch, 0xF7
    je .overflow_left
    cmp ch, 207
    je .overflow_right
    jmp .after_overflow

.overflow_left:
    mov ch, 198
    jmp .after_overflow

.overflow_right:
    mov ch, 0

.after_overflow:
    mov ax, bx
    add ax, 16
    push cx
    push LOC_N
    push 4
    push ax
    call FINDNREP_W

.end_proc:
    pop dx
    pop cx
    pop ax
    ret

CLEAR_MOVE:
    push bp
    mov bp, sp
    push ax
    mov cx, [bp + 6]
    mov dx, [bp + 4]
    add cx, 4
    add dx, 4
    push cx
    push dx
    call GRAPHICS_GETCOLOR
    cmp al, blue
    je .not_clear
    stc
    jmp .clear_move_end

.not_clear:
    clc

.clear_move_end:
    pop ax
    pop bp
    ret 4

G_NORMAL_AI:
    push ax
    push di
    mov al, byte [G_TARY]
    mov ah, byte [G_TARX]
    xor di, di

.dist_loop:
    cmp word [G_PDIR + di], LOC_N
    je .end_dist
    push ax
    push word [G_PDIR + di]
    call MATH_DIST
    pop word [G_PDIR + di]

.end_dist:
    add di, 2
    cmp di, 8
    jne .dist_loop

.choose_dir:
    mov di, bx
    add di, 16
    push 4
    push di
    call FINDMIN_W
    pop di
    cmp di, IDIR_R
    je .dir_right
    cmp di, IDIR_D
    je .dir_down
    cmp di, IDIR_L
    je .dir_left

.dir_up:
    mov word [G_DIR], DIR_U
    jmp .normal_ai_end

.dir_down:
    mov word [G_DIR], DIR_D
    jmp .normal_ai_end

.dir_left:
    mov word [G_DIR], DIR_L
    jmp .normal_ai_end

.dir_right:
    mov word [G_DIR], DIR_R

.normal_ai_end:
    pop di
    pop ax
    ret

G_FRIGH_AI:
    push ax
    push di

    mov al, byte [PACY]
    mov ah, byte [PACX]
    xor di, di

.dist_loop:
    cmp word [G_PDIR + di], LOC_N
    je .end_dist

    push ax
    push word [G_PDIR + di]
    call MATH_DIST
    pop word [G_PDIR + di]

.end_dist:
    add di, 2
    cmp di, 8
    jne .dist_loop

    mov di, bx
    add di, 16
    push 4
    push di
    call FINDMAX_W
    pop di

    cmp di, IDIR_R
    je .right
    cmp di, IDIR_D
    je .down
    cmp di, IDIR_L
    je .left

.up:
    mov word [G_DIR], DIR_U
    jmp .end_proc

.down:
    mov word [G_DIR], DIR_D
    jmp .end_proc

.left:
    mov word [G_DIR], DIR_L
    jmp .end_proc

.right:
    mov word [G_DIR], DIR_R

.end_proc:
    pop di
    pop ax
    ret

G_MOVE:
    push bx
    push cx
    push dx

    mov bx, GHOSTS
.clear_loop:
    call G_CLEAR
    add bx, [ARR_JMP]
    cmp bx, [ARR_END]
    jne .clear_loop

    mov bx, GHOSTS
.move_loop:
    cmp word [G_ENABLED], 0
    je .end_move

    call G_GETPOSDIR
    cmp byte [IS_FRIGH], 1
    je .frigh_ai

    call G_NORMAL_AI
    jmp .move_ghost

.frigh_ai:
    call G_FRIGH_AI

.move_ghost:
    mov cx, [G_X]
    mov dx, [G_Y]

    add cl, byte [G_DIR + 1]
    add dl, byte [G_DIR]

    cmp cl, 0xF7
    je .overflow_l
    cmp cx, 207
    je .overflow_r
    jmp .test_obj

.overflow_l:
    mov cx, 198
    jmp .test_obj

.overflow_r:
    mov cx, 0

.test_obj:
    push cx
    push dx
    call G_FINDOBJ
    pop word [G_OBJ]

    mov [G_X], cx
    mov [G_Y], dx

.end_move:
    add bx, [ARR_JMP]
    cmp bx, [ARR_END]
    jne .move_loop

    mov bx, GHOSTS
.print_loop:
    call G_PRINT
    add bx, [ARR_JMP]
    cmp bx, [ARR_END]
    jne .print_loop

.end_proc:
    pop dx
    pop cx
    pop bx
    ret

G_FINDOBJ:
    push bp
    mov bp, sp
    push ax
    push bx

    %define PX_X word [bp + 6]
    %define PX_Y word [bp + 4]

    add PX_X, 4
    add PX_Y, 4
    push PX_X
    push PX_Y
    call GRAPHICS_GETCOLOR

    cmp al, BLUE
    je .wall
    cmp al, WHITE
    je .dot
    cmp al, PP_PINK
    je .pp
    cmp al, BLACK
    je .void

    sub PX_X, 4
    sub PX_Y, 4
    push PX_X
    push PX_Y
    call G_TRACE
    pop bx
    cmp bx, [ARR_END]
    je .void

    push word [G_OBJ]
    pop PX_X
    jmp .end_proc

.wall:
    mov PX_X, OBJ_WALL
    jmp .end_proc

.dot:
    mov PX_X, OBJ_DOT
    jmp .end_proc

.pp:
    mov PX_X, OBJ_PP
    jmp .end_proc

.void:
    mov PX_X, OBJ_VOID

.end_proc:
    pop bx
    pop ax
    pop bp
    ret 2

G_INIT:
    mov bx, GHOSTS

    mov word [G_MINDOTS], 0
    mov word [G_COLOR], RED
    add bx, [ARR_JMP]

    mov word [G_MINDOTS], 5
    mov word [G_COLOR], PINK
    add bx, [ARR_JMP]

    mov word [G_MINDOTS], 20
    mov word [G_COLOR], LIGHT_CYAN
    add bx, [ARR_JMP]

    mov word [G_MINDOTS], 60
    mov word [G_COLOR], ORANGE

    ret

G_ENABLE:
    mov word [G_ENABLED], TRUE
    mov word [G_X], 99
    mov word [G_Y], 72
    call G_PRINT
    ret

G_CHECK_DOTS:
    push bx
    mov bx, GHOSTS

.loop:
    cmp word [G_ENABLED], TRUE
    jz .end_loop

    cmp word [G_MODE], MODE_DEAD
    jz .end_loop

    mov ax, [CNT_DOTS_TEMP]
    cmp ax, [G_MINDOTS]
    jb .end_loop

    call G_ENABLE

.end_loop:
    add bx, [ARR_JMP]
    cmp bx, [ARR_END]
    jnz .loop

    pop bx
    ret

G_TRACE:
    push bp
    mov bp, sp

    %define PX_X word [bp + 6]
    %define PX_Y word [bp + 4]

    push bx
    push cx
    push dx

    mov bx, GHOSTS
    mov cx, PX_X
    mov dx, PX_Y

.trace_loop:
    cmp word [G_X], cx
    jz .check_y

.check_y:
    cmp word [G_Y], dx
    jnz .not_traced

    jmp .end_proc

.not_traced:
    add bx, [ARR_JMP]
    cmp bx, [ARR_END]
    jnz .trace_loop

.end_proc:
    mov PX_X, bx
    pop dx
    pop cx
    pop bx
    pop bp
    ret 2

G_ZERO:
    push bx
    push cx

    mov bx, GHOSTS
    mov cx, 56

.zero_loop:
    mov word [bx], 0
    add bx, 2
    loop .zero_loop

    pop cx
    pop bx
    ret
	