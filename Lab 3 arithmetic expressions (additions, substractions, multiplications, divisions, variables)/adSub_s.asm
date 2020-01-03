bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    ;(b+b)-c-(a+d) , all no. are signed
    a DB 5
    b DW 22
    c DD 999
    d DQ 1000
    x DQ 0
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov AX, [b]
        add AX, [b] ; b+b
        cwd
        sub AX, word [c]
        sbb DX, word [c+2] ; DX:AX = (b+b) - c
        push DX
        push AX
        pop EAX
        cdq
        mov dword [x], EAX
        mov dword [x+4], EDX; x = (b+b) - c
        mov AL, [a]
        cbw
        cwd
        cdq
        add EAX, dword [d]
        adc EDX, dword [d+4] ; EDX:EAX = a+d
        sub dword [x], EAX
        sbb dword [x+4], EDX ; x = (b+b)-c-(a+d)
        mov EAX, dword [x]
        mov EDX, dword [x+4] ; EDX:EAX = (b+b)-c-(a+d)
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
