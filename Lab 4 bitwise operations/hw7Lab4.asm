bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ... 7 th ex from lab 4
    A dw 1100110011110000b
    B dw 1001100101100110b
    C dd 0
    ; C should be 0000000001100101 1001111000011111 b
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov AX, 0 ; I'll use AX to construct the low word of C
        OR AX, 0000000000011111b ; the bits 0-4 of C have the value 1 
        
        mov BX, [A]
        AND BX, 0000000001111111b
        SHL BX, 5
        OR AX, BX ; the bits 5-11 of C are the same as the bits 0-6 of A
        
        ;the bits 16-31 of C have the value 0000000001100101b
        mov DX, 0000000001100101b ; I'll use DX to for the high word of C
        
        mov BX, [B]
        AND BX, 0000111100000000b
        SHL BX, 4
        OR AX, BX ; the bits 12-15 of C are the same as the bits 8-11 of B 
        
        mov [C], AX
        mov [C+2], DX ; put the result in C
        
        push DX
        push AX
        pop EAX ; too see the result
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
