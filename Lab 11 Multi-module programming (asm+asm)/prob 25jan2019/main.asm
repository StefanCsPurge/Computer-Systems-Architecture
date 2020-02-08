bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        
global r
; declare external functions needed by our program
extern exit,printf,longestOddSeq             
import exit msvcrt.dll    
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s db 12,13,10b,7,-3,100,101b,11h,27,-1,4
    lenS equ $-s
    pFmt db "%Xh ",0
    r resb 222

; our code starts here
segment code use32 class=code
    start:
        push s ; given string
        push lenS ; its length
        call longestOddSeq
        add ESP,4*2
        
        mov ECX,EAX ;the function returns in EAX the len of the r sequence
        JECXZ theEnd
        mov ESI,r
        
        .print:
        LODSB
        movzx EAX,AL
        push ECX
        push EAX
        push pFmt
        call [printf]
        add ESP,4*2
        pop ECX
        loop .print
        
        theEnd:
        jmp $
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
