#include "lista_enlazada.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


lista_t* nueva_lista(void) {
    lista_t* new_list=  (lista_t*)malloc(sizeof(lista_t));
    new_list->head=NULL;

    return new_list;
}

uint32_t longitud(lista_t* lista) {
    uint32_t count=0;
    nodo_t* nodo_prueba= lista->head;

    while(nodo_prueba!=NULL){
        ++count;
        nodo_prueba=nodo_prueba->next;
    }
    return count;
    
}

void agregar_al_final(lista_t* lista, uint32_t* arreglo1, uint64_t longitud1) {
    nodo_t *nuevo_nodo=lista->head;
    if(nuevo_nodo==NULL){
        nuevo_nodo=(nodo_t*)malloc(sizeof(nodo_t));
        nuevo_nodo->longitud=longitud1;
        nuevo_nodo->arreglo=(uint32_t*)malloc(longitud1*sizeof(uint32_t));
        memcpy(nuevo_nodo->arreglo, arreglo1, longitud1 * sizeof(uint32_t));
        lista->head=nuevo_nodo;
        
    }else{
        while(nuevo_nodo->next!=NULL){
            nuevo_nodo=nuevo_nodo->next;
        }
        nuevo_nodo->next=(nodo_t*)malloc(sizeof(nodo_t));
        nuevo_nodo=nuevo_nodo->next;
        nuevo_nodo->longitud=longitud1;
        nuevo_nodo->arreglo=(uint32_t*)malloc((uint32_t)longitud1*sizeof(uint32_t));
        memcpy(nuevo_nodo->arreglo, arreglo1, longitud1 * sizeof(uint32_t));
        nuevo_nodo->next=NULL;
    }

}

nodo_t* iesimo(lista_t* lista, uint32_t i) {
    nodo_t *nodo_search=lista->head;
    int count=0;
    while(count<i&nodo_search!=NULL){
        ++count;
        nodo_search=nodo_search->next;
    }
    return nodo_search;
}

uint64_t cantidad_total_de_elementos(lista_t* lista) {
    nodo_t* es_nodo=lista->head;
    uint64_t count=0;
    while(es_nodo!=NULL){
        for(int i=0;i< es_nodo->longitud;++i){
            count++;
        }
        es_nodo=es_nodo->next;
    }
    return count;
}

void imprimir_lista(lista_t* lista) {
    nodo_t* es_nodo=lista->head;
    int count=0;
    while(es_nodo!=NULL){
        for(int i=0;i< es_nodo->longitud;++i){
            ++count;
        }
        printf("| %d | -> ",es_nodo->longitud);
        es_nodo=es_nodo->next;
    }
    
}

// Función auxiliar para lista_contiene_elemento
int array_contiene_elemento(uint32_t* array, uint64_t size_of_array, uint32_t elemento_a_buscar) {
    for(int i=0;i<size_of_array;++i){
        if(array[i]==elemento_a_buscar){
            return 1;
        }
    }
    return 0;
}

int lista_contiene_elemento(lista_t* lista, uint32_t elemento_a_buscar) {
    nodo_t *nuevo_nodo=lista->head;
    while (nuevo_nodo!=NULL)
    {
        if(array_contiene_elemento(nuevo_nodo->arreglo,nuevo_nodo->longitud,elemento_a_buscar)){
            return 1;
        }
        nuevo_nodo=nuevo_nodo->next;
    }
    return 0;
}


// Devuelve la memoria otorgada para construir la lista indicada por el primer argumento.
// Tener en cuenta que ademas, se debe liberar la memoria correspondiente a cada array de cada elemento de la lista.
void destruir_lista(lista_t* lista) {
}



int main()
{
    lista_t* lista = nueva_lista();

    // Caso de prueba 1: Agregar un elemento
    uint32_t arr1[] = {1};
    uint32_t arr2[] = {6,8};
    agregar_al_final(lista, arr1, 1);
    agregar_al_final(lista, arr2, 2);

    printf("Lista después de agregar un elemento:\n");
    imprimir_lista(lista);
    printf("Cantidad total de elementos: %u\n", cantidad_total_de_elementos(lista));
    printf("Longitud de la lista: %u \n", longitud(lista));
    printf("contiene el elemento?: %d \n", lista_contiene_elemento(lista,0));
    return 0;
}