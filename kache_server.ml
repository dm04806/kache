(* server *)

(* convert from [Lru.stats] to [Cache_types.stats] *)
let stats_of_lru_stats lru_stats = {
  Kache_types.num_hits = lru_stats.Lru.s_num_hits;
  num_misses = lru_stats.Lru.s_num_misses;
  num_entries = lru_stats.Lru.s_num_entries;
  size = lru_stats.Lru.s_size;
  max_size = lru_stats.Lru.s_max_size
}

let respond lru sock msg =
  let response = 
    match Kache_types.t_of_string msg with
      | `Put (k, v) -> 
	Lru.put lru k v;
	`Ok

      | `Get k -> (
	match Lru.get lru k with
	  | `Found v -> `Value v
	  | `NotFound -> `NotFound
      )

      | `Remove k ->
	Lru.remove lru k

      | `Mem k -> 
	Lru.mem lru k

      | `Clear -> 
	Lru.clear lru;
	`Ok

      | `GetEntries ->
	`Entries (Lru.entries lru)

      | `GetStats ->
	`Stats (stats_of_lru_stats (Lru.stats lru))

      | `Ping -> 
        `Ok

      | _ -> `Bad
  in
  let response_s = Kache_types.string_of_t 1024 response in
  Message.send sock (Message.frame response_s)
  
let int_of_si_bytes si_bytes =
  let f, multiplier_s = Scanf.sscanf si_bytes "%f %s" (fun i s -> i, s) in
  let multiplier =
    if String.length multiplier_s = 0 then
      1.
    else
      match multiplier_s.[0] with
	| 'G' -> 1_000_000_000.
	| 'M' -> 1_000_000.
	| 'K' -> 1_000.
	| _ -> raise (Invalid_argument multiplier_s)
  in
  int_of_float (f *. multiplier)

let sprintf = Printf.sprintf 

let _ =
  let usage = sprintf "usage: %s [-p <port>] [-s <max-size>]" Sys.argv.(0) in
  let port= ref 9009 in
  let max_size_s = ref "10M" in

  Arg.parse [
    "-p", Arg.Int (fun i -> port := i), 
    sprintf "  port (default %d)" !port;

    "-s", Arg.String (fun s -> max_size_s := s), 
    sprintf "  max size (default %s)" !max_size_s
  ] (fun _ -> ()) usage;

  let max_size = int_of_si_bytes !max_size_s in

  (* igore SIGPIPE's *)
  Sys.set_signal Sys.sigpipe Sys.Signal_ignore;

  (* create the lru *)
  let len = String.length in
  let lru = Lru.create max_size (fun (k,v) -> (len k) + (len v)) in

  (* create and run the server *)
  let srv = Server.server !port (respond lru) in
  Lwt_unix.run srv
      
