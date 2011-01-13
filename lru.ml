(* LRU *)

module H = Hashtbl
module DL = DList

exception NegativeSize of int

type ('a, 'b) t = {
  map : ('a, (('a * 'b) DL.cell)) H.t;
  (* a hash map of keys to values *)

  mutable priority_list : ('a * 'b) DL.t;
  (* list arranged so that recently used data is at the head, and
     least used data is at the tail; [priority_list] is itself
     mutable; the mutable field is only used to easily clear the list
     by replacing it with an new, empty one. *)

  size_of : ('a * 'b) -> int;
  (* a function that returns the size of an entry *)
  
  (* sum of [size_of] applied to every entry in the cache *)
  mutable size : int;

  mutable num_hits : int;
  (* the count of lookups that resulted in an entry being found *)

  mutable num_misses : int;
  (* the count of lookups that resulted in ann entry being not found *)

  max_size : int ;

  mutable num_entries : int ;
  (* the number of elements in the LRU, as distinct from its size *)

}

let create max_size size_of = 
  if max_size < 1 then
    raise (Invalid_argument (string_of_int max_size))
  else {
    map = H.create 1;
    priority_list = DL.create ();
    max_size = max_size;
    size_of = size_of;
    num_hits = 0;
    num_misses = 0;
    size = 0;
    num_entries = 0;
  }
  
let get t k =
  try
    let cell = H.find t.map k in

    (* delete the cell from its current location in the priority
       list *)
    DList.delete t.priority_list cell;

    (* now place the same data at the head of the priority list *)
    DL.prepend t.priority_list cell.DL.data;

    let _, v = cell.DL.data in
    t.num_hits <- t.num_hits + 1;
    `Found v

  with Not_found ->
    t.num_misses <- t.num_misses + 1;
    `NotFound

let remove t k =
  try
    let cell = H.find t.map k in
    
    (* delete the cell from the priority list *)
    DList.delete t.priority_list cell;

    H.remove t.map k;

    t.num_entries <- t.num_entries - 1;
    assert (t.num_entries >= 0);

    let size = t.size_of cell.DL.data in
    if size < 0 then 
      raise (NegativeSize size);
      
    (* update the size *)
    t.size <- t.size - size;
    assert (t.size >= 0);
    `Found

  with Not_found ->
    `NotFound

let rec prune t =
  if t.size > t.max_size then
    let last_cell = DL.last t.priority_list in

    (* delete the last (least-recently-used) cell *)
    DList.delete t.priority_list last_cell;

    let kv = DL.contents last_cell in
    let k, _ = kv in
    let size = t.size_of kv in
    if size < 0 then 
      raise (NegativeSize size);
    
    (* update the size *)
    t.size <- t.size - size;
    assert (t.size >= 0);

    (* remove from the map *)
    H.remove t.map k;

    t.num_entries <- t.num_entries - 1;
    assert (t.num_entries >= 0);

    prune t


let put t k v =
  (* remove an existing mapping from [k] to [v], if any *)
  ignore (remove t k);

  let kv = k, v in
  let cell = DL.create_cell kv in
  H.replace t.map k cell;
  DL.prepend_cell t.priority_list cell;
  t.num_entries <- t.num_entries + 1;

  let size = t.size_of kv in
  if size < 0 then
    raise (NegativeSize size);
  t.size <- t.size + size;
  prune t
  
let entries t =
  DL.to_list t.priority_list 

let mem t k =
  if H.mem t.map k then
    `Found
  else
    `NotFound

let clear t =
  H.clear t.map;
  t.priority_list <- DL.create ();
  t.num_entries <- 0;
  t.size <- 0

type stats = {
  s_num_entries : int ;
  s_num_hits : int ;
  s_num_misses : int ;
  s_size : int ;
  s_max_size : int 
}

let stats t = {
  s_num_entries = t.num_entries;
  s_num_hits = t.num_hits;
  s_num_misses = t.num_misses;
  s_size = t.size;
  s_max_size = t.max_size
}
  
