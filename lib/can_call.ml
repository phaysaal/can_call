
let get_ast file : Clang__.Clang__bindings.cxtranslationunit =
  Clang.parse_file file ;;
  
let can_call filename from_fun to_fun =
  let ast = get_ast filename in
  let call_graph  = Analyzer.build_call_graph ast in
  let tr_call_graph = Analyzer.get_transitive_callees call_graph in
  if Analyzer.can_call tr_call_graph from_fun to_fun then
    Printf.printf "true\n"
  else
    Printf.printf "false\n"
;;

