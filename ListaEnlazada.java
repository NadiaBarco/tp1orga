package aed;

import java.util.*;

public class ListaEnlazada<T> implements Secuencia<T> {
    // Completar atributos privados
    private Nodo head;
    private Nodo last;
    private int longitudLista;

    private class Nodo {
        private T valor;
        private Nodo next;
        private Nodo anterior;
        Nodo(T valor){
            valor=null;
        }
    }

    public ListaEnlazada() {
        this.head=null;
        this.last=null;
        this.longitudLista=0;

    }

    public int longitud() {
        return longitudLista;
    }

    public void agregarAdelante(T elem) {
        Nodo nodoNuevo= new Nodo(elem);
        if(head==null && longitudLista==0){
            head=nodoNuevo;
            last=nodoNuevo;
            head.next=last;
            last.anterior=head;
        }else{
            nodoNuevo.next=head;
            head=nodoNuevo;
        }
    }

    public void agregarAtras(T elem) {
        Nodo nuevoNodo= new Nodo(elem);
        nuevoNodo.anterior=last;
        nuevoNodo.next=null;
        last=nuevoNodo;

    }

    public T obtener(int i) {
        int k=0;
        Nodo nuevoNodo=head;
        while(k<longitudLista && nuevoNodo!=null){
            if (k==i){
                return nuevoNodo.valor;
            }
            k++;
            nuevoNodo=nuevoNodo.next;
        }
        return ;
    }

    public void eliminar(int i) {
        Nodo nodoActual=head;
        int count=0;
        while(count!=i){
            nodoActual=nodoActual.next;
            ++count;
        }
        
    }

    public void modificarPosicion(int indice, T elem) {
        throw new UnsupportedOperationException("No implementada aun");
    }

    public ListaEnlazada(ListaEnlazada<T> lista) {
        throw new UnsupportedOperationException("No implementada aun");
    }
    
    @Override
    public String toString() {
        throw new UnsupportedOperationException("No implementada aun");
    }

    private class ListaIterador implements Iterador<T> {
    	// Completar atributos privados

        public boolean haySiguiente() {
	        throw new UnsupportedOperationException("No implementada aun");
        }
        
        public boolean hayAnterior() {
	        throw new UnsupportedOperationException("No implementada aun");
        }

        public T siguiente() {
	        throw new UnsupportedOperationException("No implementada aun");
        }
        

        public T anterior() {
	        throw new UnsupportedOperationException("No implementada aun");
        }
    }

    public Iterador<T> iterador() {
	    throw new UnsupportedOperationException("No implementada aun");
    }

}
