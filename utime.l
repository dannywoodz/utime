%{
#include <time.h>
#include "y.tab.h"
extern int yylval;
%}

%%
now 		{ yylval = time(NULL); return NAMED_TIME; }
yesterday 	{ yylval = time(NULL) - (60 * 60 * 24); return NAMED_TIME; }
tomorrow	{ yylval = time(NULL) + (60 * 60 * 24); return NAMED_TIME; }
[0-9]+	 	{ yylval = atoi(yytext); return INTEGER; }
hours? 		return HOURS;
days? 		return DAYS;
minutes?	return MINUTES;
seconds?	return SECONDS;
[\t ] ;
\n { return 0; }
. { return yytext[0]; }

%%
