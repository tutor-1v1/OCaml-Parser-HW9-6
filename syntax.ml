https://tutorcs.com
WeChat: cstutorcs
QQ: 749389476
Email: tutorcs@163.com
https://tutorcs.com
WeChat: cstutorcs
QQ: 749389476
Email: tutorcs@163.com
(** Type of pattern representations *)
type pattern =
  | PWildcard
  (** [PWildcard] represents the wildcard pattern [_] *)
  | PVar of string
  (** [PVar "x"] represents the variable pattern: [x] *)
  | PNum of int
  (** [PNum i] represents the number pattern [i]. *)
  | PTrue
  (** [PTrue] represents the pattern [true] *)
  | PFalse
  (** [PFalse] represents the pattern [false] *)
  | PTuple of pattern list
  (** [PTuple [p1; p2; ...; pn]] represents the tuple pattern [(p1, p2, ..., pn)].
      [PTuple []] represents the nullary tuple pattern [()]. *)
  | PConstruct of string * pattern list
  (** [PConstruct ("C", [p1; p2; ...; pn])] represents the variant pattern [C (p1, p2, ..., pn)].
      [PConstruct ("C", [p])] represents the variant pattern [C p].
      [PConstruct ("C", [])] is the variant pattern [C] (without extra data). *)
  | POr of pattern * pattern
  (** [POr (p1, p2)] is the or-pattern [p1 | p2]. MiniML will try [p1] first and then [p2]. *)

(** Type of expression representations *)
type expr =
  | EVar of string list
  (** [EVar ["M"; "x"]] represents the variable [M.x] *)
  | ELet of (pattern * expr) * expr
  (** [ELet ((p, e1), e2)] represents [let p = e1 in e2] *)
  | ELetRec of (pattern * expr) * expr
  (** [ELetRec ((p, e1), e2)] represents [let rec p = e1 in e2] *)
  | ENum of int
  (** [ENum i] represents numeric literal [i] *)
  | EMinus of expr
  (** [EMinus e] represents [- e] *)
  | EAdd of expr * expr
  (** [EAdd (e1, e2)] represents [e1 + e2] *)
  | ESub of expr * expr
  (** [ESub (e1, e2)] represents [e1 - e2] *)
  | EMul of expr * expr
  (** [EMul (e1, e2)] represents [e1 * e2] *)
  | EDiv of expr * expr
  (** [EDiv (e1, e2)] represents [e1 / e2] *)
  | EMod of expr * expr
  (** [EMod (e1, e2)] represents [e1 mod e2] *)
  | EEqual of expr * expr
  (** [EEqual (e1, e2)] represents [e1 = e2] *)
  | ELess of expr * expr
  (** [ELess (e1, e2)] represents [e1 < e2] *)
  | EGreater of expr * expr
  (** [EGreater (e1, e2)] represents [e1 > e2] *)
  | ETrue
  (** [ETrue] represents [true] *)
  | EFalse
  (** [EFalse] represents [false] *)
  | ETuple of expr list
  (** [ETuple []] represents the nullary tuple [()]
      [ETuple [e1; e2; ...; en]] represents [(e1, e2, ..., en)] *)
  | EFunction of (pattern * expr) list
  (** [EFunction [(p1,e1); (p2,e2); ...; (pn,en)]] represents the pattern matching
      [function p1 -> e1 | p2 -> e2 | ... | pn -> en] *)
  | EApply of expr * expr
  (** [EApply (e1, e2)] represents [e1 e2] *)
  | EConstruct of string * expr list
  (** [EConstruct ("C", [e1; e2; ...; en])] represents [C (e1, e2, ..., en)]
      [EConstruct ("C", [e])] represents [C e]
      [EConstruct ("C", [])] represents [C] *)
  | EPrintInt of expr
  (** [EPrintInt e] prints the integer [e] to the standard output. *)

(** Type of value representations *)
type value =
  | VNum of int
  (** [VNum i] represents the number value [i] *)
  | VTrue
  (** [VTrue] represents the boolean value [true] *)
  | VFalse
  (** [VFalse] represents the boolean value [false] *)
  | VTuple of value list
  (** [VTuple [v1; v2; ...; vn]] represents the tuple [(v1, v2, ...)].
      [VTuple []] represents the nullary tuple [()]. *)
  | VFunction of {env : value Environment.t; cases : (pattern * expr) list}
  (** [VFunction {env; cases = [(p1,e1); (p2,e2); ...; (pn,en)]}]
      represents the closure with the following component:
      1. The code: [function p1 -> e1 | p2 -> e2 | ... | pn -> en]
      2. The environment: [env] *)
  | VRecFunction of {env : value Environment.t; fun_name : string; cases : (pattern * expr) list}
  (** [VRecFunction {env; fun_name; arg_name; body}] represents the closure of
      a recursive function with the following component:
      1. The code: [function p1 -> e1 | p2 -> e2 | ... | pn -> en]
         where [ei] refers to the function itself by [fun_name].
      2. The environment: [env] *)
  | VConstruct of string * value list
  (** [VConstruct ("C", [v1; v2; ...; vn])] represents [C (v1, v2, ..., vn)]
      [VConstruct ("C", [v])] represents [C v]
      [VConstruct ("C", [])] represents [C] *)

(** Type of definition representations *)
type definition =
  | DEval of expr
  (** [DEval e] represents a stand-alone expression [e] *)
  | DLet of pattern * expr
  (** [DLet (p, e)] represents [let p = e] *)
  | DLetRec of pattern * expr
  (** [DLetRec (p, e)] represents [let rec p = e] *)
  | DModule of string * module_expr
  (** [DModule ("M", m)] represents [module X = m] *)
  | DOpen of module_expr
  (** [DOpen m] represents [open m] *)
  | DInclude of module_expr
  (** [DInclude m] represents [include m] *)

(** Type of structure representations *)
and structure = definition list

(** Type of module expression representations *)
and module_expr =
  | MVar of string list
  (** [MVar ["A"; "B"; "C"]] represents [A.B.C] *)
  | MStruct of structure
  (** [MStruct [d1; d2; ...; dn]] represents [struct d1 d2 ... dn end] *)

(** Type of representations of top-level directives *)
type toplevel =
  | TopStruct of structure
  (** [TopStruct [d1; d2; ...; dn]] represents the code block [d1; d2; ...; dn] *)
  | TopUse of string
  (** [TopUse "file.ml"] represents [#use "file.ml"] *)
  | TopQuit
  (** [TopQuit] represents [#quit] *)
  | TopSecret
  (** [TopSecret] represents, well, TOP SECRET! *)
