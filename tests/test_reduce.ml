open OUnit
open TestCase

let test expected expr =
  (fun _ -> assert_parse_reduce expected expr)

let suite = "Expression Reduction" >:::
  ["test variable" >:: test "x" "x";
   "test abstraction" >:: test "fn x. x" "fn x. x";
   "test application of non-abstraction" >:: test "x y" "x y";
   "test application of abstraction" >:: test "y" "(fn x. x) y";
   "test higher-order function" >:: test "fn x. x" "(fn z. z) (fn x. x)";
   "test sequence" >:: test "y" "(fn z. z) (fn x. x) y";
   "test nested" >:: test "a" "(fn x y. x y) (fn z. z) a";
   "test several non-abstractions" >:: test "x y z" "x y z";
   "test Church if true" >:: test "a" "(fn p. p) (fn x y. x) a b";
   "test Church if false" >:: test "b" "(fn p. p) (fn x y. y) a b"]
