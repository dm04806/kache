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

let verify l =
  match l.head with
    | Some start ->
      assert(start.prev = None);
      let cur = ref start in
      while !cur.next <> None do
	match !cur.next with
	  | Some n ->
	    ( match n.prev with
	      | Some p -> assert (p == !cur)
	      | None -> assert false
	    );
	    cur := n;
	  | None ->
	    assert false
      done;
      ( match l.last with
	| Some z -> assert (z == !cur)
	| None -> assert false
      );
    | None ->
      assert (l.last = None)

let create () = { 
  head = None; 
  last = None 
}

let create_cell data = {
  data = data;
  next = None;
  prev = None;
}

let head l = 
  match l.head with
    | Some cell -> cell
    | None -> raise Not_found

let last l = 
  match l.last with
    | Some cell -> cell
    | None -> raise Not_found
      
let next cell = 
  match cell.next with
    | Some cell -> cell
    | None -> raise Not_found

let prev cell = 
  match cell.prev with
    | Some cell -> cell
    | None -> raise Not_found

let contents cell =
  cell.data

let prepend_cell l cell =
  cell.prev <- None;
  cell.next <- l.head;
  ( match l.head with
    | Some p ->
      p.prev <- Some cell
    | None ->
      ()
  );
  l.head <- Some cell;
  if l.last = None then l.last <- Some cell

let prepend l data =
  let cell = { 
    data = data;
    prev = None;
    next = None
  } 
  in
  prepend_cell l cell


let append_cell l cell =
  cell.prev <- l.last;
  cell.next <- None;
  ( match l.last with
    | Some p ->
      p.next <- Some cell
    | None ->
      ()
  );
  l.last <- Some cell;
  if l.head = None then l.head <- Some cell


let append l data =
  let cell = { 
    data = data;
    prev = None;
    next = None
  } 
  in
  append_cell l cell


let delete l cell =
  (* There is no check that [cell] is actually a member of [l]! *)
  ( match cell.prev with
    | None ->
      l.head <- cell.next
    | Some p ->
      p.next <- cell.next
  );
  ( match cell.next with
    | None ->
      l.last <- cell.prev
    | Some n ->
      n.prev <- cell.prev
  );
  cell.prev <- None;
  cell.next <- None


let iter f l =
  let p = ref l.last in
  while !p <> None do
    match !p with
      | Some cell ->
	f cell.data;
	p := cell.prev;
      | None ->
	assert false
  done

let map f l =
  let h = ref [] in
  iter (
    fun a -> 
      h := (f a) :: !h
  ) l;
  !h

let fold f b0 l =
  let b = ref b0 in
  iter (
    fun a ->
      b := f !b a
  ) l;
  !b

let to_list l =
  fold (
    fun accu a ->
      a :: accu
  ) [] l
