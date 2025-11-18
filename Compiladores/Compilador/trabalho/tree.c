/*+=============================================================
|           UNIFAL = Universidade Federal de Alfenas .
|           BACHARELADO EM CIENCIA DA COMPUTACAO.
| Trabalho ..: Construcao Arvore Sintatica e Geracao de Codigo
| Disciplina : Teoria de Linguagens e Compiladores
| Professor .: Luiz Eduardo da Silva
| Aluno .....: Thallysson Luis Teixeira Carvalho   2024.1.08.022
| Data ......: 30/11/2025
+=============================================================**/

// Enumerador para os tipos de nós na árvore sintática
typedef enum {
        PRG, // Programa
        IDF, // Identificador
        DVR, // Declaração de Variáveis
        LVR, // Lista de Variáveis
        LCM, // Lista de Comandos
        TIP, // Tipo (de identificador)
        LER, // Leitura
        ESC, // Escrita
        REP, // Repetição
        SEL, // Seleção
        ATR, // Atribuição
        OU,  // Ou
        E,   // E
        IGUAL, // Igual
        MAI, // Maior
        MEN, // Menor
        SUM, // Soma
        SUB, // Subtração
        MULT, // Multiplicação
        DIV, // Divisão
        NAO, // Negação
        VAR, // Variável
        NUM, // Número
        BOOL // Booleano
} TipoNo;

typedef struct no *ptno;

struct no {
    char *valor;
    TipoNo tipo;
    ptno filho;
    ptno irmao;
};



ptno criaNo(TipoNo tipo, char *valor) {
    ptno novo_no = (ptno)malloc(sizeof(struct no));
    if (!novo_no) {
        return NULL;
    }
    novo_no->tipo = tipo;
    novo_no->valor = strdup(valor);
    novo_no->filho = NULL;
    novo_no->irmao = NULL;
    return novo_no;
}

void adicionaFilho(ptno pai, ptno filho) {
    if (!pai || !filho) {
        return;
    }
    filho->irmao = pai->filho;
    pai->filho = filho;
}

/*void mostra(ptno no, int nivel) {
    if (!no) {
        return;
    }
    for (int i = 0; i < nivel; i++) {
        printf("\t");
    }

    ptno p = no->filho;
    printf("[%c|%d]\n", no->tipo, no->valor);
    while (p){
        mostra(p, nivel + 1);
        p = p->irmao;
    }
}*/

char* tipoToString(TipoNo tipo) {
    switch (tipo) {
        case PRG: return "programa";
        case IDF: return "identificador";
        case DVR: return "declaracao de variaveis";
        case TIP: return "tipo";
        case LVR: return "lista variaveis";
        case LCM: return "lista comandos";
        case LER: return "leitura";
        case ESC: return "escrita";
        case REP: return "repeticao";
        case SEL: return "selecao";
        case ATR: return "atribuicao";
        case OU: return "ou";
        case E: return "e";
        case IGUAL: return "compara igual";
        case MAI: return "compara maior";
        case MEN: return "compara menor";
        case SUM: return "soma";
        case SUB: return "subtrai";
        case MULT: return "multiplica";
        case DIV: return "divide";
        case NAO: return "negacao (nao)";
        case VAR: return "variavel";
        case NUM: return "numero";
        case BOOL: return "booleano";
        default: return "UNKNOWN";
    }
}

void geraNos(FILE *fp, ptno raiz){
    ptno p;
    fprintf(fp, "\tn%p [label=\"%s|%s\"]\n", raiz, tipoToString(raiz->tipo), raiz->valor);
    p = raiz->filho;
    while (p){
        geraNos(fp, p);
        p = p->irmao;
    }
}
void geraLigacoes(FILE *fp, ptno raiz){
    ptno p;
    p = raiz->filho;
    while (p){
        fprintf(fp, "\tn%p -> n%p\n", raiz, p);
        geraLigacoes(fp, p);
        p = p->irmao;
    }

}

void geraDot(ptno raiz) {
    FILE *fp = fopen("tree.dot", "wt");
    fprintf(fp, "digraph {\n");
    fprintf(fp, "\tnode [shape=record , height = .1];\n");
    geraNos(fp, raiz);
    geraLigacoes(fp, raiz);
    fprintf(fp, "}\n");
    fclose(fp);
    system("dot -Tpng tree.dot -o tree.png &");
    //system("xdg-open tree.png &");
}

