bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
; (a*2+b/2+e)/(c-d)+x/a; a - word; b,c,d - byte; e - doubleword; x - qword
segment data use32 class=data
    ; ...
    a DW 100
    b DB 8
    c DB 4
    d DB 2
    e DD 420
    x DQ 600
    y DW 0 ; aux
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov AL, 2
        mov AH, 0
        mul word [a] ; DX:AX = AX * a = 2 * a
        mov BX, AX
        mov CX, DX ; CX:BX = DX:AX = 2*a
        mov AL, [b]
        mov AH, 0
        mov DL, 2
        div DL ; AL = AX/DL = b/2
        mov AH, 0 
        mov DX, 0 ; AX:DX = b/2
        add AX, BX
        adc DX, CX ; DX:AX = DX:AX + CX:BX = b/2 + a*2
        add AX, word [e]
        adc DX, word [e+2] ;DX:AX = a*2+b/2+e
        mov BL, [c]
        sub BL, [d]
        mov BH, 0 ;BX = (c-d)
        div BX ; AX = DX:AX / BX = (a*2+b/2+e) / (c-d)
        mov [y], AX ; y=AX
        mov EAX, [x]
        mov EDX, [x+4] ; EDX:EAX = x
        mov BX, [a]
        mov CX, 0 ; CX:BX = a
        push CX
        push BX
        pop EBX ; EBX = a
        div EBX ; EAX = EDX:EAX / EBX = x/a
        mov BX, [y]
        mov CX, 0
        push CX
        push BX
        pop EBX ; EBX = y = (a*2+b/2+e)/(c-d)
        add EAX, EBX ; EAX = y + EAX = (a*2+b/2+e)/(c-d) + x/a
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
