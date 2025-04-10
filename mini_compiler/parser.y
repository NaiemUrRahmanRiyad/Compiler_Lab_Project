%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>  // For strdup

int yylex();
void yyerror(const char *s);
%}

%union {
    int num;
    char* id;
}

%token <id> ID
%token <num> NUM
%token INT IF ELSE WHILE
%token RELOP
%token ASSIGN SEMI LPAR RPAR LBRACE RBRACE
%left '+' '-'
%left '*' '/'

%%

program:
    declarations statements
    {
        printf("Parsing completed successfully!\n");
    }
    ;

declarations:
    declarations declaration
    | /* empty */
    ;

declaration:
    INT ID SEMI
    {
        printf("Parsed declaration: int %s;\n", $2);
        free($2); // Free memory allocated by strdup
    }
    ;

statements:
    statements statement
    | /* empty */
    ;

statement:
    ID ASSIGN expression SEMI
    {
        printf("Parsed assignment to variable.\n");
        free($1);
    }
    | IF LPAR condition RPAR statement ELSE statement
    {
        printf("Parsed IF-ELSE statement.\n");
    }
    | WHILE LPAR condition RPAR statement
    {
        printf("Parsed WHILE loop.\n");
    }
    | LBRACE statements RBRACE
    {
        printf("Parsed block statement.\n");
    }
    ;

condition:
    expression RELOP expression
    {
        printf("Parsed condition with RELOP.\n");
    }
    ;

expression:
    expression '+' expression
    | expression '-' expression
    | expression '*' expression
    | expression '/' expression
    | LPAR expression RPAR
    | ID { free($1); }
    | NUM
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
}

int main() {
    printf("Enter code:\n");
    return yyparse();
}
