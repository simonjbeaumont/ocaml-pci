module Pci_dev : sig
  type t
  type base_class =
    | NOT_DEFINED
    | STORAGE
    | NETWORK
    | DISPLAY
    | MULTIMEDIA
    | MEMORY
    | BRIDGE
    | COMMUNICATION
    | SYSTEM
    | INPUT
    | DOCKING
    | PROCESSOR
    | SERIAL
    | WIRELESS
    | INTELLIGENT
    | SATELLITE
    | CRYPT
    | SIGNAL
    | OTHERS
end

  val domain : t -> int
  val bus : t -> int
  val dev : t -> int
  val func : t -> int
  val vendor_id : t -> int
  val device_id : t -> int
  val device_class : t -> int
  val irq : t -> int
  val base_addr : t -> nativeint list
  val size : t -> nativeint list
end

module Pci_access : sig
  type t
  val devices : t -> Pci_dev.t list
end

type fill_flag =
  | FILL_IDENT
  | FILL_IRQ
  | FILL_BASES
  | FILL_ROM_BASE
  | FILL_SIZES
  | FILL_CLASS
  | FILL_CAPS
  | FILL_EXT_CAPS
  | FILL_PHYS_SLOT
  | FILL_MODULE_ALIAS
  | FILL_RESCAN

val alloc : unit -> Pci_access.t
val init : Pci_access.t -> unit
val cleanup : Pci_access.t -> unit
val scan_bus : Pci_access.t -> unit
val fill_info : Pci_dev.t -> fill_flag list -> int
val read_byte : Pci_dev.t -> int -> int
val lookup_class_name : Pci_access.t -> int -> string
val lookup_progif_name : Pci_access.t -> int -> int -> string
val lookup_vendor_name : Pci_access.t -> int -> string
val lookup_device_name : Pci_access.t -> int -> int -> string
val lookup_subsystem_name : Pci_access.t -> int -> int -> int -> int -> string
