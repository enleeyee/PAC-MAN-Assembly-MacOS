section .text
    global _start

_start:
    call LAYOUT_PRINT
    ret

LAYOUT_PRINT:
    ; Print top row (23x1)
    push 0        
    push 0        
    push 207     
    push 9        
    push ax       
    call GRAPHICS_PRINTRECT

    ; Print bottom row (23x1)
    push 0        
    push 189      
    push 207     
    push 9       
    push ax       
    call GRAPHICS_PRINTRECT

    ; Print left column (1x22)
    push 0       
    push 0       
    push 9       
    push 198     
    push ax      
    call GRAPHICS_PRINTRECT

    ; Print right column (1x21)
    push 198      
    push 0      
    push 9       
    push 198    
    push ax       
    call GRAPHICS_PRINTRECT

    ; Print left tunnel box (4x6)
    push 9        
    push 63       
    push 36       
    push 63       
    push ax       
    call GRAPHICS_PRINTRECT

    ; Print right tunnel box (4x6)
    push 162      
    push 63       
    push 36      
    push 63     
    push ax      
    call GRAPHICS_PRINTRECT

    ; Print tunnels left (5x1)
    push 0        
    push 90       
    push 45       
    push 9        
    push black    
    call GRAPHICS_PRINTRECT

    ; Print tunnels right (5x1)
    push 162      
    push 90      
    push 45      
    push 9       
    push black    
    call GRAPHICS_PRINTRECT

    ; Print top left rectangle (3x2)
    push 18   
    push 18      
    push 27      
    push 18      
    push ax  
    call GRAPHICS_PRINTRECT

	; Print top right rectangle (3x2)
    push 62   
    push 18      
    push 27      
    push 18      
    push ax  
    call GRAPHICS_PRINTRECT

    ; Print top left rectangle (4x2)
    push 54   
    push 18      
    push 36      
    push 18      
    push ax  
    call GRAPHICS_PRINTRECT

	; Print top right rectangle (4x2)
    push 117   
    push 18      
    push 36      
    push 18      
    push ax  
    call GRAPHICS_PRINTRECT

	; Print top left rectangle (4x2)
    push 54   
    push 18      
    push 36      
    push 18      
    push ax  
    call GRAPHICS_PRINTRECT

	; Print top right rectangle (4x2)
    push 117   
    push 18      
    push 36      
    push 18      
    push ax  
    call GRAPHICS_PRINTRECT

	; Print top left rectangle (3x1)
    push 18    
    push 45      
    push 27  
    push 9      
    push ax    
    call GRAPHICS_PRINTRECT

	; Print top right rectangle (3x1)
    push 162     
    push 45     
    push 27      
    push 9      
    push ax       
    call GRAPHICS_PRINTRECT

	; Print top left top vertical (1x5)
    push 54       
    push 45        
    push 9         
    push 45       
    push ax        
    call GRAPHICS_PRINTRECT

	; Print top left top horizontal (3x1)
    push 63        
    push 63        
    push 27       
    push 9        
    push ax       
    call GRAPHICS_PRINTRECT

	; Print top right top vertical (1x5)
    push 144       
    push 45        
    push 9        
    push 45       
    push ax       
    call GRAPHICS_PRINTRECT

	; Print top right top horizontal (3x1)
    push 117       
    push 63        
    push 27        
    push 9         
    push ax        
    call GRAPHICS_PRINTRECT

	; Print top middle top vertical (1x2)
    push 99        
    push 54        
    push 9        
    push 18       
    push ax        
    call GRAPHICS_PRINTRECT

	; Print top middle top horizontal (7x1)
    push 72        
    push 45        
    push 63        
    push 9        
    push ax       
    call GRAPHICS_PRINTRECT

	; Print bottom middle top vertical (1x2)
    push 99        
    push 126       
    push 9         
    push 18        
    push ax        
    call GRAPHICS_PRINTRECT

	; Print bottom middle top horizontal (3x1)
    push 72        
    push 117       
    push 63        
    push 9         
    push ax        
    call GRAPHICS_PRINTRECT

	; Print bottom middle rectangle (4x1)
    push 54        
    push 135       
    push 36       
    push 9         
    push ax        
    call GRAPHICS_PRINTRECT

	; Print middle left rectangle (1x2)
    push 54        
    push 99        
    push 9         
    push 27        
    push ax        
    call GRAPHICS_PRINTRECT

	; Print ghost house (7x2)
    push 72        
    push 81        
    push 63        
    push 27        
    push ax        
    call GRAPHICS_PRINTRECT

    ret

LAYOUT_CLEAR:
    push 0        
    push 0       
    push 320      
    push 200      
    push black    
    call GRAPHICS_PRINTRECT
    ret

LAYOUT_PRINT_DOT:
    add [esp + 6], 4    
    add [esp + 4], 4     

    ; Print the dot (1x1)
    push white        
    push 1               
    push 1              
    push [esp + 6]       
    push [esp + 4]        
    call GRAPHICS_PRINTRECT
    ret 4                 

LAYOUT_PRINT_PP:
    add [esp + 6], 3     
    add [esp + 4], 2  

    push pp_pink        
    push 5               
    push 3                
    push [esp + 6]       
    push [esp + 4]       
    call GRAPHICS_PRINTRECT

    dec [esp + 6]         
    inc [esp + 4]        

    push pp_pink         
    push 3                
    push 5                
    push [esp + 6]        
    push [esp + 4]        
    call GRAPHICS_PRINTRECT
    ret 4                 

LAYOUT_PRINT_ALLDOTS:
    push cx
    push dx

    mov dx, 9

    ALLDOT_Y:
        mov cx, 9

        ALLDOT_X:
            push cx
            push dx
            call LAYOUT_PRINT_DOT
            add cx, 9
            cmp cx, 198
            jb ALLDOT_X

        add dx, 9
        cmp dx, 189
        jb ALLDOT_Y

    push 63
    push 54
    push 63
    push 99
    push black
    call GRAPHICS_PRINTRECT

    mov dx, 18
    ALLDOT_PP_Y:
        mov cx, 9
        ALLDOT_PP_X:
            push cx
            push dx
            call LAYOUT_PRINT_PP
            add cx, 180
            cmp cx, 189
            jz ALLDOT_PP_X

        add dx, 117
        cmp dx, 135
        jz ALLDOT_PP_Y

    pop dx
    pop cx
    ret

BLINK_DELAY:
    push 4000h
    push 4h
    call DELAY
    ret

LAYOUT_BLINK:
    push ax
    push bx
    push cx

    push 4000h
    push 15h
    call DELAY

    mov cx, 4
    @@BLINK_LOOP:
        mov ax, white
        call LAYOUT_PRINT
        call BLINK_DELAY

        mov ax, blue
        call LAYOUT_PRINT
        call BLINK_DELAY
        loop @@BLINK_LOOP

    pop cx
    pop bx
    pop ax
    ret
