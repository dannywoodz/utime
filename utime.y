%token INTEGER DAYS HOURS MINUTES SECONDS NAMED_TIME
%left '-' '+'
%{
#include <stdio.h>
extern FILE *yyin;
%}
%%

statement:expression		{ printf("%lu\n", $1); }
;

expression:
|expression '+' timespec { $$=$1 + $3; }
|expression '-' timespec { $$=$1 - $3; }
|timespec                { $$=$1; }
;

timespec: INTEGER HOURS { $$ = $1 * 60 * 60; }
|INTEGER DAYS { $$ = $1 * 60 * 60 * 24; }
|INTEGER MINUTES { $$ = $1 * 60; }
|INTEGER SECONDS
|INTEGER { $$ = $1; }
|NAMED_TIME { $$ = $1; }
;

%%

int main(int argc, char *argv[])
{
  if ( argc > 1 )
  {
    yyin = tmpfile();
    while(--argc) fprintf(yyin, "%s ", *++argv);
    fputc('\n', yyin);
    rewind(yyin);
  }
  yyparse();
  if ( yyin != stdin ) fclose(yyin);
  return 0;
}
