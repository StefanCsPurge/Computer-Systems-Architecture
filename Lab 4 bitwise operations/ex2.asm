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
    a DB 10110101b
    b DB 00011101b
    c DB 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov AL, [a]
        AND AL, 00001100b
        SHR AL, 2
        OR byte[c], AL
        mov BL, [b]
        NOT BL
        AND BL, 00000111b
        SHL BL, 2
        OR byte[c], BL
        AND byte[c], 10011111b
        OR byte[c], 10000000b
        mov CL, [c]
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
