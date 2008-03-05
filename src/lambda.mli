open Expr

val equivalent : expr -> expr -> bool
val occurs_free :  string -> expr -> bool
val reduce : expr -> expr
val substitute : expr -> string -> expr -> expr
