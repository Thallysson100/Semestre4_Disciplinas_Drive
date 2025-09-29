
%{
    #include <stdio.h>
    int yylex(void);
    void yyerror(char *);

%}

%token T_ENTER
%token T_MAIS
%token T_MENOS
%token T_MULT
%token T_DIV
%token T_ABRE
%token T_FECHA
%token T_NUM

%start calculo

%left T_MAIS T_MENOS
%left T_MULT T_DIV

%%
calculo : calculo expr T_ENTER {printf("result = %d\n", $2);}
        |
        ;

expr : expr T_MAIS expr {$$ = $1 + $3;}
     | expr T_MENOS expr {$$ = $1 - $3;}
     | expr T_MULT expr {$$ = $1 * $3;}
     | expr T_DIV expr {$$ = $1 / $3;}
     | T_ABRE expr T_FECHA {$$ = $2;}
     | T_NUM {$$ = $1;}
     ;

%%

void yyerror (char *msg){
    printf("Erro: %s\n", msg);
} 

int main(){
    yyparse();
    return 0;
}