(lang dune 1.10)

(name can_call)

(generate_opam_files true)

(source
 (github phaysaal/can_call))

(authors "Mahmudul Faisal Al Ameen")

(license LICENSE)

(package
 (name can_call)
 (synopsis "A static checker for C function call")
 (description "A tool to check if a function can call another function in the give C program file.")
 (depends ocaml dune)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
