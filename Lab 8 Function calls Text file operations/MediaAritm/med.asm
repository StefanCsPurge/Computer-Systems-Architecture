bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fclose,fscanf,printf,fprintf   ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
import fscanf msvcrt.dll
import fprintf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file db "note.txt",0
    handle dd -1
    aMode db "a+",0
    fmt db "%d",0
    ffmt db `\nThe average is %d`,0
    nota dd 0
    cnt dw 0

; our code starts here
segment code use32 class=code
    start:
        mov BX,0
        ;fopen
        push aMode
        push file
        call [fopen]
        add ESP,4*2
        cmp EAX,0
        je theEnd
        mov [handle],EAX
        
        loop1:
        push nota  ;trebuie sa fie dword!!
        push fmt
        push dword[handle]
        call [fscanf]
        add ESP,4*3
        cmp EAX,-1
        je calcAverage
        add BX,[nota]
        inc word[cnt]
        jmp loop1
        
        calcAverage:
        mov DX,0
        mov AX,BX
        div word[cnt]  ;AX = DX:AX/cnt
        mov [nota],AX
        mov word[nota+2],0
        ;fprintf
        push dword[nota]
        push ffmt
        push dword[handle]
        call [fprintf]
        add ESP,4*1
        
        theEnd:
        ;fclose
        push dword[handle]
        call [fclose]
        add ESP,4
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
