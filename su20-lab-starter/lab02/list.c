#include "list.h"

/* Add a node to the end of the linked list. Assume head_ptr is non-null. */
void append_node (node** head_ptr, int new_data) {
	/* First lets allocate memory for the new node and initialize its attributes */
	/* YOUR CODE HERE */
	node* tmp = (node*)malloc(sizeof(node));
	tmp -> val = new_data;
	tmp -> next = NULL;
	/* If the list is empty, set the new node to be the head and return */
	if (*head_ptr == NULL) {
		/* YOUR CODE HERE */
		*head_ptr = tmp;
		return;
	}
	node* curr = *head_ptr;
	while (/* YOUR CODE HERE */ curr -> next != NULL) {
		curr = curr->next;
	}
	/* Insert node at the end of the list */
	/* YOUR CODE HERE */
	curr -> next = tmp;
}

/* Reverse a linked list in place (in other words, without creating a new list).
   Assume that head_ptr is non-null. */
void reverse_list (node** head_ptr) {
	node* prev = NULL;
	node* curr = *head_ptr;
	node* tmp = NULL;
	while (curr != NULL) {
		/* INSERT CODE HERE */
		if (prev == NULL){
			prev = curr;
			curr = curr -> next;
			prev -> next = NULL;
		} else{
			tmp = curr;
			curr = curr -> next;
			tmp -> next = prev;
			prev = tmp;
		}
	}
	/* Set the new head to be what originally was the last node in the list */
	*head_ptr = prev;/* INSERT CODE HERE */
}



