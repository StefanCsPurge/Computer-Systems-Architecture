bits 32
global buildSF
extern printf
import printf msvcrt.dll

segment data use32 class=data
    d resd 1
    a resd 1
segment code use32 class=code
    buildSF:
    mov ESI,[ESP+4]
    mov EDI,[ESP+8]
    mov ECX,[ESP+12]
    mov EBX,[ESP+16]
    mov dword[a],EBX ; saved the address of the lenSF 
    
    parseSIs:
        LODSD
        mov [d],EAX
        mov BL,0
        countHpairs:
            mov DL,AL ; lets work with DH and DL to avoid losing hexa digits from EAX
            
            add DL,1 ; the great checking
            mov DH,DL
            AND DH,0Fh
            shr DL,4
            cmp DH,DL
            jne nextB
            
            inc BL  ; we found a good hexa pair
            shr EAX,4
            
            nextB:
            shr EAX,4
            cmp EAX,0
            ja countHpairs
        cmp BL,2
        jb next
        mov EAX,[d]
        STOSD
        mov EBX,[a]
        inc dword[EBX]
        next:
        loop parseSIs
    ret