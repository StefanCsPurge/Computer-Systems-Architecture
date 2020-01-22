bits 32
global _prime
segment code public code use32
_prime:
    push ebp
	mov ebp,esp
    mov EAX,[EBP+8]
    cmp EAX,1
    jle false
    cmp EAX,2
    je true
    mov ECX,EAX
    dec ECX
    
    .r: ; start of the for
    
    mov EDX,0
    idiv ECX ; EDX := EDX:EAX % ECX, EAX := EDX:EAX / ECX
    
    cmp EDX,0
    je false
    
    dec ECX
    cmp ECX,1
    je true
    mov EAX, [EBP+8]
    
    jmp .r ; end of the for
    
    false:
    mov EAX,0
    mov esp, ebp
    pop ebp
    ret
    
    true:
    mov EAX,1
    mov esp, ebp
    pop ebp
    ret