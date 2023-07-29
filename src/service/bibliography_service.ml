(*---------------------------------------------------------------------------
   Copyright (c) 2021 University of Bern. All rights reserved.
   Distributed under the ISC license, see terms at the end of the file.
  ---------------------------------------------------------------------------*)

open Hyperbib.Std
open Result.Syntax

let bibtex_file env file =
  let g = Service_env.page_gen env in
  let b = Page.Gen.bibliography g in
  match String.equal file (Bibliography.bibtex_filename b) with
  | false -> Http.Response.not_found_404 ()
  | true ->
      let only_public = Rel_query.Bool.true' in
      let refs = Reference.list ~only_public in
      let* refs =
        Service_env.with_db env (Reference.render_data ~only_public refs)
      in
      let now = Page.Gen.now g in
      match Export.bibtex_of_refs ~now b refs with
      | Ok bib -> Ok (Http.Response.text Http.Status.ok_200 bib)
      | Error explain -> Http.Response.server_error_500 ~explain ()

let page env p =
  let page = p (Service_env.page_gen env) in
  Ok (Page.response page)

let resp r env sess req = match (r : Bibliography.Url.t) with
| Home -> page env Home_html.page
| Help -> page env Help_html.page
| Bibtex_file file -> bibtex_file env file

let v = Kurl.service Bibliography.Url.kind resp

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
