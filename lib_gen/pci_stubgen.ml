open Pci_bindings

let _ =
  let ml_out = open_out "lib/pci_generated.ml" in
  let c_out = open_out "lib/pci_stubs.c" in
  let c_fmt = Format.formatter_of_out_channel c_out in
  let ml_fmt = Format.formatter_of_out_channel ml_out in
  Format.fprintf c_fmt "#include <pci/pci.h>@.";
  Cstubs.write_c c_fmt ~prefix:"libpci_stub_" (module Bindings);
  Cstubs.write_ml ml_fmt ~prefix:"libpci_stub_" (module Bindings);
