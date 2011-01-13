(* Auto-generated from "kache_types.atd" *)


type stats = {
  num_hits: int;
  num_misses: int;
  num_entries: int;
  max_size: int;
  size: int
}

type t = [
    `Ping
  | `Put of (string * string)
  | `Get of string
  | `Mem of string
  | `Remove of string
  | `Clear
  | `Value of string
  | `NotFound
  | `Found
  | `Bool of bool
  | `Ok
  | `Bad
  | `GetEntries
  | `Entries of (string * string) list
  | `GetStats
  | `Stats of stats
]

let stats_tag = Bi_io.record_tag
let write_untagged_stats = (
  fun ob x ->
    Bi_vint.write_uvint ob 5;
    Bi_outbuf.add_char4 ob '\162' '\002' '\002' '\153';
    (
      Bi_io.write_svint
    ) ob x.num_hits;
    Bi_outbuf.add_char4 ob '\167' '\154' '\138' '\131';
    (
      Bi_io.write_svint
    ) ob x.num_misses;
    Bi_outbuf.add_char4 ob '\197' '|' '\027' '\023';
    (
      Bi_io.write_svint
    ) ob x.num_entries;
    Bi_outbuf.add_char4 ob '\150' 'T' '\159' '|';
    (
      Bi_io.write_svint
    ) ob x.max_size;
    Bi_outbuf.add_char4 ob '\204' 'S' '\160' '\193';
    (
      Bi_io.write_svint
    ) ob x.size;
)
let write_stats ob x =
  Bi_io.write_tag ob Bi_io.record_tag;
  write_untagged_stats ob x
let string_of_stats n x =
  let ob = Bi_outbuf.create n in
  write_stats ob x;
  Bi_outbuf.contents ob
let get_stats_reader = (
  fun tag ->
    if tag <> 21 then Ag_ob_run.read_error () else
      fun ib ->
        let x =
          {
            num_hits = Obj.magic 0.0;
            num_misses = Obj.magic 0.0;
            num_entries = Obj.magic 0.0;
            max_size = Obj.magic 0.0;
            size = Obj.magic 0.0;
          }
        in
        let bits0 = ref 0 in
        let len = Bi_vint.read_uvint ib in
        for i = 1 to len do
          match Bi_io.read_field_hashtag ib with
            | 570557081 ->
              let v =
                (
                  Ag_ob_run.read_int
                ) ib
              in
              Obj.set_field (Obj.repr x) 0 (Obj.repr v);
              bits0 := !bits0 lor 0x1;
            | 664439427 ->
              let v =
                (
                  Ag_ob_run.read_int
                ) ib
              in
              Obj.set_field (Obj.repr x) 1 (Obj.repr v);
              bits0 := !bits0 lor 0x2;
            | -981722345 ->
              let v =
                (
                  Ag_ob_run.read_int
                ) ib
              in
              Obj.set_field (Obj.repr x) 2 (Obj.repr v);
              bits0 := !bits0 lor 0x4;
            | 374644604 ->
              let v =
                (
                  Ag_ob_run.read_int
                ) ib
              in
              Obj.set_field (Obj.repr x) 3 (Obj.repr v);
              bits0 := !bits0 lor 0x8;
            | -866934591 ->
              let v =
                (
                  Ag_ob_run.read_int
                ) ib
              in
              Obj.set_field (Obj.repr x) 4 (Obj.repr v);
              bits0 := !bits0 lor 0x10;
            | _ -> Bi_io.skip ib
        done;
        if !bits0 <> 0x1f then Ag_ob_run.missing_fields [| !bits0 |] [| "num_hits"; "num_misses"; "num_entries"; "max_size"; "size" |];
        x
)
let read_stats = (
  fun ib ->
    if Bi_io.read_tag ib <> 21 then Ag_ob_run.read_error_at ib;
    let x =
      {
        num_hits = Obj.magic 0.0;
        num_misses = Obj.magic 0.0;
        num_entries = Obj.magic 0.0;
        max_size = Obj.magic 0.0;
        size = Obj.magic 0.0;
      }
    in
    let bits0 = ref 0 in
    let len = Bi_vint.read_uvint ib in
    for i = 1 to len do
      match Bi_io.read_field_hashtag ib with
        | 570557081 ->
          let v =
            (
              Ag_ob_run.read_int
            ) ib
          in
          Obj.set_field (Obj.repr x) 0 (Obj.repr v);
          bits0 := !bits0 lor 0x1;
        | 664439427 ->
          let v =
            (
              Ag_ob_run.read_int
            ) ib
          in
          Obj.set_field (Obj.repr x) 1 (Obj.repr v);
          bits0 := !bits0 lor 0x2;
        | -981722345 ->
          let v =
            (
              Ag_ob_run.read_int
            ) ib
          in
          Obj.set_field (Obj.repr x) 2 (Obj.repr v);
          bits0 := !bits0 lor 0x4;
        | 374644604 ->
          let v =
            (
              Ag_ob_run.read_int
            ) ib
          in
          Obj.set_field (Obj.repr x) 3 (Obj.repr v);
          bits0 := !bits0 lor 0x8;
        | -866934591 ->
          let v =
            (
              Ag_ob_run.read_int
            ) ib
          in
          Obj.set_field (Obj.repr x) 4 (Obj.repr v);
          bits0 := !bits0 lor 0x10;
        | _ -> Bi_io.skip ib
    done;
    if !bits0 <> 0x1f then Ag_ob_run.missing_fields [| !bits0 |] [| "num_hits"; "num_misses"; "num_entries"; "max_size"; "size" |];
    x
)
let stats_of_string ?pos s =
  read_stats (Bi_inbuf.from_string ?pos s)
let _1_tag = Bi_io.array_tag
let write_untagged__1 = (
  Ag_ob_run.write_untagged_list
    Bi_io.tuple_tag
    (
      fun ob x ->
        Bi_vint.write_uvint ob 2;
        (
          let x, _ = x in (
            Bi_io.write_string
          ) ob x
        );
        (
          let _, x = x in (
            Bi_io.write_string
          ) ob x
        );
    )
)
let write__1 ob x =
  Bi_io.write_tag ob Bi_io.array_tag;
  write_untagged__1 ob x
let string_of__1 n x =
  let ob = Bi_outbuf.create n in
  write__1 ob x;
  Bi_outbuf.contents ob
let get__1_reader = (
  Ag_ob_run.get_list_reader (
    fun tag ->
      if tag <> 20 then Ag_ob_run.read_error () else
        fun ib ->
          let len = Bi_vint.read_uvint ib in
          if len < 2 then Ag_ob_run.missing_tuple_fields len [ 0; 1 ];
          let x0 =
            (
              Ag_ob_run.read_string
            ) ib
          in
          let x1 =
            (
              Ag_ob_run.read_string
            ) ib
          in
          for i = 2 to len - 1 do Bi_io.skip ib done;
          (x0, x1)
  )
)
let read__1 = (
  Ag_ob_run.read_list (
    fun tag ->
      if tag <> 20 then Ag_ob_run.read_error () else
        fun ib ->
          let len = Bi_vint.read_uvint ib in
          if len < 2 then Ag_ob_run.missing_tuple_fields len [ 0; 1 ];
          let x0 =
            (
              Ag_ob_run.read_string
            ) ib
          in
          let x1 =
            (
              Ag_ob_run.read_string
            ) ib
          in
          for i = 2 to len - 1 do Bi_io.skip ib done;
          (x0, x1)
  )
)
let _1_of_string ?pos s =
  read__1 (Bi_inbuf.from_string ?pos s)
let t_tag = Bi_io.variant_tag
let write_untagged_t = (
  fun ob x ->
    match x with
      | `Ping -> Bi_outbuf.add_char4 ob '5' '1' '\030' '\146'
      | `Put x ->
        Bi_outbuf.add_char4 ob '\128' '=' '\026' '\175';
        (
          fun ob x ->
            Bi_io.write_tag ob Bi_io.tuple_tag;
            Bi_vint.write_uvint ob 2;
            (
              let x, _ = x in (
                Bi_io.write_string
              ) ob x
            );
            (
              let _, x = x in (
                Bi_io.write_string
              ) ob x
            );
        ) ob x
      | `Get x ->
        Bi_outbuf.add_char4 ob '\128' '6' '8' 'v';
        (
          Bi_io.write_string
        ) ob x
      | `Mem x ->
        Bi_outbuf.add_char4 ob '\128' ':' '\197' '\245';
        (
          Bi_io.write_string
        ) ob x
      | `Remove x ->
        Bi_outbuf.add_char4 ob '\185' '\029' '\016' 'd';
        (
          Bi_io.write_string
        ) ob x
      | `Clear -> Bi_outbuf.add_char4 ob '[' '\136' '\225' 'm'
      | `Value x ->
        Bi_outbuf.add_char4 ob '\196' '\229' '\239' 'Q';
        (
          Bi_io.write_string
        ) ob x
      | `NotFound -> Bi_outbuf.add_char4 ob 'n' 'W' '\144' 'O'
      | `Found -> Bi_outbuf.add_char4 ob '\023' '\196' 'r' '"'
      | `Bool x ->
        Bi_outbuf.add_char4 ob '\171' '\244' '\176' 'J';
        (
          Bi_io.write_bool
        ) ob x
      | `Ok -> Bi_outbuf.add_char4 ob '\000' '\000' 'E' '<'
      | `Bad -> Bi_outbuf.add_char4 ob '\000' '2' 'i' '\165'
      | `GetEntries -> Bi_outbuf.add_char4 ob '?' 'q' '\183' 'z'
      | `Entries x ->
        Bi_outbuf.add_char4 ob '\198' '\176' 'U' '0';
        (
          write__1
        ) ob x
      | `GetStats -> Bi_outbuf.add_char4 ob '=' '\148' 'A' '\201'
      | `Stats x ->
        Bi_outbuf.add_char4 ob '\151' '8' '\229' '\255';
        (
          write_stats
        ) ob x
)
let write_t ob x =
  Bi_io.write_tag ob Bi_io.variant_tag;
  write_untagged_t ob x
let string_of_t n x =
  let ob = Bi_outbuf.create n in
  write_t ob x;
  Bi_outbuf.contents ob
let get_t_reader = (
  fun tag ->
    if tag <> 23 then Ag_ob_run.read_error () else
      fun ib ->
        Bi_io.read_hashtag ib (fun ib h has_arg ->
          match h, has_arg with
            | 892411538, false -> `Ping
            | 4004527, true -> `Put (
                (
                  fun ib ->
                    if Bi_io.read_tag ib <> 20 then Ag_ob_run.read_error_at ib;
                    let len = Bi_vint.read_uvint ib in
                    if len < 2 then Ag_ob_run.missing_tuple_fields len [ 0; 1 ];
                    let x0 =
                      (
                        Ag_ob_run.read_string
                      ) ib
                    in
                    let x1 =
                      (
                        Ag_ob_run.read_string
                      ) ib
                    in
                    for i = 2 to len - 1 do Bi_io.skip ib done;
                    (x0, x1)
                ) ib
              )
            | 3553398, true -> `Get (
                (
                  Ag_ob_run.read_string
                ) ib
              )
            | 3851765, true -> `Mem (
                (
                  Ag_ob_run.read_string
                ) ib
              )
            | 958206052, true -> `Remove (
                (
                  Ag_ob_run.read_string
                ) ib
              )
            | -611786387, false -> `Clear
            | -991563951, true -> `Value (
                (
                  Ag_ob_run.read_string
                ) ib
              )
            | -296251313, false -> `NotFound
            | 398750242, false -> `Found
            | 737456202, true -> `Bool (
                (
                  Ag_ob_run.read_bool
                ) ib
              )
            | 17724, false -> `Ok
            | 3303845, false -> `Bad
            | 1064417146, false -> `GetEntries
            | -961522384, true -> `Entries (
                (
                  read__1
                ) ib
              )
            | 1033126345, false -> `GetStats
            | 389604863, true -> `Stats (
                (
                  read_stats
                ) ib
              )
            | _ -> Ag_ob_run.unsupported_variant h has_arg
        )
)
let read_t = (
  fun ib ->
    if Bi_io.read_tag ib <> 23 then Ag_ob_run.read_error_at ib;
    Bi_io.read_hashtag ib (fun ib h has_arg ->
      match h, has_arg with
        | 892411538, false -> `Ping
        | 4004527, true -> `Put (
            (
              fun ib ->
                if Bi_io.read_tag ib <> 20 then Ag_ob_run.read_error_at ib;
                let len = Bi_vint.read_uvint ib in
                if len < 2 then Ag_ob_run.missing_tuple_fields len [ 0; 1 ];
                let x0 =
                  (
                    Ag_ob_run.read_string
                  ) ib
                in
                let x1 =
                  (
                    Ag_ob_run.read_string
                  ) ib
                in
                for i = 2 to len - 1 do Bi_io.skip ib done;
                (x0, x1)
            ) ib
          )
        | 3553398, true -> `Get (
            (
              Ag_ob_run.read_string
            ) ib
          )
        | 3851765, true -> `Mem (
            (
              Ag_ob_run.read_string
            ) ib
          )
        | 958206052, true -> `Remove (
            (
              Ag_ob_run.read_string
            ) ib
          )
        | -611786387, false -> `Clear
        | -991563951, true -> `Value (
            (
              Ag_ob_run.read_string
            ) ib
          )
        | -296251313, false -> `NotFound
        | 398750242, false -> `Found
        | 737456202, true -> `Bool (
            (
              Ag_ob_run.read_bool
            ) ib
          )
        | 17724, false -> `Ok
        | 3303845, false -> `Bad
        | 1064417146, false -> `GetEntries
        | -961522384, true -> `Entries (
            (
              read__1
            ) ib
          )
        | 1033126345, false -> `GetStats
        | 389604863, true -> `Stats (
            (
              read_stats
            ) ib
          )
        | _ -> Ag_ob_run.unsupported_variant h has_arg
    )
)
let t_of_string ?pos s =
  read_t (Bi_inbuf.from_string ?pos s)
let create_stats 
  ~num_hits
  ~num_misses
  ~num_entries
  ~max_size
  ~size
  () =
  {
    num_hits = num_hits;
    num_misses = num_misses;
    num_entries = num_entries;
    max_size = max_size;
    size = size;
  }
