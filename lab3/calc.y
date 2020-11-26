%{
#include <stdio.h>
#include "mod_oper.h"

#define YYSTYPE int

int yylex();
int yyerror(char*);
%}

%token VAL
%left ADD SUB
%left MUL DIV
%left UNARY_MINUS
%right POW
%token L_BRACE
%token R_BRACE

%token END
%token ERROR

%%
input:
    | input line
;

line: expr END {
        rebuild_stack(false);
        printf("= \033[0;31m%d\033[0m\n\n", inv_addmod($$));
    }
    | error END	{
        rebuild_stack(true);
        printf("Błąd składni!\n");
    }
;

expr: VAL {
        write_stack((stack_element){ .val = $1 % MOD_G }, true);
    }
    | expr ADD expr {
        $$ = add_mod($1 % MOD_G, $3 % MOD_G);
        write_stack((stack_element){ .oper = '+' }, false);
    }
    | expr SUB expr {
        $$ = sub_mod($1 % MOD_G, $3 % MOD_G);
        write_stack((stack_element){ .oper = '-' }, false);
    }
    | expr MUL expr {
        $$ = mul_mod($1 % MOD_G, $3 % MOD_G);
        write_stack((stack_element){ .oper = '*' }, false);
    }
    | expr DIV expr {
        $$ = div_mod($1 % MOD_G, $3 % MOD_G);
        write_stack((stack_element){ .oper = '/' }, false);
    }
    | SUB expr %prec UNARY_MINUS {
        $$ = -$2;
    }
    | VAL POW _pow {
        int top = pop();
        write_stack((stack_element){ .val = $1 }, true);
        write_stack((stack_element){ .val = top }, true);
        $$ = pow_mod($1 % MOD_G, $3 % MOD_G);
        write_stack((stack_element){ .oper = '^' }, false);
    }
    | L_BRACE expr R_BRACE {
        $$ = $2;
    }
;

_pow: VAL {
        write_stack((stack_element){ .val = $1 % MOD_G }, true);
    }
    | SUB _pow %prec UNARY_MINUS {
        $$ = -$2;
    }
    | L_BRACE _pow R_BRACE { $$ = $2; }
;
%%

int yyerror(char *s)
{
    printf("%s\n",s);
    return 0;
}

int main()
{
    yyparse();
    return 0;
}
