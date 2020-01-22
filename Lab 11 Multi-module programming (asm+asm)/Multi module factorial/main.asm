bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf,scanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import scanf msvcrt.dll
; our data is declared here (the variables needed by our program)
%include "fact.asm" 
segment data use32 class=data
    n resd 1
    pFmt db "n=",0
    rFmt db "%d",0
    f db "factorial is %d",0

; our code starts here
segment code use32 class=code
    start:
        push dword pFmt
        call [printf]
        add ESP, 4*1
        
        ;scanf("%d",n)
        push n
        push rFmt
        call [scanf]
        add ESP, 4*2
        
        push dword[n]
        call factorial
        add esp,4*1
        push EAX
        push f
        call [printf]
        add ESP, 4*2
        
        jmp $ ;loop infinit ca sa ramana fereastra deschisa
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
        
