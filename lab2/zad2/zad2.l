%{
#include <stdio.h>

int yywrap();
int yylex();
%}

%s DOC_STRING_A
%s DOC_STRING_B
%s STRING_A
%s STRING_B
%s HASH

%%
<INITIAL>{
    [#] {
        BEGIN(HASH);
    }

    ['][']['] {
        printf("%s", yytext);
        BEGIN(DOC_STRING_A);
    }

    ["]["]["] {
        printf("%s", yytext);
        BEGIN(DOC_STRING_B);
    }

    ['] {
        printf("%s", yytext);
        BEGIN(STRING_A);
    }

    ["] {
        printf("%s", yytext);
        BEGIN(STRING_B);
    }
}

<DOC_STRING_A>{
    ['][']['] {
        printf("%s", yytext);
        BEGIN(INITIAL);
    }
}

<DOC_STRING_B>{
    ["]["]["] {
        printf("%s", yytext);
        BEGIN(INITIAL);
    }
}

<STRING_A>{
    \\['] {
        printf("%s", yytext);
    }

    ['] {
       printf("%s", yytext); 
    }
}

<STRING_B>{
    \\["] {
        printf("%s", yytext);
    }

    ["] {
       printf("%s", yytext);
       BEGIN(INITIAL);
    }
}

<HASH>{
    [\n] {
        BEGIN(INITIAL);
    }

    . ;
}
%%

int main(int argc, char *argv[]) {
    yylex();
}
