let parse lexbuf = Grammar.stmt Syntax.token lexbuf
let parse_channel c = parse (Lexing.from_channel c)
let parse_string s = parse (Lexing.from_string s)
let parse_test_string s = parse_string (s ^ ";")
