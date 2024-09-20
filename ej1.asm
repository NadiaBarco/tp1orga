section .rodata
; Poner acá todas las máscaras y coeficientes que necesiten para el filtro
;align 16

filtro_gris dd 0.2126, 0.7152, 0.0722 ,0
filtro_alpha: db  0,0,0,255,0,0,0,255,0,0,0,255,0,0,0,255
section .text

; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 1 como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - ej1
global EJERCICIO_1_HECHO

;ej1(rgba_t* dst,rgba_t* src,uint32_t width, uint32_t height) 
;         rdi         rsi         rcx            rdx
EJERCICIO_1_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Convierte una imagen dada (`src`) a escala de grises y la escribe en el
; canvas proporcionado (`dst`).
;
; Para convertir un píxel a escala de grises alcanza con realizar el siguiente
; cálculo:
; ```
; luminosidad = 0.2126 * rojo + 0.7152 * verde + 0.0722 * azul 
; ```
;
; Como los píxeles de las imágenes son RGB entonces el píxel destino será
; ```
; rojo  = luminosidad
; verde = luminosidad
; azul  = luminosidad
; alfa  = 255
; ```
;
; Parámetros:
;   - dst:    La imagen destino. Está a color (RGBA) en 8 bits sin signo por
;             canal.
;   - src:    La imagen origen A. Está a color (RGBA) en 8 bits sin signo por
;             canal.
;   - width:  El ancho en píxeles de `src` y `dst`.
;   - height: El alto en píxeles de `src` y `dst`.
global ej1
ej1:
	;ej1(rgba_t* dst,rgba_t* src,uint32_t width, uint32_t height) 
;         rdi         rsi         rcx            rdx
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits.
	;
	; r/m64 = rgba_t*  dst
	; r/m32 = uint32_t width
	; r/m32 = uint32_t height
	;puntero rsi -> [r,g,b,a]

	;movdqu xmm0 [rsi]
	;[R1,G1,B1,A1,R2,G2,B2,A2,R3,G3,B3,A3,R4,G4,B4,A4]
	;[ 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0] filtro_alpha
	;-------------------------------------------------
	;[R1,G1,B1,0,R2,G2,B2,0,R3,G3,B3,0,R4,G4,B4,0] 

	;filtro_alpha: 0xffffff00


	push rbp
	mov rbp, rsp

	sub rsp, 16

	mov [rbp-8], rsi ; guardo el puntero a la imgaen src
	mov [rbp -16], rdi ; guardo el punt dst
	xor rax, rax


	mov rax, rcx ;ancho
	imul rax, rdx; ancho*largo
	shr rax,2

	loop1:
		
		cmp rax,0
		je fin
		pxor xmm1, xmm1
		movdqu xmm0, [rsi]
		movdqu xmm3, [filtro_gris]; [filR,filG,filB,filA]
		movdqu xmm7, [filtro_alpha]

		PMOVZXBD xmm0, xmm0 
		;andps
		;xmm0[r1,,g1,b1]
		;[R1,G1,B1,A1,R2,G2,B2,A2,R3,G3,B3,A3,R4,G4,B4,A4]
		;R1 0 G1 0 B1 0
		;
		;XMM0:[000R,000G,000B,000A] 
		cvtdq2ps xmm0, xmm0 
		andps xmm0, xmm7 
		mulps xmm0, xmm3
		haddps xmm0,xmm0
		haddps xmm0,xmm0
		cvttps2dq xmm0,xmm0



		PACKuSDw xmm0, xmm0 ; double word a word
		PACKUSWB xmm0, xmm0 ; word a byte
		
		por xmm0, xmm7 
		movdqu [rdi], xmm0


			add rsi, 4
			mov [rbp-8], rsi
			add rdi, 4
			mov [rbp-16], rdi
			dec rax
			jmp loop1
			

	fin:

	mov rdi, [rbp-8]
	add rsp, 16
	pop rbp
	ret
