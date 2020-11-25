#include <stdbool.h>

#include "mod_oper.h"

/**
 * 
 * 
 * USE EXTENDED EUCLID's ALGORITHM HERE
 * Instead of this naive shit
 * 
*/
int inv_mulmod(int a) {
    a = a >= 0 ? a : MOD_G + a;
    for (int i=1; i<MOD_G; ++i) {
        if (mul_mod(a, i) == 1) {
            return i;
        }
    }

    return 0;
}

int add_mod(int a, int b) {
    return (a + b) % MOD_G;
}

int sub_mod(int a, int b) {
    return (a - b) % MOD_G;
}

int mul_mod(int a, int b) {
    return (a * b) % MOD_G;
}

int div_mod(int a, int b) {
    return a * inv_mulmod(b);
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
