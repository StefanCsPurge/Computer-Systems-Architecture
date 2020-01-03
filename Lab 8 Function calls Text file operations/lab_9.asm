bits 32

global start        
;read 100 bytes from file a
extern exit ,fopen, fclose, fread           
import exit msvcrt.dll    
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll

segment data use32 class=data
    n    DB  "a.txt", 0
    m    DB  "r", 0
    d_f  DD  -1  ;df resd -1 - descriptor fisier
    c    DD  0
    buff resb 100
    len  equ $-buff
    
segment code use32 class=code
    start:
        push m ;adresa este de 32 de biti a lui [m]
        push n
        call [fopen] ;;deschide fisierul si pune in EAX descriptorul de fisier, daca e eroare pune 0 in EAX
        cmp EAX, 0
        jz end
        mov [d_f], EAX
        add ESP, 4*2
        
        .r: 
        push dword[d_f] ; nu punem adresa pt ca e un numar, nu un sir de chr
        push len 
        push 1 ;citim un octet
        push buff ; este sir de chr
        call [fread] ;pune in EAX cati octeti a citit
        add ESP, 4*4
        cmp EAX, len
        je  .r 
        
        
        push dword[d_f]
        call [fclose]
        add ESP, 4*1
    
        end:
        push    dword 0    
        call    [exit]       
