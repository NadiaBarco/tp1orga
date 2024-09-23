section .rodata
; Poner acá todas las máscaras y coeficientes que necesiten para el filtro
;align 16
align 16
dato_align dd 0


filtro_gris dd 0.2126, 0.7152, 0.0722 ,0

filtro_alpha: db  0,0,0,255,0,0,0,255,0,0,0,255,0,0,0,255
ordenPixel2 : db 4,5,6,7,8,9,10,11,12,13,14,15,0,1,2,3
ordenPixel3: db 8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7
ordenPixel4: db 12,13,14,15,0,1,2,3,4,5,6,7,8,9,10,11

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
EJERCICIO_1_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

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



	push rbp
	mov rbp, rsp

	xor rax, rax

	mov rax, rcx ;ancho
	imul rax, rdx; ancho*largo
	shr rax,2
	movdqu xmm4, [ordenPixel2]
	movdqu xmm5, [ordenPixel3]
	movdqu xmm6,[ordenPixel4]
	movdqu xmm7, [filtro_gris]
	movdqu xmm8, [filtro_alpha]
	loop1:


	;filtro_gris dd 0.2126, 0.7152, 0.0722 ,0
    ;filtro_alpha: db  0,0,0,255,0,0,0,255,0,0,0,255,0,0,0,255

		cmp rax,0
		je fin
		;pxor xmm1, xmm1
		;movdqu xmm0, [rsi]
		;movdqu xmm3, [filtro_gris]; [filR,filG,filB,filA]
		;movdqu xmm7, [filtro_alpha]

		;pmovzxbd xmm0, xmm0 
		
		;xmm0[r1,,g1,b1]n
		;[R1,G1,B1,A1,R2,G2,B2,A2,R3,G3,B3,A3,R4,G4,B4,A4]
		;R1 0 G1 0 B1 0
		;
		;XMM0:[000R,000G,000B,000A] 

		;cvtdq2ps xmm0, xmm0 
		;mulps xmm0, xmm3
		;haddps xmm0,xmm0
		;haddps xmm0,xmm0
		;cvttps2dq xmm0,xmm0

		;packusdw xmm0, xmm0 ; double word a word
		;PACKUSWB xmm0, xmm0 ; word a byte
		
		;por xmm0, xmm7 
		;movdqu [rdi], xmm0

		;ordenPixel2 : db 4,5,6,7,8,9,10,11,12,13,14prin,15,0,1,2,3
		;ordenPixel3: db 8,9,10,11,12,13,14,15
	;	ordenPixel4: db 12,13,14,15
		;movdqu xmm4, [ordenPixel2]
	;	movdqu xmm5, [ordenPixel3]
	;	movdqu xmm6,[ordenPixel4]
		movdqu xmm0, [rsi]
		pmovzxbd xmm1, xmm0 ;PRIMER PIXEL, PARTE BAJA 0-3
		pshufb xmm0, xmm4
		movdqu xmm2,xmm0 ; PIXEL 2, PARTE 4-7

		pshufb xmm0, xmm5    
		movdqu xmm3, xmm0 ; PIXEL 3 PARTE 8-11
		pshufb xmm0, xmm6; PIXEL 4 12-15

		pmovzxbd xmm2, xmm2 ;EXTIENDO LOS PIXELES A WORD
		pmovzxbd xmm3,xmm3
		pmovzxbd xmm0, xmm0


		;PASO LOS 4 PIXELES A FLOTANTES
		cvtdq2ps xmm1, xmm1
		cvtdq2ps xmm2, xmm2
		cvtdq2ps xmm3, xmm3
		cvtdq2ps xmm0, xmm0


		;APLICO LAS MASCARA GRIS A CADA PIXEL [0.2126 * rojo , 0.7152 * verde, 0.0722 * azul, ALPHA*0]
		mulps xmm1, xmm7
		mulps xmm2, xmm7
		mulps xmm3, xmm7
		mulps xmm0, xmm7

		;luminosidad = 0.2126 * rojo + 0.7152 * verde + 0.0722 * azul +0
		haddps xmm1, xmm1
		haddps xmm1, xmm1
		haddps xmm2, xmm2
		haddps xmm2, xmm2
		haddps xmm3, xmm3
		haddps xmm3, xmm3
		haddps xmm0, xmm0
		haddps xmm0, xmm0

		;PASO DE FLOATS PACKED SINGLES A INTEGER PACKED SINGLE
		cvttps2dq xmm1,xmm1
		cvttps2dq xmm2,xmm2
		cvttps2dq xmm3, xmm3
		cvttps2dq xmm0, xmm0


		
		
		;packusdw xmm1,xmm1
		;packusdw xmm2, xmm2
		;packusdw xmm3, xmm3
		;packusdw xmm0, xmm0

		;packuswb xmm1,xmm1
		;packuswb xmm2, xmm2
		;packuswb xmm3, xmm3
		;packuswb xmm0, xmm0

		;packusdw xmm1 = [R1,   G1,  B1,  A1], 	xmm2=[R2,  G2,  B2,  A2] => xmm1 = [R1, G1, B1, A1, R2,  G2,  B2,  A2]
		;				  
		packusdw xmm1, xmm2
		packusdw xmm3,xmm0

		packuswb xmm1, xmm3 ; xmm1 = [R1,G1,B1,A1,R2,G2,B2,A2,R3,G3,B3,A3,R4,G4,B4,A4]

		;packuswb xmm1, xmm2
		;packuswb xmm3, xmm0
		;packuswb xmm1,xmm3


		por xmm1,xmm8
		movdqu [rdi], xmm1

		add rsi, 16
		add rdi,16
		sub rax, 1
		jmp loop1
			

	fin:

	pop rbp
	ret

