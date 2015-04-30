module Pci_dev : sig
  type t
  val vendor_id : t -> int
  val device_id : t -> int
  val device_class : t -> int
end

module Pci_access : sig
  type t
  val devices : t -> Pci_dev.t list
end

val pci_alloc : unit -> Pci_access.t
val pci_init : Pci_access.t -> unit
val pci_cleanup : Pci_access.t -> unit
val pci_scan_bus : Pci_access.t -> unit
