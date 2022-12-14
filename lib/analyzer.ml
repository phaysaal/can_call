module Ast = Clang.Ast
module StrMap = CGlobal.StrMap
module StrSet = CFunction.StrSet

let build_call_graph ast =
  let tu : Ast.translation_unit = Ast.of_cxtranslationunit ast in
  let call_graph = CGlobal.get_callees_of_functions tu in
  call_graph
;;

let show call_graph =
  StrMap.iter (fun caller callees ->
      let st_callees = StrSet.fold (fun callee acc -> acc ^ " " ^ callee) callees "" in
      Printf.printf "%s -> %s\n" caller st_callees
    ) call_graph

let rec least_fixpoint f x =
  let r, x' = f x in
  if r then
    x'
  else
    least_fixpoint f x'
    
let one_step_traverse call_graph =
  let new_call_graph =
    StrMap.map (fun callees ->
      StrSet.fold (fun callee callees ->
            let callees_of_callee = StrMap.find callee call_graph in
            StrSet.union callees_of_callee callees
          ) callees callees
      ) call_graph in
  let is_fixpoint = StrMap.equal (fun a b -> StrSet.equal a b) new_call_graph call_graph in
  is_fixpoint, new_call_graph

let get_transitive_callees call_graph = least_fixpoint one_step_traverse call_graph

let get_call_status call_graph x y =
  if StrMap.mem x call_graph then
    let callees = StrMap.find x call_graph in
    callees, StrSet.mem y callees
  else
    StrSet.empty, false

let can_call call_graph x y =
  let _, is_called = get_call_status call_graph x y in
  is_called

let can_eventually_call call_graph x y =
  let rec can_call call_graph x y =
    let callees, is_called = get_call_status call_graph x y in
    if is_called then
      call_graph, true
    else
      let call_graph' = StrMap.remove x call_graph in
      let already_checked'', is_called =
        StrSet.fold (fun z (call_graph, is_called) ->
            if is_called then
              call_graph, true
            else
              can_call call_graph z y
          ) callees (call_graph', false) in
      already_checked'', is_called
  in
  let _, is_called = can_call call_graph x y in
  is_called
