/******************************************************************************
 * utime.l - lexer instructions for identifying tokens for the utime program.
 *****************************************************************************/

%{
#include <time.h>
#include <string.h>
#include "y.tab.h"
#include "utime.h"
extern int yylval;
char buffer[11];
struct tm *timestruct;
time_t timeval;
%}

%%
now 		{ yylval = time(NULL); return NAMED_TIME; }
today {
  time(&timeval);
  timestruct = localtime(&timeval);
  // Get the string from the time, deliberately losing precision
  strftime(&buffer[0], sizeof(buffer), "%d-%m-%Y", timestruct);
  // Convert the (less-precise) time string back to a struct tm
  memset(timestruct, 0, sizeof(struct tm));
  strptime(&buffer[0], "%d-%m-%Y", timestruct);  
  yylval = mktime(timestruct);
  return NAMED_TIME;
  }
yesterday 	{ yylval = time(NULL) - DAY_IN_SECONDS; return NAMED_TIME; }
tomorrow	{ yylval = time(NULL) + DAY_IN_SECONDS; return NAMED_TIME; }
[0-9]+	 	{ yylval = atoi(yytext); return INTEGER; }
hours? 		return HOURS;
days? 		return DAYS;
minutes?	return MINUTES;
seconds?	return SECONDS;
[\t ] ;
\n { return 0; }
. { return yytext[0]; }

%%
