open Ctypes

module Bindings (F : Cstubs.FOREIGN) = struct
  open F

  type pci_access = unit ptr
  let pci_access : pci_access typ = ptr void

  type pci_dev = unit ptr
  let pci_dev : pci_dev typ = ptr void

  let pci_alloc =
    foreign "pci_alloc" (void @-> returning pci_access)

  let pci_init =
    foreign "pci_init" (pci_access @-> returning void)

  let pci_scan_bus =
    foreign "pci_scan_bus" (pci_access @-> returning void)
end
