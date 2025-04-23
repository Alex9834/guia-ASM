extern sumar_c
extern restar_c


;########### SECCION DE MACROS 
  %macro procesarFloats 1 
    movd xmm9, [rsp + 24] 
    cvtss2sd xmm9, xmm9  
    
   %if %1 <= 7
      cvtss2sd xmm%1, xmm%1
      sub rsp, 16 
      movaps [rsp], xmm%1
      procesarFloats eval(%1 + 1)

    %endif
      sub rsp, 16
      
  %endmacro


  %macro procesarInts 5 

  cvtsi2sd xmm1, %1
  cvtsi2sd xmm2, %2 
  cvtsi2sd xmm3, %3 
  cvtsi2sd xmm4, %4
  cvtsi2sd xmm5, %5

  sub rsp, 80 
  movaps [rsp], xmm1
  movaps [rsp+16], xmm2
  movaps [rsp+32], xmm3
  movaps [rsp+48], xmm4
  movaps [rsp+64], xmm5

%endmacro
    

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_using_c
global alternate_sum_4_using_c_alternative
global alternate_sum_8
global product_2_f
global product_9_f

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4:
  sub EDI, ESI
  add EDI, EDX
  sub EDI, ECX

  mov EAX, EDI
  ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4_using_c:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  push R12
  push R13	; preservo no volatiles, al ser 2 la pila queda alineada

  mov R12D, EDX ; guardo los parámetros x3 y x4 ya que están en registros volátiles
  mov R13D, ECX ; y tienen que sobrevivir al llamado a función

  call restar_c 
  ;recibe los parámetros por EDI y ESI, de acuerdo a la convención, y resulta que ya tenemos los valores en esos registros
  
  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, R12D
  call sumar_c

  mov EDI, EAX
  mov ESI, R13D
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  pop R13 ;restauramos los registros no volátiles
  pop R12
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


alternate_sum_4_using_c_alternative:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  sub RSP, 16 ; muevo el tope de la pila 8 bytes para guardar x4, y 8 bytes para que quede alineada

  mov [RBP-8], RCX ; guardo x4 en la pila

  push RDX  ;preservo x3 en la pila, desalineandola
  sub RSP, 8 ;alineo
  call restar_c 
  add RSP, 8 ;restauro tope
  pop RDX ;recupero x3
  
  mov EDI, EAX
  mov ESI, EDX
  call sumar_c

  mov EDI, EAX
  mov ESI, [RBP - 8] ;leo x4 de la pila
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  add RSP, 16 ;restauro tope de pila
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: 
; x1 --> [EDI], 
; x2 --> [ESI],
; x3 --> [EDX],
; x4 --> [ECX],
; x5 --> [R8D],
; x6 --> [R9D], 
; x7 --> [RSI +8],
; x8 --> [RSI]. YA POR CONVENCION SE QUE DEBERE DE MANEJAR ESTOS. Y CALCUJLAR PADDING SI PASA OTRA COSA. 
alternate_sum_8:
	;prologo nada
  
   
  


	; COMPLETAR
  
  sub EDI, ESI
  add EDI, EDX 
  sub EDI, ECX
  add EDI, R8D 
  sub EDI, R9D
  mov R9D, [RSP+8]
  add EDI, R9D
  mov R9D, [RSP+16]
  sub EDI, R9D
  mov EAX, EDI
	;epilogo
	ret

  
; con pop no es, es con mov para leer y no modificar el rsp

; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: RDI, x1 [RSI], f1[XMM0]
product_2_f:
  ;prologo 
  cvtsi2sd xmm1, esi 
  cvtss2sd xmm0, xmm0
  mulsd xmm1, xmm0 ;el orden no importa pero si, ira en xmm1 el res, pero la multiplicacion puede ser de cualquier ordenm  
  
  cvtsd2si eax, xmm1  ;esdto daba error al parecer con el abi. 
  mov dword [rdi], eax

	ret

;respeta los tipos


;extern void product_9_f(double * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;  registros y pila: destination[rdi], x1[rsi], f1[xmm0], x2[rdx], f2[xmm1], x3[rcx], f3[xmm2], x4[r8], f4[xmm3]
;	, x5[r9], f5[xmm4], x6[rsp + 40], f6[xmm5], x7[rsp + 32], f7[xmm6], x8[rsp + 24], f8[xmm7],
;	, x9[rsp +16], f9[rsp + 8]  


; 
%define contador r11
product_9_f: ;al parecer si o si solo queda hacer a mano
	;prologo
  ;
  
	push rbp
	mov rbp, rsp
  
  sub rsp,16
  movaps [rsp], xmm8


      
	;convertimos los flotantes de cada registro xmm en doubles
	
  procesarFloats 0 ; convertidos y guardados, no hacia falta pushear. sino dejarlo como estaban 
  
  

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
  xor contador, contador
  add contador, 1
  movaps xmm0, [rsp]
  add rsp, 16 

	multiplicadorDeDoubles:
    cmp contador, 8
    jg finDeMultiplicar 

  recursionMultiplicadora: 
    movaps xmm1, [rsp + contador * 16]
    mulsd xmm0, xmm1 ;Preguntar la basura 
    inc contador  ; sumar contador
    jmp multiplicadorDeDoubles


  finDeMultiplicar:;
    add rsp, 128
    
	; convertimos los enteros en doubles y los multiplicamos por xmm0.
  procesarInts rsi, rdx, rcx, r8, r9
    
    xor contador, contador
    add contador, 1

  multiplicarPorXmm0:
    cmp contador, 5
    jg anclado

  recursionMultiplicadoraXmm0:
    movaps xmm1, [rsp + contador *16]
    mulsd xmm0, xmm1 
    inc contador
    jmp multiplicarPorXmm0
  
  anclado:
    cvtsd2si eax, xmm0
    mov dword [rdi], eax

	; epilogo
  add rsp, 80
	pop rbp
	ret

