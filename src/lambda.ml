open Expr

(* Utility Functions *)

let rec all_ids expr =
  match expr with
    Group g -> all_ids g
  | Abstraction (x, body) -> x :: (all_ids body)
  | Application (e1, e2) -> (all_ids e1) @ (all_ids e2)
  | Variable x -> [x]

let unused_id expr x =
  let used_ids = all_ids expr in
  let rec loop n =
    let id = x ^ (string_of_int n) in
    if List.mem id used_ids then loop (n + 1) else id in
  loop 0

let mutually_unused_id expr1 expr2 x =
  (* This takes advantage of the behavior of all_ids when given an *)
  (* Application in order to get an id that isn't in either expr.  *)
  unused_id (Application (expr1, expr2)) x

(* Public Functions *)

let rec equivalent expr1 expr2 =
  match (expr1, expr2) with
  | (Group g, Group h) -> equivalent g h
  | (Abstraction (x1, body1), Abstraction (x2, body2)) ->
      let id = mutually_unused_id expr1 expr2 "_" in
      let body1' = substitute body1 x1 (Variable id) in
      let body2' = substitute body2 x2 (Variable id) in
      equivalent body1' body2'
  | (Application (e1,e2), Application (f1,f2)) ->
      (equivalent e1 f1) && (equivalent e2 f2)
  | (Variable x, Variable y) -> x = y
  | _ -> false

and occurs_free var expr =
  match expr with
  | Group g -> occurs_free var g
  | Abstraction (x, body) when x = var -> false
  | Abstraction (x, body) -> occurs_free var body
  | Application (e1, e2) -> (occurs_free var e1) || (occurs_free var e2)
  | Variable x -> x = var

and reduce expr =
  match expr with
    Group g -> reduce g
  | Application (Group g, y) -> reduce (Application (g, y))
  | Application (Abstraction (x, body), y) -> reduce (substitute body x y)
  | Application (Application (Variable _,_),_) -> expr
  | Application (Application _ as e1, e2) ->
      reduce (Application (reduce e1, e2))
  | _ -> expr

and substitute expr var subst =
  match expr with
    Group g -> Group (substitute g var subst)
  | Abstraction (x, body) when x = var -> expr
  | Abstraction (x, body) when occurs_free x subst ->
      let x' = unused_id body x in
      let body' = substitute body x (Variable x') in
      Abstraction (x', substitute body' var subst)
  | Abstraction (x, body) -> Abstraction (x, substitute body var subst)
  | Application (e1, e2) ->
      Application (substitute e1 var subst, substitute e2 var subst)
  | Variable x when x = var -> subst
  | Variable x -> expr
