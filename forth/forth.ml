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

(** return stack (for nested calls & control structures compilation) *)
let r = ref ([] : addr list)

(** data stack *)
let d : cell Stack.t = Stack.create ()

(** `( -- o )` push item *)
let push o = Stack.push o d

(** `( o -- )` pop item *)
let pop () =
  try Stack.pop d with
  | Stack.Empty -> failwith "underflow"

(** ( -- ) get top element *)
let top = Stack.top d

(* ( a -- a a ) *)
let dup = Stack.dup d

(* ( a -- ) *)
let drop = Stack.drop d

(* ( a b -- b a ) *)
let swap = Stack.swap d

(* ( a b -- b ) *)
let press = Stack.press d


(* ( a b -- a b a ) *)
      let over = Stack.over d

(* (a b c -- b c a) *)
    let rot = Stack.rot d
(* (a b c -- c a b ) *)
    let mrot = Stack.mrot d
(* ( ... n -- ... d[n] ) fetch n-th item counting from stack top *)
    let pick = Stack.pick (Stack.pop) d

    (* ( ... -- d.sizeof ) get stack depth *)
    let depth = Stack.depth d

  (* vocabulary is an ordered list of string:cell pairs *)
let w =
  [
    ( (("nop", nop), ("bye", bye)),
      ("space", ' '),
      ("cr", '\r'),
      ("lf", '\n'),
      ("pi", 3.1415),
      ("dup",dup), 
      ("drop",drop), 
      ("swap",swap), 
      ("over",over), 
      ("rot",rot), 
      ("-rot",mrot), 
      ("pick",pick), 
      ("depth",depth),
      );
  ]
