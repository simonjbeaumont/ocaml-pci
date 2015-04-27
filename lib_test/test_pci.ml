open Pci

let _ =
  let pci_access = pci_alloc () in
  pci_init pci_access;
  pci_scan_bus pci_access
