#ifndef MOD_OPER_H
#define MOD_OPER_H

#include <stdbool.h>

#ifndef MOD_G
#define MOD_G 1234577
#endif

typedef union {
    int val;
    char oper;
} stack_element;

typedef struct stack stack;

struct stack {
    stack *prev;
    stack_element val;
    bool is_val;
};

bool write_stack(stack_element el, bool is_val);
void rebuild_stack(bool cleanup);
void clear_mem();
int pop();

int inv_mulmod(int a);
int inv_addmod(int a);

int add_mod(int a, int b);

int sub_mod(int a, int b);

int mul_mod(int a, int b);

int div_mod(int a, int b);

int pow_mod(int a, int b);

#endif
