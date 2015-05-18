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
  val size : t -> nativeint list
  val phy_slot : t -> string option
  val subsystem_id : t -> (int * int) option
end

module Pci_access : sig
  type t
end

val lookup_class_name : Pci_access.t -> int -> string
val lookup_progif_name : Pci_access.t -> int -> int -> string
val lookup_vendor_name : Pci_access.t -> int -> string
val lookup_device_name : Pci_access.t -> int -> int -> string
val lookup_subsystem_vendor_name : Pci_access.t -> int -> string
val lookup_subsystem_device_name : Pci_access.t -> int -> int -> int -> int -> string

val with_access : ?cleanup:bool -> (Pci_access.t -> 'a) -> 'a
val get_devices : Pci_access.t -> Pci_dev.t list
