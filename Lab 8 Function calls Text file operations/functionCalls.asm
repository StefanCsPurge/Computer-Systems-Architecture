;LAB 8 / 4: Se dau doua numere naturale a si b (a, b: word, definite in segmentul de date). Sa se calculeze produsul lor si sa se afiseze in urmatorul format: "<a> * <b> = <result>"
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw -3
    b dw 7
    r dd 0
    printfmt db "%d * %d = %d",0
; our code starts here
segment code use32 class=code
    start:
        
        mov AX, [a]
        imul word [b]
        mov [r], AX
        mov [r+2], DX
        push dword [r]
        mov AX, [b]
        cwde
        push EAX
        mov AX, [a]
        cwde
        push EAX
        push dword printfmt
        call [printf]
        add ESP, 4*4
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
