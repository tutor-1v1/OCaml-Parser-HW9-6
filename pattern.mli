https://tutorcs.com
WeChat: cstutorcs
QQ: 749389476
Email: tutorcs@163.com
https://tutorcs.com
WeChat: cstutorcs
QQ: 749389476
Email: tutorcs@163.com
(** [match_value p v] matches the value [v] against the pattern [p]
    and returns all bindings caused by the matching, in the order
    of their appearances in the pattern [p]. If the value does not
    match the pattern, it returns [None].

    A helpful idea is to think of it as [let p = v] in OCaml.
    What new bindings should be introduced after running
    [let p = v]. If bindings are created, the function should
    return the bindings as an association list. Otherwise,
    if the pattern matching fails, the function should return
    [None]. The semantics should agree with OCaml. This homework
    requires you to reflect upon what you have learned and
    codify your knowledge into programs.

    For example, [match_value (PVar "x") (VNum 100)] will return
    the value [Some [("x", VNum 100)]] because the variable pattern
    [x] matches any value. The corresponding OCaml code is
    {[
      let x = 100
    ]}
    After this line, the variable [x] is bound to [100]. The code
    thus should compute the mapping [("x", VNum 100)]].

    Another example is [let (x, y) = (42, ())], which should create
    two bindings: [x] is mapped to [42] and [y] is mapped to [()].
    In our representation, this means
    {[
      match_value
        (PTuple [PVar "x"; PVar "y"]) (* The pattern [(x, y)] *)
        (VTuple [VNum 42; VTuple []]) (* The value [(42, ())] *)
    ]}
    should return [Some [("x", VNum 42); ("y", VTuple [])]].
    The binding [x] is before [y] because [x] appears first.

    Yet another example is [match_value (PNum 10) (VNum 10)],
    which should return [Some []] because the numbers match but
    the pattern creates zero bindings.

    On the other hand, [match_value PTrue VFalse] should return
    [None] because [true] does not match [false]. *)
val match_value : Syntax.pattern -> Syntax.value -> (string * Syntax.value) list option
