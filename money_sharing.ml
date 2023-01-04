open Tools
open Ff_algo
open Msharfile

type person = (string*int);;

let () =

  (* Check the number of command-line arguments *)
  let nb_arguments = Array.length Sys.argv
  in
  if nb_arguments < 2 || nb_arguments > 3 then
    begin
      Printf.printf
        "\n ✻  Usage: %s infile infile outfile(optional)\n\n%s%!" Sys.argv.(0)
        ("             🟄  infile  : input file containing the names and the expenses of eachone (one name followed by the expenses per line)\n" ^
         "    OPTIONAL 🟄 outfile : output file in which the resulted graph should be written.\n\n") ;
      exit 0
    end ;


  (* Arguments are : infile(1) outfile(2) (outfile is optional so used or not at the end *)
  
  let infile = Sys.argv.(1)
    
  in
  
  (* Read and print the names and the total of the expenses for each person from the file *)
  let (names, expenses) = from_file infile
  in
  
  (* Compute the difference between what everyone paid and what they should have paid *)
  let diff_expenses = compute_diff expenses
  in
  
  (* Create the initial graph using the diff_expenses list *)
  let graph = create_start_graph diff_expenses
  in
  
  (* Apply the Ford-Fulkerson algorithm (the node 0 is alsways define as the start and 1 as the end *)
  let new_graph = main_algo graph 0 1
  in
  
  (* Read and print the results from the graph *)
  let () = print_results new_graph names
  in
  
  (* Just for debugging : convert the final graph to a string graph and write in the outputfile *)
  if nb_arguments = 3 then let outfile = Sys.argv.(2) in let () = write_file outfile (convert_to_string_graph new_graph) in () else ()
  
