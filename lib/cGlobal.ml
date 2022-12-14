module Ast = Clang.Ast
module StrMap = Map.Make(String)
module StrSet = CFunction.StrSet

module CallGraph = struct
  type t = StrSet.t StrMap.t
  let zero = StrMap.empty
  let ( + ) = StrMap.union (fun _key s1 s2 -> Some (StrSet.union s1 s2))
end

module rec FunctionVisitor : Refl.Visit.VisitorS
           with type 'a Applicative.t = CallGraph.t = struct
  module Applicative = Traverse.Applicative.Reduce (CallGraph)

  let hook : type a . a Refl.refl -> (a -> CallGraph.t) -> a -> CallGraph.t =
    fun refl super x ->
    let call_graph = super x in
    match refl with
    | Ast.Refl_function_decl ->
       begin match CFunction.get_function_name x with
       | Some name ->
          begin match CFunction.get_set_of_callees x with
          | Some callees ->
             StrMap.singleton name callees
          | None -> call_graph end
       | None -> call_graph end
    | _ -> call_graph

end
   and VisitFunctions : Refl.Visit.VisitS with
         type 'a Visitor.t = 'a -> CallGraph.t =
     Refl.Visit.Make (FunctionVisitor)
;;

let get_callees_of_functions tu = VisitFunctions.visit [%refl: Ast.translation_unit] [] tu
