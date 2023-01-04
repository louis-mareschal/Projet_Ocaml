(* Yes, we have to repeat open Graph. *)
open Graph

(* returns a new graph having the same nodes than gr, but no arc *)
let clone_nodes (gr:'a graph) = n_fold gr new_node empty_graph;;
    
(* maps all arcs of gr by function f *)
let gmap gr f = 
    let new_graph = clone_nodes gr 
    in
        e_fold gr (fun graph id1 id2 lbl ->  new_arc graph id1 id2 (f lbl)) new_graph;;
        

(* adds n to the value of the arc between id1 and id2. If the arc does not exist, it is created *)
let add_arc g id1 id2 n = match find_arc g id1 id2 
    with
        | None -> new_arc g id1 id2 n
        | Some lbl -> new_arc g id1 id2 (lbl + n)



