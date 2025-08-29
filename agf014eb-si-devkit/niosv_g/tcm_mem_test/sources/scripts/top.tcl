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
# File: top.tcl
# Generated on: Tue Oct 22 05:39:14 2024

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
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 23.3.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "08:11:53  DECEMBER 26, 2023"
	set_global_assignment -name LAST_QUARTUS_VERSION "24.3.1 Pro Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
	set_global_assignment -name DEVICE AGFB014R24B2E2V
	set_global_assignment -name FAMILY "Agilex 7"
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
	set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "AVST X32"
	set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
	set_global_assignment -name USE_PWRMGT_SDA SDM_IO12
	set_global_assignment -name USE_CONF_DONE SDM_IO16
	set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE LTC3888
	set_global_assignment -name ENABLE_STATUS_BYTE OFF
	set_global_assignment -name ACTIVE_SERIAL_CLOCK AS_FREQ_115MHZ_IOSC
	set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
	set_global_assignment -name PWRMGT_PAGE_COMMAND_PAYLOAD 0
	set_global_assignment -name GENERATE_PR_RBF_FILE ON
	set_global_assignment -name ENABLE_ED_CRC_CHECK ON
	set_global_assignment -name MINIMUM_SEU_INTERVAL 0
	set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 28
	set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
	set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-12"
	set_global_assignment -name DEVICE_INITIALIZATION_CLOCK INIT_INTOSC
	set_global_assignment -name IP_FILE ip/ag_qsys/ag_qsys_clock_in.ip
	set_global_assignment -name IP_FILE ip/ag_qsys/ag_qsys_reset_in.ip
	set_global_assignment -name QSYS_FILE ag_qsys.qsys
	set_global_assignment -name IP_FILE ip/ag_qsys/ag_qsys_jtag_uart_0.ip
	set_global_assignment -name VERILOG_FILE top.v
	set_global_assignment -name IP_FILE ip/ag_qsys/ag_qsys_s10_user_rst_clkgate_0.ip
	set_global_assignment -name IP_FILE ip/ag_qsys/ag_qsys_sysid_qsys_0.ip
	set_global_assignment -name IP_FILE ip/ag_qsys/ag_qsys_intel_niosv_g_1.ip
	set_global_assignment -name IP_FILE ip/ag_qsys/ag_qsys_onchip_memory2_0.ip
	set_global_assignment -name IP_FILE ip/ag_qsys/ag_qsys_onchip_memory2_1.ip
	set_global_assignment -name IP_FILE ip/ag_qsys/ag_qsys_performance_counter_0.ip
	set_global_assignment -name IP_FILE ip/ag_qsys/ag_qsys_timer_0.ip
	set_global_assignment -name IP_FILE ip/ag_qsys/ag_qsys_emif_fm_0.ip
	set_global_assignment -name IP_FILE ip/ag_qsys/ag_qsys_emif_cal_0.ip
	set_global_assignment -name VERILOG_FILE reset_release.v
	set_global_assignment -name IP_FILE ip/ag_qsys/ag_qsys_onchip_memory2_3.ip
	set_global_assignment -name BOARD default
	set_location_assignment PIN_U52 -to fpga_clk_100
	set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_clk_100 -entity top
	set_location_assignment PIN_G52 -to fpga_reset_reset
	set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_reset_reset -entity top
	set_location_assignment PIN_T17 -to ddr4_emif_mem_mem_a[0]
	set_location_assignment PIN_V17 -to ddr4_emif_mem_mem_a[1]
	set_location_assignment PIN_U16 -to ddr4_emif_mem_mem_a[2]
	set_location_assignment PIN_W16 -to ddr4_emif_mem_mem_a[3]
	set_location_assignment PIN_T15 -to ddr4_emif_mem_mem_a[4]
	set_location_assignment PIN_V15 -to ddr4_emif_mem_mem_a[5]
	set_location_assignment PIN_U14 -to ddr4_emif_mem_mem_a[6]
	set_location_assignment PIN_W14 -to ddr4_emif_mem_mem_a[7]
	set_location_assignment PIN_T13 -to ddr4_emif_mem_mem_a[8]
	set_location_assignment PIN_V13 -to ddr4_emif_mem_mem_a[9]
	set_location_assignment PIN_U12 -to ddr4_emif_mem_mem_a[10]
	set_location_assignment PIN_W12 -to ddr4_emif_mem_mem_a[11]
	set_location_assignment PIN_P9 -to ddr4_emif_mem_mem_a[12]
	set_location_assignment PIN_L8 -to ddr4_emif_mem_mem_a[13]
	set_location_assignment PIN_N8 -to ddr4_emif_mem_mem_a[14]
	set_location_assignment PIN_M7 -to ddr4_emif_mem_mem_a[15]
	set_location_assignment PIN_P7 -to ddr4_emif_mem_mem_a[16]
	set_location_assignment PIN_N16 -to ddr4_emif_mem_mem_act_n
	set_location_assignment PIN_L6 -to ddr4_emif_mem_mem_alert_n
	set_location_assignment PIN_N6 -to ddr4_emif_mem_mem_ba[0]
	set_location_assignment PIN_M5 -to ddr4_emif_mem_mem_ba[1]
	set_location_assignment PIN_P5 -to ddr4_emif_mem_mem_bg
	set_location_assignment PIN_M13 -to ddr4_emif_mem_mem_ck
	set_location_assignment PIN_P13 -to ddr4_emif_mem_mem_ck_n
	set_location_assignment PIN_L14 -to ddr4_emif_mem_mem_cke
	set_location_assignment PIN_L16 -to ddr4_emif_mem_mem_cs_n
	set_location_assignment PIN_M21 -to ddr4_emif_mem_mem_dbi_n[0]
	set_location_assignment PIN_F7 -to ddr4_emif_mem_mem_dbi_n[1]
	set_location_assignment PIN_L28 -to ddr4_emif_mem_mem_dbi_n[2]
	set_location_assignment PIN_U28 -to ddr4_emif_mem_mem_dbi_n[3]
	set_location_assignment PIN_B7 -to ddr4_emif_mem_mem_dbi_n[4]
	set_location_assignment PIN_T21 -to ddr4_emif_mem_mem_dbi_n[5]
	set_location_assignment PIN_A14 -to ddr4_emif_mem_mem_dbi_n[6]
	set_location_assignment PIN_T7 -to ddr4_emif_mem_mem_dbi_n[7]
	set_location_assignment PIN_G14 -to ddr4_emif_mem_mem_dbi_n[8]
	set_location_assignment PIN_P23 -to ddr4_emif_mem_mem_dq[0]
	set_location_assignment PIN_M19 -to ddr4_emif_mem_mem_dq[1]
	set_location_assignment PIN_N20 -to ddr4_emif_mem_mem_dq[2]
	set_location_assignment PIN_M23 -to ddr4_emif_mem_mem_dq[3]
	set_location_assignment PIN_L20 -to ddr4_emif_mem_mem_dq[4]
	set_location_assignment PIN_P19 -to ddr4_emif_mem_mem_dq[5]
	set_location_assignment PIN_L24 -to ddr4_emif_mem_mem_dq[6]
	set_location_assignment PIN_N24 -to ddr4_emif_mem_mem_dq[7]
	set_location_assignment PIN_J6 -to ddr4_emif_mem_mem_dq[8]
	set_location_assignment PIN_F5 -to ddr4_emif_mem_mem_dq[9]
	set_location_assignment PIN_H9 -to ddr4_emif_mem_mem_dq[10]
	set_location_assignment PIN_G10 -to ddr4_emif_mem_mem_dq[11]
	set_location_assignment PIN_J10 -to ddr4_emif_mem_mem_dq[12]
	set_location_assignment PIN_F9 -to ddr4_emif_mem_mem_dq[13]
	set_location_assignment PIN_H5 -to ddr4_emif_mem_mem_dq[14]
	set_location_assignment PIN_G6 -to ddr4_emif_mem_mem_dq[15]
	set_location_assignment PIN_N30 -to ddr4_emif_mem_mem_dq[16]
	set_location_assignment PIN_M31 -to ddr4_emif_mem_mem_dq[17]
	set_location_assignment PIN_P31 -to ddr4_emif_mem_mem_dq[18]
	set_location_assignment PIN_P27 -to ddr4_emif_mem_mem_dq[19]
	set_location_assignment PIN_L26 -to ddr4_emif_mem_mem_dq[20]
	set_location_assignment PIN_L30 -to ddr4_emif_mem_mem_dq[21]
	set_location_assignment PIN_M27 -to ddr4_emif_mem_mem_dq[22]
	set_location_assignment PIN_N26 -to ddr4_emif_mem_mem_dq[23]
	set_location_assignment PIN_V27 -to ddr4_emif_mem_mem_dq[24]
	set_location_assignment PIN_T31 -to ddr4_emif_mem_mem_dq[25]
	set_location_assignment PIN_T27 -to ddr4_emif_mem_mem_dq[26]
	set_location_assignment PIN_W30 -to ddr4_emif_mem_mem_dq[27]
	set_location_assignment PIN_V31 -to ddr4_emif_mem_mem_dq[28]
	set_location_assignment PIN_U30 -to ddr4_emif_mem_mem_dq[29]
	set_location_assignment PIN_U26 -to ddr4_emif_mem_mem_dq[30]
	set_location_assignment PIN_W26 -to ddr4_emif_mem_mem_dq[31]
	set_location_assignment PIN_B5 -to ddr4_emif_mem_mem_dq[32]
	set_location_assignment PIN_C6 -to ddr4_emif_mem_mem_dq[33]
	set_location_assignment PIN_D9 -to ddr4_emif_mem_mem_dq[34]
	set_location_assignment PIN_B9 -to ddr4_emif_mem_mem_dq[35]
	set_location_assignment PIN_A6 -to ddr4_emif_mem_mem_dq[36]
	set_location_assignment PIN_D5 -to ddr4_emif_mem_mem_dq[37]
	set_location_assignment PIN_C10 -to ddr4_emif_mem_mem_dq[38]
	set_location_assignment PIN_A10 -to ddr4_emif_mem_mem_dq[39]
	set_location_assignment PIN_V23 -to ddr4_emif_mem_mem_dq[40]
	set_location_assignment PIN_T23 -to ddr4_emif_mem_mem_dq[41]
	set_location_assignment PIN_W24 -to ddr4_emif_mem_mem_dq[42]
	set_location_assignment PIN_W20 -to ddr4_emif_mem_mem_dq[43]
	set_location_assignment PIN_U24 -to ddr4_emif_mem_mem_dq[44]
	set_location_assignment PIN_T19 -to ddr4_emif_mem_mem_dq[45]
	set_location_assignment PIN_V19 -to ddr4_emif_mem_mem_dq[46]
	set_location_assignment PIN_U20 -to ddr4_emif_mem_mem_dq[47]
	set_location_assignment PIN_B13 -to ddr4_emif_mem_mem_dq[48]
	set_location_assignment PIN_D17 -to ddr4_emif_mem_mem_dq[49]
	set_location_assignment PIN_A16 -to ddr4_emif_mem_mem_dq[50]
	set_location_assignment PIN_D13 -to ddr4_emif_mem_mem_dq[51]
	set_location_assignment PIN_A12 -to ddr4_emif_mem_mem_dq[52]
	set_location_assignment PIN_B17 -to ddr4_emif_mem_mem_dq[53]
	set_location_assignment PIN_C16 -to ddr4_emif_mem_mem_dq[54]
	set_location_assignment PIN_C12 -to ddr4_emif_mem_mem_dq[55]
	set_location_assignment PIN_W6 -to ddr4_emif_mem_mem_dq[56]
	set_location_assignment PIN_U10 -to ddr4_emif_mem_mem_dq[57]
	set_location_assignment PIN_T5 -to ddr4_emif_mem_mem_dq[58]
	set_location_assignment PIN_W10 -to ddr4_emif_mem_mem_dq[59]
	set_location_assignment PIN_V9 -to ddr4_emif_mem_mem_dq[60]
	set_location_assignment PIN_T9 -to ddr4_emif_mem_mem_dq[61]
	set_location_assignment PIN_U6 -to ddr4_emif_mem_mem_dq[62]
	set_location_assignment PIN_V5 -to ddr4_emif_mem_mem_dq[63]
	set_location_assignment PIN_H17 -to ddr4_emif_mem_mem_dq[64]
	set_location_assignment PIN_F13 -to ddr4_emif_mem_mem_dq[65]
	set_location_assignment PIN_J16 -to ddr4_emif_mem_mem_dq[66]
	set_location_assignment PIN_G16 -to ddr4_emif_mem_mem_dq[67]
	set_location_assignment PIN_F17 -to ddr4_emif_mem_mem_dq[68]
	set_location_assignment PIN_H13 -to ddr4_emif_mem_mem_dq[69]
	set_location_assignment PIN_G12 -to ddr4_emif_mem_mem_dq[70]
	set_location_assignment PIN_J12 -to ddr4_emif_mem_mem_dq[71]
	set_location_assignment PIN_L22 -to ddr4_emif_mem_mem_dqs[0]
	set_location_assignment PIN_G8 -to ddr4_emif_mem_mem_dqs[1]
	set_location_assignment PIN_M29 -to ddr4_emif_mem_mem_dqs[2]
	set_location_assignment PIN_T29 -to ddr4_emif_mem_mem_dqs[3]
	set_location_assignment PIN_A8 -to ddr4_emif_mem_mem_dqs[4]
	set_location_assignment PIN_U22 -to ddr4_emif_mem_mem_dqs[5]
	set_location_assignment PIN_B15 -to ddr4_emif_mem_mem_dqs[6]
	set_location_assignment PIN_U8 -to ddr4_emif_mem_mem_dqs[7]
	set_location_assignment PIN_F15 -to ddr4_emif_mem_mem_dqs[8]
	set_location_assignment PIN_N22 -to ddr4_emif_mem_mem_dqs_n[0]
	set_location_assignment PIN_J8 -to ddr4_emif_mem_mem_dqs_n[1]
	set_location_assignment PIN_P29 -to ddr4_emif_mem_mem_dqs_n[2]
	set_location_assignment PIN_V29 -to ddr4_emif_mem_mem_dqs_n[3]
	set_location_assignment PIN_C8 -to ddr4_emif_mem_mem_dqs_n[4]
	set_location_assignment PIN_W22 -to ddr4_emif_mem_mem_dqs_n[5]
	set_location_assignment PIN_D15 -to ddr4_emif_mem_mem_dqs_n[6]
	set_location_assignment PIN_W8 -to ddr4_emif_mem_mem_dqs_n[7]
	set_location_assignment PIN_H15 -to ddr4_emif_mem_mem_dqs_n[8]
	set_location_assignment PIN_M15 -to ddr4_emif_mem_mem_odt
	set_location_assignment PIN_N12 -to ddr4_emif_mem_mem_par
	set_location_assignment PIN_P17 -to ddr4_emif_mem_mem_reset_n
	set_location_assignment PIN_M9 -to ddr4_emif_oct_oct_rzqin
	set_location_assignment PIN_L10 -to ddr4_emif_pll_ref_clk_clk

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
