bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
; Se da un sir de numere signed byte. Sa se salveze in alt sir numerele negative pare din acest sir.

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a db 4,1,-6,-4,-3,-2
    len_a equ $-a
    r times len_a db 0
    fmt db "%d ", 0 ; param for printf
; our code starts here
segment code use32 class=code
    start:
        mov ECX, len_a
        mov ESI, a
        mov EDI, r
        
        .loop
            cmp byte[ESI], 0
            JGE .nextEl ;if we dont have a neg nr, we jump to the next one
            
            mov AL, [ESI]
            test AL, 1 ;if the last bit if AL([ESI]) is 1, then the number is odd, and we jump to the next one
            JNZ .nextEl
            
            mov [EDI], AL
            inc EDI
            
            ;call printf
            push ECX
            cbw
            cwde
            push EAX
            push fmt
            call [printf]
            add ESP,4*2
            pop ECX
            
            .nextEl
            inc ESI
           
        loop .loop
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
