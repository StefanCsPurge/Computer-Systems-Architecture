%ifndef _PRIME_ASM_
%define _PRIME_ASM_

prime:
    mov EAX,[ESP+4]
    cmp EAX,1
    jle false
    cmp EAX,2
    je true
    mov ECX,EAX
    dec ECX
    
    .r:
    
    mov EDX,0
    idiv ECX ; EDX := EDX:EAX % ECX, EAX := EDX:EAX / ECX
    
    cmp EDX,0
    je false
    
    dec ECX
    cmp ECX,1
    je true
    mov EAX, [ESP+4]
    
    jmp .r
    
    false:
    mov EAX,0
    ret
    
    true:
    mov EAX,1
    ret

%endif