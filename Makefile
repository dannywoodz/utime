YACC=bison -y
LEX=flex

all: utime.y utime.l
	$(YACC) -d utime.y
	$(LEX) utime.l
	gcc y.tab.c lex.yy.c -o utime -lfl
clean:
	rm -f utime y.tab.c y.tab.h lex.yy.o lex.yy.c
