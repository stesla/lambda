open OUnit
open TestCase

let test expected expr1 expr2 =
  (fun _ -> assert_parse_occurs_free expected expr1 expr2)

let suite = "Expression Free Variable Detection" >:::
  ["test same variable" >:: test true "x" "x";
   "test different variable" >:: test false "x" "y";
   "test bound" >:: test false "x" "fn x. x";
   "test not bound" >:: test true "x" "fn y. x";
   "test application" >:: test true "x" "(x y)";
   "test bound application" >:: test false "x" "((fn x. x) y)";
   "test bound application to free var" >:: test true "x" "((fn x. x) x)"]
