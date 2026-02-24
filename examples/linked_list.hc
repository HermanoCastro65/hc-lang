#include <stdio.h>
#include <stdlib.h>

struct Node
    int data
    struct Node *next

struct Node* create_node(int value)
    struct Node *new_node = malloc(sizeof(struct Node))
    new_node->data = value
    new_node->next = NULL
    return new_node

void print_list(struct Node *head)
    struct Node *current = head
    while (current != NULL)
        printf("%d\n", current->data)
        current = current->next

int main()
    struct Node *head = create_node(10)
    head->next = create_node(20)
    head->next->next = create_node(30)

    print_list(head)

    return 0