#ifndef MOD_OPER_H
#define MOD_OPER_H

#ifndef MOD_G
#define MOD_G 1234577
#endif

int inv_mulmod(int a);

int add_mod(int a, int b);

int sub_mod(int a, int b);

int mul_mod(int a, int b);

int div_mod(int a, int b);

int pow_mod(int a, int b);

#endif
