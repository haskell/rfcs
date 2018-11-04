%START  NORM  VERB  INVERB MATH  SYNTAX
sp			[ \t]*
verb			^{sp}@{sp}\n
math			\n{sp}\"{sp}\n
synt			\n{sp}@@@{sp}\n
nl			{sp}\n{sp}
%{
#define PUSH		states[top++] =
#define POP		BEGIN states[--top]
int yywrap (void) { return 1; }
%}
%%
			int states[256];
			int top;
			BEGIN NORM;
			top = 0;
<NORM>@@		{ printf ("@"); }
<NORM>@			{ printf ("\\mbox{\\tt ");
			  PUSH NORM;  BEGIN INVERB; }
<INVERB>" "             { printf ("\\ "); }
<INVERB>@		{ printf ("}");  POP; }
<INVERB>\#		{ printf ("{\\char'43}"); }
<INVERB>\$		{ printf ("{\\char'44}"); }
<INVERB>\%		{ printf ("{\\char'45}"); }
<INVERB>\&		{ printf ("{\\char'46}"); }
<INVERB>\~		{ printf ("{\\char'176}"); }
<INVERB>\_		{ printf ("{\\char'137}"); }
<INVERB>\^		{ printf ("{\\char'136}"); }
<INVERB>\\		{ printf ("{\\char'134}"); }
<INVERB>\{		{ printf ("{\\char'173}"); }
<INVERB>\}		{ printf ("{\\char'175}"); }
<NORM>{verb}		{ printf ("{\\small\\begin{verbatim}\n"); PUSH NORM;  BEGIN VERB; }
<VERB>{verb}		{ printf ("\\end{verbatim}}\n"); POP; }
<NORM>\"\"		{ printf ("\""); }
<NORM>\"{sp}		{ printf ("\\mbox{$\\it ");
			  PUSH NORM;  BEGIN MATH; }
<MATH>{sp}\"		{ printf ("$}"); POP; }
<NORM>{math}{sp}	{ printf ("\n\\[\n\\it ");
			  PUSH NORM;  BEGIN MATH; }
<MATH>{sp}{math}	{ printf ("\n\\]\n"); POP; }
<MATH>{nl}		{ printf ("\\\\\n\\it "); }
<MATH>{sp}&{sp}		{ printf ("&\\it "); }
<MATH>\\{nl}		{ }
<MATH>{sp}		{ printf ("\\ "); }
<MATH>"..."		{ printf ("\\ldots "); }
<MATH>">="		{ printf ("\\geq "); }
<MATH>"<="		{ printf ("\\leq "); }
<MATH>"->"		{ printf ("\\rightarrow "); }
<MATH>"<-"		{ printf ("\\leftarrow "); }
<MATH>@@		{ printf ("@"); }
<MATH>@			{ printf ("\\makebox{\\tt ");
			  PUSH MATH;  BEGIN INVERB; }
<NORM>{synt}{sp}	{ printf ("\n\\begin{flushleft}");
			  printf ("\\it\\begin{tabbing}\n");
			  printf ("\\hspace{0.6in}\\=");
			  printf ("\\hspace{3.1in}\\=\\kill\n$\\it "); 
			  BEGIN SYNTAX; }
<SYNTAX>{sp}{synt}	{ printf ("$\n\\end{tabbing}\\end{flushleft}\n"); 
			  BEGIN NORM; }
<SYNTAX>{nl}		{ printf ("$\\\\ \n$\\it "); }
<SYNTAX>{sp}"->"{sp}	{ printf ("$\\>\\makebox[3.5em]{$\\rightarrow$}");
			  printf ("$\\it "); }
<SYNTAX>{nl}"|"{sp}	{ printf ("$\\\\ \n$\\it "); 
			  printf ("$\\>\\makebox[3.5em]{$|$}$\\it "); }
<SYNTAX>{sp}&{sp}	{ printf ("$\\>\\makebox[3em]{}$\\it "); }
<SYNTAX>\\{nl}		{ }
<SYNTAX>{sp}		{ printf ("\\ "); }
<SYNTAX>"..."		{ printf ("\\ldots "); }
<SYNTAX>">="		{ printf ("\\geq "); }
<SYNTAX>"<="		{ printf ("\\leq "); }
<SYNTAX>"->"		{ printf ("\\rightarrow "); }
<SYNTAX>"<-"		{ printf ("\\leftarrow "); }
<SYNTAX>@@		{ printf ("@"); }
<SYNTAX>@		{ printf ("\\makebox{\\tt ");
			  PUSH SYNTAX;  BEGIN INVERB; }

%%
int
main()
{
    yylex();
    return(0);
}
