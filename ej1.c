#include "ej1.h"

/**
 * Marca el ejercicio 1 como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - ej1
 */
bool EJERCICIO_1_HECHO = true;

/**
 * Convierte una imagen dada (`src`) a escala de grises y la escribe en el
 * canvas proporcionado (`dst`).
 *
 * Para convertir un píxel a escala de grises alcanza con realizar el
 * siguiente cálculo:
 * ```
 * luminosidad = 0.2126 * rojo + 0.7152 * verde + 0.0722 * azul 
 * ```
 *
 * Como los píxeles de las imágenes son RGB entonces el píxel destino será
 * ```
 * rojo  = luminosidad
 * verde = luminosidad
 * azul  = luminosidad
 * alfa  = 255
 * ```
 *
 * Parámetros:
 *   - dst:    La imagen destino. Está a color (RGBA) en 8 bits sin signo por
 *             canal.
 *   - src:    La imagen origen A. Está a color (RGBA) en 8 bits sin signo por
 *             canal.
 *   - width:  El ancho en píxeles de `src` y `dst`.
 *   - height: El alto en píxeles de `src` y `dst`.
 */
void ej1(rgba_t* dst,rgba_t* src,uint32_t width, uint32_t height){
    uint32_t fila=0;
    uint32_t columna=0;
    if (dst==0 || src==0 ){
        return 0;
    } 
    while(fila<=(height*width)/4 ){

            double gris= 0.2126 * src->r + 0.7152 * src->g + 0.0722 * src->b;
            int8_t grey= (int8_t) gris;
            dst->a=255;
            dst->r=gris;
            dst->g=gris;
            dst->b=gris; 
            
        dst =dst+16;
        src=src+16;

        ++fila;

    }
} 


