;Write a program that reads a dword N, and N dword numbers.
;It will store the N numbers in an array. Then it will build a new string of bytes
;which contains the sum of even digits of each number from the first array.
;All dword numbers are in the interval [0,65535].
;Ex: N=4 -> 124,22,678,91 -> 6,4,14,0

bits 32 ; assembling for the 32 bits architecture
global start        

extern exit,scanf,printf               
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    N resd 1
    pf db "N=",0
    pf2 db "%d ",0
    sf db "%d",0
    b resd 1
    r resb 420 ;here I'll store the resulting string
    

segment code use32 class=code
    evenDigSum:
    mov EAX,[ESP+4] ;the number
    mov EBX,10
    mov ECX,0 ;sum
    
    divLoop:
        mov EDX,0
        div EBX ; EAX div 10
        test EDX,1 ;EDX has the digit, we test it's parity
        jnz nextDig
        add ECX,EDX
        nextDig:
        cmp EAX,0
        ja divLoop
       
    mov EAX,ECX
    ret
    
    start:
        ;printf(pf)
        push pf
        call [printf]
        add ESP,4
        ;scanf(sf,N)
        push N
        push sf
        call [scanf]
        add ESP,4*2
        
        mov EDI,r ;the resulting string of bytes
        mov ECX,[N]
        JECXZ theEnd
        CLD
        
        .read:
            push ECX
            push b
            push sf
            call [scanf]
            add ESP,4*2
            
            ;evenDigSum(b)
            push dword[b]
            call evenDigSum
            add ESP,4*1
            STOSB
            
            pop ECX
        loop .read
        
        mov ESI,r
        CLD
        mov ECX,[N]
        
        .printR:
        LODSB
        movzx EAX,AL
        push ECX
        push EAX
        push pf2
        call [printf]
        add ESP,4*2
        pop ECX
        loop .printR
        
        jmp $
        theEnd:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
