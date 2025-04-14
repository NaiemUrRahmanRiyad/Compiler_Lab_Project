%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *s);

/* Symbol Table */
char* symbol_table[100];
int symbol_count = 0;

int lookup(char* name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i], name) == 0) return 1;
    }
    return 0;
}

void insert(char* name) {
    if (!lookup(name)) {
        symbol_table[symbol_count++] = strdup(name);
        printf("[SEMANTIC] Declared variable: %s\n", name);
    } else {
        printf("[SEMANTIC ERROR] Variable already declared: %s\n", name);
        exit(1);
    }
}

int temp_count = 0;
char* new_temp() {
    char* temp = malloc(10);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}
%}

/* Declare types */
%union {
    int num;
    char* id;
    char* code;
}

/* Token types */
%token <id> ID
%token <num> NUM
%token INT IF ELSE WHILE
%token RELOP
%token ASSIGN SEMI LPAR RPAR LBRACE RBRACE
%left '+' '-'
%left '*' '/'

/* Non-terminal types */
%type <code> statement expression

%%

program:
    declarations statements {
        printf("\n[SUCCESS] Parsing complete.\n");
    }
    ;

declarations:
    declarations declaration
    | /* empty */
    ;

declaration:
    INT ID SEMI {
        insert($2);
        free($2);
    }
    ;

statements:
    statements statement
    | /* empty */
    ;

statement:
    ID ASSIGN expression SEMI {
        if (!lookup($1)) {
            printf("[SEMANTIC ERROR] Undeclared variable: %s\n", $1);
            exit(1);
        }
        printf("[ICG] %s = %s\n", $1, $3);
        free($1); free($3);
    }
    ;

expression:
    expression '+' expression {
        char* temp = new_temp();
        printf("[ICG] %s = %s + %s\n", temp, $1, $3);
        free($1); free($3);
        $$ = temp;
    }
    | expression '-' expression {
        char* temp = new_temp();
        printf("[ICG] %s = %s - %s\n", temp, $1, $3);
        free($1); free($3);
        $$ = temp;
    }
    | expression '*' expression {
        char* temp = new_temp();
        printf("[ICG] %s = %s * %s\n", temp, $1, $3);
        free($1); free($3);
        $$ = temp;
    }
    | expression '/' expression {
        char* temp = new_temp();
        printf("[ICG] %s = %s / %s\n", temp, $1, $3);
        free($1); free($3);
        $$ = temp;
    }
    | ID {
        if (!lookup($1)) {
            printf("[SEMANTIC ERROR] Undeclared variable: %s\n", $1);
            exit(1);
        }
        $$ = $1;
    }
    | NUM {
        char* temp = malloc(10);
        sprintf(temp, "%d", $1);
        $$ = temp;
    }
    ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "[SYNTAX ERROR] %s\n", s);
}

int main() {
    printf("===== Compilation Start =====\n\n");
    yyparse();
    printf("\n===== Compilation End =====\n");
    return 0;
}
