YACC=bison -y
LEX=flex

all: ptime.y ptime.l
	$(YACC) -d ptime.y
	$(LEX) ptime.l
	gcc y.tab.c lex.yy.c -o ptime -lfl -ly
clean:
	rm -f ptime y.tab.c y.tab.h lex.yy.o lex.yy.c
