open OUnit
open TestCase

let test expected input =
  (fun _ -> assert_parse_expr expected input)

let suite = "Expression Parsing" >:::
  ["test variable" >:: test "x" "x";
   "test abstraction" >:: test "fn x. x" "fn x. x";
   "test application" >:: test "f x" "f x";
   "test Y combinator" >:: test
                            "fn g. (fn x. g (x x)) (fn x. g (x x))"
                            "fn g. (fn x. g (x x)) (fn x. g (x x))";
   "test currying" >:: test "fn f. fn x. f x" "fn f x. f x";
   "test var applied to abstraction" >:: test "x (fn y. y)" "x (fn y. y)"]
