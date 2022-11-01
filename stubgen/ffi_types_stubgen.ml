let () =
  print_endline "#include <pci/pci.h>" ;
  Cstubs.Types.write_c Format.std_formatter
    (module Pci_bindings.Ffi_bindings.Types)
