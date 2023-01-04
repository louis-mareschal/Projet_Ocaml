open Graph
open Gfile
open Tools

(* Define a path in a graph as a list of information about the arcs used : id of the 2 nodes of the arc, followed by its current flow and its capacitiy *)
type graph_path = (id*id*int*int) list;;

(* VERSION 1 (voir version 2 simplifiée en dessous *)
(*let find_path graph id1 id2 =
    let rec loop current_node path list_out_arcs = 
        if current_node = id2 then Some (List.rev path) 
        else
        (let rec loop2 = function
            | [] -> -1, []
            | (id_dest, (flow, cap))::tail -> if flow < cap 
                                then id_dest, tail  
                                else loop2 tail
        in
            let id_dest, tail = loop2 list_out_arcs
        in
            if id_dest = -1 then None 
            else 
            (let final_path = loop id_dest (id_dest::path) (out_arcs graph id_dest)
            in
            if final_path = None then loop current_node path tail else final_path))
   in
   let list_out_arcs = out_arcs graph id1
   in
    loop id1 [id1] list_out_arcs;;*)


(* Find a possible path between 2 nodes 
   We expect that an id is greater or equal than 0 *)
let find_path graph id1 id2 =
    let rec loop current_node path list_out_arcs = 
        if current_node = id2 then Some (List.rev path) 
        else
        
        match list_out_arcs with
        | [] -> None
        | (id_dest, (flow, cap))::tail -> if flow < cap && not (List.exists (fun (x,_,_,_) -> x = id_dest) path)
                                then 
                                (let final_path = loop id_dest ((current_node, id_dest, flow, cap)::path) (out_arcs graph id_dest)
                                in 
                                if final_path = None then loop current_node path tail else final_path)
                                else loop current_node path tail
   in
   let list_out_arcs = out_arcs graph id1
   in
    loop id1 [] list_out_arcs;;
    
    
(* Print a graph path*)    
let print_path = function
    | None -> Printf.printf "Le chemin est invalide\n"
    | Some graph_path -> Printf.printf "path = %s\n%!" (String.concat " -> " ( List.map (fun (id_start, id_dest, flow, cap) -> "Start : " ^ string_of_int id_start ^ " | Dest : " ^ string_of_int id_dest ^ " | Flow : " ^ string_of_int flow ^ " | Cap : " ^ string_of_int cap) graph_path))
    ;;


(* Read an int graph from a file and convert it as an int*int graph *)
let open_and_initialize path =
    let string_graph = from_file path in
    gmap string_graph (fun s -> (0, int_of_string s));;
    
    
(* Compute and return the maximum flow that can goes threw a graph path *)    
let max_flow_path graph_path = 
    let rec loop max_flow = function
        | [] -> max_flow
        | (_, _, flow, cap)::tail -> let max_f = cap - flow in if max_f < max_flow then loop max_f tail else loop max_flow tail
    in
    loop Int.max_int graph_path ;;
     
     
(* Update the capacity of all arcs of the graph_path given the max flow and the graph. It returns the new graph *)     
let update_capacity graph graph_path increase =
    let rec loop new_graph = function
        | [] -> new_graph
        | (id_start, id_dest, flow, cap)::tail -> let new_graph = new_arc new_graph id_start id_dest ((flow + increase), cap) in
                                                  let new_graph = new_arc new_graph id_dest id_start (0, cap-(flow + increase))
                                                    in loop new_graph tail
    in
    loop graph graph_path ;;
    

(* Remove all arcs created just for the algo *)
let clean_unusefull_arcs gr new_graph =
    e_fold gr (fun graph id1 id2 (_,cap) -> let flow = (match find_arc new_graph id1 id2 with
                                                | None -> assert false
                                                | Some (new_flow, _) -> new_flow) 
                                               in new_arc graph id1 id2 (flow, cap)) gr;;
    
    
(* Main algorithm, given a graph, a starting node and an ending node, it return the final graph with the updates flows *)    
let main_algo graph id1 id2 = 
    let rec loop graph max_flow =
        let graph_path = find_path graph id1 id2 
        in
        match graph_path with
        | None -> max_flow, graph
        | Some g_path -> let increase =  max_flow_path g_path 
                            in
                            let graph = update_capacity graph g_path increase
                            in
                            loop graph (max_flow + increase)         
    in
    let (max_flow, new_graph) = loop graph 0
    in
    let clean_graph = clean_unusefull_arcs graph new_graph
    in
    Printf.printf "Maximum flow : %d\n "  max_flow;
    clean_graph;;

