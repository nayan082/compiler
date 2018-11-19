/* C Declarations */

%{
	#include<stdio.h>
	int sym[26],store[26];
	int dummy=3;
	int forswitchcase=5;
	int forifelse = 1;
	int fvalue ;
%}

/* BISON Declarations */

%token NUM AA FOR VAR COLON BREAK DEFAULT CASE THEN IF ELSE SWITCH VOIDMAIN INT FLOAT CHAR LP RP LB RB CM SM PR PLUS MINUS MULT DIV ASSIGN GT LT GE LE EE
%nonassoc IFX
%nonassoc ELSE
%left LT GT
%left VAR

	
/* Simple grammar rules */

%%

program		: VOIDMAIN LP RP LB cstatement RB { printf("\nsuccessful compilation\n"); }
			;

cstatement	: /* empty */
			| cstatement statement
			| cstatement cdeclaration
			| cstatement structure
			;
	
cdeclaration: TYPE varlist SM			{ printf("valid declaration\n"); }
			;
			
TYPE 		: INT | FLOAT | CHAR ;
				
varlist : vassign CM varlist | vassign ;
			
vassign		: VAR					{	if(store[$1] == 1) printf("variable '%c' Redeclared\n",$1+'a');
										else store[$1]=1;
									}
									
			| VAR ASSIGN NUM 		{ 	
										if(store[$1] == 1) printf("variable '%c' Redeclared\n",$1+'a');
										else store[$1]=1;
										sym[$1] = $3; 
										//printf("%d\n",$1);
										//if(store[$1]!=1)printf("%c is undeclared",$1+'a');
										printf("\nValue of the %c = %d\t\n",$1+'a',$3);
									}
			;
			
structure  	: IF VAR operator NUM THEN COLON LB finside RB	{	if(store[$2]!=1)printf("Undeclared character : %c\n",$2+'a');
																printf("\nIf Block\n");
																if( sym[$2] > $4)
																{
																	printf("Condition True!\n");
																	printf("value of %c = %d \n",fvalue+'a', sym[fvalue]); 
																	forifelse = 0;
																}
																else
																{
																	printf("Your 'IF' condition is false!\n");
																}
															}
															
			| ELSE LB finside RB 	{ 	printf("\nElse Block\n");
										if(forifelse){
											printf("value of %c = %d \n",fvalue+'a', sym[fvalue]); 
										}
									}
			| FOR LP VAR ASSIGN NUM CM VAR LE NUM CM VAR AA RP LB finside RB 	{
																					printf("For Loop!!\n");
																					for( sym[$3]=$5; sym[$3] <= $9; sym[$3]++)
																					{
																						printf("value of %c = %d\n",fvalue+'a',sym[fvalue]);
																					}	
																				}
			
			| SWITCH LP VAR RP LB sblock RB 		{ printf("Switch case\n"); forswitchcase=sym[$3]; printf("%d",forswitchcase);}	
			
			;
			
sblock 		: caselist | caselist defaultstm ;

caselist	: casestm | casestm caselist ;

casestm		: CASE NUM COLON PR VAR SM BREAK SM		{printf("Case \n");}
			;
			
defaultstm	: DEFAULT COLON PR VAR SM 				{printf("Default \n");}
			;
			
operator	: GT | LT | EE | LE | GE ;
			
finside 	:
			| PR VAR SM	{ fvalue=$2; }
			;
			
statement	: SM
			| expr SM 				{ printf("\nvalue of expression: %d\n", $1); }
			| VAR ASSIGN expr SM 	{ 
										sym[$1] = $3; 
										//printf("%d\n",$1);
										if(store[$1]!=1)printf("%c is Undeclared",$1+'a');
										printf("\nValue of the %c = %d\t\n",$1+'a',$3);
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

