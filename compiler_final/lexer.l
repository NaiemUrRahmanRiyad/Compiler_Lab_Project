%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%

"int"               { printf("[LEX] Keyword: int\n"); return INT; }
"if"                { printf("[LEX] Keyword: if\n"); return IF; }
"else"              { printf("[LEX] Keyword: else\n"); return ELSE; }
"while"             { printf("[LEX] Keyword: while\n"); return WHILE; }

"=="|"!="|"<="|">="|"<"|">"   { printf("[LEX] Relop: %s\n", yytext); return RELOP; }

"="                 { printf("[LEX] Symbol: =\n"); return ASSIGN; }
";"                 { printf("[LEX] Symbol: ;\n"); return SEMI; }
"("                 { return LPAR; }
")"                 { return RPAR; }
"{"                 { return LBRACE; }
"}"                 { return RBRACE; }

"+"   { return '+'; }
"-"   { return '-'; }
"*"   { return '*'; }
"/"   { return '/'; }

[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.id = strdup(yytext);
    printf("[LEX] Identifier: %s\n", yytext);
    return ID;
}

[0-9]+ {
    yylval.num = atoi(yytext);
    printf("[LEX] Number: %s\n", yytext);
    return NUM;
}

[ \t\n\r]+          { /* skip whitespace */ }

. {
    printf("Unexpected character: %s\n", yytext);
}
