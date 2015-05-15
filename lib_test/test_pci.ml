open OUnit
open Pci

let smoke_test () =
  with_access (fun _ -> ())

let _ =
  let suite = "pci" >:::
    [
      "smoke_test" >:: smoke_test;
    ]
  in
  run_test_tt suite
