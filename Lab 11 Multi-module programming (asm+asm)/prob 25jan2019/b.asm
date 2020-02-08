bits 32
extern r ;the resulting sequence
global longestOddSeq

segment data use32 class=data
    max dd 0 ;local variable, max len

segment code use32 class=code
longestOddSeq:
    
    mov ESI,[ESP+8] ;offset of s
    mov ECX,[ESP+4] ;lenS
    mov EBX,0 ; counter
    mov EDX,ESI ; sequence start
    CLD
    
    theFor:
        LODSB
        test AL,1 ; test parity
        jnz count; the AND is 0 if we had an even no
        cmp EBX,[max]
        jle noMax
        mov [max],EBX
        mov EDI,EDX ; put in EDI the offset of the max sequence
        noMax:
        mov EBX,-1
        mov EDX,ESI
        count:
        inc EBX
    loop theFor
    
    mov ESI,EDI ; ESI:=offset of the seq found in s
    mov EDI,r ; now we add this max seq to r
    mov ECX,[max]
    rep MOVSB ;byte EDI := byte ESI , ESI++ EDI++
    
    mov EAX,[max] ; EAX:=the max len
    ret