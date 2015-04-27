open Ctypes

module Bindings (F : Cstubs.FOREIGN) = struct
  open F

  type pci_access = unit ptr
  let pci_access : pci_access typ = ptr void

  type pci_dev = unit ptr
  let pci_dev : pci_dev typ = ptr void

  type pci_param = unit ptr
  let pci_param : pci_param typ = ptr void

  type pci_cap = unit ptr
  let pci_cap : pci_cap typ = ptr void

  type pci_filter = unit ptr
  let pci_filter : pci_filter typ = ptr void

  let pci_alloc =
    foreign "pci_alloc" (void @-> returning pci_access)

  let pci_init =
    foreign "pci_init" (pci_access @-> returning void)

  let pci_cleanup =
    foreign "pci_cleanup" (pci_access @-> (returning void))

  let pci_scan_bus =
    foreign "pci_scan_bus" (pci_access @-> returning void)

  let pci_get_dev =
    foreign "pci_get_dev" (pci_access @-> int @-> int @-> int @-> int @-> returning pci_dev)

  let pci_free_dev =
    foreign "pci_free_dev" (pci_dev @-> returning void)

  let pci_lookup_method =
    foreign "pci_lookup_method" (string @-> returning int)

  let pci_get_method_name =
    foreign "pci_get_method_name" (int @-> returning string)

  let pci_get_param =
    foreign "pci_get_param" (pci_access @-> string @-> returning string)

  let pci_set_param =
    foreign "pci_set_param" (pci_access @-> string @-> string @-> returning int)

  let pci_walk_params =
    foreign "pci_walk_params" (pci_access @-> pci_param @-> returning pci_param)

  let pci_read_byte =
    foreign "pci_read_byte" (pci_dev @-> int @-> returning uint8_t)

  let pci_read_word =
    foreign "pci_read_word" (pci_dev @-> int @-> returning uint16_t)

  let pci_read_long =
    foreign "pci_read_long" (pci_dev @-> int @-> returning uint32_t)

  let pci_read_block =
    foreign "pci_read_block" (pci_dev @-> int @-> ptr uint8_t @-> int @-> returning int)

  let pci_read_vpd =
    foreign "pci_read_vpd" (pci_dev @-> int @-> ptr uint8_t @-> int @-> returning int)

  let pci_write_byte =
    foreign "pci_write_byte" (pci_dev @-> int @-> uint8_t @-> returning int)

  let pci_write_long =
    foreign "pci_write_long" (pci_dev @-> int @-> uint16_t @-> returning int)

  let pci_write_block =
    foreign "pci_write_block" (pci_dev @-> int @-> ptr uint8_t @-> int @-> returning int)

  let pci_setup_cache =
    foreign "pci_setup_cache" (pci_dev @-> ptr uint8_t @-> int @-> returning void)

  let pci_find_cap =
    foreign "pci_find_cap" (pci_dev @-> uint @-> uint @-> returning pci_cap)

  let pci_filter_init =
    foreign "pci_filter_init" (pci_access @-> pci_filter @-> returning void)

  let pci_filter_parse_slot =
    foreign "pci_filter_parse_slot" (pci_filter @-> string @-> returning string)

  let pci_filter_parse_id =
    foreign "pci_filter_parse_id" (pci_filter @-> string @-> returning string)

  let pci_filter_match =
    foreign "pci_filter_match" (pci_filter @-> pci_dev @-> returning int)

  let pci_lookup_name =
    foreign "pci_lookup_name" (pci_access @-> string @-> int @-> int @-> returning string)

  let pci_load_name_list =
    foreign "pci_load_name_list" (pci_access @-> returning int)

  let pci_free_name_list =
    foreign "pci_free_name_list" (pci_access @-> returning void)

  let pci_set_name_list_path =
    foreign "pci_set_name_list_path" (pci_access @-> string @-> int @-> returning void)

  let pci_id_cache_flush =
    foreign "pci_id_cache_flush" (pci_access @-> returning void)
end
