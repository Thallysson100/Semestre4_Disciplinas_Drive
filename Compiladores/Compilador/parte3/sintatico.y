%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "utils.c"

    extern int yyerror(char *);

    extern char atomo[100];
    int yylex(void); 
    
    extern FILE *yyin, *yyout;

    int contaVar =0;
    int tipo;
    int rotulo = 0;
%}

%token T_PROGRAMA T_INICIO T_FIM T_IDENTIF T_LEIA T_ESCREVA
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
    : cabecalho 
        {fprintf(yyout,"\tINPP\n");}
    variaveis 
        {
            fprintf(yyout,"\tAMEM\t%d\n", contaVar);
            empilha(contaVar);
        }
    T_INICIO lista_comandos T_FIM
        {
            int conta = desempilha();
            fprintf(yyout,"\tDMEM\t%d\n", conta);
            fprintf(yyout,"\tFIMP\n");
        }
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
        {tipo = LOG;}
    | T_INTEIRO
        {tipo = INT;}
    ;

lista_variaveis
    : lista_variaveis T_IDENTIF
        {
            strcpy(elemTab.id, atomo);
            elemTab.tip = tipo;
            elemTab.end = contaVar++;
            insereSimbolo(elemTab);
        }
    | T_IDENTIF
        {
            strcpy(elemTab.id, atomo);
            elemTab.tip = tipo;
            elemTab.end = contaVar++;
            insereSimbolo(elemTab);
        }
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

leitura 
    : T_LEIA T_IDENTIF 
        {
            int i = buscaSimbolo(atomo);
            fprintf(yyout,"\tLEIA\n");
            fprintf(yyout,"\tARZG\t%d\n", tabSimb[i].end);
        }
    ;

escrita 
    : T_ESCREVA expressao 
        {fprintf(yyout,"\tESCR\n");}
    ;

repeticao 
    : T_ENQTO 
        {
            fprintf(yyout,"L%d\tNADA\n", ++rotulo);
            empilha(rotulo);
        }    
    expressao T_FACA 
        {
            fprintf(yyout,"\tDSVF\tL%d\n", ++rotulo);
            empilha(rotulo);
        }
    lista_comandos T_FIMENQTO 
        {
            int y = desempilha();
            int x = desempilha();
            fprintf(yyout,"\tDSVS\tL%d\n", x);
            fprintf(yyout,"L%d\tNADA\n", y);
        } 
    ;

selecao 
    : T_SE expressao T_ENTAO 
        {
            fprintf(yyout,"\tDSVF\tL%d\n", ++rotulo);
            empilha(rotulo);
        }
    lista_comandos T_SENAO 
        {
            int x = desempilha();
            fprintf(yyout,"\tDSVS\tL%d\n", ++rotulo);
            empilha(rotulo);
            fprintf(yyout,"L%d\tNADA\n", x);
        } 
    lista_comandos T_FIMSE 
        {
            int y = desempilha();
            fprintf(yyout,"L%d\tNADA\n", y);
        }
    ;

atribuicao 
    : T_IDENTIF 
        {
            int pos = buscaSimbolo(atomo);
            empilha(pos);
        }
    T_ATRIB expressao 
        {
            int pos = desempilha();
            fprintf(yyout,"\tARZG\t%d\n", tabSimb[pos].end);
        }
    ;

expressao
    : expressao T_OU expressao
        {fprintf(yyout,"\tDISJ\n");}
    | expressao T_E expressao
        {fprintf(yyout,"\tCONJ\n");}
    | expressao T_IGUAL expressao
        {fprintf(yyout,"\tCMIG\n");}
    | expressao T_MAIOR expressao
        {fprintf(yyout,"\tCMMA\n");}
    | expressao T_MENOR expressao
        {fprintf(yyout,"\tCMME\n");}
    | expressao T_MAIS expressao
        {fprintf(yyout,"\tSOMA\n");} 
    | expressao T_MENOS expressao
        {fprintf(yyout,"\tSUBT\n");}
    | expressao T_VEZES expressao
        {fprintf(yyout,"\tMULT\n");} 
    | expressao T_DIV expressao
        {fprintf(yyout,"\tDIVI\n");} 
    | termo
    ;

termo
    : T_IDENTIF
        {
            int i = buscaSimbolo(atomo);
            fprintf(yyout,"\tCRVG\t%d\n", tabSimb[i].end);
        }
    | T_NUMERO
        {fprintf(yyout,"\tCRCT\t%s\n", atomo);}
    | T_V
        {fprintf(yyout,"\tCRCT\t1\n");}
    | T_F
        {fprintf(yyout,"\tCRCT\t0\n");}
    | T_NAO termo
        {fprintf(yyout,"\tNEGA\t0\n");}
    | T_ABRE expressao T_FECHA
    ;

%%

int main(int argc, char **argv){
    char nameIn[30], nameOut[30], *p;
    if (argc < 2) {
        printf("Uso:\n\t%s <nome_programa>[.simples]\n\n", argv[0]);
        exit(1);
    }
    p = strstr(argv[1], ".simples");
    if (p) p = 0;
    strcpy(nameIn, argv[1]);
    strcpy(nameOut, argv[1]);
    strcat(nameIn, ".simples");
    strcat(nameOut, ".mvs");
    yyin = fopen(nameIn, "rt");
    yyout = fopen(nameOut, "wt");

    yyparse();
    printf("Programa Ok!\n");
    return 0;
}

