type t = {
  socket : Lwt_unix.file_descr;
  send_recv : Kache_types.t -> Kache_types.t option Lwt.t;
}
val connect : port:int -> host:string -> t Lwt.t
