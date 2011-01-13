(* LRU *)
exception NegativeSize of int

type ('a, 'b) t

val create : int -> ('a * 'b -> int) -> ('a, 'b) t
(* [create max_size size_of] creates an LRU whose size is not to
   exceed [max_size].  The size of the LRU is the sum of applying
   [size_of] to all its elements. [Invalid_argument] is raised if
   max_size is not positive. *)

val get : ('a, 'b) t -> 'a -> [> `Found of 'b | `NotFound ]
val remove : ('a, 'b) t -> 'a -> [> `NotFound | `Found ]

val put : ('a, 'b) t -> 'a -> 'b -> unit
(* add a replace an entry *)

val entries : ('a, 'b) t -> ('a * 'b) list

val mem : ('a, 'b) t -> 'a -> [> `NotFound | `Found ]
(* mem does not change the 'usedness' -- hence priority -- of the
   entry being found *)

val clear : ('a, 'b) t -> unit

type stats = {
  s_num_entries : int ;
  s_num_hits : int ;
  s_num_misses : int ;
  s_size : int ;
  s_max_size : int 
}

val stats : ('a, 'b) t -> stats
