
typedef struct no *ptno;

struct no {
    int valor;
    int tipo;
    ptno filho;
    ptno irmao;
};

ptno criaNo(int tipo, int valor) {
    ptno novo_no = (ptno)malloc(sizeof(struct no));
    if (!novo_no) {
        return NULL;
    }
    novo_no->valor = valor;
    novo_no->tipo = tipo;
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

void mostra(ptno no, int nivel) {
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
}
void geraNos(FILE *fp, ptno raiz){
    ptno p;
    fprintf(fp, "\tn%p [label=\"%c|%d\"]\n", raiz, raiz->tipo, raiz->valor);
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
    system("xdg-open tree.png &");
}

