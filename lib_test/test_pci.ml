open Pci


let _ =
  let pci_access = pci_alloc () in
  pci_init pci_access;
  pci_scan_bus pci_access;
  let devs = get_devices pci_access in
  List.iter (fun d -> Printf.printf "vendor_id = 0x%04x\n" (vendor_id d)) devs;
  pci_cleanup pci_access
