%{
  #include "sintatico.h"
  char atomo[100];
  int nLin = 1;  /* variavel para contar as linhas */
  int yyerror(char *);



  void verifica_palavra_parecida(const char *);
  int distancia(const char *, const char *);
  /* lista de palavras reservadas da linguagem */
  const char *reservadas[] = {
    "programa", "inicio", "fimprograma", "leia", "escreva",
    "se", "entao", "senao", "fimse", "enquanto", "faca", "fimenquanto",
    "inteiro", "logico", "V", "F", "div", "e", "ou", "nao"
  };
  int num_reservadas = sizeof(reservadas)/sizeof(reservadas[0]);
  
%}


identificador [a-zA-Z][a-zA-Z0-9]*
numero        [0-9]+
espaco        [ \t]+
novalinha     [\n]

%x coment

%%

programa                { return  T_PROGRAMA;}
inicio                  { return  T_INICIO;}
fimprograma             { return  T_FIM;}
leia                    { return  T_LEIA;}
escreva                 { return  T_ESCREVA;}
se                      { return  T_SE;}
entao                   { return  T_ENTAO;}
senao                   { return  T_SENAO;}
fimse                   { return  T_FIMSE;}
enquanto                { return  T_ENQTO;}
faca                    { return  T_FACA;}
fimenquanto             { return  T_FIMENQTO;}

"+"                      {return T_MAIS;}
"-"                      {return T_MENOS;}
"*"                      {return T_VEZES;}
"div"                    {return T_DIV;}

">"                      {return T_MAIOR;}
"<"                      {return T_MENOR;}
"="                      {return T_IGUAL;}

"e"                      {return T_E;}
"ou"                     {return T_OU;}
"nao"                    {return T_NAO;}

"<-"                     {return T_ATRIB;}

"("                      {return T_ABRE;}
")"                      {return T_FECHA;}

"inteiro"                {return T_INTEIRO;}
"logico"                 {return T_LOGICO;}

"V"                      {return T_V;}
"F"                      {return T_F;}

"//".*                   /* nada */
"/*"                     BEGIN(coment);
<coment>"*/"             BEGIN(INITIAL);
<coment>"./"             /* nada */
<coment>"\n"             ++nLin;

{identificador}         {
                          strcpy(atomo, yytext);
                          verifica_palavra_parecida(atomo);
                          return T_IDENTIF;
            
                        }

{numero}                {
                          strcpy (atomo, yytext);
                          return T_NUMERO;  
                        }
{espaco}                 /* nada */ 
{novalinha}              ++nLin;
.                        yyerror("ERRO LEXICO - simbolo desconhecido!");

%%

int yywrap (void) {return 1;}
int yyerror(char *s){
    printf("\nErro na linha %d: %s próximo de %s\n\n", nLin, s, yytext);
    exit (10);
}








/* função para calcular a distância de Levenshtein */
int distancia(const char *s1, const char *s2) {
    int len1 = strlen(s1), len2 = strlen(s2);
    int i, j;
    int **d = malloc((len1+1) * sizeof(int*));
    for (i = 0; i <= len1; i++) d[i] = malloc((len2+1) * sizeof(int));

    for (i = 0; i <= len1; i++) d[i][0] = i;
    for (j = 0; j <= len2; j++) d[0][j] = j;

    for (i = 1; i <= len1; i++) {
        for (j = 1; j <= len2; j++) {
            int custo = (s1[i-1] == s2[j-1]) ? 0 : 1;
            int del = d[i-1][j] + 1;
            int ins = d[i][j-1] + 1;
            int sub = d[i-1][j-1] + custo;
            d[i][j] = (del < ins ? (del < sub ? del : sub) : (ins < sub ? ins : sub));
        }
    }

    int result = d[len1][len2];
    for (i = 0; i <= len1; i++) free(d[i]);
    free(d);
    return result;
}

/* verifica se o identificador parece uma palavra reservada */
void verifica_palavra_parecida(const char *id) {
    for (int i = 0; i < num_reservadas; i++) {
        int d = distancia(id, reservadas[i]);
        if (d > 0 && d <= 1 && (strlen(reservadas[i]) > 2 || strlen(id) > 1)) { /* 1 a 2 letras diferentes */
            fprintf(stderr, "Aviso: palavra '%s' parece com '%s' (linha %d)\n", id, reservadas[i], nLin);
            break;
        }
    }
}