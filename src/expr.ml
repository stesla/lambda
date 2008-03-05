type expr =
    Abstraction of string * expr
  | Application of expr * expr
  | Group of expr (* Intended to make handling parens easier in to_string *)
  | Variable of string

let rec to_string expr =
  match expr with
    Group g -> "("^(to_string g)^")"
  | Abstraction (v, e) -> "fn "^v^". "^(to_string e)
  | Application (e, f) -> (to_string e)^" "^(to_string f)
  | Variable v -> v
