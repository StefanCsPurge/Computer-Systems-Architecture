bits 32
global _factorial
segment data public data use32
segment code public code use32
_factorial:
	push ebp
	mov ebp,esp
	sub esp, 4                   
	mov eax, [ebp+8] 
	cmp eax,2
	jbe   .trivial
	.recursiv:
		dec  eax
		push eax
		call _factorial
		add  esp, 4    
		mov  [ebp-4], eax   ; m = (n-1)!
		mov  eax, [ebp+8]   ; n
		mul  dword [ebp-4]  ; edx:eax ? n * m
		jmp  .final
	.trivial:
		xor  edx, edx     
	.final:
	add esp, 4
    mov esp, ebp
    pop ebp
    ret