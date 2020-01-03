bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
;Se da un sir de octeti S de lungime l. 
;Sa se construiasca sirul D de lungime l-1 astfel incat elementele din D sa reprezinte diferenta dintre fiecare 2 elemente consecutive din S. 
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    S db 1,2,4,6,10,20,25
    len equ $-S-1
    D times len db 0
    fmt db "%d", 10 ;format for print

; our code starts here
segment code use32 class=code
    start:
        mov ECX, len
        mov ESI, 0
        jecxz EndProg
        Repeat1:
                mov AL, [S+ESI+1]
                sub AL, [S+ESI]
                mov [D+ESI], AL
                inc ESI
                
                ;print element
                push ECX
                cbw
                cwde
                mov EBX, EAX
                push EBX
                push dword fmt
                call [printf]
                add esp, 4*2
                pop ECX
                
        loop Repeat1
                
        
        EndProg:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
