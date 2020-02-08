bits 32
global start        
extern exit,printf,longestSeq           
import exit msvcrt.dll
import printf msvcrt.dll


segment data use32 class=data
        s db 1,1,1,2,0,0,5,10,8,9,2,0,3,11,14,9,9,0
        lenS equ $-s
        pf db "%d ",0

segment code use32 class=code
    start:
        push s
        push lenS
        call longestSeq
        add ESP,4*2
        
        mov ESI,EAX
        
        printLoop:
        LODSB
        cmp AL,0
        je theEnd
        movzx EAX,AL
        push EAX
        push pf
        call [printf]
        add ESP,4*2
        jmp printLoop
        
        theEnd:
        ; exit(0)
        push    dword 0     
        call    [exit]      
