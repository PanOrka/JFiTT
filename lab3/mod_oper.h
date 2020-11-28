#ifndef MOD_OPER_H
#define MOD_OPER_H

#include <stdbool.h>

#ifndef MOD_G
#define MOD_G 1234577
#endif

typedef union {
    int val;
    char oper;
} payload;

typedef struct node node;

struct node {
    node *next;
    node *prev;
    payload val;
    bool is_val;
};

bool write_list(payload el, bool is_val);
void clear_list(bool print);
int pop();

int inv_addmod(int a);

int add_mod(int a, int b);

int sub_mod(int a, int b);

int mul_mod(int a, int b);

int div_mod(int a, int b);

int pow_mod(int a, int b);

#endif
