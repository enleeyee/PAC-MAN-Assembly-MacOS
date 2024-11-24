; Colors
black               equ 0000b
blue                equ 0011b
green               equ 0010b
cyan                equ 0001b
red                 equ 0100b
magenta             equ 0101b
brown               equ 0110b
yellow              equ 2Ch

army_green         equ 74h

light_gray         equ 0111b
dark_gray          equ 1000b

light_blue         equ 1001b
light_green        equ 1010b
light_cyan         equ 1011b
light_red          equ 1100b
pink               equ 1101b
light_brown        equ 1110b
orange             equ 2Ah
white              equ 1111b

clear_black        equ 10h

dark_red           equ 70h
pp_pink            equ 59h

dark_yellow        equ 2Bh
orange             equ 2Ah
white_1            equ 1Fh


; Scan Codes
ARR_U              equ 48h
ARR_D              equ 50h
ARR_L              equ 4Bh
ARR_R              equ 4Dh

SC_SPACE           equ 39h
SC_ENTER           equ 1Ch
SC_RSHFT           equ 36h


; Directions
DIR_U              equ 00F7h
DIR_D              equ 0009h
DIR_L              equ 0F700h
DIR_R              equ 0900h
DIR_N              equ 0000h

; Direction Indexes
IDIR_U             equ 0
IDIR_D             equ 1
IDIR_L             equ 2
IDIR_R             equ 3
IDIR_N             equ 4


; Locations
LOC_N              equ 0FFFFh


; Objects
OBJ_VOID           equ 0
OBJ_WALL           equ 1
OBJ_DOT            equ 2
OBJ_PP             equ 3


; Ghost Array
G_X                equ BX
G_Y                equ BX + 2

G_TARX             equ BX + 4
G_TARY             equ BX + 6

G_DIR              equ BX + 8
G_OBJ              equ BX + 10
G_COLOR            equ BX + 12
G_MODE             equ BX + 14

G_PDIR             equ BX + 16
G_PDIR_U           equ BX + 16
G_PDIR_D           equ BX + 18
G_PDIR_L           equ BX + 20
G_PDIR_R           equ BX + 22

G_MINDOTS          equ BX + 24
G_ENABLED          equ BX + 26


; Ghost Modes
MODE_SCAT          equ 0
MODE_CHASE         equ 1
MODE_FRIGH         equ 2
MODE_DEAD          equ 3


; MAIN_MENU
BTN_PLAY           equ 0
BTN_HELP           equ 1
BTN_EXIT           equ 2


; Boolean Values
TRUE               equ 1
FALSE              equ 0


; Files
READ               equ 0
WRITE              equ 1
READ_WRITE         equ 2

SOF                equ 0
CURRENT            equ 1
EOF                equ 2


; Clock
CLOCK_ADDRESS      equ WORD PTR ES:6Ch
