open Ctypes

module Bindings (F : Cstubs.FOREIGN) = struct
  open F

  module Pci_cap = struct
    type pci_cap
    let pci_cap : pci_cap structure typ = structure "pci_cap"
    let (-:) ty label = field pci_cap label ty
    let next = (ptr_opt pci_cap) -: "next"
    let id = uint16_t -: "id"
    let type_ = uint16_t -: "type" 
    let addr = int -: "addr" 
    let () = seal pci_cap

    type t = pci_cap structure ptr
    let t = ptr pci_cap
  end

  module Pci_dev = struct
    type pci_dev
    let pci_dev : pci_dev structure typ = structure "pci_dev"
    let (-:) ty label = field pci_dev label ty
    let next = (ptr_opt pci_dev) -: "next"
    let domain = uint16_t -: "domain"
    let bus = uint8_t -: "bus"
    let dev = uint8_t -: "dev"
    let func = uint8_t -: "func"
    let known_fields = int -: "known_fields"
    let vendor_id = uint16_t -: "vendor_id"
    let device_id = uint16_t -: "device_id"
    let device_class = uint16_t -: "device_class"
    let irq = int -: "irq"
    let pciaddr_t = nativeint (* TODO: this is derived at compile time in pci/types.h... *)
    let base_addr = (array 6 pciaddr_t) -: "base_addr"
    let size = (array 6 pciaddr_t) -: "size"
    let rom_base_addr = pciaddr_t -: "rom_base_addr"
    let rom_size = pciaddr_t -: "rom_size"
    let first_cap = Pci_cap.t -: "first_cap"
    let phy_slot = string -: "phy_slot"
    let module_alias = string -: "module_alias"
    (* Fields used internally *)
    let access = (ptr void) -: "access"
    let methods = (ptr void) -: "methods"
    let cache = (ptr uint8_t) -: "cache"
    let cache_len = int -: "cache_len"
    let hdrtype = int -: "hdrtype"
    let aux = (ptr void) -: "aux"
    let () = seal pci_dev

    type t = pci_dev structure ptr
    let t = ptr pci_dev
  end

  module Pci_param = struct
    type pci_param
    let pci_param : pci_param structure typ = structure "pci_param"
    let (-:) ty label = field pci_param label ty
    let next = ptr_opt pci_param -: "next"
    let param = string -: "param"
    let value = string -: "value"
    let value_malloced = int -: "value_malloced"
    let help = string -: "help"
    let () = seal pci_param

    type t = pci_param structure ptr
    let t = ptr pci_param
  end

  module Pci_filter = struct
    type pci_filter
    let pci_filter : pci_filter structure typ = structure "pci_filter"
    let (-:) ty label = field pci_filter label ty
    let domain = int -: "domain"
    let bus = int -: "bus"
    let slot = int -: "slot"
    let func = int -: "func"
    let vendor = int -: "vendor"
    let device = int -: "device"
    let () = seal pci_filter

    type t = pci_filter structure ptr
    let t = ptr pci_filter
  end

  module Pci_access = struct
    open Pci_dev
    type pci_access
    let pci_access : pci_access structure typ = structure "pci_access"
    let (-:) ty label = field pci_access label ty
    let method_ = uint -: "method"
    let writeable = int -: "writeable"
    let buscentric = int -: "buscentric"
    let id_file_name = string -: "id_file_name"
    let free_id_name = int -: "free_id_name"
    let numeric_ids = int -: "numeric_ids"
    let lookup_mode = uint -: "lookup_mode"
    let debugging = int -: "debugging"
    let error = (ptr void) -: "error"
    let warning = (ptr void) -: "warning"
    let debug = (ptr void) -: "debug"
    let devices = field pci_access "devices" (ptr_opt pci_dev)
    (* Fields used internally *)
    let methods = (ptr void) -: "methods"
    let params = (ptr void) -: "params"
    let id_hash = (ptr (ptr void)) -: "id_hash"
    let current_id_bucket = (ptr void) -: "current_id_bucket"
    let id_load_failed = int -: "id_load_failed"
    let id_cache_status = int -: "id_cache_status"
    let fd = int -: "fd"
    let fd_rw = int -: "fd_rw"
    let fd_pos = int -: "fd_pos"
    let fd_vpd = int -: "fd_vpd"
    let cached_dev = (ptr_opt pci_dev) -: "cached_dev"
    let () = seal pci_access

    type t = pci_access structure ptr
    let t = ptr pci_access
  end

  let pci_alloc =
    foreign "pci_alloc" (void @-> returning Pci_access.t)

  let pci_init =
    foreign "pci_init" (Pci_access.t @-> returning void)

  let pci_cleanup =
    foreign "pci_cleanup" (Pci_access.t @-> returning void)

  let pci_scan_bus =
    foreign "pci_scan_bus" (Pci_access.t @-> returning void)

  let pci_get_dev =
    foreign "pci_get_dev" (Pci_access.t @-> int @-> int @-> int @-> int @-> returning Pci_dev.t)

  let pci_free_dev =
    foreign "pci_free_dev" (Pci_dev.t @-> returning void)

  let pci_lookup_method =
    foreign "pci_lookup_method" (string @-> returning int)

  let pci_get_method_name =
    foreign "pci_get_method_name" (int @-> returning string)

  let pci_get_param =
    foreign "pci_get_param" (Pci_access.t @-> string @-> returning string)

  let pci_set_param =
    foreign "pci_set_param" (Pci_access.t @-> string @-> string @-> returning int)

  let pci_walk_params =
    foreign "pci_walk_params" (Pci_access.t @-> Pci_param.t @-> returning Pci_param.t)

  let pci_read_byte =
    foreign "pci_read_byte" (Pci_dev.t @-> int @-> returning uint8_t)

  let pci_read_word =
    foreign "pci_read_word" (Pci_dev.t @-> int @-> returning uint16_t)

  let pci_read_long =
    foreign "pci_read_long" (Pci_dev.t @-> int @-> returning uint32_t)

  let pci_read_block =
    foreign "pci_read_block" (Pci_dev.t @-> int @-> ptr uint8_t @-> int @-> returning int)

  let pci_read_vpd =
    foreign "pci_read_vpd" (Pci_dev.t @-> int @-> ptr uint8_t @-> int @-> returning int)

  let pci_write_byte =
    foreign "pci_write_byte" (Pci_dev.t @-> int @-> uint8_t @-> returning int)

  let pci_write_long =
    foreign "pci_write_long" (Pci_dev.t @-> int @-> uint16_t @-> returning int)

  let pci_write_block =
    foreign "pci_write_block" (Pci_dev.t @-> int @-> ptr uint8_t @-> int @-> returning int)

  let pci_fill_info =
    foreign "pci_fill_info" (Pci_dev.t @-> int @-> returning int)

  let pCI_FILL_IDENT = 1
    (* foreign "PCI_FILL_IDENT" constant 1 *)

  let pci_setup_cache =
    foreign "pci_setup_cache" (Pci_dev.t @-> ptr uint8_t @-> int @-> returning void)

  let pci_find_cap =
    foreign "pci_find_cap" (Pci_dev.t @-> uint @-> uint @-> returning Pci_cap.t)

  let pci_filter_init =
    foreign "pci_filter_init" (Pci_access.t @-> Pci_filter.t @-> returning void)

  let pci_filter_parse_slot =
    foreign "pci_filter_parse_slot" (Pci_filter.t @-> string @-> returning string)

  let pci_filter_parse_id =
    foreign "pci_filter_parse_id" (Pci_filter.t @-> string @-> returning string)

  let pci_filter_match =
    foreign "pci_filter_match" (Pci_filter.t @-> Pci_dev.t @-> returning int)

  let pci_lookup_name_1_ary =
    foreign "pci_lookup_name" (Pci_access.t @-> string @-> int @-> int @-> int @-> returning string)

  let pci_lookup_name_2_ary =
    foreign "pci_lookup_name" (Pci_access.t @-> string @-> int @-> int @-> int @-> int @-> returning string)

  let pci_load_name_list =
    foreign "pci_load_name_list" (Pci_access.t @-> returning int)

  let pci_free_name_list =
    foreign "pci_free_name_list" (Pci_access.t @-> returning void)

  let pci_set_name_list_path =
    foreign "pci_set_name_list_path" (Pci_access.t @-> string @-> int @-> returning void)

  let pci_id_cache_flush =
    foreign "pci_id_cache_flush" (Pci_access.t @-> returning void)
end
