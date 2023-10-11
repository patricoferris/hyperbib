(lang dune 3.11)

(name hyperbib)

(generate_opam_files true)

(source (github patricoferris/))
(license ISC)
(authors "Daniel Bünzli")
(maintainers "patrick@sirref.org")

(package
 (name hyperbib)
 (synopsis "Publish annotated bibliographies")
 (license "ISC")
 (description "")
 (depends
  (cmdliner (>= "1.0.4"))
  b0
  ptime
  webs
  htmlit
  htmlact
  rel
  note
  brr
  bos
  fmt
  js_of_ocaml))
