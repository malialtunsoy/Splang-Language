/* splang.l */
letter_lower		[a-z]
letter_upper		[A-Z]
letter 			({letter_lower}|{letter_upper}) 	
digit 			[0-9]	
special			[\!\'\^\+\%\&\/\(\=\?\_\-\*\)\$\½\{\}\[\]\.]*	
integer			({digit}*)
float			({integer}\.{integer})
real_num		({integer}|{float})
letter_or_digit		({letter}*|{digit})
string			({letter_or_digit}*)
expr			({real_num}{ar_op}{real_num}|{real_num})
bool_expr		({expr}{eq_op}{expr})|true|false
func_def		({string})
space 			[ \t]+ 
something		({string}|{space}*|{special}*|{real_num}*)
string_seq 		\"({something}*)({special}*({comment}*))\"
word			(\t)*([aA-zZ]*)(\t)|(([0-9]*)((\t))
words			({word}*)
comment			\#\#({something}*)({special}*)\#\#
nl              \n
%%
cons				{return CONSTANT;}  
exec				{return EXEC;}     
end				    {return END;}    
{comment} 			printf("");   
\( 					{return LP;}     
\)					{return RP;} 
\.					{return DOT;}   
\+					{return ADDITION_OP;}  
\-					{return SUB_OP;}   
\*					{return MULT_OP;}   
\/					{return DIV_OP;}   
\=\=				{return EQ_OP;}   
\=					{return ASSIGN_OP;}   
\{					{return LEFT_BRACE;}    
\}					{return RIGHT_BRACE;}   
\<					{return LESS_THAN;}  
\>					{return GREATER_THAN;}
\<\=				{return LESS_THAN_OR_EQ;}
\>\=				{return GREATER_THAN_OR_EQ;}
\<\<				{return SUB_SET_OP;}
\>\>				{return SUPER_SET_OP;}
\[\+\]				{return ADD_TO_SET_OP;}
\[\-\]				{return REMOVE_FROM_SET_OP;}
\[\+\+\]			{return SET_ADDITION_OP;}
\[\-\-\]			{return SET_SUBTRACTION_OP;}
\[\/\/\]			{return SET_DIFFERENCE_OP;}
\[U\]				{return SET_UNION_OP;}
\[\%\%\]			{return SET_INTERSECTION_OP;}
aNd					{return AND;}
oR					{return OR;}
\~					{return NOT;}
\;					{return SEMICOLON;}
\,					{return COMMA;}
{integer}			{return INTEGER;}
{float}				{return FLOAT;}
create				{return CREATE;}
delete              {return DELETE;}
print               {return PRINT;}
readFile            {return READFILE;}
var					{return VAR_DEC;}
if 					{return IF;}
else				{return ELSE;}
while				{return WHILE;}
do					{return DO;}
is_empty			{return IS_EMPTY;}
get_size			{return GET_SIZE;}
return				{return RETURN;}
true				{return TRUE;}
false				{return FALSE;}
\£{string}+			{return TRUTH_VAR_IDENTIFIER;}
\${string}+			{return SET_VARIABLE_IDENTIFIER;}
\&{string}+			{return VARIABLE_IDENTIFIER;}
{string}			{return IDENTIFIER;}
\"{string}+\" 		{return STRING ;}
{nl}                { extern int lineno; lineno++;
                    printf("\n");
                    }
.                    printf("");

                    


%%
int yywrap() { return 1; }