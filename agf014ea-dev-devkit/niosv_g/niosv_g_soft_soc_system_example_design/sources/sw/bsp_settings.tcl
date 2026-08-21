# Remove existing memory regions and section mappings
foreach region_info [get_current_memory_regions] {
    delete_memory_region [lindex $region_info 0]
}

foreach mapping_info [get_current_section_mappings] {
    delete_section_mapping [lindex $mapping_info 0]
}

# Settings
set_setting altera_avalon_jtag_uart_driver.enable_jtag_uart_ignore_fifo_full_error {false}
set_setting altera_avalon_jtag_uart_driver.enable_small_driver {false}
set_setting altera_s10_mailbox_client.rsu.enable_rsu {false}
set_setting altera_s10_mailbox_client.rsu.enable_spt_checksum {false}
set_setting altera_s10_mailbox_client.rsu.fpga_device.Stratix10 {false}
set_setting altera_s10_mailbox_client.rsu.rsu_log_level {3}
set_setting altera_s10_mailbox_client.rsu.rsu_protected_slot {-1}
set_setting hal.dfl_start_address {-1}
set_setting hal.enable_c_plus_plus {true}
set_setting hal.enable_clean_exit {true}
set_setting hal.enable_exit {true}
set_setting hal.enable_instruction_related_exceptions_api {false}
set_setting hal.enable_lightweight_device_driver_api {false}
set_setting hal.enable_reduced_device_drivers {false}
set_setting hal.enable_runtime_stack_checking {false}
set_setting hal.enable_sim_optimize {false}
set_setting hal.linker.allow_code_at_reset {true}
set_setting hal.linker.enable_alt_load {true}
set_setting hal.linker.enable_alt_load_copy_exceptions {false}
set_setting hal.linker.enable_alt_load_copy_rodata {true}
set_setting hal.linker.enable_alt_load_copy_rwdata {true}
set_setting hal.linker.enable_exception_stack {false}
set_setting hal.linker.exception_stack_memory_region_name {emif_fm_0_emif_fm_0_arch}
set_setting hal.linker.exception_stack_size {1024}
set_setting hal.linker.use_picolibc {false}
set_setting hal.log_flags {0}
set_setting hal.log_port {none}
set_setting hal.make.asflags {-Wa,-gdwarf2}
set_setting hal.make.cflags_debug {-g}
set_setting hal.make.cflags_defined_symbols {none}
set_setting hal.make.cflags_optimization {-O2}
set_setting hal.make.cflags_undefined_symbols {none}
set_setting hal.make.cflags_user_flags {none}
set_setting hal.make.cflags_warnings {-Wall -Wformat-security}
set_setting hal.make.cxx_flags {none}
set_setting hal.make.enable_cflag_fstack_protector_strong {true}
set_setting hal.make.enable_cflag_wformat_security {true}
set_setting hal.make.link_flags {none}
set_setting hal.make.objdump_flags {-Sdtx}
set_setting hal.max_file_descriptors {32}
set_setting hal.stderr {jtag_uart_0}
set_setting hal.stdin {jtag_uart_0}
set_setting hal.stdout {jtag_uart_0}
set_setting hal.sys_clk_timer {intel_niosv_g_0}
set_setting hal.timestamp_timer {intel_niosv_g_0}
set_setting hal.toolchain.ar {riscv32-unknown-elf-ar}
set_setting hal.toolchain.as {riscv32-unknown-elf-gcc}
set_setting hal.toolchain.cc {riscv32-unknown-elf-gcc}
set_setting hal.toolchain.cxx {riscv32-unknown-elf-g++}
set_setting hal.toolchain.enable_executable_overrides {false}
set_setting hal.toolchain.objdump {riscv32-unknown-elf-objdump}
set_setting hal.toolchain.prefix {riscv32-unknown-elf-}
set_setting hal.use_dfl_walker {false}
set_setting intel_niosv_g_hal_driver.internal_timer_ticks_per_sec {1000}

# Software packages

# Drivers
set_driver intel_niosv_g_hal_driver intel_niosv_g_0
set_driver altera_s10_mailbox_client s10_mailbox_client_0
set_driver altera_msgdma_driver msgdma_0
set_driver altera_avalon_jtag_uart_driver jtag_uart_0
set_driver altera_avalon_pio_driver pio_1
set_driver altera_avalon_i2c_driver i2c_0
set_driver altera_avalon_spi_driver spi_0
set_driver altera_avalon_timer_driver timer_0
set_driver altera_avalon_pio_driver pio_0
set_driver altera_avalon_sysid_qsys_driver sysid_qsys_0

# User devices

# Linker memory regions
add_memory_region reset ocm_boot_niosv 0 32
add_memory_region ocm_boot_niosv ocm_boot_niosv 32 524256
add_memory_region ocm_write_dma_read ocm_write_dma_read 0 1048576
add_memory_region ocm_read_dma_write ocm_read_dma_write 0 1048576
add_memory_region emif_fm_0_emif_fm_0_arch emif_fm_0_emif_fm_0_arch 0 2147483648

# Linker section mappings
add_section_mapping .text ocm_boot_niosv
add_section_mapping .exceptions ocm_boot_niosv
add_section_mapping .rodata ocm_boot_niosv
add_section_mapping .rwdata ocm_boot_niosv
add_section_mapping .bss ocm_boot_niosv
add_section_mapping .heap ocm_boot_niosv
add_section_mapping .stack ocm_boot_niosv
