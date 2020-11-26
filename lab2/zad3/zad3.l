%{
#include <stdio.h>
#include <stdbool.h>

int yywrap();
int yylex();

bool docs = false;
%}

%s STRING_ENTRY
%s NON_DOC_STD_COMMENT
%s NON_DOC_COMMENT

%s DOC_STD_COMMENT
%s DOC_COMMENT

%%
<INITIAL>{
    ["] {
        printf("%s", yytext);
        BEGIN(STRING_ENTRY);
    }

    [/][/] {
        BEGIN(NON_DOC_STD_COMMENT);
    }

    [/][*] {
        BEGIN(NON_DOC_COMMENT);
    }

    [/][*][*!] {
        if (docs) {
            printf("%s", yytext);
            BEGIN(DOC_COMMENT);
        } else {
            BEGIN(NON_DOC_COMMENT);
        }
    }

    [/][/][/!] {
        if (docs) {
            printf("%s", yytext);
            BEGIN(DOC_STD_COMMENT);
        } else {
            BEGIN(NON_DOC_STD_COMMENT);
        }
    }
}

<STRING_ENTRY>{
    [\\]["] {
        printf("%s", yytext);
    }

    [\\][\\] {
        printf("%s", yytext);
    }

    ["] {
        printf("%s", yytext);
        BEGIN(INITIAL);
    }
}

<NON_DOC_STD_COMMENT>{
    [\\][\n] ;

    [\n] BEGIN(INITIAL);

    . ;
}

<NON_DOC_COMMENT>{
    [*][/] BEGIN(INITIAL);

    [\n] ;

    . ;
}

<DOC_STD_COMMENT>{
    [\\][\n] printf("%s", yytext);

    [\n] {
        printf("%s", yytext);
        BEGIN(INITIAL);
    }
}

<DOC_COMMENT>{
    [*][/] {
        printf("%s", yytext);
        BEGIN(INITIAL);
    }
}
%%

int main(int argc, char *argv[]) {
    if (argc >= 2) {
        docs = true;
    }
    yylex();
}
