(** doubly linked list *)

(* AUTHOR: Gerd Stolpmann, with some additions by barko *)

(* LICENSE:

   Copyright (c) 2007, Wink Technologies, Inc.

   All rights reserved.

   Redistribution and use in source and binary forms, with or without 
   modification, are permitted provided that the following conditions are met:

   * Redistributions of source code must retain the above copyright 
   notice, this list of conditions and the following disclaimer.
   * Redistributions in binary form must reproduce the above copyright 
   notice, this list of conditions and the following disclaimer in 
   the documentation and/or other materials provided with the 
   distribution.
   * Neither the name of Wink Technologies, Inc. nor the names of its 
   contributors may be used to endorse or promote products 
   derived from this software without specific prior written 
   permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*)


type 'a cell = {
  data : 'a;
  mutable prev : 'a cell option;
  mutable next : 'a cell option;
}

type 'a t = { 
  mutable head : 'a cell option; 
  mutable last : 'a cell option; 
}

val verify : 'a t -> unit
val create : unit -> 'a t
val create_cell : 'a -> 'a cell
val head : 'a t -> 'a cell
val last : 'a t -> 'a cell
val next : 'a cell -> 'a cell
val prev : 'a cell -> 'a cell
val contents : 'a cell -> 'a
val prepend_cell : 'a t -> 'a cell -> unit
val prepend : 'a t -> 'a -> unit
val append_cell : 'a t -> 'a cell -> unit
val append : 'a t -> 'a -> unit
val delete : 'a t -> 'a cell -> unit
val iter : ('a -> 'b) -> 'a t -> unit
val map : ('a -> 'b) -> 'a t -> 'b list
val fold : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
val to_list : 'a t -> 'a list
