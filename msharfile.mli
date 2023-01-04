(* Read names and expenses from a file *)
open Graph
open Printf
open Tools

type path = string

(* Names and expenses are read and summed from the original file *)
val from_file: path -> (string list)*(int list)

(* Compute differences between what they paid and what they should paid *)
val compute_diff : int list -> int list

(* Used in compute_diff : In case the total expenses divided by the number of persons is not an int, we have to make some people pay more*)
val map_expenses : int -> int -> int list -> int list

(* Create a graph with n nodes (number of persons) and link them with arcs with infinite capacities
   Then add start and end node and link them to the rest using diff_expenses to define capcities  *)
val create_start_graph : int list -> (int*int) graph

(* Used in create_start_graph : Create a graph with n nodes (number of persons) without arcs *)
val create_all_nodes : int list -> (int*int) graph

(* Used in create_start_graph : Add all possible arcs in the graph with infinite capacities *)
val add_all_arcs : (int*int) graph -> (int*int) graph

(* Used in create_start_graph : Link the start and end node to the rest of the graph using diff_expenses to define capcities *)
val add_edges : (int*int) graph -> int list -> (int*int) graph

(* Read and print the results from the graph, saying what everyone has to pay to the other *)
val print_results : (int*int) graph -> string list -> unit


(* DEBUGGING *)
(* Convert the (int*int) graph to a string graph *)
val convert_to_string_graph: (int*int) graph -> string graph

(* Write the resulted graph in the path file. *)
val write_file : path -> string graph -> unit


