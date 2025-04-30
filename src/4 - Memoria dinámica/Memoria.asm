extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)

; a -> [RDI]
; b -> [RSI]

strCmp:
	
	;push rbp 
	;mov rbp, rsp 
; por convencion mantene que es negativo pero en principio, no sabe que es negativo o no
;por eso un numero que quiza es -5 , 0xfb pero es solo un numero igual que si no fuera negativo (representa otro numero)
; igual, puede dar 0, pues habra overflow pero en el fondo da 0. solo suma el procesador. 
	; MientrasNoTermine: 
	; 	mov r8b, byte [RSI]
	; 	mov r9b, byte [RDI]
		
	; 	mov eax, 0
	; 	or r8b, r9b 
	; 	jz fin
		

		

	; 	CMPSB
	; 	ja Caso_b_Above_a 
	; 	jb Caso_b_Below_a
	; 	jmp MientrasNoTermine 
	
	; Caso_b_Above_a: 
	; 	mov eax, 1		
	; 	jmp fin 

	; Caso_b_Below_a:
	; 	mov eax, -1 
	

	; fin: 
	; pop rbp 

	; ret



	
	push rbp 
	mov rbp, rsp 
; por convencion mantene que es negativo pero en principio, no sabe que es negativo o no
;por eso un numero que quiza es -5 , 0xfb pero es solo un numero igual que si no fuera negativo (representa otro numero)
; igual, puede dar 0, pues habra overflow pero en el fondo da 0. solo suma el procesador. 
	MientrasNoTermine: 
		mov r8b, byte [RSI]
		mov r9b, byte [RDI]
		

		cmp r8b, r9b 
		ja Caso_b_Above_a
		jb Caso_b_Below_a

		mov eax, 0
		or r8b, r9b 
		jz fin
		add RSI,1
		add RDI,1
		jmp MientrasNoTermine
		
	
	Caso_b_Above_a: 
		mov eax, 1		
		jmp fin 

	Caso_b_Below_a:
		mov eax, -1 
	

	fin: 
	pop rbp 

	ret



;el error de valgrid que explkotaba era por el cmpsb, mientras que el error de memoria
;que decia el gdb era por los demas, asi que fijate bien de quien es el errror. 






; char* strClone(char* a)
strClone:
;prologo
	push rbp 
	mov rbp, rsp ;se hacia para esto mismo, por que ire usandolo. desde aqui 
	sub rsp, 16 
	mov [rsp], rdi 
	
	call strLen
	
	add rax, 1 
	mov rdi, rax
	mov [rsp +8], rax 
	
	call malloc
	
	mov rsi, qword [rsp]  ;traer de memoria es importante, mala practica pero byueno, esta "al borde" y no salto 2 veces 
	mov rdi, rax 
	mov rcx, qword [rsp +8]

	rep movsb 

;epilogo
	
	add rsp, 16  
	pop rbp 

	ret

; void strDelete(char* a)
strDelete:
	push rbp 
	mov rbp, rsp 

	call free


	pop rbp
	ret

; el error de memoria que marcaba malloc, etc era que se hacia borarr en los test, 
;detecta bien eso

	; mov qword [rsp], rdi 
	
	; call strLen 

	; mov ecx, eax ;esto es para el repeat 
	; mov al, 0 

	; rep stosb 

	; add rsp, 16 
	; pop rbp

	; ret

; void strPrint(char* a, FILE* pFile)
strPrint:

;para escribir null, es cosa de hacer memoria, guardar cosas? 
;o ponerlo arriba como parametro y usarlo y ya. mas facil. 

	ret

; uint32_t strLen(char* a)
strLen:

	push rbp 
	mov rbp, rsp 
	
	mov eax, 0 
	StringCounting:
		mov r8b, byte [rdi]
		test r8b, r8b 
		jz fin2 

		add eax, 1
		add rdi,2
		jmp StringCounting

	fin2: 
	pop rbp
	ret


