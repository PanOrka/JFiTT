%option noyywrap

%{
#include <stdint.h>

#include "calc_y.h"

int yylex();
uint8_t any_symbol = 0;
%}

%s COMMENT

%%
<INITIAL>{
    [#] {
        printf("\033[0;31m%s\033[0m", yytext);
        BEGIN(COMMENT);
    }

    [ \t]+ {
        printf("\033[0;31m%s\033[0m", yytext);
    }

    [0-9]+ {
        any_symbol = 1;
        printf("\033[0;31m%s\033[0m", yytext);
        yylval = atoi(yytext);
        return VAL;
    }

    [+] {
        any_symbol = 1;
        printf("\033[0;31m%s\033[0m", yytext);
        return ADD;
    }

    [-] {
        any_symbol = 1;
        printf("\033[0;31m%s\033[0m", yytext);
        return SUB;
    }

    [*] {
        any_symbol = 1;
        printf("\033[0;31m%s\033[0m", yytext);
        return MUL;
    }

    [/] {
        any_symbol = 1;
        printf("\033[0;31m%s\033[0m", yytext);
        return DIV;
    }

    [\(] {
        any_symbol = 1;
        printf("\033[0;31m%s\033[0m", yytext);
        return L_BRACE;
    }

    [\)] {
        any_symbol = 1;
        printf("\033[0;31m%s\033[0m", yytext);
        return R_BRACE;
    }

    [\^] {
        any_symbol = 1;
        printf("\033[0;31m%s\033[0m", yytext);
        return POW;
    }

    [\n]+ {
        if (any_symbol) {
            any_symbol = 0;
            printf("\033[0;31m%s\033[0m", yytext);
            return END;
        }

        return EMPTY;
    }

    . {
        any_symbol = 0;
        printf("\033[0;31m%s\033[0m", yytext);
        return ERROR;
    }
}

<COMMENT>{
    [\n] {
        printf("\n");
        BEGIN(INITIAL);
        if (any_symbol) {
            any_symbol = 0;
            return END;
        }
    }

    [\\][\n] {
        printf("\033[0;31m\\\n\033[0m");
    }

    . {
        printf("\033[0;31m%s\033[0m", yytext);
    }
}
%%
