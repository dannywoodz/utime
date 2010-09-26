%token INTEGER DAYS HOURS MINUTES SECONDS NAMED_TIME
%left '-' '+'
%{
#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include <string.h>
extern FILE *yyin;
typedef enum { FORWARD, REVERSE } utime_mode_t;
static utime_mode_t mode = FORWARD;
%}
%%

statement:expression		{
  if ( mode == FORWARD ) printf("%lu\n", $1);
  else {
    struct tm *time;
    char *time_string;
    time_t unix_time = $1;
    if ( (time = localtime(&unix_time)) == NULL )
    {
      perror("localtime");
      exit(EXIT_FAILURE);
    }
    if ( (time_string = asctime(time)) == NULL )
    {
      perror("asctime");
      exit(EXIT_FAILURE);
    }
    printf("%s", time_string);
  }
}
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
  if ( argc > 1 && strcmp(argv[1], "-r") == 0 )
  {
    mode = REVERSE;
    argv++; argc--;
  }
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
