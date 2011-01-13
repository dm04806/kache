type t = [
| `Ping
| `Put of string * string 
| `Get of string
| `Mem of string
| `Remove of string
| `Clear
| `Value of string
| `NotFound
| `Found
| `Bool of bool
| `Ok
| `Bad
| `GetEntries
| `Entries of (string * string) list
| `GetStats
| `Stats of stats
]
and stats = {
  num_hits : int;
  num_misses : int;
  num_entries : int;
  max_size : int;
  size : int;
}

let of_string s : t =
  Marshal.from_string s 0

let to_string (t:t) =
  Marshal.to_string t [] 

let spr = Printf.sprintf

let rec sprint = function
  | `Ping -> "Ping"
  | `Put (k, v) -> spr "Put %S %S" k v
  | `Get k -> spr "Get %S" k
  | `Mem k -> spr "Mem %S" k
  | `Remove k -> spr "Remove %S" k
  | `Clear -> "Clear"
  | `Value v -> spr "Value %S" v
  | `NotFound -> "NotFound" 
  | `Bool b -> spr "Bool %b" b
  | `Ok -> "Ok"
  | `Bad -> "Bad"
  | `Found -> "Found"
  | `GetEntries -> "GetEntries"
  | `Entries pairs -> "Entries [" ^ (sprint_pairs pairs) ^ "]"
  | `GetStats -> "GetStats"
  | `Stats stats -> "Stats {" ^ (sprint_stats stats) ^ "}"
and sprint_pairs pairs =
  let n = List.length pairs in 
  let sep =
    if n > 5 then
      ";\n"
    else
      "; "
  in
  String.concat sep (
    List.map (
      fun (k, v) ->
	Printf.sprintf "%S,%S" k v
    ) pairs
  )
and sprint_stats stats =
  let num_gets = stats.num_hits + stats.num_misses in
  Printf.sprintf "gets=%d; hits=%d; misses=%d; entries=%d; size=%d; max_size=%d"
    num_gets stats.num_hits stats.num_misses stats.num_entries stats.size stats.max_size
