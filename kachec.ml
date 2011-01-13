(* command-line client *)

open Lwt
open Kache_client

let _ = 
  let cmd = ref "" in
  let port = ref 9009 in
  let host = ref "localhost" in

  (try
     Getopt.parse_cmdline [
       'p', "port", None, Some (fun s -> port := int_of_string s);
       'h', "host", None, Some (fun s -> host := s);
       'c', "cmd", None, Some (fun s -> cmd := s);
     ] (fun _ -> ())
   with Getopt.Error err ->
     print_endline err;
     exit 1
  );

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


