bits 32
global start
extern exit,printf
import exit msvcrt.dll
import printf msvcrt.dll

;find the smallest 3 numbers
segment data use32 class=data
    s dd 11,22,420,12,69,9999,1,45
    lenS equ ($-s)/4
    min dd 7FFFFFFFh ; max signed
    min2 dd 7FFFFFFFh
    min3 dd 7FFFFFFFh
    pf db "The top 3 min numbers are: %d %d %d",0
    
segment code use32 class=code
    start:
    mov ESI,s
   ; min2
    
    mov ECX,lenS
    forLoop:
        LODSD
        
        cmp EAX,[min]
        jge min_2
        mov EBX,[min2]
        mov [min3],EBX   ; min3 = min2
        mov EBX,[min] ; min2 = min1
        mov [min2],EBX
        mov [min],EAX ; min1 = EAX
        jmp endCmp
       
        min_2:
        cmp EAX,[min2]
        jge min_3
        mov EBX,[min2]
        mov [min3],EBX ; min3 = min2
        mov [min2],EAX ; min2 = EAX
        jmp endCmp
        
        min_3:
        cmp EAX,[min3]
        jge endCmp
        mov [min3],EAX ; min3 = EAX
        
        endCmp:
    loop forLoop
    
    push dword[min3]
    push EBX
    push dword[min]
    push pf
    call [printf]
    add ESP,4*4
    
    push dword 0
    call [exit]
    add ESP,4