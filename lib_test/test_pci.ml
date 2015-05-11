open Pci

(* This should be equivalent to `lspci -nnnDv` *)
let _ =
  let pci_access = alloc () in
  init pci_access;
  scan_bus pci_access;
  let devs = Pci_access.devices pci_access in
  List.iter (fun d ->
    let fill_flags = [ FILL_IDENT; FILL_CLASS; FILL_BASES; FILL_SIZES; FILL_PHYS_SLOT ] in
    let (_: int) = fill_info d fill_flags in
    let open Pci_dev in
    Printf.printf "Device: %04x:%02x:%02x.%d\n"
      (domain d) (bus d) (dev d) (func d);
    Printf.printf "Class:  %s [%04x]\n"
      (lookup_class_name pci_access (device_class d)) (device_class d);
    Printf.printf "Vendor: %s [%04x]\n"
      (lookup_vendor_name pci_access (vendor_id d)) (vendor_id d);
    Printf.printf "Device: %s [%04x]\n"
      (lookup_device_name pci_access (vendor_id d) (device_id d)) (device_id d);
    begin match subsystem_id d with
    | Some (sv_id, sd_id) ->
      Printf.printf "SVendor:\t%s [%04x]\n"
        (lookup_vendor_name pci_access sv_id) sv_id;
      Printf.printf "SDevice:\t%s [%04x]\n"
        (lookup_subsystem_name pci_access (vendor_id d) (device_id d) sv_id sd_id) sd_id
    | None -> ()
    end;
    begin match phy_slot d with
    | Some slot -> Printf.printf "PhySlot:\t%s\n" slot
    | None -> ()
    end;
    print_endline ""
  ) devs;

  begin match devs with
  | [] -> ()
  | d::ds ->
    let open Pci_dev in
    Printf.printf "Getting region sizes for device %04x:%02x:%02x.%d\n"
      (domain d) (bus d) (dev d) (func d);
    List.iteri (fun i size ->
      Printf.printf "\tRegion %d has size %nd\n" i size
    ) (size d)
  end;

  cleanup pci_access
