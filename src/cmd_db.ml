(*---------------------------------------------------------------------------
   Copyright (c) 2021 University of Bern. All rights reserved.
   Distributed under the ISC license, see terms at the end of the file.
  ---------------------------------------------------------------------------*)

open Hyperbib.Std
open Result.Syntax

let schema () =
  Log.if_error ~use:Hyperbib.Exit.some_error @@
  let schema = Sql.create_schema Schema.tables in
  let stmts = [schema] in
  Log.app (fun m -> m "@[<v>%a@]" (Fmt.list Sql.Stmt.pp_src) stmts);
  Ok Hyperbib.Exit.ok

let diagram () =
  Format.printf "%a@." (Rel_kit.Schema_diagram.pp_dot ()) Schema.tables;
  Hyperbib.Exit.ok

let db conf action data_conf = match action with
| `Schema -> schema ()
| `Diagram -> diagram ()

(* Command line interface *)

open Cmdliner

let doc = "Manage the database"
let exits = Hyperbib.Exit.Info.base_cmd
let man = [
  `S Manpage.s_description;
  `P "The $(tname) manages the app database."; ]

let action =
  let action = [ "schema", `Schema; "diagram", `Diagram ] in
  let doc =
    let alts = Arg.doc_alts_enum action in
    Fmt.str "The action to perform. $(docv) must be one of %s." alts
  in
  let action = Arg.enum action in
  Arg.(required & pos 0 (some action) None & info [] ~doc ~docv:"ACTION")

let cmd =
  Cmd.v (Cmd.info "db" ~doc ~exits ~man)
    Term.(const db $ Hyperbib.Cli.conf $ action $
          Hyperbib.Cli.data_conf ~pos:1)

(*---------------------------------------------------------------------------
   Copyright (c) 2021 University of Bern

   Permission to use, copy, modify, and/or distribute this software for any
   purpose with or without fee is hereby granted, provided that the above
   copyright notice and this permission notice appear in all copies.

   THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
   WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
   MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
   ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
   WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
   ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
   OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  ---------------------------------------------------------------------------*)
