bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
; (a*2+b/2+e)/(c-d)+x/a; a - word; b,c,d - byte; e - doubleword; x - qword
; SIGNED INTERPRETATION / representation
segment data use32 class=data
    ; ...
    a DW 100
    b DB 8
    c DB 4
    d DB 2
    e DD 420
    x DQ 600
    y DW 0 ; aux
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov AL, 2
        cbw
        imul word [a] ; DX:AX = AX * a = 2 * a
        mov BX, AX
        mov CX, DX ; CX:BX = DX:AX = 2*a
        mov AL, [b]
        cbw
        mov DL, 2
        idiv DL ; AL = AX/DL = b/2
        cbw 
        cwd ; AX:DX = b/2
        add AX, BX
        adc DX, CX ; DX:AX = DX:AX + CX:BX = b/2 + a*2
        add AX, word [e]
        adc DX, word [e+2] ;DX:AX = a*2+b/2+e
        
        mov BL, [c]
        sub BL, [d] ; BL = c-d
        mov CX, AX ; DX:CX = a*2+b/2+e
        mov AL, BL ; AL = c-d
        cbw ; AX = (c-d)
        mov BX, AX ; BX = (c-d)
        mov AX, CX ; DX:AX = a*2+b/2+e
        idiv BX ; AX = DX:AX / BX = (a*2+b/2+e) / (c-d)
        mov [y], AX ; y=AX
        
        mov EBX, [x]
        mov ECX, [x+4] ; ECX:EBX = x
        mov AX, [a]
        cwd ;DX:AX = a
        push DX
        push AX
        pop EAX ; EAX = a
        mov EDX, EAX ; EDX = a
        mov EAX, EBX
        mov EBX, EDX ; EBX = a
        mov EDX, ECX ; EDX:EAX = x
        idiv EBX ; EAX = EDX:EAX / EBX = x/a
        
        mov ECX, EAX ; ECX = x/a
        mov AX, [y]
        cwd
        push DX
        push AX
        pop EAX ; EAX = y = (a*2+b/2+e)/(c-d)
        add EAX, ECX ; EAX = y + ECX = (a*2+b/2+e)/(c-d) + x/a
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
