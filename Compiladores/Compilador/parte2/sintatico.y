%{
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror(char *s){ fprintf(stderr, "Erro: %s\n", s); }
    int yylex(void);
%}

%token T_PROGRAMA T_INICIO T_FIM T_IDENTIF T_LEIA T_ESCERVA
%token T_ENQTO T_FACA T_FIMENQTO T_SE T_ENTAO T_SENAO T_FIMSE
%token T_ATRIB T_VEZES T_DIV T_MAIS T_MENOS T_MAIOR T_MENOR T_IGUAL
%token T_E T_OU T_V T_F T_NUMERO T_NAO T_ABRE T_FECHA
%token T_LOGICO T_INTEIRO

%start programa

%left T_OU
%left T_E
%left T_IGUAL
%left T_MAIOR T_MENOR
%left T_MAIS T_MENOS
%left T_VEZES T_DIV
%right T_NAO

%%
programa
    : cabecalho variaveis T_INICIO lista_comandos T_FIM
    ;

cabecalho
    : T_PROGRAMA T_IDENTIF
    ;

variaveis
    : /* vazio */
    | declaracao_variaveis
    ;

declaracao_variaveis
    : declaracao_variavel declaracao_variaveis
    | declaracao_variavel
    ;

declaracao_variavel
    : tipo lista_variaveis
    ;

tipo
    : T_LOGICO
    | T_INTEIRO
    ;

lista_variaveis
    : T_IDENTIF
    | lista_variaveis T_IDENTIF
    ;

lista_comandos
    : /* vazio */
    | comando lista_comandos
    ;

comando
    : leitura
    | escrita
    | repeticao
    | selecao
    | atribuicao
    ;

leitura : T_LEIA T_IDENTIF ;
escrita : T_ESCERVA expressao ;
repeticao : T_ENQTO expressao T_FACA lista_comandos T_FIMENQTO ;
selecao : T_SE expressao T_ENTAO lista_comandos T_SENAO lista_comandos T_FIMSE ;
atribuicao : T_IDENTIF T_ATRIB expressao ;

expressao
    : expressao T_OU expressao
    | expressao T_E expressao
    | expressao T_IGUAL expressao
    | expressao T_MAIOR expressao
    | expressao T_MENOR expressao
    | expressao T_MAIS expressao
    | expressao T_MENOS expressao
    | expressao T_VEZES expressao
    | expressao T_DIV expressao
    | T_NAO expressao
    | termo
    ;

termo
    : T_IDENTIF
    | T_NUMERO
    | T_V
    | T_F
    | T_ABRE expressao T_FECHA
    ;

%%
int main(void) {
    yyparse();
    printf("Programa Ok!\n");
    return 0;
}

