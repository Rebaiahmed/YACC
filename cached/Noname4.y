%{
extern int yylex();
#include <stdio.h>
#include <stdlib.h>
#include "set.h"

Set_t Var[100]; /* tableau des variables */
%}

%error-verbose

%union {
  int index;    /* valeur = indice de variable S_i */
  Elem_t elem;  /* valeur = elemt d'ensemble */
  Set_t set;    /* Ensemble (bit-vector) */
}

%token <index> VAR  
%token <elem> ELEM  
%token '(' ')' '{' '}' ',' '\n' '='

%left UNION DIFF
%left INTER
%left COMP

%type <set> Expr E_list 

%%
Ligne   :
	  | Ligne  Expr         '\n' {printf("  == "); Println_set($2);}
	  | Ligne  VAR '=' Expr '\n' {Var[$2]=$4; printf("Var[%d] = ",$2); Println_set($4);}
	  | Ligne  error        '\n' {yyerrok; printf(" ERREUR SYNTAXE \n");}
        ;

Expr : '{' '}'          {$$=Empty_set();}
     | '{' E_list '}'   {$$=$2;}
     | '(' Expr ')'     {$$=$2;}
     | Expr UNION Expr  {$$=Union_set($1,$3);}
     | Expr INTER Expr  {$$=Inter_set($1,$3);}
     | Expr DIFF Expr   {$$=Diff_set($1,$3);}
     | COMP Expr        {$$=Comp_set($2);}
     | VAR              {$$=Var[$1];}

E_list :	  ELEM  {$$=Singleton_set($1);}
     | E_list ',' ELEM  {$$=Add_elem_set($3,$1);}
%%
int yyerror (char const *message) { 
  fprintf(stderr,"<%s>\n", message);
  return 0;
}
Set_t Empty_set()                { return( 0 ); }
Set_t Union_set(Set_t A, Set_t B){ return( A | B ); }
Set_t Inter_set(Set_t A, Set_t B){ return( A & B ); }
Set_t Diff_set(Set_t A, Set_t B) { return( A & (~B) ); }
Set_t Comp_set(Set_t A)          { return( ~A ); }

boolean Is_elem_out_of_range (Elem_t x) {
  return( (x<0) || (x >= 8*sizeof(Set_t)) );
}

boolean Is_elem_in_set (Elem_t x , Set_t A) {
  return( (A & Singleton_set(x)) != 0 );
}

boolean Is_empty_set (Set_t A){
  return( A==0 );
}

Set_t Singleton_set(Elem_t x){
  if (Is_elem_out_of_range(x)) {
    fprintf(printout, "ERROR : out of range element (%d) ignored\n",x); 
    return(Empty_set());
  }
  else return((Set_t)1<<x);
}

Set_t Add_elem_set (Elem_t x, Set_t A){
  return(A|Singleton_set(x));
}

void Print_set(Set_t A){
  int i, first=0;
  fprintf(printout,"{ ");
  for(i=0; i<8*sizeof(Set_t); i++)
    if (Is_elem_in_set(i,A)) {
      if (first++) fprintf(printout,", %d",i);
      else fprintf(printout,"%d",i);
    }
  fprintf(printout," }");
}

void Println_set(Set_t A){
  Print_set(A);
  fprintf(printout,"\n");
}
int main(void) {
	//yy_scan_string ("{ 1 , 2 , 3 } \n { 1 , 2 , 3 , 2 , 1} \n {1,2} inter {1,3}   \n ({1,2} union {1,3}) inter {3,4,5}  \n {1,2} union {1,3}  inter {3,4,5} \n {0,1,2,3,4,5} diff {1,3,5} \n S_2 = {1,2,4,8,16,32,64,128}   \n S_2  \n S_2 inter comp S_2  \n comp S_2 union S_2    \n S_3 = S_2  \n {1,}    \n {1}   \n");
	
	yyparse(); 
}
