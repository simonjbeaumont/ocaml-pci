open Pci

let _ =
  let open Ctypes in
  let pci_access = pci_alloc () in
  pci_init pci_access;
  pci_scan_bus pci_access;
  let ifn = getf (!@ pci_access) id_file_name in
  Printf.printf "pci_access->id_file_name = \"%s\"\n" ifn;
  let d = getf (!@ pci_access) devices in
  let vid = getf (!@ d) vendor_id in
  Printf.printf "d->vendor_id = 0x%04x\n" @@ Unsigned.UInt16.to_int vid;
  pci_fill_info d 1;
  pci_cleanup pci_access
