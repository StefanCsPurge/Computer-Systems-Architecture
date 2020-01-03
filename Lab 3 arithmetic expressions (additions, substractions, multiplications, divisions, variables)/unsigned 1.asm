bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    b db 2
    d db 200
    c dw 15
    e dq 80 
; a+b/c-d*2-e
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov AL, [b]
        mov AH, 0
        mov DX, 0
        div word [c] ; AX = DX:AX/c = b/c
        mov BX, AX
        mov AL, 2
        MUL byte [d]
        SUB BX, AX ; BX = b/c - d*2
        mov DX, 0 ; DX:BX = - || -
        ADD BX, WORD [a]   ; DX:BX = a+b/c-d*2
        ADC DX, WORD [a+2] ; both
        mov AX, BX
        ;trebe sa ajungem la EDX:EAX
        PUSH DX
        PUSH AX
        POP EAX
        mov EDX, 0
        SUB EAX, DWORD [e]
        SBB EDX, DWORD [e+4]
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
