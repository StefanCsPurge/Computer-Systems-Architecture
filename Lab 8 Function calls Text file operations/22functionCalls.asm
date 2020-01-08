;22: Se citesc de la tastatura doua numere a si b. Sa se calculeze valoarea expresiei (a+b)*k, 
;k fiind o constanta definita in segmentul de date. Afisati valoarea expresiei (in baza 10).

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,scanf,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a resw 1
    b resw 1
    k equ 4
    r resd 0
    fmt1 db "a=",0
    fmt2 db "b=",0
    readFmt db "%d",0
    printFmt db "Valoarea expresiei este: %d",0

; our code starts here
segment code use32 class=code
    start:
        ;printf(“a=”)
        push dword fmt1
        call [printf]
        add ESP, 4*1
        ;call scanf("%d", a)
        push a
        push readFmt
        call [scanf]
        add ESP, 4*2
        
        ;printf(“b=”)
        push dword fmt2
        call [printf]
        add ESP, 4*1
        ;call scanf("%d", b)
        push b
        push readFmt
        call [scanf]
        add ESP, 4*2
        
        mov AX, [a]
        add AX, [b]
        mov CX, k
        imul CX
        mov [r], AX
        mov [r+2], DX
        
        push dword [r]
        push printFmt
        call [printf]
        add ESP, 4*2
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
