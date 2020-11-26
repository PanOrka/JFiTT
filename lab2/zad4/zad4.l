%{
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

int yywrap();
int yylex();

typedef struct lifo lifo;
typedef int (*oper)(int, int);

struct lifo {
    lifo *prev;
    int val;
};

lifo *q = NULL;

void put(int a) {
    lifo *new_q = malloc(sizeof(lifo));
    if (!new_q) {
        printf("\nERROR: not enough heap memory!\n");
        exit(EXIT_FAILURE);
    }
    new_q->prev = q;
    new_q->val = a;

    q = new_q;
}

int pop() {
    if (!q) {
        printf("\nERROR: too few arguments!\n");
        exit(EXIT_FAILURE);
    }

    lifo *old_q = q;
    int ret_val = q->val;

    q = q->prev;
    free(old_q);

    return ret_val;
}

void exec(oper f) {
    int a = pop();
    int b = pop();

    put(f(b, a));
}

void end_st() {
    int ans = pop();
    if (!q) {
        printf("\n= %d\n\n", ans);
    } else {
        printf("\nERROR: too few operators!\n");
        exit(EXIT_FAILURE);
    }
}

int add(int a, int b) {
    return a + b;
}

int sub(int a, int b) {
    return a - b;
}

int mul(int a, int b) {
    return a * b;
}

int divide(int a, int b) {
    if (b == 0) {
        printf("\nERROR: division by 0!\n");
        exit(EXIT_FAILURE);
    }

    return a / b;
}

int power(int a, int b) {
    int acc = 1;
    for (int i = 0; i < b; ++i) {
        acc *= a;
    }

    return acc;
}

int mod(int a, int b) {
    return a % b;
}

%}

%%
-?[0-9]+ {
    printf("%s", yytext);
    put(atoi(yytext));
}

[+] {
    printf("%s", yytext);
    exec(&add);
}

[-] {
    printf("%s", yytext);
    exec(&sub);
}

[*] {
    printf("%s", yytext);
    exec(&mul);
}

[/] {
    printf("%s", yytext);
    exec(&divide);
}

"^" {
    printf("%s", yytext);
    exec(&power);
}

[%] {
    printf("%s", yytext);
    exec(&mod);
}

[\n] {
    end_st();
}

[ ] printf(" ");

. {
    printf("\nERROR: wrong symbol \"%s\"!\n", yytext);
    exit(EXIT_FAILURE);
}
%%

int main(int argc, char *argv[]) {
    yylex();
}
