section .data

SPEED dw 0
DUR_1ST_SCAT dw 0
DUR_CHASE dw 0
DUR_SCAT dw 0
DUR_FRI dw 0

section .text
global SET_DIFFICULTY_0
global SET_DIFFICULTY_1
global SET_DIFFICULTY_2
global SET_DIFFICULTY_3
global SET_DIFFICULTY_4
global SET_DIFFICULTY_5
global SET_DIFFICULTY_6

SET_DIFFICULTY_0:
    mov word [SPEED], 4
    mov word [DUR_1ST_SCAT], 216  ; = 12s * 18
    mov word [DUR_CHASE], 270     ; = 15s * 18
    mov word [DUR_SCAT], 126      ; =  7s * 18
    mov word [DUR_FRI], 108       ; =  6s * 18
    ret

SET_DIFFICULTY_1:
    mov word [SPEED], 3
    mov word [DUR_1ST_SCAT], 180  ; = 10s * 18
    mov word [DUR_CHASE], 450     ; = 25s * 18
    mov word [DUR_SCAT], 90       ; = 5s  * 18
    mov word [DUR_FRI], 90        ; = 5s  * 18
    ret

SET_DIFFICULTY_2:
    mov word [SPEED], 3
    mov word [DUR_1ST_SCAT], 144  ; = 8s   * 18
    mov word [DUR_CHASE], 720     ; = 40s  * 18
    mov word [DUR_SCAT], 63       ; = 3.5s * 18
    mov word [DUR_FRI], 72        ; = 4s   * 18
    ret

SET_DIFFICULTY_3:
    mov word [SPEED], 2
    mov word [DUR_1ST_SCAT], 90   ; = 5s  * 18
    mov word [DUR_CHASE], 1080    ; = 60s * 18
    mov word [DUR_SCAT], 18       ; = 1s  * 18
    mov word [DUR_FRI], 54        ; = 3s  * 18
    ret

SET_DIFFICULTY_4:
    mov word [SPEED], 2
    mov word [DUR_1ST_SCAT], 54   ; = 3s   * 18
    mov word [DUR_CHASE], 5400    ; = 300s * 18
    mov word [DUR_SCAT], 9        ; = 0.5s * 18
    mov word [DUR_FRI], 45        ; = 2.5s * 18
    ret

SET_DIFFICULTY_5:
    mov word [SPEED], 2
    mov word [DUR_1ST_SCAT], 18   ; = 1s      * 18
    mov word [DUR_CHASE], 0FFFFh  ; = FFFFs   * 18
    mov word [DUR_SCAT], 1        ; = (1/18)s * 18
    mov word [DUR_FRI], 18        ; = 1s      * 18
    ret

SET_DIFFICULTY_6:
    mov word [SPEED], 2
    mov word [DUR_1ST_SCAT], 1    ; = (1/18)s * 18
    mov word [DUR_CHASE], 0FFFFh  ; = FFFFs   * 18
    mov word [DUR_SCAT], 1        ; = (1/18)s * 18
    mov word [DUR_FRI], 18        ; = 1s      * 18
    ret
