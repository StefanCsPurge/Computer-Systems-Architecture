bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
; compute: (a-b)+(c-b-d)+d
segment data use32 class=data
    ; ...
    a DB 2
    b DW 20
    c DD 200
    d DQ 2222
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov AX, word [c]
        mov DX, word [c+2] ; DX:AX = c
        mov BX, [b]
        mov CX, 0 ;CX:BX = b
        sub AX, BX
        sbb DX, CX ; DX:AX = c-b
        push DX
        push AX
        pop EAX ;EAX = c-b
        mov EDX, 0
        sub EAX, dword [d]
        sbb EDX, dword [d+4] ;EDX:EAX = c-b-d
        mov BL, [a]
        mov BH, 0
        mov CX, [b]
        sub BX, CX ; BX = a-b
        mov CX, 0
        push CX
        push BX
        pop EBX
        mov ECX, 0 ; ECX:EBX = a-b
        add EAX, EBX
        adc EDX, ECX ; EDX:EAX = (a-b) + (c-b-d)
        add EAX, dword [d]
        adc EDX, dword [d+4] ;EDX:EAX = (a-b) + (c-b-d) + d
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
