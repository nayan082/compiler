/* C Declarations */


s_char [a-z]
c_char [A-Z]
digit [0-9]
sp [" "]
operator [+|*|/|=|;|:|-]

vint "_int"
vstring "_string"
vfloat "_float"
vchar "_char"
iff "_if"
elsee "_else"
elsif "_elsif"
whilee "_while"
gt "_gt"
lt "_lt"
print "_pr"
thenn "_then"
lcb "_lcb"
rcb "_rcb"
assign "_eq"
forr "_for"
too "_to"
include "_include"
main "_main"
lp "_lp"
rp "_rp"
rtrn "_return"
stdio "_stdio.h"
conio "_conio.h"
void "_void"
break "_break"
continue "_continue"
scan "_scan"


l_angular "<<"
r_angular ">>"

ge "_ge"
le "_le"
ee "_ee"

add "_add"
sub "_sub"
mul "_mul"
div "_div"

ae "_ae"
se "_se"
me "_me"
de "_de"
ne "_ne"

aa "_aa"
ss "_ss"

andd "_and"
orr "_or"
nott "_not"


%{
	#include<stdio.h>
	#include "main.tab.h"
	#include<stdlib.h>
	extern int yylval;
%}

/*-------------------------------------RE and Action------------------------------------------------*/

%%

{vint}		{ return INT; }
{vfloat}	{ return FLOAT; }
{vchar}		{ return CHAR; }

{digit}+	{ 
				yylval = atoi(yytext);
				return NUM;
			}
	
{lp}		{ return LP; }
{rp}		{ return RP; }
{lcb}		{ return LB; }
{rcb}		{ return RB; }
","			{ return CM; }
";"			{ return SM; }

{add}		{ return PLUS; }
{sub}		{ return MINUS; }
"**"		{ return MULT; }
"//"		{ return DIV; }
{assign}	{ return ASSIGN;  }
"GT"		{ return GT; }
"LT"		{return LT; }

[a-z]		{
				yylval = *yytext - 'a';
				return	VAR;
			}

{iff}		{ return IF;		}
{elsee}		{ return ELSE;		}

{void}{sp}{main}	{ return VOIDMAIN; }

[ \t\n]*	;

.	{
		yyerror("Unknown Character.\n");
	}
%%

/* user subroutines */

int main()
{
	printf("\n*****************This is My Compiler..!!********************\n\n");
	yyin = freopen("a.txt","r",stdin);
	//yyout = freopen("out.txt","w",stdout);
	yyparse();
}

