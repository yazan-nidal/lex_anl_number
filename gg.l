/* scanner for a toy Pascal-like language */

%{
/* need this for the call to atof() below */
#include <math.h>

#define R 10000

int iM=0;
char money[R][R];

int iP=0;
char percentages[R][R];

int iY=0;
char years[R][R];

int iO=0;
char other[R][R];

void copy(char *x,char *y)
{
    for(int i=0;y[i];i++)x[i]=y[i]; 
}


void out(){ 

    printf("money : ");
    if(iM==0){ printf("{empty}\n"); }
    else{
     printf("%s",money[0]);
     for(int i=1;i<iM;i++){ printf(" , %s",money[i]); }
     printf("\n");   
    }

     for(int i=0;i<iM;i++){money[i][0]='\0';}
     iM=0;

    printf("percentages : ");
    if(iP==0){ printf("{empty}\n"); }
    else{
     printf("%s",percentages[0]);
     for(int i=1;i<iP;i++){ printf(" , %s",percentages[i]); }
     printf("\n");   
    }

     for(int i=0;i<iP;i++){percentages[i][0]='\0';}
     iP=0;

    printf("years : ");
    if(iY==0){ printf("{empty}\n"); }
    else{
     printf("%s",years[0]);
     for(int i=1;i<iY;i++){ printf(" , %s",years[i]); }
     printf("\n");   
    }

     for(int i=0;i<iY;i++){years[i][0]='\0';}
     iY=0;

     if(iO==0) return;
     else{
     printf("other : ");
     printf("%s",other[0]);
     for(int i=1;i<iO;i++){ printf(" , %s",other[i]); }
     printf("\n");   
    }

     for(int i=0;i<iO;i++){other[i][0]='\0';}
     iO=0;

} 

%}

DIGIT    [0-9]

ID       [a-z][a-z0-9]*

NUMBER  {DIGIT}+(\.{DIGIT}+)?(E[+-]?{DIGIT}+)?

mo1     (\((£{NUMBER}(m|b)?)\))

mo      (${NUMBER}(m|b)?((\ )mo1)?)

pr1     ({DIGIT}(\.{DIGIT}+)?|[1-9]{DIGIT}(\.{DIGIT}+)?|100)

pr      (%{pr1}|{pr1}%)

ye      ([2-9]{DIGIT}{3}((\ )|(\s))?)

ot      ({DIGIT}+[+,-]{DIGIT}+[\ ]?[a-zA-Z]*)

%%


{DIGIT}+    {}

{NUMBER}      {}

if|then|begin|end|procedure|function  { }

{ID}       ;

"+"|"-"|"*"|"/"   ;

"{"[^}\n]*"}"     /* eat up one-line comments */

[ \t]+          /* eat up whitespace */

.          ;

 {mo}      {   copy(money[iM],yytext); iM++;  } 
 {pr}      {   copy(percentages[iP],yytext); iP++;  }  
 {ye}      {   copy(years[iY],yytext); iY++;  }  
 {ot}      {   copy(other[iO],yytext); iO++;  } 


[\n] out();

%%

int yywrap(){ return 1; 
} 
int main( argc, argv )
int argc;
char **argv;
    {
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 )
            yyin = fopen( argv[0], "r" );
    else
            yyin = stdin;

    yylex();

    return 0;
    }
