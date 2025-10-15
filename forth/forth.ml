(** FORTH Virtual Machine in OCaml
    - declarative stack machine emulation *)

(** {1 VM high-level types} *)

(** data types: stack and vocabulary items *)
type cell = Func of (unit -> unit) | Char of char | Int of int | Num of float

(* compiled cell execution sequence *)
type seq = cell list

(* executable sequence addressing: seq[int] *)
type addr = seq * int

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

(** `( -- o )` get top element *)
let top () =
  try Stack.top d with
  | Stack.Empty -> failwith "underflow"

(** `( a -- a a )` duplicate top *)
let dup () =
  let a = pop () in
  push a;
  push a

(** `( a -- )` drop top *)
let drop () = ignore (pop ())

(** `( a b -- b a )` swap top two *)
let swap () =
  let b = pop () in
  let a = pop () in
  push b;
  push a

(** `( a b -- a b a )` copy second to top *)
let over () =
  let b = pop () in
  let a = pop () in
  push a;
  push b;
  push a

(** `( a b c -- b c a )` rotate three items *)
let rot () =
  let c = pop () in
  let b = pop () in
  let a = pop () in
  push b;
  push c;
  push a

(** `( a b c -- c a b )` reverse rotate three items *)
let mrot () =
  let c = pop () in
  let b = pop () in
  let a = pop () in
  push c;
  push a;
  push b

(** `( ... -- n )` get stack depth *)
let depth () = push (Int (Stack.length d))

(** vocabulary *)
let w =
  [
    ("nop", Func nop);
    ("bye", Func bye);
    ("dup", Func dup);
    ("drop", Func drop);
    ("swap", Func swap);
    ("over", Func over);
    ("rot", Func rot);
    ("-rot", Func mrot);
    ("depth", Func depth);
    ("space", Char ' ');
    ("cr", Char '\r');
    ("lf", Char '\n');
    ("pi", Num 3.1415);
  ]
