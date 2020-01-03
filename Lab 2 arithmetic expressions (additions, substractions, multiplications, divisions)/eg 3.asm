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
    a DB 30
    b DB 22
    c DB 100
    d DB 50
    e DW 123
    f DW 2
    x DW 0 bits 32 ; assembling for the 32 bits architecture

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov AL, [b]
        ;mov AH, 0
        mul BYTE [c]
        mov BX, [e]
        add BX, [f]
        sub AX, BX
        mov BL, [a]
        add BL, [d]
        div BL
        ;mov [x], AX
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
