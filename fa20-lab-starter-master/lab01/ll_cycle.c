#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    if (head == NULL || head->next == NULL) {
        return 0;
    }
    node* tortoise = head;
    node* hare = head -> next;
    while (hare != NULL && hare ->next != NULL) {
        if (tortoise == hare) {
            return 1;
        }
        hare = hare ->next ->next;
        tortoise = tortoise ->next;
    }
    return 0;
}