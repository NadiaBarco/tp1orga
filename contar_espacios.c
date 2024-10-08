#include "contar_espacios.h"
#include <stdio.h>

/*REC: *puntero -> desreferenciando el puntero y accediaendo a su valor
        puntero -> contenemos el puntero, podemos incrementar (++puntero) y apuntamos a otro elem*/
uint32_t longitud_de_string(char* string) {
    uint32_t count=0;
    while (*string!='\0')
    {
        ++count;
        ++string;
    }
    
    return count;
}

uint32_t contar_espacios(char* string) {
    uint32_t count=0;
    while (*string !='\0')
    {
        if(*string ==' '){
            ++count;
        }
        ++string;
    }
    return count;
    
}

// Pueden probar acá su código (recuerden comentarlo antes de ejecutar los tests!)

int main() {

    printf("1. %d\n", contar_espacios("hola como andas?"));

    printf("2. %d\n", contar_espacios("holaaaa orga2"));
}
