; LAB 6, 9
;A list of doublewords is given. Starting from the low part of the doubleword, 
;obtain the doubleword made of the high even bytes of the low words of each doubleword from the given list.
;If there are not enough bytes, the remaining bytes of the doubleword will be filled with the byte FFh

bits 32 ; assembling for the 32 bits architecture
; declare the EntryPoint (a label defining the very first instruction of the program)
global start 
; declare external functions needed by our program
extern exit,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s DD 12345678h, 1A2C3C4Dh, 98FCDD76h, 12783A2Bh
    lenS equ ($-s)/4
    d DD 0
    complete db 0FFh ;255
    fmt db "The result in hexa is: %x",0
; our code starts here
segment code use32 class=code
    start:
        mov dx,0
        mov ESI,s
        cld
        mov ECX, lenS
        mov EDI, d
        
        repeat1:
        LODSD ;EAX = ESI, ESI+=4 
        test AH,1 ; and AH, 00000001
        jnz nextDW
        mov AL, AH
        STOSB
        inc dx
        nextDW:
        loop repeat1
        
        repeat2:
        cmp dx,4
        jae theEnd
        mov AL, [complete]
        STOSB
        inc dx
        jmp repeat2
        
        theEnd:
        ;print d in hexa
        push dword [d]
        push fmt
        call [printf]
        add ESP, 4*2
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
