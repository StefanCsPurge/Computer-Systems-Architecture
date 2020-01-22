bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf,fread,fclose,fopen,fprintf
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
import fopen msvcrt.dll
import fprintf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file db "mesaj.txt",0
    rMode db "a+",0
    handle dd -1
    c db 0
    msg db "ok",0
    fmt db "%c",0
    fmt2 db "%d ",0
    ok db 0
    ffmt db `\nDecoded message:\n`,0
    result resb 222
    

; our code starts here
segment code use32 class=code
    start:
        mov EDI, result
        ;fopen
        push rMode
        push file
        call [fopen]
        add ESP,4*2
        cmp EAX,0
        je theEnd
        mov [handle],EAX
        
        loop1:
        ;fread
        push dword[handle]
        push 1
        push 1
        push c
        call [fread]
        add ESP,4*4
        cmp EAX,0
        je theEnd
        
        mov AL,0
        cmp byte[c],'a'
        jb notLetter1
        cmp byte[c],'z'
        ja notLetter1
        jmp letter
        notLetter1:
        cmp byte[c],'A'
        jb print
        cmp byte[c],'Z'
        ja print
        mov AL,1 ;if we have uppercase
        add byte[c],32
        
        letter:
        sub byte[c],2
        cmp byte[c],'a' ; check if letter is out of range
        jae checkUpper
        add byte[c],26
        checkUpper:
        cmp AL,0 ; check if we had uppercase
        je print
        sub byte[c],32
        
        print:
        push dword[c]
        push fmt
        call [printf]
        add ESP,4*2
        
        mov AL,byte[c]
        STOSB
        
        jmp loop1
        
        theEnd:
        ;fprintf
        push ffmt
        push dword[handle]
        call [fprintf]
        add ESP,4*2
        
        mov ESI,result
        
        loop2:
        mov EAX,0
        LODSB
        cmp AL,0
        je closeFile
        push EAX
        push fmt
        push dword[handle]
        call [fprintf]
        add ESP,4*2
        jmp loop2
        
        closeFile:
        ;fclose
        push dword[handle]
        call [fclose]
        add ESP,4
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
