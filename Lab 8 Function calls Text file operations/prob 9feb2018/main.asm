bits 32
global start
extern exit,printf
import exit msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    s dq 1110111b,100000000h,0ABCD0002E7FCh,5
    lenS equ ($-s)/8
    r resd lenS
    bin resb 33
    inv resb 33
    pf db "%d",0
    pf2 db "%s ",0

segment code use32 class=code
    checkDegree:
        mov EDX,[ESP+4] ; the given number
        mov EBX,0 ; degree
        theWhile:
            mov EAX,7
            AND EAX,EDX
            cmp EAX,7 
            je shr3 ; we found a group of 3 '1's
            shr EDX,1
            jmp nextBits
            shr3:
            shr EDX,3
            inc EBX ; rank increases
            nextBits:
            cmp EDX,0
            ja theWhile
        cmp EBX,2
        jb false
        mov EAX,1
        jmp return
        false:
        mov EAX,0
        return:
        ret
     
    transformBinary:
        mov EBX,2
        mov EDI,0
        
        divLoop:
        mov EDX,0
        div EBX ; EAX div 2
        ADD DL,'0'
        mov [inv+EDI],DL ; add byte to inv str
        inc EDI
        cmp EAX,0
        ja divLoop
        
        mov EAX,EDI
        mov EDI,0
        reverse:
        dec EAX
        mov DL,[inv+EAX]
        mov [bin+EDI],DL
        inc EDI
        cmp EAX,0
        ja reverse
        mov byte[bin+EDI],0
        ret
    
    start:
    mov ECX,lenS
    mov ESI,0
    parseS:
        push ECX ;save ecx
        
        push dword[s+ESI] ; the inferior dword
        call checkDegree
        add ESP,4
        cmp EAX,0 ; if the function returned 0, then we don't have degree 2
        je next
        
        mov EAX,[s+ESI]
        call transformBinary
        push bin
        push pf2
        call [printf]
        add ESP,4*2
        
        next:
        add ESI,8
        pop ECX ; return the saved ECX
    loop parseS
    
    push 0
    call [exit]
