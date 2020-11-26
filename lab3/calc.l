%option noyywrap

%{
#include "calc_y.h"

int yylex();
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
        printf("\033[0;31m%s\033[0m", yytext);
        yylval = atoi(yytext);
        return VAL;
    }

    [+] {
        printf("\033[0;31m%s\033[0m", yytext);
        return ADD;
    }

    [-] {
        printf("\033[0;31m%s\033[0m", yytext);
        return SUB;
    }

    [*] {
        printf("\033[0;31m%s\033[0m", yytext);
        return MUL;
    }

    [/] {
        printf("\033[0;31m%s\033[0m", yytext);
        return DIV;
    }

    [\(] {
        printf("\033[0;31m%s\033[0m", yytext);
        return L_BRACE;
    }

    [\)] {
        printf("\033[0;31m%s\033[0m", yytext);
        return R_BRACE;
    }

    [\^] {
        printf("\033[0;31m%s\033[0m", yytext);
        return POW;
    }

    \n {
        printf("\033[0;31m%s\033[0m", yytext);
        return END;
    }

    . {
        printf("\033[0;31m%s\033[0m", yytext);
        return ERROR;
    }
}

<COMMENT>{
    [\n] {
        printf("\033[0;31m%s\033[0m", yytext);
        BEGIN(INITIAL);
    }

    [\\][\n] {
        printf("\033[0;31m%s\033[0m", yytext);
        BEGIN(COMMENT);
    }

    . {
        printf("\033[0;31m%s\033[0m", yytext);
    }
}
%%
