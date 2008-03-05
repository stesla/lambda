{
open Grammar
exception Eof
}
rule token = parse
  [' ' '\n' '\r' '\t'] {token lexbuf}
| "fn" {FN}
| ['A'-'Z' 'a'-'z' '0'-'9' '_']+ as lexeme {VAR lexeme}
| "." {PERIOD}
| "(" {LPAREN}
| ")" {RPAREN}
| ";" {SEMICOLON}
| eof {raise Eof}
