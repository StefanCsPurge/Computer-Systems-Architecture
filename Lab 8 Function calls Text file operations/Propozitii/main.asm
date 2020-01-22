;Program that counts & processes sentences from a file.

bits 32

global start        


extern exit, fread, fopen, fclose, printf
import exit msvcrt.dll
import fread msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll


segment data use32 class=data
    words_counter dd 1
    number_of_sentences dd 1
    file_name db "s.txt",0
    print_format db "Propozitia %d: %s. Nr. cuvinte: %d. Primul cuvant %s are %d litere.",10,0
    just_format db "%s",0
    character db 0
    read_format db "%c",0
    acces_mode db "r",0
    letter_count db 0
    first_string times 100 db 0
    sentence times 100 db 0
    inversed_word times 100 db 0
    first_word db 1
    file_descriptor dd -1

segment code use32 class=code
    start:
        push dword acces_mode
        push dword file_name
        call [fopen]
        add esp, 4*2
        
        mov ebx,0
        mov esi,0
        mov edi,0
        
        cmp eax,0
        je .final
        mov [file_descriptor], eax
        
        .reading:
                ;fread
                push dword [file_descriptor]
                push dword 1
                push dword 1
                push dword character
                call [fread]
                add esp, 4*4
                cmp eax, 0
                je .final
                
                cmp byte[character], '.'
                je .reset_all
                
                cmp byte[character], ' '
                je .end_of_first_word
                jmp .not_end_of_first_word
                
                .end_of_first_word:
                        inc byte[words_counter]
                        inc ebx
                        mov byte[first_word], 0
                .not_end_of_first_word: 
                        cmp byte[first_word], 1
                        je .memorize_word
                        jmp .dont_memorize_word
                .memorize_word:
                        mov bl, [character]
                        mov [first_string+esi], bl
                        inc esi
                .dont_memorize_word:
                        mov bl, [character]
                        mov [sentence+edi], bl
                        inc edi
                jmp .dont_reset
                .reset_all:
                        mov ecx, esi
                        .inverse:
                                mov al, [first_string+ecx-1]
                                mov ebx, esi
                                sub ebx, ecx
                                mov [inversed_word+ebx], al
                                dec ecx
                                cmp ecx, 0
                                jne .inverse
                                
                        push dword esi
                        push dword inversed_word
                        push dword [words_counter]
                        push dword sentence
                        push dword [number_of_sentences]
                        push dword print_format
                        call [printf]
                        add esp, 4*6
                        
                        mov esi, 0
                        mov edi, 0
                        inc byte[number_of_sentences]
                        mov byte[words_counter], 1
                        mov byte[first_word], 1
                .dont_reset:
                jmp .reading
        
        .final:
                push dword [file_descriptor]
                call [fclose]
                add esp, 4*1
                push  dword 0
                call  [exit]
