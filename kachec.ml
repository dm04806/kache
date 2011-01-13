(* command-line client *)

(*
Copyright (c) 2011, barko 00336ea19fcb53de187740c490f764f4
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:
      
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the
   distribution.

3. Neither the name of barko nor the names of contributors may be used
   to endorse or promote products derived from this software without
   specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*)

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


