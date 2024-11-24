FILE_OPEN:
    push bp
    mov bp, sp
    
    mov dx, [bp + 6]        
    mov ah, 3Dh             
    mov al, 0               
    int 21h         
    
    jc  @@END_PROC         
    
    mov bx, [bp + 4]   
    mov [bx], ax            
    
@@END_PROC:
    pop bp
    ret 4                  

FILE_READ_OR_WRITE:
    push bp
    mov bp, sp
    
    mov bx, [bp + 4]      
    mov cx, [bp + 6]     
    mov dx, [bp + 8]   
    
    cmp word [bp + 10], WRITE  
    jz  @@WRITE

	; READ
    mov ah, 3Fh            
    mov al, 0             
    int 21h
    jmp @@END_PROC

@@WRITE:
    mov ah, 40h             
    int 21h

@@END_PROC:
    pop bp
    ret 8                   

FILE_CLOSE:
    push bp
    mov bp, sp
    
    mov ah, 3Eh             
    mov bx, [bp + 4]     
    int 21h

    pop bp
    ret 2                  

FILE_UPDATE_POINTER:
    push bp
    mov bp, sp
    
    mov ax, [bp + 10]      
    mov ah, 42h             
    mov bx, [bp + 4]       
    mov cx, [bp + 8]     
    mov dx, [bp + 6]   
    int 21h

@@END_PROC:
    pop bp
    ret 8                
