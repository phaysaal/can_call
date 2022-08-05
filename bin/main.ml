open Cmdliner
   
let filename =
  let doc = "You must enter a C source $(docv)." in
  Arg.(required & pos 0 (some non_dir_file) None & info [] ~docv:"FILENAME" ~doc)

let from_func =
  let doc = "Give the caller function name $(docv)." in
  Arg.(required & pos 1 (some string) None & info [] ~docv:"FROM_FUNCTION" ~doc)

let to_func =
  let doc = "Give the called function name $(docv)." in
  Arg.(required & pos 2 (some string) None & info [] ~docv:"TO_FUNCTION" ~doc)

let can_call_t = Term.(const Can_call.can_call $ filename $ from_func $ to_func)

let cmd =
  let doc = "In the given C file, it checks whether a function calls another function" in
  let man = [
      `S Manpage.s_description;
      `P "$(tname) reads the C file $(i,FILE) and shows function reachability from the first function to the second function.";
      `S Manpage.s_bugs;
      `P "Email bug to mahmudulfaisal@gmail.com"
    ] in
  let info = Cmd.info "can_call" ~version:"0.0.1" ~doc ~man in
  Cmd.v info can_call_t

let eval = Cmd.eval

let () = exit (eval cmd)
