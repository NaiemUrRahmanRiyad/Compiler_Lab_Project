%{
#include "parser.tab.h"
#include <string.h>
%}

%%

"int"               { return INT; }
"if"                { return IF; }
"else"              { return ELSE; }
"while"             { return WHILE; }

"=="|"!="|"<="|">="|"<"|">"   { return RELOP; }

"="                 { return ASSIGN; }
";"                 { return SEMI; }
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
    printf("Token: ID (%s)\n", yytext);
    return ID;
}

[0-9]+ {
    yylval.num = atoi(yytext);
    printf("Token: NUM (%s)\n", yytext);
    return NUM;
}

[ \t\n\r]+          { /* skip whitespace */ }

. {
    printf("Unexpected character: %s\n", yytext);
}
