type 'a cell = {
  data : 'a;
  mutable prev : 'a cell option;
  mutable next : 'a cell option;
}

type 'a t = { 
  mutable head : 'a cell option; 
  mutable last : 'a cell option; 
}

val verify : 'a t -> unit
val create : unit -> 'a t
val create_cell : 'a -> 'a cell
val head : 'a t -> 'a cell
val last : 'a t -> 'a cell
val next : 'a cell -> 'a cell
val prev : 'a cell -> 'a cell
val contents : 'a cell -> 'a
val prepend_cell : 'a t -> 'a cell -> unit
val prepend : 'a t -> 'a -> unit
val append_cell : 'a t -> 'a cell -> unit
val append : 'a t -> 'a -> unit
val delete : 'a t -> 'a cell -> unit
val iter : ('a -> 'b) -> 'a t -> unit
val map : ('a -> 'b) -> 'a t -> 'b list
val fold : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
val to_list : 'a t -> 'a list
