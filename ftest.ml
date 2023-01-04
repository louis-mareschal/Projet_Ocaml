open Gfile
open Tools
open Ff_algo


let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf
        "\n ✻  Usage: %s infile source sink outfile\n\n%s%!" Sys.argv.(0)
        ("    🟄  infile  : input file containing a graph\n" ^
         "    🟄  outfile : output file in which the result should be written.\n" ^
         "    🟄  source node : the id (int) of the starting node\n"^
         "    🟄  target node : the id (int) of the sink node.\n\n") ;
      exit 0
    end ;


  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) *)
  
  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(2)
  and id_start = int_of_string(Sys.argv.(3))
  and id_dest = int_of_string(Sys.argv.(4))
 
  
  in

  
  
  (* **** TEST 1 clone_nodes **** *)
  
  (*
  let graph = from_file infile in
  let final_graph = clone_nodes graph in 
  *)
  
  (* **** TEST 2 gmap **** *)
  
  (*let graph = from_file infile in
  let final_graph = gmap graph (fun s -> s  ^ " OK !") in *)
  
  (* **** TEST 3 export **** *)
  (* let graph = from_file infile
     in
     let () = export "test_export.dot" graph
     in *) 
  
  (* **** TEST 3 open_and_initialize and convert_to_string_graph **** *)
  
  (*let graph = open_and_initialize infile
  in
  
  
  (* *** TEST 3.1 find_path and print_path *** *)
  let test_path = find_path graph 0 1
  in
  print_path test_path;
  
  (* *** TEST 3.2 max_flow_path and update_capacity *** *)
  match test_path with
      | None -> ()
      | Some path -> let max_flow_p = max_flow_path path
                       in
                    let graph = update_capacity graph path max_flow_p;
                    in
                    Printf.printf "Maximum flow of the test path : %d\n "  max_flow_p;
  
  
  (* ***************************************  *)
  
  let final_graph = convert_to_string_graph graph
  in*)
  
  (* **** TEST 4 main_algo **** *)
  (*let graph = open_and_initialize infile
  in
  let new_graph = main_algo graph id_start id_dest
  in
  let final_graph = convert_to_string_graph new_graph
  in
   
  (* Rewrite the graph that has been read. *)
  let () = write_file outfile final_graph in*)

  ()

