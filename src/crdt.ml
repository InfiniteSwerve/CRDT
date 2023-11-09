module Partial_Ordering = struct
  type cmp = Less | Equal | Greater
  type t = cmp Option.t
end

module Vector_clock : sig
  type vector_clock = int Array.t
  type t = { id : int; clock : vector_clock }

  val init : int -> t
  val compare : t -> t -> Partial_Ordering.t
  val increment : t -> int -> unit
  val reconcile : t -> t -> unit
  val process : t -> t -> unit
end = struct
  type vector_clock = int Array.t
  type t = { id : int; clock : vector_clock }

  let init id = { id; clock = Array.make 10 0 }

  let compare { clock = v1; _ } { clock = v2; _ } =
    match Array.for_all2 (fun c1 c2 -> c1 < c2) v1 v2 with
    | true -> Some Partial_Ordering.Less
    | false -> (
        match Array.for_all2 (fun c1 c2 -> c1 = c2) v1 v2 with
        | true -> Some Partial_Ordering.Equal
        | false -> (
            match Array.for_all2 (fun c1 c2 -> c1 > c2) v1 v2 with
            | true -> Some Partial_Ordering.Greater
            | false -> None))

  let increment (v : t) (num : int) = v.clock.(v.id) <- v.clock.(v.id) + num

  let reconcile v other =
    for i = 0 to Array.length v.clock - 1 do
      v.clock.(i) <- Int.max v.clock.(i) other.clock.(i)
    done

  let process v other =
    increment v 1;
    reconcile v other
end

module Counter : sig
  include module type of struct
    include Vector_clock
  end

  val query : t -> int
end = struct
  include Vector_clock

  let query vc = Array.fold_left (fun acc n -> acc + n) 0 vc.clock
end
