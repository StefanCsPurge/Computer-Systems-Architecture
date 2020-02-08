;A string if dwords is given in SI. Construct a new string of dwords SF
;that contains the dwords from SI that have at least 2 descending hexa pairs in them.
;Descending hexa pair: FE, 21, DC etc
bits 32
global start
extern exit,printf,buildSF
import exit msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    SIs dd 921FFE34h,1111h,0EDCBh,0F120h
    lenSI equ ($-SIs)/4
    SF resd lenSI
    lenSF dd 0
    pf db "%X ",0
    pf2 db "%d",10,0

segment code use32 class=code
    start:
    
    ;buildSF(SIs,SF,lenSI,lenSF)
    push lenSF
    push lenSI
    push SF
    push SIs
    call buildSF
    add ESP,4*4
   
    mov ESI,SF
    mov ECX,[lenSF]
    JECXZ theEnd
    
    printLoop:
    push ECX
    LODSD
    push EAX
    push pf
    call [printf]
    add ESP,4*2
    pop ECX
    loop printLoop
    
    theEnd:
    push dword 0
    call [exit]
