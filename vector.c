#include "vector.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>



vector_t* nuevo_vector(void) {
    vector_t *nuevo_vec=malloc(sizeof(vector_t));
    nuevo_vec->size=0;
    nuevo_vec->capacity=2;
    nuevo_vec->array=(uint32_t*) malloc(nuevo_vec->capacity*sizeof(uint32_t));
    return nuevo_vec;
}

uint64_t get_size(vector_t* vector) {
    return vector->size;
    
}

void push_back(vector_t* vector, uint32_t elemento) {
    int i=0;
    if(vector->capacity==vector->size){
        vector->capacity*=2;
        vector->array=realloc(vector->array,(vector->capacity)*sizeof(uint32_t));
    }
    while(i<vector->size){
        ++i;
    }
    vector->array[i]=elemento;
    ++vector->size;
}

int son_iguales(vector_t* v1, vector_t* v2) {
    uint8_t es_diff=1;
    for(int i=0;i<v1->size;++i){
        if(v1->array[i]!=v2->array[i]){
            es_diff=0;
        }
    }
    return v1->capacity==v2->capacity & v1->size==v2->size & es_diff;
}

uint32_t iesimo(vector_t* vector, size_t index) {
    int i=0;
    if(index>vector->size){
        return 0;
    }
    while (i<vector->size+1)
    {
        if (i==index)
        {
            return vector->array[i];
        }
        ++i;
    }
}

void copiar_iesimo(vector_t* vector, size_t index, uint32_t* out)
{
    uint32_t* ptr_copia=malloc(sizeof(uint32_t));
    *ptr_copia=iesimo(vector,index);
    *out=*ptr_copia;
}


// Dado un array de vectores, devuelve un puntero a aquel con mayor longitud.
vector_t* vector_mas_grande(vector_t** array_de_vectores, size_t longitud_del_array) {
    if((*array_de_vectores)->size==0){
        return NULL;
    }

    for(int i=0;i<(*array_de_vectores)->size;i++){
            
    }
}

