(doc_comment) @comment.doc
(line_comment) @comment
(block_comment) @comment

(string_literal) @string
(char_literal) @constant
(byte_literal) @constant
(number_literal) @number
(boolean_literal) @boolean
(none_literal) @constant.builtin

[
  "import"
  "type"
  "fn"
  "impl"
  "struct"
  "interface"
  "enum"
  "union"
  "error"
  "if"
  "else"
  "match"
  "for"
  "break"
  "continue"
  "return"
  "catch"
  "as"
  "defer"
  "panic"
  "unsafe"
] @keyword

[
  (const)
  (let)
  (mut)
  (in)
  (is)
  (comptime)
  (move)
] @keyword

((identifier) @keyword
 (#any-of? @keyword
  "import" "type" "const" "let" "mut" "fn"
  "impl" "struct" "interface" "enum" "union" "error"
  "if" "else" "match" "for" "in" "is"
  "break" "continue" "return" "comptime" "move"
  "catch" "as" "defer" "panic" "unsafe"))

[
  "="
  "+="
  "-="
  "*="
  "/="
  "%="
  "!"
  "!!"
  "?"
  "??"
  "@"
  "^"
  "+"
  "++"
  "-"
  "--"
  "*"
  "/"
  "%"
  "=="
  "!="
  "<"
  "<="
  ">"
  ">="
  "&&"
  "||"
  "::"
  "..."
  ".."
  "..="
  "=>"
] @operator

["(" ")" "[" "]" "{" "}"] @punctuation.bracket
["," ";" ":" "."] @punctuation.delimiter

(range_expression ":" @operator)

(attribute
  "#" @punctuation.special
  name: (identifier) @attribute)

(struct_declaration
  name: (identifier) @type)

(interface_declaration
  name: (identifier) @type)

(enum_declaration
  name: (identifier) @type)

(type_declaration
  name: (identifier) @type)

(impl_declaration
  target: (named_type (identifier) @type))

(impl_declaration
  target: (named_type
    (scoped_identifier
      name: (identifier) @type)))

(named_type (identifier) @type
 (#not-eq? @type "map"))

(generic_type
  name: (identifier) @type
  (#not-eq? @type "map"))

(generic_type
  name: (scoped_identifier
    name: (identifier) @type))

(named_type
  (scoped_identifier
    name: (identifier) @type))

(scoped_identifier
  scope: (identifier) @type)

(scoped_identifier
  scope: (scoped_identifier
    name: (identifier) @type))

(named_type
  (scoped_identifier
    scope: (identifier) @type))

(named_type
  (scoped_identifier
    scope: (scoped_identifier
      name: (identifier) @type)))

((identifier) @type.builtin
 (#any-of? @type.builtin
  "bool" "char" "string" "Self"
  "u8" "u16" "u32" "u64" "usize"
  "i8" "i16" "i32" "i64" "isize"
  "f32" "f64" "void"))

(function_declaration
  name: (identifier) @function)

(interface_method
  name: (identifier) @function)

(call_expression
  function: (identifier) @function)

(call_expression
  function: (scoped_identifier
    name: (identifier) @function))

(call_expression
  function: (selector_expression
    field: (identifier) @function))

(generic_call_expression
  function: (identifier) @function)

(generic_call_expression
  function: (scoped_identifier
    name: (identifier) @function))

(generic_call_expression
  function: (selector_expression
    field: (identifier) @function))

(ERROR
  (identifier) @function
  (argument_list))

(ERROR
  (scoped_identifier
    name: (identifier) @function)
  (argument_list))

(ERROR
  (selector_expression
    field: (identifier) @function)
  (argument_list))

(binary_expression
  left: (identifier) @function
  (ERROR)
  right: (parenthesized_expression))

(binary_expression
  left: (scoped_identifier
    name: (identifier) @function)
  (ERROR)
  right: (parenthesized_expression))

(binary_expression
  left: (selector_expression
    field: (identifier) @function)
  (ERROR)
  right: (parenthesized_expression))

(typed_parameter
  name: (identifier) @variable.parameter)

(lambda_parameter
  name: (identifier) @variable.parameter)

(type_parameter
  name: (identifier) @type)

(labeled_statement
  label: (identifier) @label)

(let_clause
  name: (identifier) @variable)

(const_clause
  name: (identifier) @constant)

(const_declaration
  name: (identifier) @constant)

(field_declaration
  name: (identifier) @property)

(named_field_initializer
  name: (identifier) @property)
