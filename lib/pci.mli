module Pci_dev : sig
  type t = {
    domain : int;
    bus : int;
    dev : int;
    func : int;
    vendor_id : int;
    device_id : int;
    device_class : int;
    irq : int;
    base_addr : nativeint list;
    size : nativeint list;
    phy_slot : string option;
    subsystem_id : (int * int) option;
  }
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
