
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,scanf        ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
        vector resd 128 ; spatiu de stocare pentru 128 întregi
        fmt db "%d", 0 ; vom citi cu scanf ("%d", ...) 
segment code use32  class=code
start:
        mov ebx, vector ; ebx indică elementul curent (primul) 
        mov ecx, 128 ; permitem maximum 128 elemente
    .bucla:
        push ecx ; salvam ECX (funcțiile externe au 
        push ebx ; drept să-l altereze)
        push fmt ; cei doi parametri sunt în stivă
        call [scanf] ; apel scanf cu "%d" si ebx
        add esp, 2 * 4 ; eliberarea parametrilor din stivă
        pop ecx ; restaurare valoarea lui ECX
        add ebx, 4 ; avansăm cu un DWORD
        cmp eax, 0 ; eax (rezultatul lui scanf) este zero?
    loopnz .bucla ; dacă nu, predă controlul instructiunii
    ; de după  .bucla
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
