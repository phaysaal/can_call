module Ast = Clang.Ast

let get_function_name (f : Ast.function_decl) =
  match f.Ast.name with
  | Ast.IdentifierName name -> Some name
  | _ -> None
;;

module StrSet = Set.Make(String)

module CallSet = struct
  type t = StrSet.t
  let zero = StrSet.empty
  let ( + ) = StrSet.union
end

module CallVisitor : Refl.Visit.VisitorS
       with type 'a Applicative.t = CallSet.t = struct
  module Applicative = Traverse.Applicative.Reduce (CallSet)
                     
  let hook : type a . a Refl.refl -> (a -> CallSet.t) -> a -> CallSet.t =
    fun refl super x ->
    let call_set = super x in
    match refl with
    | Ast.Refl_expr ->
       begin
         match x.desc with
         | Call { callee; _ } ->
            begin
              match callee.desc with
              | DeclRef { name = IdentifierName name; _} ->
                 StrSet.singleton name 
              | _ -> call_set
            end
         | _ -> call_set
       end
    | _ -> call_set
end

let call_set_of_function_body body =
  let module Visit : Refl.Visit.VisitS with
               type 'a Visitor.t = 'a -> CallSet.t =
    Refl.Visit.Make (CallVisitor)
  in
  Visit.visit [%refl: Ast.stmt] [] body

let get_set_of_callees (f : Ast.function_decl) =
  match f.body with
  | Some fbody ->
    Some (call_set_of_function_body fbody)
  | None -> None
