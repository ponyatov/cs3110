(** FORTH Virtual Machine in OCaml
    - declarative stack machine emulation *)

(** {1 VM high-level types} *)

(* executable sequence addressing *)
type addr = int

(** vocabulary entry types *)
type cell = Func of (unit -> unit) | Char of char | Int of int | Num of float

(** {1 Commands} *)

(** `NOP ( -- )` do nothing *)
let nop () = ()

(** `BYE ( -- )` stop whole VM *)
let bye () = exit 0

(** {1 VM Memory} *)

(** data stack *)
let d = ref ([] : cell list)

(** return stack (for nested calls & control structures compilation) *)
let r = ref ([] : addr list)

(* vocabulary is an ordered list of string:cell pairs *)
let w =
  [ ((("nop", nop), ("bye", bye)), ("cr", '\r'), ("lf", '\n'), ("pi", 3.1415)) ]
