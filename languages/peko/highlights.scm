; =============================================================================
; Pekoscript highlights.scm
; =============================================================================

; -----------------------------------------------------------------------------
; Keywords
; -----------------------------------------------------------------------------

[
  "fn"
  "class"
  "module"
  "closure"
  "constructor"
  "operator"
  "from"
  "super"
] @keyword

[
  "if"
  "else"
  "for"
  "in"
  "while"
] @keyword.control

; break and return are named nodes, not anonymous tokens
(break_statement) @keyword.control
(return_statement "return" @keyword.control)

[
  "import"
  "as"
  "style"
] @keyword.import

[
  "platform"
  "arch"
] @keyword.special

; -----------------------------------------------------------------------------
; Visibility modifiers
; -----------------------------------------------------------------------------

(visibility
  "[" @punctuation.bracket
  [
    "private"
    "constant"
    "external"
    "variadic"
    "hidden"
    "state"
    "notrack"
    "blockexit"
    "mutates"
  ] @keyword.modifier
  "]" @punctuation.bracket)

; -----------------------------------------------------------------------------
; Built-in types
; -----------------------------------------------------------------------------

(builtin_type) @type.builtin

; -----------------------------------------------------------------------------
; Functions
; -----------------------------------------------------------------------------

(function_declaration
  name: (identifier) @function)

(forward_declaration
  name: (identifier) @function)

(method_declaration
  name: (identifier) @function.method)

(constructor "constructor" @function.special)

(call_expression
  (identifier) @function.call)

(call_expression
  (field_expression
    (identifier) @function.method.call))

; -----------------------------------------------------------------------------
; Classes
; -----------------------------------------------------------------------------

(class_declaration
  name: (identifier) @type)

(class_declaration
  parent: (identifier) @type)

(generic_params
  (identifier) @type.parameter)

; -----------------------------------------------------------------------------
; Variables
; -----------------------------------------------------------------------------

(variable_declaration
  name: (identifier) @variable)

(typed_variable_declaration
  name: (identifier) @variable)

(argument
  name: (identifier) @variable.parameter)

(for_loop
  item: (identifier) @variable)

(capture_list
  (identifier) @variable)

(call_item
  arg_name: (identifier) @variable.parameter)

; -----------------------------------------------------------------------------
; Operators
; -----------------------------------------------------------------------------

[
  "+"  "-"  "*"  "/"  "^"
  "||" "&&"
  "==" "!=" "<"  ">"  "<=" ">="
  ".."
  "="
  "&"  "!"
] @operator

(unary_expression
  [ "&" "*" "-" "!" ] @operator)

"=>"  @operator
":="  @operator

; -----------------------------------------------------------------------------
; Operator overloads
; -----------------------------------------------------------------------------

(operator_overload
  "[" @punctuation.bracket
  "operator" @keyword
  op: (identifier) @operator
  "]" @punctuation.bracket)

; -----------------------------------------------------------------------------
; Literals
; -----------------------------------------------------------------------------

(number) @number

(string)           @string
(protected_string) @string.special
(char_literal)     @character
(escape_sequence)  @string.escape

(template_string
  "`"              @string
  (template_chars) @string
  "`"              @string)

(template_interpolation
  "${" @punctuation.special
  "}"  @punctuation.special)

(array_literal
  "#[" @punctuation.bracket
  "]"  @punctuation.bracket)

(map_literal
  "#{" @punctuation.bracket
  "}"  @punctuation.bracket)

(map_entry ":" @punctuation.delimiter)

; -----------------------------------------------------------------------------
; Comments
; -----------------------------------------------------------------------------

((comment) @comment.doc
  (#match? @comment.doc "^///"))

((comment) @comment
  (#not-match? @comment "^///"))

; -----------------------------------------------------------------------------
; Module access
; -----------------------------------------------------------------------------

(module_access
  (identifier) @namespace
  "::" @punctuation.delimiter)

(module_declaration
  name: (identifier) @namespace)

; -----------------------------------------------------------------------------
; Imports
; -----------------------------------------------------------------------------

(import_statement
  alias: (identifier) @namespace)

(package_name
  (identifier) @namespace)

(package_path
  (identifier) @namespace)

(nested_unpack
  (identifier) @namespace)

(package_name
  (string) @string.special)

; -----------------------------------------------------------------------------
; Types
; -----------------------------------------------------------------------------

(generic_type
  (identifier) @type)

(module_type
  (identifier) @namespace)

(attribute_declaration
  name: (identifier) @variable.member)

(function_declaration
  return_type: (_) @type)

(forward_declaration
  return_type: (_) @type)

; -----------------------------------------------------------------------------
; XML — tags
; -----------------------------------------------------------------------------

; Opening tag name
(xml_open_tag
  tag: (xml_tag_name) @tag)

; Closing tag name
(xml_close_tag
  tag: (xml_tag_name) @tag)

; Self-closing tag name
(xml_self_closing_element
  tag: (xml_tag_name) @tag)

; Tag punctuation: < > </ />
(xml_open_tag
  "<" @punctuation.bracket
  ">" @punctuation.bracket)

(xml_close_tag
  "</" @punctuation.bracket
  ">"  @punctuation.bracket)

(xml_self_closing_element
  "<"  @punctuation.bracket
  "/>" @punctuation.bracket)

; -----------------------------------------------------------------------------
; XML — attributes
; -----------------------------------------------------------------------------

(xml_attribute
  name: (identifier) @attribute)

(xml_attribute
  "=" @operator)

; Event handler braces
(xml_event_handler
  "{" @punctuation.bracket
  "}" @punctuation.bracket)

; -----------------------------------------------------------------------------
; XML — children / interpolation
; -----------------------------------------------------------------------------

; Raw text content between tags
(xml_text) @string

; Element interpolation { expr }
(xml_element_interpolation
  "{" @punctuation.special
  "}" @punctuation.special)

; Value interpolation ${ expr }
(xml_value_interpolation
  "${" @punctuation.special
  "}"  @punctuation.special)

; -----------------------------------------------------------------------------
; Punctuation
; -----------------------------------------------------------------------------

[ "(" ")" "{" "}" "[" "]" ] @punctuation.bracket

[ "," ":" ";" ]             @punctuation.delimiter

"::"                        @punctuation.delimiter

"."                         @punctuation.delimiter

; -----------------------------------------------------------------------------
; Platform / arch identifiers
; -----------------------------------------------------------------------------

(platform_block os:   (identifier) @string.special)
(arch_block     arch: (identifier) @string.special)
