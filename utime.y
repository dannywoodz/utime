/******************************************************************************
 * utime.y - a simple grammar definition for utime expressions
 *****************************************************************************/

%token INTEGER DAYS HOURS MINUTES SECONDS NAMED_TIME
%left '-' '+'
%{
#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include <string.h>
#include "utime.h"
extern FILE *yyin;
void yyerror(char*);
typedef enum { FORWARD, REVERSE } utime_mode_t;
static utime_mode_t mode = FORWARD;
%}
%%

statement:expression		{
  if ( mode == FORWARD ) printf("%lu\n", $1);
  else {
    struct tm time;
    char time_string[26]; /* The 26-byte requirement is specified by POSIX for asctime_r */
    time_t unix_time = $1;
    memset(&time, 0, sizeof(struct tm));
    if ( localtime_r(&unix_time, &time) == NULL )
    {
      perror("localtime");
      exit(EXIT_FAILURE);
    }
    if ( asctime_r(&time, time_string) == NULL )
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

timespec: INTEGER HOURS { $$ = $1 * HOUR_IN_SECONDS; }
|INTEGER DAYS { $$ = $1 * DAY_IN_SECONDS; }
|INTEGER MINUTES { $$ = $1 * MINUTE_IN_SECONDS; }
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

void yyerror(char *s) { puts(s); }
