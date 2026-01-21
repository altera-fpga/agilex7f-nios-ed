# Copyright (C) 2025  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and any partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the Intel FPGA Software License Subscription Agreements 
# on the Quartus Prime software download page.

# Quartus Prime: Generate Tcl File for Project
# File: niosv_tinyml.tcl
# Generated on: Tue Jan  7 03:42:57 2025

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "niosv_tinyml"]} {
		puts "Project niosv_tinyml is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists niosv_tinyml]} {
		project_open -revision niosv_tinyml niosv_tinyml
	} else {
		project_new -revision niosv_tinyml niosv_tinyml
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name TOP_LEVEL_ENTITY sys
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 24.2.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "09:54:27  JULY 19, 2024"
	set_global_assignment -name LAST_QUARTUS_VERSION "25.1.0 Pro Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name FAMILY "Agilex 7"
	set_global_assignment -name DEVICE AGFB014R24B2E2V
	set_global_assignment -name BOARD "Agilex 7 FPGA F-Series Development Kit P-Tile and E-Tile DK-DEV-AGF014EA"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
	set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
	set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-13"
	set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "ACTIVE SERIAL X4"
	set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 47
	set_global_assignment -name PWRMGT_SLAVE_DEVICE1_ADDRESS 00
	set_global_assignment -name PWRMGT_SLAVE_DEVICE2_ADDRESS 00
	set_global_assignment -name ACTIVE_SERIAL_CLOCK AS_FREQ_100MHZ
	set_global_assignment -name USE_PWRMGT_SCL SDM_IO14
	set_global_assignment -name USE_PWRMGT_SDA SDM_IO11
	set_global_assignment -name USE_CONF_DONE SDM_IO16
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
	set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE OFF
	set_global_assignment -name POWER_APPLY_THERMAL_MARGIN ADDITIONAL
	set_global_assignment -name NUMBER_OF_SLAVE_DEVICE 1
	set_global_assignment -name SDC_FILE top.sdc
	set_global_assignment -name IP_FILE ip/sys/sys_clock_in.ip
	set_global_assignment -name QSYS_FILE sys.qsys
	set_global_assignment -name IP_FILE ip/sys/sys_intel_niosv_g_0.ip
	set_global_assignment -name IP_FILE ip/sys/sys_intel_onchip_memory_0.ip
	set_global_assignment -name IP_FILE ip/sys/sys_jtag_uart_0.ip
	set_global_assignment -name IP_FILE ip/sys/sys_sysid_qsys_0.ip
	set_global_assignment -name IP_FILE ip/sys/sys_iopll_0.ip
	set_global_assignment -name IP_FILE ip/sys/sys_s10_user_rst_clkgate_0.ip

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
