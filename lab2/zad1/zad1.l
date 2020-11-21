%{
#include <stdio.h>

int yywrap();
int yylex();

unsigned int lines, words;
unsigned int had_word;
%}

%%
^[ \t]*\n {
    had_word = 0;
}

[ \t]+ {
    if (had_word) {
        printf(" ");
    }
}

[^ ^\t^\n]+ {
    ++words;
    ++had_word;
    printf("%s", yytext);
}

[ \t]*\n {
    had_word = 0;
    ++lines;
    printf("\n");
}

<<EOF>> {
    if (had_word) {
        ++lines;
        printf("\n");
    }

    return 0;
}
%%

int main(int argc, char *argv[]) {
    yylex();
    printf("lines = %u, words = %u\n", lines, words);
}
