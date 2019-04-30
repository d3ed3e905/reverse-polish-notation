%include "io.inc"

%define MAX_INPUT_SIZE 4096

section .bss
    expr: resb MAX_INPUT_SIZE

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    push ebp
    mov ebp, esp

    GET_STRING expr, MAX_INPUT_SIZE

    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor esi, esi
    xor edi, edi    ; 1 = nr negativ, 0 = nr pozitiv

test_one_byte:
    mov bl, byte [expr + ecx]
    test bl, bl ; citesc caractere pana la terminatorul de sir
    je out
    cmp bl, '*' ; inmultire
    je multiplication
    cmp bl, '/' ; impartire
    je division
    cmp bl, '+' ; adunare
    je addition
    cmp bl, '-'
    je compare2
    cmp bl, '0' ; cifra => creare numar
    jge number
    inc ecx
    jmp test_one_byte
compare2:
    cmp byte [expr + ecx + 1], '0'  ; daca e mai mic decat valoarea ASCII pentru cifre
    jl subtraction  ; scadere
    mov edi, 1    ; nr. negativ
    inc ecx
    jmp test_one_byte

number:
    xor eax, eax    ; in eax construiesc numarul
    mov esi, 10
create_number:
    sub bl, '0' ; convertesc char la int
    mul esi
    add eax, ebx
    inc ecx
    mov bl, byte [expr + ecx]
    cmp bl, ' ' ; citesc cifre pana la spatiu (' ')
    jne create_number 
    test edi, edi
    jne negative    ; nr negativ => C2
    push eax    ; pune nr pe stiva
    jmp test_one_byte

negative:
    neg eax
    push eax
    xor edi, edi    ; resetare edi
    jmp test_one_byte

multiplication:
    xor edx, edx
    pop esi ; inmultitorul
    pop eax ; deinmultitul
    imul esi
    push eax    ; pune rezultatul operatiei pe stiva
    inc ecx
    jmp test_one_byte
    
division:
    xor edx, edx
    pop esi ; inmultitor
    pop eax ; deinmultit
    cdq
    idiv esi
    push eax    ; pune rezultatul operatiei pe stiva
    inc ecx
    jmp test_one_byte

addition:
    pop esi ; termen1
    pop eax ; termen2
    add eax, esi
    push eax    ; pune rezultatul pe stiva
    inc ecx
    jmp test_one_byte

subtraction:
    pop esi ; scazator
    pop eax ; descazut
    sub eax, esi
    push eax    ; pune rezultatul pe stiva
    inc ecx
    jmp test_one_byte

out:
    pop eax
    PRINT_DEC 4, eax    ; afisare rezultat final

    xor eax, eax
    pop ebp
    ret
