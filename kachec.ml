(* command-line client *)

open Lwt
open Kache_client

let sprintf = Printf.sprintf

let _ = 
  let port = ref 9009 in
  let host = ref "localhost" in
  let cmd = ref "[Ping]" in

  let usage = sprintf "usage: %s [-p <port>] [-h <host>] <cmd> \n
       where default command is %S" Sys.argv.(0) !cmd in

  Arg.parse [
    "-p", Arg.Int (fun i -> port := i), sprintf "  port (default %d)" !port;
    "-h", Arg.String (fun s -> host := s), sprintf "  host (default %S)" !host;
  ] (fun s -> cmd := s) usage;
    
  let request = 
    match Pcre.split !cmd with
      | [ "put"; key; value ] -> `Put (key, value)
      | [ "get"; key ]        -> `Get key
      | [ "remove"; key ]     -> `Remove key
      | [ "mem"; key ]        -> `Mem key
      | [ "clear" ]           -> `Clear
      | [ "entries" ]         -> `GetEntries
      | [ "stats" ]           -> `GetStats

      | _ -> 
	Printf.printf "bad command %S\n%!" !cmd;
	exit 1
  in

  Lwt_unix.run (
    lwt client = Kache_client.connect ~host:!host ~port:!port in
    lwt resp_opt = client.send_recv request in
    let msg = 
      match resp_opt with
	| None -> "something bad happend"
	| Some t -> Kache_types.sprint t
    in
    print_endline msg;
    Lwt_unix.close client.socket
  )


