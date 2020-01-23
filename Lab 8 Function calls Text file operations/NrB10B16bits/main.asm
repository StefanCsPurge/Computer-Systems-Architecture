bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fclose,scanf,printf,fprintf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll
import fprintf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file db "numbers.txt",0
    no resd 1
    handle dd -1
    wMode db "w",0
    fmt db "%d",0
    ffmt db `D: %d, H: %X, no of 1 bits: %d\n`,0
    pf db "Insert number: ",0

; our code starts here
segment code use32 class=code
    start:
        ;fopen("numbers.txt","w")
        push wMode
        push file
        call [fopen]
        add ESP, 4*2
        cmp EAX, 0
        je theEnd
        mov [handle], EAX
        
        readLoop:
        ;printf
        push pf
        call [printf]
        add ESP,4
        ;scanf
        push no
        push fmt
        call [scanf]
        add ESP,4*2
        cmp EAX,0
        je theEnd
        cmp byte[no],0
        je theEnd
        mov EBX,0   ;contor
        mov EAX,[no]
        
        .count1:
        SHR EAX,1
        ADC EBX,0
        cmp EAX,0
        je print
        jmp .count1
        
        print:
        ;fprintf
        push EBX
        push dword[no]
        push dword[no]
        push ffmt
        push dword[handle]
        call [fprintf]
        add ESP,4*5
        jmp readLoop
        
        theEnd:
        ; fclose(FILE* handle)
        push dword [handle]
        call [fclose]
        add ESP, 4*1
        ; exit(0)
        push dword 0      ; push the parameter for exit onto the stack
        call [exit]       ; call exit to terminate the program
