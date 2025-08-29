# Copyright (C) 2024  Intel Corporation. All rights reserved.
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
# File: quartus_ag.tcl
# Generated on: Wed Oct  9 06:53:48 2024

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "quartus_ag"]} {
		puts "Project quartus_ag is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists quartus_ag]} {
		project_open -revision quartus_ag quartus_ag
	} else {
		project_new -revision quartus_ag quartus_ag
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name TOP_LEVEL_ENTITY quartus_ag
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 23.3.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "16:01:32  NOVEMBER 09, 2023"
	set_global_assignment -name LAST_QUARTUS_VERSION "24.3.1 Pro Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
	set_global_assignment -name DEVICE AGFB014R24B2E2V
	set_global_assignment -name FAMILY "Agilex 7"
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
	set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
	set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-12"
	set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "AVST X32"
	set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
	set_global_assignment -name USE_PWRMGT_SDA SDM_IO12
	set_global_assignment -name USE_CONF_DONE SDM_IO16
	set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE LTC3888
	set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 28
	set_global_assignment -name ACTIVE_SERIAL_CLOCK AS_FREQ_115MHZ_IOSC
	set_global_assignment -name BOARD "Agilex 7 FPGA F-Series Development Kit P-Tile and E-Tile DK-DEV-AGF014EA"
	set_global_assignment -name IP_FILE ip/qsys_ag/qsys_ag_clock_in.ip
	set_global_assignment -name IP_FILE ip/qsys_ag/qsys_ag_reset_in.ip
	set_global_assignment -name QSYS_FILE qsys_ag.qsys
	set_global_assignment -name IP_FILE ip/qsys_ag/qsys_ag_onchip_memory2_0.ip
	set_global_assignment -name IP_FILE ip/qsys_ag/qsys_ag_jtag_uart_0.ip
	set_global_assignment -name IP_FILE ip/qsys_ag/qsys_ag_sysid_qsys_0.ip
	set_global_assignment -name VERILOG_FILE quartus_ag.v
	set_global_assignment -name IP_FILE ip/qsys_ag/qsys_ag_s10_user_rst_clkgate_1.ip
	set_global_assignment -name IP_FILE ip/qsys_ag/qsys_ag_timer_0.ip
	set_global_assignment -name IP_FILE ip/qsys_ag/qsys_ag_intel_niosv_g_0.ip
	# IOBANK_3A
	set_location_assignment PIN_U52 -to fpga_clk_100 -comment IOBANK_3A
	set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_clk_100 -entity quartus_ag
	# IOBANK_3A
	set_location_assignment PIN_G52 -to fpga_reset_reset -comment IOBANK_3A
	set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_reset_reset -entity quartus_ag

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
