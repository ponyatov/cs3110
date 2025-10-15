(** FORTH Virtual Machine in OCaml
    - declarative stack machine emulation *)

(** {1 VM Memory} *)

(** data stack *)
let d = ref ([] : int list)

(** return stack (for nested calls & control structures compilation) *)
let r = ref ([] : int list)

(** {1 Commands} *)

(** `NOP ( -- )` do nothing *)
let nop () = ()

(** `BYE ( -- )` stop whole VM *)
let bye () = exit 0
