open OUnit
open Pci

let vm_size () =
  let stream_of_channel ic =
    Stream.from (fun _ -> try Some (input_line ic) with End_of_file -> None) in
  let smaps_path = List.fold_left Filename.concat "/"
    [ "proc"; Unix.getpid () |> string_of_int; "status" ] in
  let rec list_of_stream acc s =
    try list_of_stream (Stream.next s::acc) s
    with Stream.Failure -> List.rev acc in
  let lines = open_in smaps_path |> stream_of_channel |> list_of_stream [] in
  let size_line = List.find (fun line -> Str.(string_match (regexp "VmSize:") line 0)) lines in
  let size_kb = List.nth (Str.(split (regexp "\ +")) size_line) 1 in
  int_of_string size_kb


let smoke_test () =
  with_access (fun _ -> ())

let test_with_access_cleanup () =
  (* Get overhead for calling the fuction and the measuremnt functions *)
  let _ = Gc.compact (); vm_size () in
  for i = 1 to 1000 do with_access ~cleanup:true (fun _ -> ()) done;
  let mem = Gc.compact (); vm_size () in
  (* The incremental cost of calling with_access should be 0 *)
  for i = 1 to 1000 do with_access ~cleanup:true (fun _ -> ()) done;
  let mem' = Gc.compact (); vm_size () in
  assert_equal ~printer:(Printf.sprintf "VmSize = %d kB") mem mem';
  (* Checking for a difference with cleanup=false as a negative test *)
  for i = 1 to 1000 do with_access ~cleanup:false (fun _ -> ()) done;
  let mem'' = Gc.compact (); vm_size () in
  assert_raises (OUnitTest.OUnit_failure "not equal") (fun () ->
    assert_equal mem' mem'')

let _ =
  let suite = "pci" >:::
    [
      "smoke_test" >:: smoke_test;
      "test_with_access_cleanup" >:: test_with_access_cleanup;
    ]
  in
  run_test_tt suite
