#include <stdbool.h>

#include "mod_oper.h"

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
