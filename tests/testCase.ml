let assert_equal_bool expected actual =
  OUnit.assert_equal ?printer:(Some string_of_bool) expected actual

let assert_equal_string expected actual =
  OUnit.assert_equal ?printer:(Some (fun s -> s)) expected actual

let assert_expr_to_string expected expr =
  assert_equal_string expected (Expr.to_string expr)

let assert_parse_equivalence expected string1 string2 =
  let expr1 = Parser.parse_test_string string1 in
  let expr2 = Parser.parse_test_string string2 in
  assert_equal_bool expected (Lambda.equivalent expr1 expr2)

let assert_parse_occurs_free expected var string =
  let expr = Parser.parse_test_string string in
  assert_equal_bool expected (Lambda.occurs_free var expr)

let assert_parse_expr expected input =
  assert_expr_to_string expected (Parser.parse_test_string input)

let assert_parse_reduce expected actual =
  let expected_expr = Parser.parse_test_string expected in
  let actual_expr = Parser.parse_test_string actual in
  let reduced_expr = Lambda.reduce actual_expr in
  OUnit.assert_equal
    ?cmp:(Some Lambda.equivalent)
    ?printer:(Some Expr.to_string)
    expected_expr
    reduced_expr

let assert_parse_substitute expected string var subst =
  let expr = Parser.parse_test_string string in
  let subst_expr = Parser.parse_test_string subst in
  let expr' = Lambda.substitute expr var subst_expr in
  assert_expr_to_string expected expr'

