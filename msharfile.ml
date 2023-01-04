open Graph
open Printf
open Tools

type path = string 


(* Format of text files:
   Pierre 20 35 8 2
   Paul 2 4
   Marie 45
*)



(* Names and expenses are read and summed from the original file *)
let from_file path =

  let infile = open_in path in
  (* Read all lines until end of file. *)
  let rec loop names expenses =
    try
      let line = input_line infile in

      (* Remove leading and trailing spaces. *)
      let line = String.trim line 
      in
      (* Computing the total of the expenses of each person *)
      let name, sum_expenses = match String.split_on_char ' ' line with
                      | name::tail -> name, List.fold_left (fun x sum -> x + sum) 0 (List.map (fun x -> int_of_string x) tail)
                      | _ -> assert false             
      
      in
      if name = "" then loop names expenses (* To prevent wrong lines and empty lines*)
      else
      (* Printing what everyone paid in total *)
      (printf "%s paid %d in total.\n" name sum_expenses;
      loop (name::names) (sum_expenses::expenses))
    with End_of_file -> names, expenses (* Done *)
  in
  let names,expenses = loop [] []
  in
  close_in infile ;
  List.rev names, expenses ;;
  
(* Used in compute_diff : In case the total expenses divided by the number of persons is not an int, we have to make some people pay more*)
let rec map_expenses additional_money dueperperson = function
    | [] -> []
    | expense::tail -> if additional_money > 0 then (expense - (dueperperson + 1))::(map_expenses (additional_money-1) dueperperson tail) 
                        else List.map (fun x -> x - dueperperson) (expense::tail);;
  
(* Compute differences between what they paid and what they should paid *)
let compute_diff expenses =
    let tot_expenses = List.fold_left (fun x sum -> x + sum) 0 expenses
    in
    let dueperperson = tot_expenses / (List.length expenses)
    in 
    let additional_money = tot_expenses mod (List.length expenses) (* The rest of the money to be paid by some of the persons*)
    in
    List.rev (map_expenses additional_money dueperperson expenses);;
    

                      

(* Used in create_start_graph : Create a graph with n nodes (number of persons) without arcs *)  
let create_all_nodes diff_expenses =

    let rec loop graph nb_nodes = function
    | [] -> graph
    | nb::tail -> let graph = new_node graph nb_nodes
                    in loop graph (nb_nodes + 1) tail
    in
    loop empty_graph 2 diff_expenses;;
    
    
(* Used in create_start_graph : Add all possible arcs in the graph with infinite capacities *)    
let add_all_arcs graph =
    n_fold graph (fun graph2 id -> n_fold graph (fun graph3 id2 -> if id = id2 then graph3 else new_arc graph3 id id2 (0, Int.max_int)) graph2) graph 
    
    
(* Used in create_start_graph : Link the start and end node to the rest of the graph using diff_expenses to define capcities *)
let add_edges graph diff_expenses =
    let rec loop new_graph nb_nodes = function
    | [] -> new_graph
    | nb::tail -> if nb > 0 then loop (new_arc new_graph nb_nodes 1 (0, nb)) (nb_nodes + 1) tail 
                            else loop (new_arc new_graph 0 nb_nodes (0, -nb)) (nb_nodes + 1) tail
    in
    loop graph 2 diff_expenses;;


(* Create a graph with n nodes (number of persons) and link them with arcs with infinite capacities
   Then add start and end node and link them to the rest using diff_expenses to define capcities  *)  
let create_start_graph diff_expenses= 
    let graph = create_all_nodes diff_expenses
    in 
    let graph = add_all_arcs graph
    in
    let new_graph = new_node graph 0
    in 
    let new_graph = new_node new_graph 1
    in add_edges new_graph diff_expenses;;
    
    

(* Read and print the results from the graph, saying what everyone has to pay to the other *)
let print_results graph names =
    e_iter graph (fun id1 id2 (flow,_) ->  if id1 = 0 || id2 = 1 || flow = 0 then () 
                                        else printf "%s owes %s %d$\n" (List.nth names (id1-2)) (List.nth names (id2-2)) flow)     
        
    
    
(* DEBUGGING *)
(* Convert the (int*int) graph to a string graph *)    
let convert_to_string_graph int_int_graph = gmap int_int_graph (fun (x,y) -> "("  ^ (string_of_int x) ^ ", " ^ (string_of_int y) ^ ")")


(* Write the resulted graph in the path file. *)
let write_file path graph =

  (* Open a write-file. *)
  let ff = open_out path in

  (* Write all nodes (with fake coordinates) *)
  n_iter_sorted graph (fun id -> fprintf ff "n 0 0 %d\n" id) ;
  fprintf ff "\n" ;
  
  (* Write all arcs *)
  let _ = e_fold graph (fun count id1 id2 lbl -> fprintf ff "e %d %d %d %s\n" id1 id2 count lbl ; count + 1) 0 in
  
  fprintf ff "\n%% End of graph\n" ;
  
  close_out ff ;
  ()
    
      
  
  
  
  
