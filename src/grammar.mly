%{
open Expr;;

exception Error

let rec apply xs =
  match xs with
    [x] -> x
  | x1::x2::xs' -> apply ((Application (x1,x2))::xs')
  | _ -> raise Error

let curry ids body =
  List.fold_right (fun id expr -> Abstraction(id, expr)) ids body

%}
%token <string> VAR
%token LPAREN RPAREN
%token PERIOD
%token FN
%token SEMICOLON
%start stmt
%type <Expr.expr> stmt
%%
stmt:
  expr SEMICOLON {$1}

expr:
  aexprs {apply $1}
| FN ids PERIOD expr {curry $2 $4}
;

aexpr:
  VAR {Variable $1}
| LPAREN expr RPAREN {Group $2}
;

aexprs:
  aexpr {[$1]}
| aexpr aexprs {$1::$2}
;

ids:
  VAR {[$1]}
| VAR ids {$1::$2}
;
