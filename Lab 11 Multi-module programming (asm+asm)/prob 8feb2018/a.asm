bits 32
global start,r
extern exit,printf,maxBytes
import exit msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    s dd 1234A678h,12345678h,1AC3B47Dh,0FEDC9876h
    lenS equ ($-s)/4
    r times lenS db 0
    d resd 1
    sum resd 1
    pf db "%Xh ",0
    pf2 db `\nThe (signed) sum of these bytes is %d\n`,0

segment code use32 class=code
start:
    ;maxBytes(s,lenS)
    push lenS
    push s
    call maxBytes
    add ESP,4*2
    ;this will return in eax the sum of the max bytes
    mov [sum],EAX
    
    CLD
    mov ESI,s
    mov EDI,0
    ; now print these bytes using the damn string of byte ranks that was built using the function from b.asm
    printBytes:
        LODSD ; EAX = [ESI] , ESI+=4
        
        ;  V1: bits shift
        mov CL,0
        mov BL,4
        sub BL,[r+EDI]
        times 8 add CL,BL ; BL*8 :)))
        shr EAX,CL
        
        ;  V2: XLAT
        ;mov [d],EAX ; put in [d] the current dword
        ;mov EBX,d ; put its offset in EBX to use the amazing XLAT
        ;mov AL,4       ; because of little endian
        ;sub AL,[r+EDI] ; now we get the good position
        ;XLAT ; AL := [d+AL]
        
        movzx EAX,AL ; move the extracted byte in EAX
        ;now print the byte extracted from the current dword
        push EAX
        push pf
        call [printf]
        add ESP,4*2
        
        inc EDI
        cmp EDI,lenS
        jb printBytes
    
    ;print(pf,sum)
    push dword[sum]
    push pf2
    call [printf]
    add ESP,4*2
    
    jmp $ ; keeps your compiled exe open
    push dword 0
    call [exit]
    