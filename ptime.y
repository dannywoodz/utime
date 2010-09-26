%token INTEGER DAYS HOURS MINUTES SECONDS NAMED_TIME
%{
#include <stdio.h>
extern FILE *yyin;
%}
%%

statement:
|timespec '+' timespec { printf("%lu\n", $1 + $3); }
|timespec '-' timespec { printf("%lu\n", $1 - $3); }
|timespec               { printf("%lu\n", $1); }
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
