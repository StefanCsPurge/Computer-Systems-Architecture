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
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov AL, [b]
        cbw
        cwd
        IDIV WORD [c]
        IMUL BYTE [d] ; AX = d*2
        mov AX, BX
        CWD ; DX:AX = b/c
        add BX, word [a]
        adc DX, word [a+2]
        mov AX, BX ;?
        push DX
        push AX
        pop EAX
        cdq    ; EDX:EAX
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
