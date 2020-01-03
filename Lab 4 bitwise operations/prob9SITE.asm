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
    A DW 0111011101010111b
    B DB 10101111b
    C DD 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov AX, [A]
        And AX, 0000001111000000b
        SHR AX, 6
        Mov BX,0 
        OR BX, AX               ; x or 0 = x , x or 1 = 1  
        OR BX, 0000000000110000b
        MOV AL, [B]
        AND AL, 000000110b      ; x and 1 = x, x and 0 = 0
        SHL AL, 5
        OR BL, AL               ; the bits 6-7 of C are the same as the bits 1-2 of B
        OR BH, [A]
        
        ; now we use DX for the high word of C
        mov DX, 0
        
        OR DL, [A+1]
        OR DH, [B]
       
        push DX
        push BX
        POP EAX
        mov [C], EAX

        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
