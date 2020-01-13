;28.Se da un nume de fisier (definit in segmentul de date). 
;Sa se creeze un fisier cu numele dat, apoi sa se citeasca de la tastatura cuvinte 
;pana cand se citeste de la tastatura caracterul '$'.
;Sa se scrie in fisier doar cuvintele care contin cel putin o litera mica (lowercase).
bits 32
global start
extern exit,fopen,fclose,scanf,printf,perror,fprintf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import perror msvcrt.dll
import fprintf msvcrt.dll

segment data use32 class=data
    fis db "words.txt",0
    wM db "w",0
    printFmt db "Insert word: ",0
    fmt2 db `Your word is: %s \n`,0
    wrd resb 55
    sfmt db "%s",0
    ffmt db `%s\n`,0
    handle dd -1
    
segment code use32 class=code
    start:
    ;fopen(const char* nume_fisier, const char * mod_acces)
    push wM
    push fis
    call [fopen]
    add ESP,4*2
    cmp EAX,0
    je theEnd
    mov [handle],EAX
    
    repeat1:
    ;printf("Insert word: ")
    push printFmt
    call [printf]
    add ESP, 4*1
    ;scanf("%s",wrd)
    push wrd
    push sfmt
    call [scanf]
    add ESP, 4*2
    cmp EAX, 0
    je theEnd
    cmp byte[wrd], '$'
    je theEnd
    ;printf(`Your word is: %s\n`,wrd)
    push wrd
    push fmt2
    call [printf]
    add ESP,4*2
    
    mov ESI,wrd
    cld
    parseLoop:
    LODSB
    cmp AL,0
    je fin_l
    cmp AL, 'a'
    jl parseLoop
    cmp AL, 'z'
    ja parseLoop
    
    ;fprintf(wrd)
    push wrd
    push ffmt
    push dword [handle]
    call [fprintf]
    add ESP, 4*2
    
    fin_l
    jmp repeat1
    
    
theEnd:
;fclose(file)
push dword [handle]
call [fclose]
add ESP, 4*1
;exit(0)
push dword 0
call [exit]
