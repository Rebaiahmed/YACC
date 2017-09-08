%{
#include <stdlib.h>
#include "set.h"
#include "y.tab.h"
%}

ELEM [0-9]+
  // element = entier , range non checké en lexical

VAR S_[0-9]{1,2}
  // nom de variable de S_0 a S_99

SPACE [ \t]*
COMM "#"[^\n]*

%%
union		return UNION;
inter		return INTER;
comp		return COMP;
diff		return DIFF;
[=(){},]	return yytext[0];
\n		return yytext[0];
{ELEM}		{ yylval.elem=atoi(yytext); return(ELEM);}
{VAR}		{ yylval.index=atoi(yytext+2); return(VAR);}
{COMM}		;
{SPACE}		;
. 		printf("Invalid Char : %c",yytext[0]);
%%

int yywrap(){return 1;}
