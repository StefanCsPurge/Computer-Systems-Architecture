bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program

; our data is declared here (the variables needed by our program)
extern exit,fopen,fclose,fscanf,printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fscanf msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    file db "info.txt",0
    readMode db "r",0
    readFmt db "%c",0
    handle dd -1
    v times 255 dd 0
    chr db 0,0
    pf db `\nSpecial chr %c has the max frequency: %d.`,0
    pf2 db `Special chr: '%c', position: %d, frequency: %d\n`,0

; our code starts here
segment code use32 class=code
    start:
        ;fopen("info.txt","r")
        push readMode
        push file
        call [fopen]
        add ESP, 4*2
        cmp EAX, 0
        je theEnd
        mov [handle], EAX
    
        ;pt a descoperi frecventa folosim un vector de frecvente
        readLoop:
            ;fscanf(handle,readFmt,chr)
            push chr
            push readFmt
            push dword[handle]
            call [fscanf]
            add ESP,4*3
            cmp EAX,-1
            je end_text
            
            mov EAX,0
            mov AL,[chr]
            
            cmp AL,'0'
            jb .not_dig
            cmp AL,'9'
            ja .not_dig
            jmp readLoop
            
            .not_dig:
            cmp AL,'a'
            jb .not_chr
            cmp AL,'z'
            ja .not_chr
            jmp readLoop
            
            .not_chr:
            inc dword[v+EAX*4] ; formula offsetului unui operand!!! v+4*nr bytes
            mov EDX,[v+EAX*4]
            push EDX
            push EAX
            push EAX
            push pf2
            call [printf]
            add ESP,4*4
            
        jmp readLoop
        
        end_text:
        
        mov ESI,v
        mov ECX,0 ;index
        mov EDX,0 ;EDX - letter pos in ASCII
        mov EBX,0 ;EBX - maxim
        
        parse_v:
        LODSD ; EAX = ESI , ESI+=4
        cmp EAX,EBX
        jb next
        mov EBX,EAX
        mov EDX,ECX
        next:
        inc ECX
        cmp ECX,255
        jb parse_v
        
        push EBX
        push EDX
        push pf
        call [printf]
        add ESP,4*3
        
        theEnd:
        ; fclose(FILE* handle)
        push dword [handle]
        call [fclose]
        add ESP, 4*1
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
