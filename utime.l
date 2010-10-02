%{
#include <time.h>
#include "y.tab.h"
#include "utime.h"
extern int yylval;
%}

%%
now 		{ yylval = time(NULL); return NAMED_TIME; }
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
