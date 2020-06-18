/* splang.y */
%{
#include <stdio.h>
%}

%token CONSTANT RETURN COMMENT LP RP DOT ADDITION_OP SUB_OP MULT_OP DIV_OP EQ_OP ASSIGN_OP LEFT_BRACE RIGHT_BRACE LESS_THAN LESS_THAN_OR_EQ 
%token GREATER_THAN GREATER_THAN_OR_EQ SUB_SET_OP SUPER_SET_OP ADD_TO_SET_OP REMOVE_FROM_SET_OP SET_ADDITION_OP 
%token SET_SUBTRACTION_OP SET_DIFFERENCE_OP SET_UNION_OP SET_INTERSECTION_OP AND OR NOT SEMICOLON COMMA INTEGER FLOAT 
%token CREATE DELETE VAR_DEC IF ELSE WHILE DO IS_EMPTY GET_SIZE TRUE FALSE TRUTH_VAR_IDENTIFIER SET_VARIABLE_IDENTIFIER VARIABLE_IDENTIFIER 
%token IDENTIFIER STRING SPACE EXEC END PRINT READFILE NL

%%
program: EXEC LESS_THAN stmts GREATER_THAN END { printf("Compiled Succesfully\n");};

stmts: stmt 
	| stmts stmt ;
 
stmt: matched | unmatched ;

matched: IF LP bool_expr RP LEFT_BRACE matched RIGHT_BRACE ELSE LEFT_BRACE matched RIGHT_BRACE SEMICOLON{ printf("matched if-else ");}
  | while_stmt
  | assign_stmt
	| return_stmt
  | do_while_stmt
  | dec_var_stmt
  | set_stmt
  | func_call_stmt
  | func_imp;

unmatched: IF LP bool_expr RP LEFT_BRACE matched RIGHT_BRACE ELSE LEFT_BRACE unmatched RIGHT_BRACE SEMICOLON
        | IF LP bool_expr RP LEFT_BRACE matched RIGHT_BRACE SEMICOLON  { printf("if stmt ");};
  
while_stmt: WHILE LP bool_expr RP LEFT_BRACE stmts RIGHT_BRACE{ printf("While Loop ");};

do_while_stmt: DO LEFT_BRACE stmts RIGHT_BRACE WHILE LP bool_expr RP SEMICOLON { printf("do While Loop ");};

dec_var_stmt: VAR_DEC VARIABLE_IDENTIFIER SEMICOLON { printf("var decleration ");}
            | VAR_DEC TRUTH_VAR_IDENTIFIER SEMICOLON { printf("truth var decleration ");}
            | VAR_DEC SET_VARIABLE_IDENTIFIER SEMICOLON { printf("set var decleration ");};

set_stmt: create_set | delete_set | print_set | set_operations SEMICOLON;

assign_stmt: VARIABLE_IDENTIFIER ASSIGN_OP expr SEMICOLON  { printf("variable assign ");}
          | VARIABLE_IDENTIFIER ASSIGN_OP func_call_stmt { printf("variable func assign ");}
          | SET_VARIABLE_IDENTIFIER ASSIGN_OP set_operations SEMICOLON { printf("set variable set op assign ");}
          | SET_VARIABLE_IDENTIFIER ASSIGN_OP set SEMICOLON { printf("set variable assign ");}
          | TRUTH_VAR_IDENTIFIER ASSIGN_OP true_or_false SEMICOLON { printf("truth var  assign ");};

 func_call_stmt: IDENTIFIER LP func_call_params RP SEMICOLON { printf("func call ");}
  | IS_EMPTY LP SET_VARIABLE_IDENTIFIER RP SEMICOLON { printf("is empty func ");}
  | GET_SIZE LP SET_VARIABLE_IDENTIFIER RP SEMICOLON { printf("get size func ");}
  | READFILE LP STRING RP SEMICOLON { printf("readFile func ");};

func_call_params: func_call_param | func_call_params COMMA func_call_param;
func_call_param:  VARIABLE_IDENTIFIER |  TRUTH_VAR_IDENTIFIER |  SET_VARIABLE_IDENTIFIER | real_num | true_or_false;

func_imp: IDENTIFIER LP func_params RP LEFT_BRACE stmts RIGHT_BRACE{ printf("func implementation ");};
func_params: func_param | func_params COMMA func_param;
func_param: VAR_DEC VARIABLE_IDENTIFIER | VAR_DEC TRUTH_VAR_IDENTIFIER | VAR_DEC SET_VARIABLE_IDENTIFIER;
          
return_stmt: RETURN bool_expr SEMICOLON { printf("return stmt ");} ;

bool_expr: expr bool_op expr 
        | true_or_false;

bool_op: EQ_OP 
  | OR 
  | AND 
  | GREATER_THAN 
  | LESS_THAN 
  | LESS_THAN_OR_EQ
  | GREATER_THAN_OR_EQ
  | SUB_SET_OP
  | SUPER_SET_OP;
  
expr: real_num 
  | expr ar_op real_num 
  | VARIABLE_IDENTIFIER
  | SET_VARIABLE_IDENTIFIER
  | TRUTH_VAR_IDENTIFIER
  | set_operations
  | NOT TRUTH_VAR_IDENTIFIER
  | true_or_false
  | LP expr RP
  | LP expr bool_op expr RP;
  
ar_op: SUB_OP 
  | MULT_OP 
  | DIV_OP 
  | ADDITION_OP;
  
set_operations: add_to_set 
              | remove_from_set 
              | set_addition 
              | set_subtraction
              | set_difference
              | set_union
              | set_intersection;
              
add_to_set: SET_VARIABLE_IDENTIFIER ADD_TO_SET_OP VARIABLE_IDENTIFIER{ printf("add to set OP ");} ;   
remove_from_set: SET_VARIABLE_IDENTIFIER REMOVE_FROM_SET_OP VARIABLE_IDENTIFIER{ printf("remove from set OP ");} ;
set_addition: SET_VARIABLE_IDENTIFIER SET_ADDITION_OP SET_VARIABLE_IDENTIFIER
            | set_addition SET_ADDITION_OP SET_VARIABLE_IDENTIFIER{ printf("set addition OP ");}  ;
set_subtraction: SET_VARIABLE_IDENTIFIER SET_SUBTRACTION_OP SET_VARIABLE_IDENTIFIER{ printf("set subs OP ");} ;
set_difference: SET_VARIABLE_IDENTIFIER SET_DIFFERENCE_OP SET_VARIABLE_IDENTIFIER{ printf("set diff OP ");} ;
set_union: SET_VARIABLE_IDENTIFIER SET_UNION_OP SET_VARIABLE_IDENTIFIER 
        | set_union SET_UNION_OP SET_VARIABLE_IDENTIFIER{ printf("set union OP ");};
set_intersection: SET_VARIABLE_IDENTIFIER SET_INTERSECTION_OP SET_VARIABLE_IDENTIFIER{ printf("set inter OP ");} ;
       
create_set: CREATE SET_VARIABLE_IDENTIFIER SEMICOLON{ printf("create set ");} ;
delete_set: DELETE SET_VARIABLE_IDENTIFIER SEMICOLON{ printf("delete set ");} ;
print_set: PRINT SET_VARIABLE_IDENTIFIER SEMICOLON{ printf("print set ");} ;
          
set: LEFT_BRACE set_elements RIGHT_BRACE | empty_set;

empty_set: LEFT_BRACE RIGHT_BRACE;

set_elements: set_element | set_element COMMA set_elements;

set_element: STRING | set | SET_VARIABLE_IDENTIFIER | VARIABLE_IDENTIFIER | real_num;
          
true_or_false: TRUE | FALSE;

real_num: INTEGER | FLOAT;


%%
#include "lex.yy.c"
int lineno;
yyerror( char *s ) { fprintf( stderr, "line %d has error: %s \n\n", lineno, s); };
int main(){

	int x= yyparse();	
	if(x==0) {
		printf("Input program valid. There are %d lines.\n\n\n", lineno );
	}else{
		printf("Failed to parse the input program.\n" );
	}
	return x;
}


