open OUnit
open TestCase

let test expected expr1 expr2 =
  (fun _ -> assert_parse_equivalence expected expr1 expr2)

let suite = "Expression Equivalence" >:::
  ["test true variable" >:: test true "x" "x";
   "test false variable" >:: test false "x" "y";
   "test true application" >:: test true "x y" "x y";
   "test false application" >:: test false "x y" "x z";
   "test true abstraction" >:: test true "fn x. x" "fn y. y";
   "test false abstraction" >:: test false "fn x. x" "fn y. x"]
