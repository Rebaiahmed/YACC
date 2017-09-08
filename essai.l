%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "essai.tab.h"

%}




ENSEMBLE E_[0-9]{1,2}
COMM "#"[^\n]*
%%


[0-9]+\.[0-9]+ 	{yylval.fval = atof(yytext); return T_FLOAT;}
[0-9]+		{yylval.ival = atoi(yytext); return T_INT;}
[ \t]	    { return T_SPACE ; }
"+"		{return T_PLUS;}
"-"		{return T_MINUS;}
"*"		{return T_MULTIPLY;}
"/"		{return T_DIVIDE;}
"("		{return T_LEFT;}
")"		{return T_RIGHT;}
"exit"		{return T_QUIT;}
"quit"		{return T_QUIT;}
"{" { return T_OUVRANTE ; }
"}" { return T_FERMANTE ;}
"," { return SEPARATEUR ; }
"UNION" { return T_UNION ; }
"INTER" { return T_INTER ; }
"DIFF" { return T_DIFF ; }
[=(){},]	return yytext[0];
{COMM}		;
{ENSEMBLE }		{ yylval.index=atoi(yytext+2); return(VAR);}
%%
