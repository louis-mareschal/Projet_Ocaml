open Graph
open Gfile
open Tools

(* Define a path in a graph as a list of information about the arcs used : id of the 2 nodes of the arc, followed by its current flow and its capacitiy *)
type graph_path = (id*id*int*int) list;;

(* Find a possible path between 2 nodes 
   We expect that an id is greater or equal than 0 *)
val find_path: (int*int) graph -> id -> id -> graph_path option;;

(* Print a graph path*)
val print_path: graph_path option -> unit;; 

(* Read an int graph from a file and convert it as an int*int graph *)
val open_and_initialize: path -> (int*int) graph;;

(* Compute and return the maximum flow that can goes threw a graph path *)
val max_flow_path: graph_path -> int;;

(* Update the capacity of all arcs of the graph_path given the max flow and the graph. It returns the new graph *)
val update_capacity: (int*int) graph -> graph_path -> int -> (int*int) graph;;

(* Remove all arcs created just for the algo *)
val clean_unusefull_arcs: (int*int) graph -> (int*int) graph -> (int*int) graph;;

(* Main algorithm, given a graph, a starting node and an ending node, it return the final graph with the updates flows *)
val main_algo: (int*int) graph -> id -> id -> (int*int) graph;;


