simples : lexico.l sintatico.y tree.c utils.c;
	@flex -o lexico.c lexico.l
	@bison -v -d sintatico.y -o sintatico.c
	@gcc sintatico.c -o simples

limpa : ;
	@echo "limpando..."
	@rm lexico.c sintatico.c sintatico.h sintatico.output simples
