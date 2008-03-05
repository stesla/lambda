let _ =
  try
    while true do
      print_string "> ";
      flush stdout;
      let expr = Parser.parse_channel stdin in
      let expr' = Lambda.reduce expr in
      print_endline (Expr.to_string expr')
    done
  with Syntax.Eof ->
    (print_endline "";
     exit 0)

