

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
NODO_OFFSET_NEXT EQU 0
NODO_OFFSET_CATEGORIA EQU 8 ; seguido van. 
NODO_OFFSET_ARREGLO EQU 16
NODO_OFFSET_LONGITUD EQU 24    ;total 24 en la estructura
NODO_SIZE EQU 32
PACKED_NODO_OFFSET_NEXT EQU 0
PACKED_NODO_OFFSET_CATEGORIA EQU 8
PACKED_NODO_OFFSET_ARREGLO EQU 9
PACKED_NODO_OFFSET_LONGITUD EQU 17
PACKED_NODO_SIZE EQU 21
LISTA_OFFSET_HEAD EQU 0
LISTA_SIZE EQU 8
PACKED_LISTA_OFFSET_HEAD EQU 0
PACKED_LISTA_SIZE EQU 8

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global cantidad_total_de_elementos
global cantidad_total_de_elementos_packed

;########### DEFINICION DE FUNCIONES
;extern uint32_t cantidad_total_de_elementos(lista_t* lista);
;registros: lista[rdi]
	%define estructura rdi
	%define acumulador eax

cantidad_total_de_elementos:

	push rbp
	mov rbp, rsp 



	xor acumulador, acumulador

	haySiguiente:

	mov rsi, [estructura] ;recorda que es acceder u obtener la direccion, recien ahi entrar a la direccion, esa direccion que tenes ahora es la del inicio de s1, DONDE SI LO PEDIS, RECIEN AHI
	;TE DA EL PUNTEOR A S2.
	cmp rsi, 0
	je salir

	evaluarElValor:
		mov ecx, [rsi + NODO_OFFSET_LONGITUD] 
		add acumulador, ecx 
		mov estructura, rsi 
		jmp haySiguiente 
	
	
	salir: 


	pop rbp
	ret

;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[rdi]
cantidad_total_de_elementos_packed: 
    
	push rbp
	mov rbp, rsp 


	xor acumulador, acumulador

	haySiguiente2: ; con el púnto al inciio, sera local a la funcion.

	mov rsi, [estructura] ;recorda que es acceder u obtener la direccion, recien ahi entrar a la direccion, esa direccion que tenes ahora es la del inicio de s1, DONDE SI LO PEDIS, RECIEN AHI
	;TE DA EL PUNTEOR A S2.
	cmp rsi, 0
	je salir2

	evaluarElValor2:
		mov ecx, [rsi + PACKED_NODO_OFFSET_LONGITUD] 
		add acumulador, ecx 
		mov estructura, rsi 
		jmp haySiguiente2 
	
	
	salir2:
	

	pop rbp
	ret

	%undef estructura 
	%undef acumulador