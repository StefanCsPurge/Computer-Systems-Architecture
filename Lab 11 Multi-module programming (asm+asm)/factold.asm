; A program with a function that calculates factorial, in a single module.

bits 32 ; assembling for the 32 bits architecture
global start        

; declare external functions needed by our program
extern exit,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    n dd 5
    f db "factorial is %d",0

; our code starts here
segment code use32 class=code

    ;functia poate fi scrisa inainte de start sau dupa exit
    factorial:
    mov EAX, 1
    mov ECX, [ESP+4]
    .r:
        mul ECX ; EDX:EAX = ECX * EAX, dar presupunem ca rezultatul incape in EAX, deci il luam numa pe asta
    loop .r ; ECX-- , jmp to .r
    ret
    
    start:
        push dword[n]
        call factorial
        add esp,4*1
        push EAX
        push f
        call [printf]
        add ESP, 4*2
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
