;Dandu-se 2 siruri de dublucuvinte, creeaza-l pe al 3-lea in felul urmator:

;    Pana la lungimea sirului cel mai mic, 
;    sa se completeze cu elementele reprezentand numarul de biti de 1 
;    in cel mai mare cuvant de acelasi rang. 

;    Pana la lungimea sirului cel mai lung, 
;    se va completa cu elementele din sirul cel mai lung 
;    in ordine inversa.


bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s1 dd 1,2,3
    l1 equ ($-s1)/4
    s2 dd 2,3,1,4,5
    l2 equ ($-s2)/4
    r dd 0,0,0,0,0 ;1,2,2,5,4
    fmt db "%d", 10 ;format for print
    
; our code starts here
segment code use32 class=code
    start:
        
        mov EAX, l1
        cmp EAX, l2
        jg change
        jle keep
        change:
        mov EAX, l2 
        keep  
        mov ECX, EAX ;ECX = length of the shortest list
        mov ESI, 0 ;source index
        
        repeta:
        
        mov EBX, [s1+ESI] ;elem of the first list
        cmp EBX, [s2+ESI] ;compare elem from the list that are at the same index
        jg gr ; jump to gr if s1[ESI] > s2[ESI]
        mov EBX, [s2+ESI]
        
        gr:
        mov DL, 0 ;contor for 1 bits
        push ECX ;save ECX of the previous loop
        mov ECX, 32 ;a dword has 32 bits
        b:
        test EBX, 1
        jz nextb ; jump to nextb if the last bit of EBX was not 1
        inc DL ;DL++ if we found a 1 bit
        nextb:
        SHR EBX,1
        loop b
        
        mov [r+ESI],DL
        add ESI,4
        
        pop ECX
        loop repeta
        
        
        ;add the remaining elements from the longest list in reverse order
        cmp EAX,l1
        je otherList
        mov EDI, 4*(l1-1)
        mov EDX, EDI
        mov ECX, l1
        
        repeta1:
        cmp ESI,EDX
        jg theEnd
        mov EBX, [s1+EDI]
        mov [r+ESI],EBX
        add ESI,4
        sub EDI,4
        jmp repeta1
        
        jmp theEnd
        
        otherList:
        mov EDI, 4*(l2-1)
        mov EDX, EDI
        mov ECX, l2 ;keep in ECX the length of the longest list
        
        repeta2:
        cmp ESI,EDX
        jg theEnd
        mov EBX, [s2+EDI]
        mov [r+ESI],EBX
        add ESI,4
        sub EDI,4
        jmp repeta2
        
        theEnd:
        
        ;print r
        mov ESI,r
        cld
        printLoop:
        push ECX
        LODSD
        push EAX
        push fmt
        call [printf]
        add ESP, 4*2
        pop ECX
        loop printLoop
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program