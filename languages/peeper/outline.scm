; Top-level declarations

(import_declaration
  "import" @context
  path: (_) @name) @item

(const_declaration
  "const" @context
  name: (identifier) @name) @item

(let_declaration
  (let_clause
    "let" @context
    "mut"? @context
    name: (identifier) @name)) @item

; Free functions
(function_declaration
  !owner
  "fn" @context
  name: (identifier) @name
  type_parameters: (type_parameter_list)? @context
  parameters: (parameter_list) @context
  result: (_) @context) @item

(function_declaration
  !owner
  !result
  "fn" @context
  name: (identifier) @name
  type_parameters: (type_parameter_list)? @context
  parameters: (parameter_list) @context) @item

; Attached methods: fn Type::Method(...)
(function_declaration
  "fn" @context
  owner: (_) @context
  "::" @context
  name: (identifier) @name
  type_parameters: (type_parameter_list)? @context
  parameters: (parameter_list) @context
  result: (_) @context) @item

(function_declaration
  !result
  "fn" @context
  owner: (_) @context
  "::" @context
  name: (identifier) @name
  type_parameters: (type_parameter_list)? @context
  parameters: (parameter_list) @context) @item

; Type members
(field_declaration
  name: (identifier) @name
  type: (_) @context) @item

(interface_method
  name: (identifier) @name
  parameters: (parameter_list) @context
  result: (_) @context) @item

(interface_method
  !result
  name: (identifier) @name
  parameters: (parameter_list) @context) @item

; Enum / error members inside type declarations
(type_declaration
  name: (identifier) @context
  value: (enum_type
    (identifier) @name @item))

(type_declaration
  name: (identifier) @context
  value: (error_type
    (identifier) @name @item))