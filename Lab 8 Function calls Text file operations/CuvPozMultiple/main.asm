bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,scanf,printf,fopen,fscanf,fclose               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file resd 9
    no resb 1
    cnt dw 0
    currW resd 9
    handle dd -1
    rMode db "r",0
    rfmt db "%s",0
    rfmt2 db "%d",0
    pfmt db `%s\n`,0
    pfmt1 db "Insert file name: ",0
    pfmt2 db `\nInsert number: `,0
    msg db 'ok',0
    

; our code starts here
segment code use32 class=code
    start:
        ;printf
        push pfmt1
        call [printf]
        add ESP,4
        ;scanf
        push file
        push rfmt
        call [scanf]
        add ESP,4*2
        ;printf
        push pfmt2
        call [printf]
        add ESP,4
        ;scanf
        push no
        push rfmt2
        call [scanf]
        add ESP,4*2
        
        ;fopen
        push rMode
        push file
        call [fopen]
        add ESP,4*2
        cmp EAX,0
        je theEnd
        mov [handle],EAX
        
        readLoop:
        ;fscanf
        push currW
        push rfmt
        push dword[handle]
        call [fscanf]
        add ESP,4*3
        cmp EAX,-1
        je theEnd
        inc word[cnt]  ; position works like a charm!
        mov AX,[cnt]
        div byte[no] ; check if pos is multiple of no
        cmp AH,0
        jne nextWord
        push currW
        push pfmt
        call [printf]
        add ESP,4
        nextWord:
        jmp readLoop
        
        theEnd:
        ;fclose
        push dword[handle]
        call [fclose]
        add ESP,4
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
