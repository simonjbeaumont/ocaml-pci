open Pci

let _ =
  let pci_access = alloc () in
  init pci_access;
  scan_bus pci_access;
  let devs = Pci_access.devices pci_access in
  List.iter (fun d ->
    let (_: int) = fill_info d [ FILL_IDENT; FILL_BASES; FILL_CLASS ] in
    let c = read_byte d 0x3d in
    let open Pci_dev in
    Printf.printf "%04x:%02x:%02x.%d vendor=%04x device=%04x class=%04x irq=%d (pin %d) base0=%nx"
      (domain d) (bus d) (dev d) (func d) (vendor_id d) (device_id d)
      (device_class d) (irq d) c (List.hd @@ base_addr d);
    let name = lookup_device_name pci_access (vendor_id d) (device_id d) in
    Printf.printf " (%s)\n" name
  ) devs;

  match devs with
  | [] -> ()
  | d::ds ->
      let open Pci_dev in
      Printf.printf "Getting region sizes for device %04x:%02x:%02x.%d\n"
        (domain d) (bus d) (dev d) (func d);
      List.iteri (fun i size ->
        Printf.printf "\tRegion %d has size %nd\n" i size
      ) (size d);

  cleanup pci_access
