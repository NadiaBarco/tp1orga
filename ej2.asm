section .rodata
align 16
datos_alineados dd 0
; Poner acá todas las máscaras y coeficientes que necesiten para el filtro
;align 16
filtro_alpha : dd 0x00ffffff,0x00ffffff,0x00ffffff,0x00ffffff
;align 16
filtro_alphab : db 0xff,0xff,0xff,0,0xff,0xff,0xff,0,0xff,0xff,0xff,0,0xff,0xff,0xff,0
;align 16
ordenPixel2 : db 4,5,6,7,8,9,10,11,12,13,14,15,0,1,2,3
;align 16
ordenPixel3: db 8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7
;align 16
ordenPixel4: db 12,13,14,15,0,1,2,3,4,5,6,7,8,9,10,1
;align 16
alpha1: db  0,0,0,254,0,0,0,254,0,0,0,254,0,0,0,254
;align 16
suma_const: dw 0, 64, 128 ,0,0,64,128,0
;align 16
shufflesuma1:db 2,0,1,3,6,4,5,7,9,10,8,11,14,12,13,15
;align 16
three: dd 3.0, 3.0 , 3.0 ,0
;align 16
sub192: dw 192,192,192,0,192,192,192,0
;align 16
multi4: dw 4,4,4,0
;align 16
restafin: dw 384,384,384,384,384,384,384,384
;align 16
byte_0: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;align 16
byte_255: db 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255

section .text

; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 2 como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - ej1
global EJERCICIO_2_HECHO
EJERCICIO_2_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Aplica un efecto de "mapa de calor" sobre una imagen dada (`src`). Escribe la
; imagen resultante en el canvas proporcionado (`dst`).
;
; Para calcular el mapa de calor lo primero que hay que hacer es computar la
; "temperatura" del pixel en cuestión:
; ```
; temperatura = (rojo + verde + azul) / 3
; ```
;
; Cada canal del resultado tiene la siguiente forma:
; ```
; |          ____________________
; |         /                    \
; |        /                      \        Y = intensidad
; | ______/                        \______
; |
; +---------------------------------------
;              X = temperatura
; ```
;
; Para calcular esta función se utiliza la siguiente expresión:
; ```
; f(x) = min(255, max(0, 384 - 4 * |x - 192|))
; ```
; Cada canal esta offseteado de distinta forma sobre el eje X, por lo que los
; píxeles resultantes son:
; ```
; temperatura  = (rojo + verde + azul) / 3
; salida.rojo  = f(temperatura)
; salida.verde = f(temperatura + 64)
; salida.azul  = f(temperatura + 128)
; salida.alfa  = 255
; ```
;
; Parámetros:
;   - dst:    La imagen destino. Está a color (RGBA) en 8 bits sin signo por
;             canal.
;   - src:    La imagen origen A. Está a color (RGBA) en 8 bits sin signo por
;             canal.
;   - width:  El ancho en píxeles de `src` y `dst`.
;   - height: El alto en píxeles de `src` y `dst`.
global ej2
ej2:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits.
	;
	; r/m64 = rgba_t*  dst
	; r/m64 = rgba_t*  src
	; r/m32 = uint32_t width
	; r/m32 = uint32_t height


;void ej2(rgba_t* dst,rgba_t* src,uint32_t width, uint32_t height)
;			rdi           rsi         rdx           rcx

	push rbp
	mov rbp, rsp
	sub rsp, 40
	mov dword[rbp-32], 384
	movdqu xmm4, [ordenPixel2]
	movdqu xmm5, [ordenPixel3]
	movdqu xmm6,[ordenPixel4]
	movdqu xmm7, [three]
	movdqu xmm15, [shufflesuma1]
	movdqu xmm12, [restafin]
	movdqu xmm13, [filtro_alpha]
	movdqu xmm11, [suma_const]
	movdqu xmm10, [alpha1]
	movdqu xmm14, [filtro_alphab]

	xor rax, rax
	mov rax, rdx
	imul rax, rcx

	shr rax, 2

	loop:
		cmp rax, 0
		je exit

		movdqu xmm8, [rsi]
		mov byte [rsi+3], 0 ; Suponiendo que resultado está definido
		mov byte [rsi + 7], 0 ; Asegúrate de que el canal alfa sea 0
		mov byte [rsi+11], 0
		mov byte [rsi+15],0


		movdqu xmm0, [rsi]
		pmovzxbw xmm1,xmm0 ;
		pshufb xmm0, xmm4 ;SHUFFLE PARA el pixel 2
		pmovzxbw xmm2,xmm0
		pshufb xmm0,xmm5 ; SHUFFLE PARA el pixel
		pmovzxbw xmm3,xmm0
		pshufb xmm0, xmm6; PIXEL 4 12-15
		pmovzxbw xmm0, xmm0

		pmovzxbd xmm1,xmm1
		pmovzxwd xmm2, xmm2
		pmovzxwd xmm3, xmm3
		pmovzxwd xmm0, xmm0

		;ROJO+VERDE+AZUL
		PHADDD xmm0, xmm0
		PHADDD xmm1, xmm1
		PHADDD xmm2, xmm2
		PHADDD xmm3, xmm3


		;PASO LOS 4 PIXELES A FLOTANTES
		cvtdq2ps xmm1, xmm1
		cvtdq2ps xmm2, xmm2
		cvtdq2ps xmm3, xmm3
		cvtdq2ps xmm0, xmm0

		divps xmm1,xmm7
		divps xmm2,xmm7
		divps xmm3,xmm7
		divps xmm0,xmm7

		;;RECORDAR PS=PACKED SINGLE,  SS=SCALAR SINGLE
		;  PD =PACKED DOUBLE, SD =SCALAR DOUBLE



	;DE FLOATS SINGLE PACKED A INTEGER PACKED
		cvttps2dq xmm1,xmm1    
		cvttps2dq xmm2,xmm2
		cvttps2dq xmm3,xmm3
		cvttps2dq xmm0,xmm0

		packusdw xmm1,xmm2
		packusdw xmm3, xmm0

		;=> xmm1=[r+g+b/3,r+g+b/3+64,r+b+g/3+124,0]
		;paddw xmm1, xmm11 
		;paddw xmm3, xmm11

		;restamos 192
		movdqu xmm9,[sub192]
		;psubsw xmm1, xmm9
		;psubsw xmm3, xmm9

		;absoluto
		;pabsw xmm1,xmm1
		;pabsw xmm3,xmm3

		;multiplico por 4
		;paddusw xmm1,xmm1
		;paddusw xmm1,xmm1
		;paddusw xmm3,xmm3
		;paddusw xmm3,xmm3
		
		;-4|temp-192|

		;384-4|temp-192|
		movdqu xmm4, xmm12
		;psubsw xmm12, xmm1
		;psubsw xmm4,xmm3

		;;movdqu xmm1,xmm12
		;;movdqu xmm3,xmm4

		packsswb xmm1,xmm3 

		;movdqu xmm5, [byte_0]
		;movdqu xmm6,[byte_255]
		;pmaxsb xmm1, xmm5  ; Asegura que los valores sean al menos 0
		;pminsb xmm1, xmm6  ; Asegura que los valores no excedan 255

		por xmm1, xmm10

		movdqu [rdi], xmm1

		add rsi,16
		add rdi,16
		dec rax 
		jmp loop 

	exit:
	add rsp, 40
	pop rbp


	ret

