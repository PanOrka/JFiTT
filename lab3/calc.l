%option noyywrap

%{
#include "calc_y.h"

int yylex();
%}

%%
[ \t]+ ;

[0-9]+ {
    yylval = atoi(yytext);
    return VAL;
}

[+] {
    return ADD;
}

[-] {
    return SUB;
}

[*] {
    return MUL;
}

[/] {
    return DIV;
}

[\(] {
    return L_BRACE;
}

[\)] {
    return R_BRACE;
}

[\^] {
    return POW;
}

\n {
    return END;
}

. {
    return ERROR;
}
%%
