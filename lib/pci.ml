open Ctypes

module B = Pci_bindings.Bindings(Pci_generated)

module Pci_dev = struct
  type t = B.Pci_dev.t
  let vendor_id t = getf !@t B.Pci_dev.vendor_id |> Unsigned.UInt16.to_int
  let device_id t = getf !@t B.Pci_dev.device_id |> Unsigned.UInt16.to_int
  let device_class t = getf !@t B.Pci_dev.device_class |> Unsigned.UInt16.to_int
  let vendor_id t = getf !@t B.Pci_dev.vendor_id |> Unsigned.UInt16.to_int
end

module Pci_access = struct
  type t = B.Pci_access.t

  let devices t =
    let rec list_of_linked_list acc = function
    | None -> acc
    | Some d -> list_of_linked_list (d::acc) (getf !@d B.Pci_dev.next) in
    list_of_linked_list [] (getf !@t B.Pci_access.devices)
end

let pci_alloc = B.pci_alloc
let pci_init = B.pci_init
let pci_cleanup = B.pci_cleanup
let pci_scan_bus = B.pci_scan_bus
