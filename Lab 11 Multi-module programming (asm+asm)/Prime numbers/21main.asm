;Se citeste de la tastatura un sir de numere in baza 10. Sa se afiseze numerele prime.
; numerele se considera reprezentate pe 32 biti fara semn

bits 32
global start        

; declare external functions needed by our program
extern exit,printf,scanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import scanf msvcrt.dll

%include "prime.asm"

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    x resd 1
    printFmt1 db `Enter the numbers. Use any chr to end the input!\n`,0
    printFmt2 db `%d `,0
    pF3 db `Input ended. The prime numbers are:\n`,0
    sFmt db "%d",0
    primes resd 1
    
    
; our code starts here
segment code use32 class=code
    start:
    mov EDI,primes
    mov EBX,0
    ;printf("...")
    push printFmt1
    call [printf]
    
    inputLoop:
    
    add ESP, 4*1
    ;scanf("%d",x)
    push x
    push sFmt
    call [scanf]
    add ESP, 4*2
    
    cmp EAX, 0
    je endLoop
    
    push dword[x]
    call prime
    add ESP, 4*1
    
    cmp EAX,0
    je nextNr
    mov EAX, [x]
    STOSD
    inc EBX
    nextNr:
    jmp inputLoop
    
    endLoop:
    push pF3
    call [printf]
    add ESP,4*1
    mov ECX,EBX
    mov ESI,primes
    
    cmp ECX,0
    je theEnd
    
    showPrimes:
    LODSD
    push ECX
    push EAX
    push printFmt2
    call [printf]
    add ESP,4*2
    pop ECX
    loop showPrimes
    
    theEnd:
    jmp $ ;infinite loop
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program