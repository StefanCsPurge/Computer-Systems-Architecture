;Se da un fisier text. Sa se citeasca continutul fisierului, sa se contorizeze numarul de cifre impare si sa se afiseze aceasta valoare. Numele fisierului text este definit in segmentul de date. 

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fclose,fread,perror,printf               
import exit msvcrt.dll    
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
import perror msvcrt.dll
import printf msvcrt.dll                 

; our data is declared here (the variables needed by our program)
segment data use32 class=data
   file db "a.txt",0
   readMode db "r",0
   c db 0
   printFMT db "There are %d odd digits in the file.",0
   cnt dd 0
   handle dd -1
   theError db "error",0

; our code starts here
segment code use32 class=code
    start:
        push readMode
        push file
        call [fopen]
        add ESP, 4*2
        cmp EAX, 0
        je theEnd
        mov [handle], EAX
        
        repeat1:
        ;fread(str ptr, int size, int n, FILE * handle)
        push dword [handle]
        push 1
        push 1
        push c
        call [fread]
        add ESP, 4*4
        cmp EAX, 0
        je theEnd
        ;comparing in ASCII code to find out if we have a digit
        cmp byte [c], ':' 
        ja nextByte
        cmp byte [c], '/'
        jl nextByte
        ;testing with 1 to find out if we have an odd digit
        test byte [c], 1
        jz nextByte
        inc dword [cnt]
        nextByte:
        jmp repeat1
        
        theEnd:
        ; fclose(FILE* handle)
        push dword [handle]
        call [fclose]
        add ESP, 4*1
        ;print(cnt)
        push dword [cnt]
        push printFMT
        call [printf]
        add ESI, 4*2
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
