bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
;Se dau 2 siruri de octeti S1 si S2 de aceeasi lungime. Sa se construiasca sirul D astfel incat fiecare element din D sa reprezinte minumul dintre elementele de pe pozitiile corespunzatoare din S1 si S2. 
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    S1 db 1, 3, 6, 2, 3, 7
    S2 db 6, 3, 8, 1, 2, 5
    len equ $-S2
    D times len db 0
    fmt db "%d", 10 ;format for print

; our code starts here
segment code use32 class=code
    start:
        mov ECX, len
        mov ESI, 0
        jecxz EndProg
        Repeat1:
                mov AL, [S1+ESI]
                mov BL, [S2+ESI]
                
                cmp AL,BL
                jb ifsmaller
                
                mov [D+ESI], BL
                jmp elseSmaller
                
                ifsmaller
                mov [D+ESI], AL
                
                elseSmaller
                mov AL, [D+ESI]
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
        push dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
