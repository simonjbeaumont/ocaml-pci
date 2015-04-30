module Pci_dev : sig
  type t
  val domain : t -> int
  val bus : t -> int
  val dev : t -> int
  val func : t -> int
  val vendor_id : t -> int
  val device_id : t -> int
  val device_class : t -> int
  val irq : t -> int
  val base_addr : t -> nativeint list
end

module Pci_access : sig
  type t
  val devices : t -> Pci_dev.t list
end

type pci_fill_flag =
  | PCI_FILL_IDENT
  | PCI_FILL_IRQ
  | PCI_FILL_BASES
  | PCI_FILL_ROM_BASE
  | PCI_FILL_SIZES
  | PCI_FILL_CLASS
  | PCI_FILL_CAPS
  | PCI_FILL_EXT_CAPS
  | PCI_FILL_PHYS_SLOT
  | PCI_FILL_MODULE_ALIAS
  | PCI_FILL_RESCAN

val pci_alloc : unit -> Pci_access.t
val pci_init : Pci_access.t -> unit
val pci_cleanup : Pci_access.t -> unit
val pci_scan_bus : Pci_access.t -> unit
val pci_fill_info : Pci_dev.t -> pci_fill_flag list -> int
val pci_read_byte : Pci_dev.t -> int -> int
