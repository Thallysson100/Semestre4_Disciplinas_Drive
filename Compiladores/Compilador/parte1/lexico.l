identificador [a-zA-Z][a-zA-Z0-9]*
numero        [0-9]+
espaco        [ \t]+
novalinha     [\n]

%{
  int nLin = 0;  /* variavel para contar as linhas */
%}

%x coment

%%

programa                 printf("%3d>%11s: palavra reservada\n", nLin,  yytext);
inicio                   printf("%3d>%11s: palavra reservada\n", nLin,  yytext);
fimprograma              printf("%3d>%11s: palavra reservada\n", nLin,  yytext);
leia                     printf("%3d>%11s: palavra reservada\n", nLin,  yytext);
escreva                  printf("%3d>%11s: palavra reservada\n", nLin,  yytext);
se                       printf("%3d>%11s: palavra reservada\n", nLin,  yytext);
entao                    printf("%3d>%11s: palavra reservada\n", nLin,  yytext);
senao                    printf("%3d>%11s: palavra reservada\n", nLin,  yytext);
fimse                    printf("%3d>%11s: palavra reservada\n", nLin,  yytext);
enquanto                 printf("%3d>%11s: palavra reservada\n", nLin,  yytext);
faca                     printf("%3d>%11s: palavra reservada\n", nLin,  yytext);
fimenquanto              printf("%3d>%11s: palavra reservada\n", nLin,  yytext);

"+"                      printf("%3d>%11s: operador de soma\n", nLin,  yytext);
"-"                      printf("%3d>%11s: operador de subtracaon\n", nLin,  yytext);
"*"                      printf("%3d>%11s: operador de multiplicacao\n", nLin,  yytext);
"div"                    printf("%3d>%11s: operador de divisao\n", nLin,  yytext);  

">"                      printf("%3d>%11s: operador relacional maior\n", nLin,  yytext);
"<"                      printf("%3d>%11s: operador relacional menor\n", nLin,  yytext);
"="                      printf("%3d>%11s: operador relacional igual\n", nLin,  yytext);

"e"                      printf("%3d>%11s: operador logico E\n", nLin,  yytext);
"ou"                     printf("%3d>%11s: operador logico OU\n", nLin,  yytext);
"nao"                    printf("%3d>%11s: operador logico NAO\n", nLin,  yytext);

"<-"                     printf("%3d>%11s: operador de atribuicao\n", nLin,  yytext);

"("                      printf("%3d>%11s: operador abre parenteses\n", nLin,  yytext);
")"                      printf("%3d>%11s: operador fecha parenteses\n", nLin,  yytext);

"inteiro"                printf("%3d>%11s: tipo inteiro\n", nLin,  yytext);
"logico"                 printf("%3d>%11s: tipo logico\n", nLin,  yytext);

"V"                      printf("%3d>%11s: constante Verdade\n", nLin,  yytext);
"F"                      printf("%3d>%11s: constante Falso\n", nLin,  yytext);

"//".*                   /* nada */
"/*"                     BEGIN(coment);
<coment>"*/"             BEGIN(INITIAL);
<coment>"./"             /* nada */
<coment>"\n"             ++nLin;

{identificador}          printf("%3d>%11s: identificador\n", nLin,  yytext);
{numero}                 printf("%3d>%11s: numero\n", nLin,  yytext);
{espaco}                 /* nada */ 
{novalinha}              ++nLin;
.                        printf("%3d>%11s: ERRO LEXICO - simbolo desconhecido!\n", nLin,  yytext);

%%

int yywrap (void) {return 1;}
int main () {
    yylex();
    printf("%d linhas (s) compiladas(s)!\n", nLin);
    return 0;
}