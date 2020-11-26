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
        clear_list(true);
        printf("= \033[0;31m%d\033[0m\n\n", inv_addmod($$));
    }
    | error END	{
        clear_list(false);
        printf("Błąd składni!\n");
    }
;

expr: VAL {
        write_list((payload){ .val = $1 % MOD_G }, true);
    }
    | expr ADD expr {
        $$ = add_mod($1 % MOD_G, $3 % MOD_G);
        write_list((payload){ .oper = '+' }, false);
    }
    | expr SUB expr {
        $$ = sub_mod($1 % MOD_G, $3 % MOD_G);
        write_list((payload){ .oper = '-' }, false);
    }
    | expr MUL expr {
        $$ = mul_mod($1 % MOD_G, $3 % MOD_G);
        write_list((payload){ .oper = '*' }, false);
    }
    | expr DIV expr {
        $$ = div_mod($1 % MOD_G, $3 % MOD_G);
        write_list((payload){ .oper = '/' }, false);
    }
    | SUB _umin %prec UNARY_MINUS {
        $$ = -$2;
    }
    | _powl POW _powr {
        $$ = pow_mod($1 % MOD_G, $3 % MOD_G);
        write_list((payload){ .oper = '^' }, false);
    }
    | L_BRACE expr R_BRACE {
        $$ = $2;
    }
;

_umin: VAL {
        write_list((payload){ .val = inv_addmod(-$1) }, true);
    }
    | L_BRACE expr R_BRACE {
        $$ = $2;
    }
;

_powr: VAL {
        write_list((payload){ .val = $1 % MOD_G }, true);
    }
    | SUB _powr %prec UNARY_MINUS {
        $$ = -$2;
        int top = pop();
        write_list((payload){ .val = inv_addmod(-top) }, true);
    }
    | L_BRACE _powr R_BRACE { $$ = $2; }
;

_powl: VAL {
        write_list_first((payload){ .val = $1 % MOD_G }, true);
    }
    | L_BRACE expr R_BRACE {
        $$ = $2;
    }
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
