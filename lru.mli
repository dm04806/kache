(* LRU *)

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

exception NegativeSize of int

type ('a, 'b) t

val create : int -> ('a * 'b -> int) -> ('a, 'b) t
(* [create max_size size_of] creates an LRU whose size is not to
   exceed [max_size].  The size of the LRU is the sum of applying
   [size_of] to all its elements. [Invalid_argument] is raised if
   max_size is not positive. *)

val get : ('a, 'b) t -> 'a -> [> `Found of 'b | `NotFound ]
val remove : ('a, 'b) t -> 'a -> [> `NotFound | `Found ]

val put : ('a, 'b) t -> 'a -> 'b -> unit
(* add a replace an entry *)

val entries : ('a, 'b) t -> ('a * 'b) list

val mem : ('a, 'b) t -> 'a -> [> `NotFound | `Found ]
(* mem does not change the 'usedness' -- hence priority -- of the
   entry being found *)

val clear : ('a, 'b) t -> unit

type stats = {
  s_num_entries : int ;
  s_num_hits : int ;
  s_num_misses : int ;
  s_size : int ;
  s_max_size : int 
}

val stats : ('a, 'b) t -> stats
