#include <stdlib.h>
#include <stdio.h>

#include "mod_oper.h"

node *mem = NULL;
node *tail = NULL;

bool write_list(payload p, bool is_val) {
    node *new_node = malloc(sizeof(node));

    if (new_node != NULL) {
        new_node->val = p;
        new_node->is_val = is_val;
        new_node->next = NULL;
        new_node->prev = tail;

        if (mem != NULL) {
            tail->next = new_node;
        } else {
            mem = new_node;
        }

        tail = new_node;

        return true;
    }

    return false;
}

int pop() {
    int ret_val = 0;
    if (mem != NULL) {
        node *to_free = tail;
        tail = tail->prev;
        if (tail != NULL) {
            tail->next = NULL;
        } else {
            mem = NULL;
        }

        ret_val = to_free->val.val;
        free(to_free);
    }

    return ret_val;
}

void clear_list(bool print) {
    while (mem != NULL) {
        node *to_free = mem;
        mem = mem->next;

        if (print) {
            if (to_free->is_val) {
                printf("%d ", to_free->val.val);
            } else {
                printf("%c ", to_free->val.oper);
            }
        }

        free(to_free);
    }
    tail = NULL;

    if (print) {
        printf("\n");
    }
}

/**
 * EXTENDED EUCLID's ALGORITHM
*/
int inv_mulmod(int a) {
    a = a >= 0 ? a : MOD_G + a;

    int x = 0, y = 1, u = 1, v = 0;
    int b = MOD_G;
    while (a != 0) {
        int q = b / a, r = b % a;
        int m = x - u * q, n = y - v * q;
        b = a, a = r, x = u, y = v, u = m, v = n;
    }

    return x / b;
}

inline int inv_addmod(int a, int mod) {
    return a >= 0 ? a % mod : mod + (a % mod);
}

int add_mod(int a, int b) {
    return (a + b) % MOD_G;
}

int sub_mod(int a, int b) {
    return (a - b) % MOD_G;
}

int mul_mod(int a, int b) {
    int acc = 0;
    b = b >= 0 ? b : MOD_G + b;

    for (int i=0; i<b; ++i) {
        acc = add_mod(acc, a);
    }

    return acc;
}

int div_mod(int a, int b) {
    return mul_mod(a, inv_mulmod(b));
}

int pow_mod(int a, int b) {
    bool inv;
    b = (inv = b < 0) ? -b : b;

    int acc = 1;
    for (int i=0; i<b; ++i) {
        acc = mul_mod(acc, a);
    }

    return inv ? inv_mulmod(acc) : acc;
}
