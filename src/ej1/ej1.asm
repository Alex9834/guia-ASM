; /** defines bool y puntero **/
%define NULL 0
%define TRUE 1
%define FALSE 0

section .data

OFFSET_NODE_FIST_LIST EQU 0 
OFFSET_NODE_LAST_LIST EQU 8 

TOTAL_STRUCT_LIST EQU 16 

;//////////////////////////////777

OFFSET_NEXT_NODE EQU 0 
OFFSET_PREVIOUS_NODE EQU 8

OFFSET_TYPE_NODE EQU 16 
OFFSET_HASH_NODE EQU 24 

TOTAL_NODE_STRUCT EQU 32 





section .text

global string_proc_list_create_asm
global string_proc_node_create_asm
global string_proc_list_add_node_asm
global string_proc_list_concat_asm

; FUNCIONES auxiliares que pueden llegar a necesitar:
extern malloc
extern free
extern str_concat


string_proc_list_create_asm:

push rbp ; alineado 
mov rbp, rsp 

mov rdi, qword TOTAL_STRUCT_LIST
call malloc 

mov qword [rax], qword 0
mov qword [rax + OFFSET_NODE_LAST_LIST], qword 0 

pop rbp 
ret 


; rdi -> type 1 byte 
; rsi -> 8 bytes *char

string_proc_node_create_asm:

push rbp 
mov rbp, rsp 
push r12 
push r15 

mov r12b, dil 
mov r15, rsi 
mov rdi, TOTAL_NODE_STRUCT 

call malloc

cmp rax, qword 0
jz .noInicializo
mov qword [rax+ OFFSET_NEXT_NODE], qword 0 
mov qword [rax + OFFSET_PREVIOUS_NODE], qword 0

mov [rax + OFFSET_TYPE_NODE], r12b 
mov [rax + OFFSET_HASH_NODE], r15

.noInicializo:

pop r15
pop r12
pop rbp
ret
string_proc_list_add_node_asm:
; rdi -> puntero a la lista
; rsi -> byte de el type (sil)
; rdx -> punteor al hash 
push rbp 
mov rbp, rsp 
push r12
push r13

push r14

push r15
mov r12, rdi
mov r13, rsi ; (r13b)

mov r14, rdx 

mov rdi, rsi
mov rsi, rdx 

call string_proc_node_create_asm

 
cmp qword [r12], 0 ; comparo si la direccion es 0, osea, entras a rdi te paras al inicio y eso compara con qword, su "CONTENIDO" en esa direccion que entraste con []
je .inicioDeLista 

mov rsi, [r12 + OFFSET_NODE_LAST_LIST] ; muevo a rsi, el ulñtimo nodo 

mov [r12 + OFFSET_NODE_LAST_LIST], rax  ; el ultimo ahora es este.

mov [rax + OFFSET_PREVIOUS_NODE], rsi ; muevo a previous el punteor al nodo ultimo que ya no lo es

mov [rsi + OFFSET_NEXT_NODE], rax 

jmp .fin






.inicioDeLista: 
mov [r12 + OFFSET_NODE_FIST_LIST], rax  
mov [r12 + OFFSET_NODE_LAST_LIST], rax

.fin: 

pop r15
pop r14
pop r13
pop r12 
pop rbp
ret



string_proc_list_concat_asm:
;rdi -> *list
;rsi -> type 
;rdx -> *char hash

push rbp 

push r12 
push r13 
push r14 
push r15 


mov r12, rdi 
mov r13, rsi

mov r14, rdx

mov r15, r14
cmp r12,0 
jz .final
mov r12, [r12 + OFFSET_NODE_FIST_LIST] ;rcx tiene la direccion al primer nodo 

 

 
; osea que este r15 sera el que tendra los concatenados. 

.loop: 
    cmp r12, qword 0
    jz .final 

    mov sil, byte [r12 + OFFSET_TYPE_NODE] ;rsi tiene el valor del type 
    mov rdx, [r12 + OFFSET_HASH_NODE] ; rdx tiene el puntero al hash

    cmp sil, r13b ; caso que no sean iguales
    jne .siguiente
;caso que sean iguales:
    
    cmp r15, r14 ; si es la misma direccion, entonces no.  "el primer concatenado"
    jne .saltarLimpiando

;caso que sean iguales, no se limpia esta ves. 
;hasta ahora el rsi, ya no me sirve, solo era paar la comparacion
    mov rdi, r15
    mov rsi, rdx 
    call str_concat
    mov r15, rax    ; no haria falta pues, el r15 ya lo use, asi que no haria falta que sea no volatil,  PERO RCX LO PONGO CON EL SIGUIENTE, ASI QUE SI, LO NECESITO
    jmp .siguiente 


.saltarLimpiando:
    mov rsi, rdx 
    mov rdi, r15 

    call str_concat 

    mov rdi, r15
    mov r15, rax 

    call free   




.siguiente: 

mov r12, [r12 + OFFSET_NEXT_NODE]
jmp .loop

.final:

mov rax, r15


pop r15 
pop r14
pop r13
pop r12

pop rbp
ret





