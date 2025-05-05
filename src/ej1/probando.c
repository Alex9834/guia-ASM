#include "ej1.h"
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>
#include <stdio.h>


char* string_proc_list_concat(string_proc_list* list, uint8_t type, char* hash){

string_proc_node* nodoActual = list -> first; 

char* concatTemporal = strdup(hash); 


while(nodoActual != NULL){
	uint8_t typeActual = nodoActual -> type;
	char* hashActual = nodoActual -> hash;
	if(typeActual = type){
		char* viejaVersion = concatTemporal; 
		concatTemporal = str_concat(concatTemporal, hashActual);
		free(viejaVersion);
	}
	nodoActual = nodoActual -> next;
}
return concatTemporal;


}

void string_proc_list_add_node(string_proc_list* list, uint8_t type, char* hash){
	string_proc_node* aNode = string_proc_node_create(type, hash);
	// ! es not
	if (list -> first == NULL) {
		list -> first = aNode;
		list -> last = aNode; 
	}
	// pensa como que list last, te da la direccion es una direccion apuntando a tal cosa
	// entonces, anteriorUltimo, es una direccion que en su contenido contiene
	// una direccion con un nodo, entonces, eso es lo que le asignas, decis 
	// anteriorUltimo, tiene una direccion a nodo, que es lo que le asignaras. 
	// que tambien una direccion a un nodo (EL "APUNTA A TAL COSA") SE VE
	// MUY SUTIL EL INICIO. ME REFIERO A "DIRECCION QUE CONTIENE UNA DIRECCION"
	// ESA "DIRECCION DE INICIO SI QUERES NO LA VEAS. "
	else {	
		string_proc_node* anteriorUltimo = list -> last;
		list -> last = aNode;
		anteriorUltimo -> next = aNode;
		aNode -> previous = anteriorUltimo;
		
	}

}

string_proc_node* string_proc_node_create(uint8_t type, char* hash){
string_proc_node* aNode = malloc(sizeof(string_proc_node));
	aNode -> next = NULL;
	aNode -> previous = NULL;
	aNode -> type = type;
	aNode -> hash = hash; // aca hash contiene tal cosa, entonces digo que contenga el inicio de la direccion.

	return aNode;

}
string_proc_list* string_proc_list_create(void){
	string_proc_list* aList = malloc(sizeof(string_proc_list));
	aList -> first = NULL; 
	aList -> last = NULL; 
	return aList;
}
