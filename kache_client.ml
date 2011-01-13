(* client *)

open Lwt

type t = {
  socket : Lwt_unix.file_descr;
  send_recv : Kache_types.t -> Kache_types.t option Lwt.t
}

let connect ~port ~host =
  lwt sock = Client.connect host port in
  let send_recv = Message.mk_send_recv sock in
  let transcode request =
    let request_s = Message.frame (Kache_types.to_string request) in
    lwt response_s_opt = send_recv request_s in

    let response = 
      match response_s_opt with
	| Some response_s ->
	  Some (Kache_types.of_string response_s)
	| None -> 
	  None
    in
    return response
  in

  return {
    socket = sock;
    send_recv = transcode
  }
