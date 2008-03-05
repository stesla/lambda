open OUnit
open TestCase

let test expected string var subst =
  (fun _ -> assert_parse_substitute expected string var subst)

let suite = "Expression Substitution" >:::
  ["matching variable" >:: test "y" "x" "x" "y";
   "substitute an abstraction" >:: test "fn x. x" "x" "x" "fn x. x";
   "non-matching variable" >:: test "x" "x" "y" "z";
   "application" >:: test "y z" "x z" "x" "y";
   "bound var" >:: test "fn x. x" "fn x. x" "x" "y";
   "bound var not free in substitution" >:: test "fn x. z" "fn x. y" "y" "z";
   "bound var free in substitution" >:: test "fn x0. x" "fn x. y" "y" "x"]
