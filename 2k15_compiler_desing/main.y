/* C Declarations */

%{
	#include<stdio.h>
	int sym[26],store[26];
	int dummy=3;
%}

/* BISON Declarations */

%token NUM VAR IF ELSE VOIDMAIN INT FLOAT CHAR LP RP LB RB CM SM PLUS MINUS MULT DIV ASSIGN GT LT
%nonassoc IFX
%nonassoc ELSE
%left LT GT

	
/* Simple grammar rules */

%%

program		: VOIDMAIN LP RP LB cstatement RB { printf("\nsuccessful compilation\n"); }
			;

cstatement	: /* empty */
			| cstatement statement
			| cstatement cdeclaration
			;
	
cdeclaration: TYPE ID1 SM			{ printf("\nvalid declaration\n"); }
			;
			
TYPE 		: INT
			| FLOAT
			| CHAR
			;

ID1  		: ID1 CM VAR			{ 	
										if(store[$3] == 1) printf("variable '%c' Redeclared\n",store[$3]+'a');
										else store[$3]=1;
										//printf("%d %d \n",$3, store[$3]);
										//dummy += 2;
									}
			| ID1 ASSIGN NUM		{	if(store[$3] == 1) printf("variable '%c' Redeclared\n",store[$3]+'a');
										else store[$3]=1;
									}
									
			| VAR					{	if(store[$1] == 1) printf("variable '%c' Redeclared\n",store[$1]+'a');
										else store[$1]=1;
										//printf("var %d %d \n",$1, store[$1]);
									}
			;

statement	: SM
			| expr SM 				{ printf("\nvalue of expression: %d\n", $1); }
			| VAR ASSIGN expr SM 	{ 
										sym[$1] = $3; 
										printf("%d\n",$1);
										if(store[$1]!=1)printf("Undeclared");
										printf("\nValue of the variable: %d\t\n",$3);
									}

			;
	
expr 		: VAR					{ $$ = sym[$1]; } 
			| expr MULT term			{ $$ = $1 * $3; }
			| expr DIV term			{ 
										if($3) 
										{
												$$ = $1 / $3;
										}
										else
										{
											$$ = 0;
											printf("\ndivision by zero\t");
										}
									}
			|term
			 ;
			 
term 		: term PLUS factor		{ $$ = $1 + $3; }
			|term MINUS factor		{ $$ = $1 - $3; }
			|factor 
			;
			
factor 		: digit					{ $$ = $1; }
			|LP expr RP				{ $$ = $2; }
			;
			
digit 		: NUM	    			{ $$ = $1; }
			;
			
			
%%

int yywrap()
{
return 1;
}


yyerror(char *s){
	printf( "%s\n", s);
}

