# Copyright (C) 2022  Intel Corporation. All rights reserved.
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
# refer to the applicable agreement for further details, at
# https://fpgasoftware.intel.com/eula.

# Quartus Prime: Generate Tcl File for Project
# File: top.tcl
# Generated on: Tue Oct 18 04:36:18 2022

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "top"]} {
		puts "Project top is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists top]} {
		project_open -revision top top
	} else {
		project_new -revision top top
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name TOP_LEVEL_ENTITY top
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 22.4.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "03:54:49  OCTOBER 18, 2022"
	set_global_assignment -name LAST_QUARTUS_VERSION "22.4.0 Pro Edition"
	set_global_assignment -name VERILOG_FILE top.v
	set_global_assignment -name FAMILY "Arria 10"
	set_global_assignment -name DEVICE 10AS066N3F40E2SG
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name SDC_FILE jtag.sdc
	set_global_assignment -name SDC_FILE timing_constraints.sdc
	set_global_assignment -name QSYS_FILE sys.qsys
	set_global_assignment -name IP_FILE ip/sys/sys_125m_clk_bridge.ip
	set_global_assignment -name IP_FILE ip/sys/sys_clk_bridge.ip
	set_global_assignment -name IP_FILE ip/sys/sys_intel_niosv_m_4.ip
	set_global_assignment -name IP_FILE ip/sys/sys_cpu_ram.ip
	set_global_assignment -name IP_FILE ip/sys/sys_desc_mem.ip
	set_global_assignment -name IP_FILE ip/sys/sys_iopll.ip
	set_global_assignment -name IP_FILE ip/sys/sys_jtag_uart.ip
	set_global_assignment -name IP_FILE ip/sys/sys_rst_bridge.ip
	set_global_assignment -name IP_FILE ip/sys/sys_sysid.ip
	set_global_assignment -name IP_FILE ip/sys/sys_led_pio.ip
	set_global_assignment -name IP_FILE ip/sys/sys_tse.ip
	set_global_assignment -name IP_FILE ip/sys/sys_tse_msgdma_rx.ip
	set_global_assignment -name IP_FILE ip/sys/sys_tse_msgdma_tx.ip
	set_global_assignment -name IP_FILE ip/sys/sys_xcvr_atx_pll.ip
	set_location_assignment PIN_AN18 -to clk_50m_fpga
	set_location_assignment PIN_AG29 -to clk_enet_fpga_p
	set_location_assignment PIN_AR20 -to eneta_mdc
	set_location_assignment PIN_AV16 -to eneta_mdio
	set_location_assignment PIN_N1 -to eneta_resetn
	set_location_assignment PIN_N2 -to eneta_intn
	set_location_assignment PIN_AG33 -to eneta_rx_p
	set_location_assignment PIN_AK39 -to eneta_tx_p
	set_location_assignment PIN_AR23 -to user_led[0]
	set_location_assignment PIN_AR22 -to user_led[1]
	set_location_assignment PIN_AM21 -to user_led[2]
	set_location_assignment PIN_AL20 -to user_led[3]
	set_instance_assignment -name IO_STANDARD "1.8 V" -to clk_50m_fpga -entity top
	set_instance_assignment -name IO_STANDARD "1.8 V" -to dev_clrn -entity top
	set_instance_assignment -name IO_STANDARD "1.8 V" -to eneta_intn -entity top
	set_instance_assignment -name IO_STANDARD "1.8 V" -to eneta_resetn -entity top
	set_instance_assignment -name IO_STANDARD "1.8 V" -to eneta_mdc -entity top
	set_instance_assignment -name IO_STANDARD "1.8 V" -to eneta_mdio -entity top
	set_instance_assignment -name IO_STANDARD "1.8 V" -to user_led -entity top
	set_instance_assignment -name IO_STANDARD LVDS -to clk_enet_fpga_p -entity top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
