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

line: expr END 	{ printf("= %d\n", ($$ >= 0 ? $$ % MOD_G : MOD_G + ($$ % MOD_G))); }
    | error END	{ printf("Błąd składni!\n"); }
;

expr: VAL
    | expr ADD expr { $$ = add_mod($1 % MOD_G, $3 % MOD_G); }
    | expr SUB expr { $$ = sub_mod($1 % MOD_G, $3 % MOD_G); }
    | expr MUL expr { $$ = mul_mod($1 % MOD_G, $3 % MOD_G); }
    | expr DIV expr { $$ = div_mod($1 % MOD_G, $3 % MOD_G); }
    | SUB expr %prec UNARY_MINUS { $$ = -$2; }
    | VAL POW _pow { $$ = pow_mod($1 % MOD_G, $3 % MOD_G); }
    | L_BRACE expr R_BRACE { $$ = $2; }
;

_pow: VAL
    | SUB _pow %prec UNARY_MINUS { $$ = -$2; }
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
