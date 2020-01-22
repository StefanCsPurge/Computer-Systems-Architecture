%ifndef _FACT_ASM_
%define _FACT_ASM_

factorial:
    mov EAX, 1
    mov ECX, [ESP+4]
    .r:
        mul ECX ; EDX:EAX = ECX * EAX, dar presupunem ca rezultatul incape in EAX, deci il luam numa pe asta
    loop .r ; ECX-- , jmp to .r
    ret

%endif