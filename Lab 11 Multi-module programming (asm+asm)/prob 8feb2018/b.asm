bits 32
extern r
global maxBytes

segment data use32 class=data
    max resb 1 ; used to calculate the max byte
    maxr resb 1 ; local variable used by the function

segment code use32 class=code
    maxBytes:
    mov ESI, [ESP+4] ; s parameter
    mov ECX, [ESP+8] ; lenS parameter
    mov EBX,0 ;initialize sum 
    mov EDI,r ;string from a.asm that will store the max bytes ranks
    CLD
    
    parseS:
        push ECX ; save ECX cuz we gonna need it l8r
        LODSD ; put in EAX the current dword
        mov CL,4 ; this will be our byte index
        mov byte[max],0 ; initialize max byte
        findMax:
            cmp AL,[max] ;start with the lowest byte
            jbe next
            mov [max],AL
            mov [maxr],CL ; save the rank from CL
            next:
            shr EAX,8
            dec CL
            cmp CL,0 ; check if we interated over all the 4 bytes of the dword
            ja findMax
        
        mov AL,[maxr] ;copy in AL the rank of the max byte
        STOSB ; store the rank in r
        movsx EAX,byte[max] ; in [max] we have the max byte
        add EBX,EAX ; add the signed byte to the sum
        pop ECX  ; restore the saved ECX
    loop parseS
    
    mov EAX,EBX ; ret the signed sum in EAX
    ret