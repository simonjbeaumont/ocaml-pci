open Ctypes

module Bindings (F : Cstubs.FOREIGN) = struct
  open F

  type pci_cap
  let pci_cap : pci_cap structure typ = structure "pci_cap"
  let next = field pci_cap "next" (ptr pci_cap)
  let id = field pci_cap "id" uint16_t
  let type_ = field pci_cap "type" uint16_t
  let addr = field pci_cap "addr" int
  let () = seal pci_cap

  type pci_dev
  let pci_dev : pci_dev structure typ = structure "pci_dev"
  let next = field pci_dev "next" (ptr pci_dev)
  let domain = field pci_dev "domain" uint16_t
  let bus = field pci_dev "bus" uint8_t
  let dev = field pci_dev "dev" uint8_t
  let func = field pci_dev "func" uint8_t
  let known_fields = field pci_dev "known_fields" int
  let vendor_id = field pci_dev "vendor_id" uint16_t
  let device_id = field pci_dev "device_id" uint16_t
  let device_class = field pci_dev "device_class" uint16_t
  let irq = field pci_dev "irq" int
  let pciaddr_t = nativeint (* TODO: this is derived at compile time in pci/types.h... *)
  let base_addr = field pci_dev "base_addr" (array 6 pciaddr_t)
  let size = field pci_dev "size" (array 6 pciaddr_t)
  let rom_base_addr = field pci_dev "rom_base_addr" pciaddr_t
  let rom_size = field pci_dev "rom_size" pciaddr_t
  let first_cap = field pci_dev "first_cap" (ptr pci_cap)
  let phy_slot = field pci_dev "phy_slot" string
  let module_alias = field pci_dev "module_alias" string
  (* Fields used internally *)
  let access = field pci_dev "access" (ptr void)
  let methods = field pci_dev "methods" (ptr void)
  let cache = field pci_dev "cache" (ptr uint8_t)
  let cache_len = field pci_dev "cache_len" int
  let hdrtype = field pci_dev "hdrtype" int
  let aux = field pci_dev "aux" (ptr void)
  let () = seal pci_dev

  type pci_param = unit ptr
  let pci_param : pci_param typ = ptr void

  type pci_filter
  let pci_filter : pci_filter structure typ = structure "pci_filter"
  let domain = field pci_filter "domain" int
  let bus = field pci_filter "bus" int
  let slot = field pci_filter "slot" int
  let func = field pci_filter "func" int
  let vendor = field pci_filter "vendor" int
  let device = field pci_filter "device" int
  let () = seal pci_filter

  type pci_access
  let pci_access : pci_access structure typ = structure "pci_access"
  let method_ = field pci_access "method" uint
  let writeable = field pci_access "writeable" int
  let buscentric = field pci_access "buscentric" int
  let id_file_name = field pci_access "id_file_name" string
  let free_id_name = field pci_access "free_id_name" int
  let numeric_ids = field pci_access "numeric_ids" int
  let lookup_mode = field pci_access "lookup_mode" uint
  let debugging = field pci_access "debugging" int
  let error = field pci_access "error" (ptr void)
  let warning = field pci_access "warning" (ptr void)
  let debug = field pci_access "debug" (ptr void)
  let devices = field pci_access "devices" (ptr pci_dev)
  (* Fields used internally *)
  let methods = field pci_access "methods" (ptr void)
  let params = field pci_access "params" (ptr void)
  let id_hash = field pci_access "id_hash" (ptr (ptr void))
  let current_id_bucket = field pci_access "current_id_bucket" (ptr void)
  let id_load_failed = field pci_access "id_load_failed" int
  let id_cache_status = field pci_access "id_cache_status" int
  let fd = field pci_access "fd" int
  let fd_rw = field pci_access "fd_rw" int
  let fd_pos = field pci_access "fd_pos" int
  let fd_vpd = field pci_access "fd_vpd" int
  let cached_dev = field pci_access "cached_dev" (ptr pci_dev)
  let () = seal pci_access

  let pci_alloc =
    foreign "pci_alloc" (void @-> returning (ptr pci_access))

  let pci_init =
    foreign "pci_init" (ptr pci_access @-> returning void)

  let pci_cleanup =
    foreign "pci_cleanup" (ptr pci_access @-> returning void)

  let pci_scan_bus =
    foreign "pci_scan_bus" (ptr pci_access @-> returning void)

  let pci_get_dev =
    foreign "pci_get_dev" (ptr pci_access @-> int @-> int @-> int @-> int @-> returning (ptr pci_dev))

  let pci_free_dev =
    foreign "pci_free_dev" (ptr pci_dev @-> returning void)

  let pci_lookup_method =
    foreign "pci_lookup_method" (string @-> returning int)

  let pci_get_method_name =
    foreign "pci_get_method_name" (int @-> returning string)

  let pci_get_param =
    foreign "pci_get_param" (ptr pci_access @-> string @-> returning string)

  let pci_set_param =
    foreign "pci_set_param" (ptr pci_access @-> string @-> string @-> returning int)

  let pci_walk_params =
    foreign "pci_walk_params" (ptr pci_access @-> pci_param @-> returning pci_param)

  let pci_read_byte =
    foreign "pci_read_byte" (ptr pci_dev @-> int @-> returning uint8_t)

  let pci_read_word =
    foreign "pci_read_word" (ptr pci_dev @-> int @-> returning uint16_t)

  let pci_read_long =
    foreign "pci_read_long" (ptr pci_dev @-> int @-> returning uint32_t)

  let pci_read_block =
    foreign "pci_read_block" (ptr pci_dev @-> int @-> ptr uint8_t @-> int @-> returning int)

  let pci_read_vpd =
    foreign "pci_read_vpd" (ptr pci_dev @-> int @-> ptr uint8_t @-> int @-> returning int)

  let pci_write_byte =
    foreign "pci_write_byte" (ptr pci_dev @-> int @-> uint8_t @-> returning int)

  let pci_write_long =
    foreign "pci_write_long" (ptr pci_dev @-> int @-> uint16_t @-> returning int)

  let pci_write_block =
    foreign "pci_write_block" (ptr pci_dev @-> int @-> ptr uint8_t @-> int @-> returning int)

  let pci_fill_info =
    foreign "pci_fill_info" (ptr pci_dev @-> int @-> returning int)

  let pCI_FILL_IDENT = 1
    (* foreign "PCI_FILL_IDENT" constant 1 *)

  let pci_setup_cache =
    foreign "pci_setup_cache" (ptr pci_dev @-> ptr uint8_t @-> int @-> returning void)

  let pci_find_cap =
    foreign "pci_find_cap" (ptr pci_dev @-> uint @-> uint @-> returning (ptr pci_cap))

  let pci_filter_init =
    foreign "pci_filter_init" (ptr pci_access @-> ptr pci_filter @-> returning void)

  let pci_filter_parse_slot =
    foreign "pci_filter_parse_slot" (ptr pci_filter @-> string @-> returning string)

  let pci_filter_parse_id =
    foreign "pci_filter_parse_id" (ptr pci_filter @-> string @-> returning string)

  let pci_filter_match =
    foreign "pci_filter_match" (ptr pci_filter @-> ptr pci_dev @-> returning int)

  let pci_lookup_name =
    foreign "pci_lookup_name" (ptr pci_access @-> string @-> int @-> int @-> returning string)

  let pci_load_name_list =
    foreign "pci_load_name_list" (ptr pci_access @-> returning int)

  let pci_free_name_list =
    foreign "pci_free_name_list" (ptr pci_access @-> returning void)

  let pci_set_name_list_path =
    foreign "pci_set_name_list_path" (ptr pci_access @-> string @-> int @-> returning void)

  let pci_id_cache_flush =
    foreign "pci_id_cache_flush" (ptr pci_access @-> returning void)
end
