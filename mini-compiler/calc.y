%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token NUMBER
%left '+' '-'
%left '*' '/'

%%
input:
    | input line
    ;

line:
    '\n'
  | expr '\n'   { printf("Result = %d\n", $1); }
  ;

expr:
    NUMBER              { $$ = $1; }
  | expr '+' expr       { $$ = $1 + $3; }
  | expr '-' expr       { $$ = $1 - $3; }
  | expr '*' expr       { $$ = $1 * $3; }
  | expr '/' expr       { $$ = $1 / $3; }
  | '(' expr ')'        { $$ = $2; }
  ;
%%
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
