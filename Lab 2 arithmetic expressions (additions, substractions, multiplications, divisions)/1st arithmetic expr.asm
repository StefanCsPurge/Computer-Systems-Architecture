; Scrieți un program în limbaj de asamblare care să rezolve expresia aritmetică, considerând domeniile de definiție ale variabilelor
; a - byte, b - word
; (b / a * 2 + 10) * b - b * 15;
; ex. 1: a = 10; b = 40; Rezultat: (40 / 10 * 2 + 10) * 40 - 40 * 15 = 18 * 40 - 1600 = 720 - 600 = 120
; ex. 2: a = 100; b = 50; Rezultat: (50 / 100 * 2 + 10) * 50 - 50 * 15 = 12 * 50 - 750 = 600 - 750 = - 250
bits 32 ;asamblare si compilare pentru arhitectura de 32 biti
; definim punctul de intrare in programul principal
global  start 

extern  exit ; indicam asamblorului ca exit exista, chiar daca noi nu o vom defini
import  exit msvcrt.dll; exit este o functie care incheie procesul, este definita in msvcrt.dll
        ; msvcrt.dll contine exit, printf si toate celelalte functii C-runtime importante
segment  data use32 class=data ; segmentul de date in care se vor defini variabilele 
	a  db 100
	b  dw 50
segment  code use32 class=code ; segmentul de cod
start: 
	mov  AX, [b] ;AX = b
	div  BYTE [a] ;AL = AX / a = b / a și AH = AX % a = b % a
	
	mov  BL, 2 ;BL = 2
    mul  BL
    ADD AX, 10 ; AX = b/a *2 + 10
    MUL word [b] ; DX:AX =( b/a *2 +10 ) * b/a
    PUSH DX
    PUSH AX
    POP EBX  ; EBX = ( b/a *2 +10 ) * b/a
    MOV AX, 15
    MUL word [b] ; DX:AX = b * 15 which is AX
    PUSH DX
    PUSH AX
    POP EAX ;EAX = b * 15
    SUB EBX, EAX
    
	
	push   dword 0 ;se pune pe stiva codul de retur al functiei exit
	call   [exit] ;apelul functiei sistem exit pentru terminarea executiei programului