#include <stdlib.h>
#include <stdio.h>

#include "mod_oper.h"

stack *mem = NULL;

bool write_stack(stack_element el, bool is_val) {
    stack *new_stack = malloc(sizeof(stack));

    if (new_stack != NULL) {
        new_stack->val = el;
        new_stack->is_val = is_val;
        new_stack->prev = mem;

        mem = new_stack;

        return true;
    }

    return false;
}

int pop() {
    int ret_val = 0;
    if (mem != NULL) {
        stack *to_free = mem;
        mem = mem->prev;

        ret_val = to_free->val.val;
        free(to_free);
    }

    return ret_val;
}

void clear_stack(stack *st) {
    while (st != NULL) {
        stack *to_free = st;
        st = st->prev;

        if (to_free->is_val) {
            printf("%d ", to_free->val.val);
        } else {
            printf("%c ", to_free->val.oper);
        }
        free(to_free);
    }

    printf("\n");
}

void rebuild_stack(bool cleanup) {
    stack *st = NULL;
    while (mem != NULL) {
        stack *to_swap = mem;
        mem = mem->prev;

        if (!cleanup) {
            to_swap->prev = st;
            st = to_swap;
        } else {
            free(to_swap);
        }
    }

    if (!cleanup) {
        clear_stack(st);
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

inline int inv_addmod(int a) {
    return a >= 0 ? a % MOD_G : MOD_G + (a % MOD_G);
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
