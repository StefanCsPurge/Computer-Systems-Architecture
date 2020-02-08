
bits 32
global longestSeq        
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    max dd 0 ; local variable, max len

; our code starts here
segment code use32 class=code
    longestSeq:
    mov ESI,[ESP+8] ;offset of s
    mov ECX,[ESP+4] ;lenS
    mov EBX,0 ;counter
    mov EDX,ESI ;sequence start
    cld
        
    theFor:
        LODSB
        cmp AL,0
        jne count
        
        cmp EBX,[max]
        jle noMax
        mov [max],EBX
        mov EDI,EDX
        
        noMax:
        mov EBX,-1
        mov EDX,ESI
        count:
        inc EBX
    loop theFor
    
    mov EAX,EDI
    ret

;%ifndef _B_ASM_
;%define _B_ASM_
;%endif