#include "ej1.h"

string_proc_list* string_proc_list_create(void){
	string_proc_list* aList = malloc(sizeof(string_proc_list));
	aList -> first = NULL; 
	aList -> last = NULL; 
	return aList;
}

string_proc_node* string_proc_node_create(uint8_t type, char* hash){
	string_proc_node* aNode = malloc(sizeof(string_proc_node));
	aNode -> next = NULL;
	aNode -> previous = NULL;
	aNode -> type = type;
	aNode -> hash = hash; // aca hash contiene tal cosa, entonces digo que contenga el inicio de la direccion.

	return aNode;
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

char* string_proc_list_concat(string_proc_list* list, uint8_t type , char* hash){
	string_proc_node* nodoActual = list -> first; 

char* concatTemporal = malloc(strlen(hash)+1); // hola"  direccion hecha con malloc hash ++ "hola"
strcpy(concatTemporal, hash);



while(nodoActual != NULL){
	uint8_t typeActual = nodoActual -> type;
	char* hashActual = nodoActual -> hash;
	if(typeActual == type){
		
		char* viejaVersion = concatTemporal;
		if (concatTemporal == hash ){  
			concatTemporal = str_concat(concatTemporal, hashActual);
			nodoActual = nodoActual -> next;
			continue;
		}
		concatTemporal = str_concat(concatTemporal, hashActual);
		free(viejaVersion); 
	}
	nodoActual = nodoActual -> next;
}
return concatTemporal;
}


/** AUX FUNCTIONS **/

void string_proc_list_destroy(string_proc_list* list){

	/* borro los nodos: */
	string_proc_node* current_node	= list->first;
	string_proc_node* next_node		= NULL;
	while(current_node != NULL){
		next_node = current_node->next;
		string_proc_node_destroy(current_node);
		current_node	= next_node;
	}
	/*borro la lista:*/
	list->first = NULL;
	list->last  = NULL;
	free(list);
}
void string_proc_node_destroy(string_proc_node* node){
	node->next      = NULL;
	node->previous	= NULL;
	node->hash		= NULL;
	node->type      = 0;			
	free(node);
}


char* str_concat(char* a, char* b) {
	int len1 = strlen(a);
    int len2 = strlen(b);
	int totalLength = len1 + len2;
    char *result = (char *)malloc(totalLength + 1); 
    strcpy(result, a);
    strcat(result, b);
    return result;  
}

void string_proc_list_print(string_proc_list* list, FILE* file){
        uint32_t length = 0;
        string_proc_node* current_node  = list->first;
        while(current_node != NULL){
                length++;
                current_node = current_node->next;
        }
        fprintf( file, "List length: %d\n", length );
		current_node    = list->first;
        while(current_node != NULL){
                fprintf(file, "\tnode hash: %s | type: %d\n", current_node->hash, current_node->type);
                current_node = current_node->next;
        }
}