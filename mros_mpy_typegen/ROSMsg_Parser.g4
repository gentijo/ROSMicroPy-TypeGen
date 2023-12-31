

parser grammar ROSMsg_Parser;

options { tokenVocab=ROSMsg_Lexer; }

/*
 PARSER RULES
*/

/* ROS Message files */
ros_file_input
    : ros_message_input
    | ros_action_input
    | ros_service_input
    ;

ros_message_input
    :   ros_message EOF
    ;

ros_action_input
    : ros_message MESSAGE_SEPARATOR ros_message MESSAGE_SEPARATOR ros_message EOF
    ;

ros_service_input
    : ros_message MESSAGE_SEPARATOR ros_message EOF
    ;

/* ROSBAG Message format */
rosbag_input
    : ros_message rosbag_nested_message* EOF
    ;

rosbag_nested_message
    : ROSBAG_MESSAGE_SEPARATOR ros_type ros_message
    ;

ros_message
    : (field_declaration | constant_declaration | comment)*
    ;
    
field_declaration
    : (type_def | array_type) identifier
    ;
    
constant_declaration
    : integral_type identifier ASSIGNMENT integral_value
    | floating_point_type identifier ASSIGNMENT (integral_value | floating_point_value)
    | boolean_type identifier ASSIGNMENT (bool_value | integral_value)
    | string_type identifier STRING_ASSIGNMENT string_value
    ;
 
comment
    : (HASH | STRING_HASH) COMMENT
    | (HASH | STRING_HASH)
    ;

identifier
    : IDENTIFIER
    | STRING_IDENTIFIER
    | INT8
    | UINT8
    | INT16
    | UINT16
    | INT32
    | UINT32
    | INT64
    | UINT64
    | BYTE
    | CHAR
    | FLOAT32
    | FLOAT64
    | TIME
    | DURATION
    | STRING
    | BOOL
    | TRUE
    | FALSE
    ;


/* ------------------------------------------------------------------ */   
/* DATA TYPES                                                         */
/* ------------------------------------------------------------------ */
 
/* Field types are all built in types or custom message types */
type_def
    : integral_type
    | floating_point_type
    | temportal_type
    | boolean_type
    | string_type
    | ros_type
    ;

ros_type
    : IDENTIFIER
    | IDENTIFIER SLASH IDENTIFIER
    ;

array_type
    : variable_array_type
    | fixed_array_type
    ;

variable_array_type
    : type_def (OPEN_BRACKET | STRING_OPEN_BRACKET) (CLOSE_BRACKET | STRING_CLOSE_BRACKET)
    ;

fixed_array_type
    : type_def OPEN_BRACKET INTEGER_LITERAL CLOSE_BRACKET
    | type_def STRING_OPEN_BRACKET STRING_INTEGER_LITERAL STRING_CLOSE_BRACKET
    ;

integral_type 
	: INT8
	| UINT8
	| INT16
	| UINT16
	| INT32
	| UINT32
	| INT64
	| UINT64
	| BYTE
	| CHAR
	;

floating_point_type 
	: FLOAT32
	| FLOAT64
	;

temportal_type
    : TIME
    | DURATION
    ;

string_type
    : STRING
    ;

boolean_type
    : BOOL
    ;

/* ------------------------------------------------------------------ */   
/* VALUES                                                             */
/* ------------------------------------------------------------------ */

sign
    : PLUS
    | MINUS
    ;

integral_value
    : sign?  INTEGER_LITERAL
    ;

floating_point_value
    : sign? REAL_LITERAL
    ;

bool_value
    : TRUE
    | FALSE
    ;

string_value
    : STRING_VALUE
    ;
