bits 32 
global start        
;R2. 
;Se da in data segment numele unui fisier. Acesta contine cifre separate prin spatiu 
;(cifrele sunt din multimea cifrelor bazei 16 separate). 
;Sa se afiseze fiecare cifra citita din fisier si numarul de biti 1 din reprezentarea binara a acesteia.
;input.txt 2 F 5 9 =>
;2 - 1
;F - 4
;5 - 2
;9 - 2
extern exit,printf,scanf,fread,fclose,fopen,fprintf,fscanf,fwrite            
import exit msvcrt.dll    
import printf msvcrt.dll
import scanf msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fscanf msvcrt.dll
import fwrite msvcrt.dll

segment data use32 class=data
    file db "t.txt",0
    handle dd -1
    rm db "r",0
    wm db "w",0
    sFmt db "%X",0
    cif resd 1
    pFmt db `%X - %d\n`,0 

; our code starts here
segment code use32 class=code
    start:
        ;fopen
        push rm
        push file
        call [fopen]
        add ESP, 4*2
        cmp EAX, 0
        je theEnd
        mov [handle], EAX
        
        readLoop:
        ;fscanf
        push cif
        push sFmt
        push dword[handle]
        call [fscanf]
        add ESP,4*3
        cmp EAX,-1
        je theEnd
        
        mov EBX,0   ;contor
        mov EAX,[cif]
        .count1:
        SHR EAX,1
        ADC EBX,0
        cmp EAX,0
        je print
        jmp .count1
        
        print:
        push EBX
        push dword[cif]
        push pFmt
        call [printf]
        add ESP,4*3
        
        jmp readLoop
        
        theEnd:
        ; fclose(FILE* handle)
        push dword [handle]
        call [fclose]
        add ESP, 4*1
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
