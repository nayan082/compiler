/* C Declarations */

%{
	#include<stdio.h>
	int sym[26],store[26];
	int dummy=3;
	int forswitchcase=5;
	int forifelse = 1,flagforstrd=0,flagforvald=0;
	int fvalue,flagforval=0,flagforstr=0,priorityval=0,prioritystr=0,priority=0;
	int switchstack[100], check[100],checkstr[100],ll=0,l=0,flag=1,val,i;
	char switchstackstr[100][100],finsidestr[100];

	extern char str[100];
	
	void strclean(){
		for(i=0;str[i]!='\0';i++)str[i]='\0';
	}
	
	void printfunc(int flagforstr,int flagforval,int prioritystr,int priorityval){
		if(flagforstr && flagforval && prioritystr < priorityval)
		{
			printf("Your statement is = %s\n",finsidestr);
			printf("value of %c = %d\n",fvalue+'a',sym[fvalue]);
		}
		else if(flagforstr && flagforval && prioritystr > priorityval)
		{
			printf("value of %c = %d\n",fvalue+'a',sym[fvalue]);
			printf("Your statement is = %s\n",finsidestr);
		}
		else{
			if(flagforval)printf("value of %c = %d\n",fvalue+'a',sym[fvalue]);
			if(flagforstr)printf("Your statement is = %s\n",finsidestr);
		}
	}
%}

/* BISON Declarations */

%token NUM AA FOR VAR COLON BREAK DEFAULT QUOTE CASE THEN IF ELSE SWITCH VOIDMAIN INT STR FLOAT CHAR LP RP LB RB CM SM PR PLUS MINUS MULT DIV ASSIGN GT LT GE LE EE
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
										//if(store[$1]!=1)printf("'%c' is undeclared",$1+'a');
										printf("\nValue of the %c = %d\t\n",$1+'a',$3);
									}
			;
			
structure  	: IF VAR operator NUM THEN COLON LB finsidelist RB	{	
																	if(store[$2]!=1)printf("Undeclared character : %c\n",$2+'a');
																	printf("\nIf Block\n");
																	if( sym[$2] > $4)
																	{
																		printf("Condition True!\n");
																		
																		printfunc(flagforstr,flagforval,prioritystr,priorityval);
																		
																		forifelse = 0;
																	}
																	else
																	{
																		printf("Your 'IF' condition is false!\n");
																	}
																}
															
			| ELSE LB finsidelist RB 	{ 	printf("\nElse Block\n");
										if(forifelse){
											printfunc(flagforstr,flagforval,prioritystr,priorityval);
										}
									}
			| FOR LP VAR ASSIGN NUM CM VAR LE NUM CM VAR AA RP LB finsidelist RB 	{
																					printf("For Loop!!\n");
																					for( sym[$3]=$5; sym[$3] <= $9; sym[$3]++)
																					{
																						printfunc(flagforstr,flagforval,prioritystr,priorityval);
																					}
																					flagforstr=flagforval=0;
																				}
			
			
			| SWITCH LP VAR RP LB sblock RB 		{ 
														printf("Switch case\n"); 
														forswitchcase=sym[$3]; 
														//printf("%d",forswitchcase);
														if(flagforval)
															for( i=0; i<l; i++){
																if(check[i]==forswitchcase){
																	printf("value of %c = %d\n",switchstack[check[i]]+'a',sym[switchstack[check[i]]]);
																	flag=0;
																	break;
																}
															}
														l=0;
														if(flagforstr)
															for( i=0; i<ll; i++){
																if(checkstr[i]==forswitchcase){
																	printf("Your statement is = %s\n",switchstackstr[check[i]]);
																	flag=0;
																	break;
																}
															}
														
														if(flag&&flagforstrd)printf("Default: Your statement = %s\n",switchstackstr[ll]);
														if(flag&&flagforvald)printf("Default: value of %c = %d\n",val+'a',sym[val]);
														ll=0;
													}	
			
			;
			
sblock 		: caselist | caselist defaultstm ;

caselist	: casestm | casestm caselist ;

casestm		: CASE NUM COLON PR VAR SM BREAK SM		{ 	
														printf("Case \n");
														switchstack[$2]=$5;
														check[l]=$2;
														//printf("%d %d\n",$2,$5);
														l++;
														//priorityval = ++priority;
														flagforval = 1;
													}
													
			| CASE NUM COLON PR QUOTE STR QUOTE SM BREAK SM		{
														
														printf("Case \n");
														//printf("string\n");
														//printf("%s\n",str);
														checkstr[ll]=$2;
														for(i=0;str[i]!='\0';i++){
															switchstackstr[ll][i]=str[i];
															//printf("%c = %d \n",str[i],str[i]);
														}
														
														ll++;
														//prioritystr == ++priority;
														flagforstr = 1;
														strclean();
													}
			;
			
defaultstm	: DEFAULT COLON PR VAR SM 				{
														printf("Default \n");
														val=$4;
														flagforvald=1;
													}
			| DEFAULT COLON PR QUOTE STR  QUOTE SM 	{
														
														printf("Default\n");
														flagforstrd=1;
										
														for(i=0;str[i]!='\0';i++)
														{	
															switchstackstr[ll][i]=str[i];
															printf("%c ",switchstackstr[ll][i]);
														}
														printf("%s\n",switchstackstr[ll]);
														strclean();
													}	
			;
			
operator	: GT | LT | EE | LE | GE ;
			
finsidelist : | finside finsidelist ;

finside		: PR VAR SM								{ 	fvalue=$2; flagforval=1;priorityval=++priority; }
			| PR QUOTE STR QUOTE SM 				{
														flagforstr=1;
														for(i=0;str[i]!='\0';i++)finsidestr[i]=str[i];
														
														prioritystr=++priority;
														strclean();
													}
			;
			
statement	: SM
			| expr SM 				{ printf("\nvalue of expression: %d\n", $1); }
			| VAR ASSIGN expr SM 	{ 
										sym[$1] = $3; 
										//printf("%d\n",$1);
										if(store[$1]!=1)printf("'%c' is Undeclared",$1+'a');
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

