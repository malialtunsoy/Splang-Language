parser: y.tab.c lex.yy.c
	gcc -o parser y.tab.c
	./parser < splang.test
	rm -f y.tab.c lex.yy.c parser
y.tab.c: splang.yacc lex.yy.c
	yacc splang.yacc
lex.yy.c: splang.lex
	lex splang.lex
clean:
	rm -f lex.yy.c y.tab.c parser
