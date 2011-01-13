(* command-line client *)

open Lwt
open Kache_client

let sprintf = Printf.sprintf

let _ = 
  let port = ref 9009 in
  let host = ref "localhost" in
  let default_request = `Ping in
  let request_j = ref (Js_kache_types.string_of_t default_request) in

  let usage = sprintf "usage: %s [-p <port>] [-h <host>] <cmd> \n
       where default command is %S" Sys.argv.(0) !request_j in

  Arg.parse [
    "-p", Arg.Int (fun i -> port := i), sprintf "  port (default %d)" !port;
    "-h", Arg.String (fun s -> host := s), sprintf "  host (default %S)" !host;
  ] (fun s -> request_j := s) usage;
    
  let request = Js_kache_types.t_of_string !request_j in

  Lwt_unix.run (
    lwt client = Kache_client.connect ~host:!host ~port:!port in
    lwt resp_opt = client.send_recv request in
    let msg = 
      match resp_opt with
	| None -> "something bad happend"
	| Some response -> 
          Js_kache_types.string_of_t response
    in
    print_endline msg;
    Lwt_unix.close client.socket
  )


