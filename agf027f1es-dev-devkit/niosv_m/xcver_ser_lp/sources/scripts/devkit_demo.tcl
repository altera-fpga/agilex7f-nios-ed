# (C) 2001-2024 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


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
# File: devkit_demo.tcl
# Generated on: Tue Apr  9 03:05:23 2024

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "devkit_demo"]} {
		puts "Project devkit_demo is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists devkit_demo]} {
		project_open -revision devkit_demo devkit_demo
	} else {
		project_new -revision devkit_demo devkit_demo
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name TOP_LEVEL_ENTITY devkit_demo
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 4.2
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "13:16:34  DECEMBER 24, 2004"
	set_global_assignment -name LAST_QUARTUS_VERSION "24.3.0 Pro Edition"
	set_global_assignment -name SAVE_DISK_SPACE OFF
	set_global_assignment -name BOARD "Agilex 7 FPGA F-Series Development Kit 2xF-Tile DK-DEV-AGF027F1ES"
	set_global_assignment -name DEVICE AGFB027R24C2E2VR2
	set_global_assignment -name FAMILY "Agilex 7"
	set_global_assignment -name ENABLE_DEVICE_WIDE_RESET OFF
	set_global_assignment -name AUTO_ENABLE_SMART_COMPILE ON
	set_global_assignment -name TIMING_ANALYZER_MULTICORNER_ANALYSIS ON
	set_global_assignment -name TIMING_ANALYZER_DO_CCPP_REMOVAL ON
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
	set_global_assignment -name USE_CONF_DONE SDM_IO16
	set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
	set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
	set_global_assignment -name USE_PWRMGT_SDA SDM_IO11
	set_global_assignment -name PWRMGT_BUS_SPEED_MODE "100 KHZ"
	set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE LTC3888
	set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 55
	set_global_assignment -name PWRMGT_SLAVE_DEVICE1_ADDRESS 00
	set_global_assignment -name PWRMGT_SLAVE_DEVICE2_ADDRESS 00
	set_global_assignment -name PWRMGT_SLAVE_DEVICE3_ADDRESS 00
	set_global_assignment -name PWRMGT_SLAVE_DEVICE4_ADDRESS 00
	set_global_assignment -name PWRMGT_SLAVE_DEVICE5_ADDRESS 00
	set_global_assignment -name PWRMGT_SLAVE_DEVICE6_ADDRESS 00
	set_global_assignment -name PWRMGT_SLAVE_DEVICE7_ADDRESS 00
	set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
	set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-12"
	set_global_assignment -name PWRMGT_TRANSLATED_VOLTAGE_VALUE_UNIT VOLTS
	set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE OFF
	set_global_assignment -name GLITCH_INTERVAL "1 ns"
	set_global_assignment -name ENABLE_SIGNALTAP ON
	set_global_assignment -name USE_SIGNALTAP_FILE stp1.stp
	set_global_assignment -name ENABLE_CLOCK_LATENCY ON
	set_global_assignment -name USE_CONFIGURATION_DEVICE OFF
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED WITH WEAK PULL-UP"
	set_global_assignment -name STATE_MACHINE_PROCESSING AUTO
	set_global_assignment -name SAFE_STATE_MACHINE ON
	set_global_assignment -name POWER_HSSI "Opportunistically power off"
	set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON
	set_global_assignment -name FITTER_EFFORT "STANDARD FIT"
	set_global_assignment -name POWER_HSSI_VCCHIP_LEFT "Opportunistically power off"
	set_global_assignment -name POWER_HSSI_VCCHIP_RIGHT "Opportunistically power off"
	set_global_assignment -name POWER_HSSI_LEFT "Opportunistically power off"
	set_global_assignment -name POWER_HSSI_RIGHT "Opportunistically power off"
	set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS"
	set_global_assignment -name PROJECT_IP_REGENERATION_POLICY NEVER_REGENERATE_IP
	set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"
	set_global_assignment -name FLOW_ENABLE_HYPER_RETIMER_FAST_FORWARD ON
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
	set_global_assignment -name AUTO_RESTART_CONFIGURATION OFF
	set_global_assignment -name ENABLE_CONFIGURATION_PINS OFF
	set_global_assignment -name ENABLE_BOOT_SEL_PIN OFF
	set_global_assignment -name GENERATE_PR_RBF_FILE ON
	set_global_assignment -name ENABLE_ED_CRC_CHECK ON
	set_global_assignment -name MINIMUM_SEU_INTERVAL 0
	set_global_assignment -name ACTIVE_SERIAL_CLOCK AS_FREQ_100MHZ
	set_global_assignment -name DEVICE_INITIALIZATION_CLOCK OSC_CLK_1_125MHZ
	set_global_assignment -name FAST_PRESERVE OFF -entity devkit_demo
	set_global_assignment -name REMOVE_DUPLICATE_REGISTERS OFF
	set_global_assignment -name GENERATE_COMPRESSED_SOF ON
	set_global_assignment -name SEARCH_PATH wab_america_west/wab_helper
	set_global_assignment -name SEARCH_PATH wab_america_west
	set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "AVST X16"
	set_global_assignment -name POWER_APPLY_THERMAL_MARGIN ADDITIONAL
	set_global_assignment -name TCL_SCRIPT_FILE ./ttk_helper_ftile.tcl
	set_global_assignment -name VHDL_FILE core_prbs/txrx_pcs_64b66b_fgt.vhd
	set_global_assignment -name VHDL_FILE prbsgenerate_10bit.vhd
	set_global_assignment -name VERILOG_FILE wab_america_west/intc_mlab.v
	set_global_assignment -name VERILOG_FILE wab_america_west/intc_lut6.v
	set_global_assignment -name VHDL_FILE synchronizer.vhd
	set_global_assignment -name VERILOG_FILE wab_america_west/wab_america_west_1f.v
	set_global_assignment -name IP_FILE clk_buffer.ip
	set_global_assignment -name IP_FILE iopll_core_noise.ip
	set_global_assignment -name VHDL_FILE core_prbs/prbstest_rsfec.vhd
	set_global_assignment -name VHDL_FILE devkit_demo.vhd
	set_global_assignment -name IP_FILE refclk.ip
	set_global_assignment -name IP_FILE core_prbs/phy_direct.ip
	set_global_assignment -name TCL_SCRIPT_FILE phy_reg_set_hw.tcl
	set_global_assignment -name TCL_SCRIPT_FILE channel_reg_set_hw.tcl
	set_global_assignment -name SYSTEMVERILOG_FILE core_prbs/hyper_pipe.sv
	set_global_assignment -name VHDL_FILE core_prbs/scrambler.vhd
	set_global_assignment -name VHDL_FILE core_prbs/descrambler.vhd
	set_global_assignment -name VHDL_FILE core_prbs/synchro.vhd
	set_global_assignment -name VHDL_FILE core_prbs/multi_prbsverify_128bit.vhd
	set_global_assignment -name VHDL_FILE core_prbs/multi_prbsgenerate_128bit.vhd
	set_global_assignment -name IP_FILE reset_release.ip
	set_global_assignment -name SDC_FILE set_create_clock.sdc
	set_global_assignment -name SDC_FILE jtag_constraints_new.sdc
	set_global_assignment -name TCL_SCRIPT_FILE reconfig_mgmt_hw.tcl
	set_global_assignment -name VHDL_FILE core_prbs/reset_synchro.vhd
	set_global_assignment -name QSYS_FILE controller.qsys
	set_global_assignment -name VHDL_FILE package_registertype.vhd
	set_global_assignment -name VHDL_FILE core_prbs/measure_refclk.vhd
	set_global_assignment -name VHDL_FILE core_prbs/counter_1ms.vhd
	set_global_assignment -name SOURCE_FILE altera_vhdl_support.vhd
	set_global_assignment -name IP_FILE ip/controller/controller_jtag_uart.ip
	set_global_assignment -name IP_FILE ip/controller/controller_sys_clk_timer.ip
	set_global_assignment -name IP_FILE ip/controller/controller_irq_10us.ip
	set_global_assignment -name IP_FILE core_prbs/adder_hw.ip
	set_global_assignment -name IP_FILE ip/controller/controller_reset_sequencer_0.ip
	set_global_assignment -name IP_FILE ip/controller/tile4_temp_reg_2.ip
	set_global_assignment -name IP_FILE ip/controller/controller_channel_reg_set_0.ip
	set_global_assignment -name IP_FILE ip/controller/controller_pio_2.ip
	set_global_assignment -name IP_FILE ip/controller/controller_pio_3.ip
	set_global_assignment -name IP_FILE ip/controller/controller_i2c_0.ip
	set_global_assignment -name IP_FILE ip/controller/controller_phy_reg_set_0.ip
	set_global_assignment -name IP_FILE ip/controller/controller_clock_bridge_0.ip
	set_global_assignment -name IP_FILE ip/controller/controller_reset_bridge_0.ip
	set_global_assignment -name IP_FILE clock_configuration.ip
	set_global_assignment -name IP_FILE clock_divider.ip
	set_global_assignment -name IP_FILE ip/controller/controller_s10_mailbox_client_0.ip
	set_global_assignment -name IP_FILE ip/controller/internal_noise.ip
	set_global_assignment -name SDC_FILE timing.sdc
	set_global_assignment -name IP_FILE ip/controller/controller_intel_niosv_m_0.ip
	set_global_assignment -name IP_FILE ip/controller/controller_intel_onchip_memory_0.ip
	set_global_assignment -name MESSAGE_DISABLE 12677
	set_global_assignment -name IP_FILE ip/controller/controller_sysid_qsys_0.ip
	# This order dependent setting should appear after all other QIP_FILE and IP_FILE settings
	set_global_assignment -name QIP_FILE support_logic/devkit_demo_auto_tiles.qip -comment "This order dependent setting should appear after all other QIP_FILE and IP_FILE settings" -tag quartus_tlg
	set_global_assignment -name SPD_FILE support_logic/devkit_demo_auto_tiles.spd -tag quartus_tlg
	set_location_assignment PIN_CK18 -to clk_sys_100m
	set_instance_assignment -name IO_STANDARD "TRUE DIFFERENTIAL SIGNALING" -to clk_sys_100m -entity devkit_demo
	set_location_assignment PIN_AW49 -to gt_refclk
	set_location_assignment PIN_FGTL12C_TX_Q1_CH0P -to qsfpdd_txp[3]
	set_location_assignment PIN_FGTL12C_TX_Q1_CH1P -to qsfpdd_txp[2]
	set_location_assignment PIN_FGTL12C_TX_Q1_CH2P -to qsfpdd_txp[1]
	set_location_assignment PIN_FGTL12C_TX_Q1_CH3P -to qsfpdd_txp[0]
	set_location_assignment PIN_FGTL12C_TX_Q2_CH0P -to qsfpdd_txp[7]
	set_location_assignment PIN_FGTL12C_TX_Q2_CH1P -to qsfpdd_txp[6]
	set_location_assignment PIN_FGTL12C_TX_Q3_CH2P -to qsfpdd_txp[5]
	set_location_assignment PIN_FGTL12C_TX_Q3_CH3P -to qsfpdd_txp[4]
	set_instance_assignment -name HSSI_PARAMETER "txeq_main_tap=35" -to qsfpdd_txp[0] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_1=5" -to qsfpdd_txp[0] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_2=0" -to qsfpdd_txp[0] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_post_tap_1=0" -to qsfpdd_txp[0] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_main_tap=35" -to qsfpdd_txp[1] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_1=5" -to qsfpdd_txp[1] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_2=0" -to qsfpdd_txp[1] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_post_tap_1=0" -to qsfpdd_txp[1] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_main_tap=35" -to qsfpdd_txp[2] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_1=5" -to qsfpdd_txp[2] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_2=0" -to qsfpdd_txp[2] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_post_tap_1=0" -to qsfpdd_txp[2] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_main_tap=35" -to qsfpdd_txp[3] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_1=5" -to qsfpdd_txp[3] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_2=0" -to qsfpdd_txp[3] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_post_tap_1=0" -to qsfpdd_txp[3] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_main_tap=35" -to qsfpdd_txp[4] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_1=5" -to qsfpdd_txp[4] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_2=0" -to qsfpdd_txp[4] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_post_tap_1=0" -to qsfpdd_txp[4] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_main_tap=35" -to qsfpdd_txp[5] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_1=5" -to qsfpdd_txp[5] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_2=0" -to qsfpdd_txp[5] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_post_tap_1=0" -to qsfpdd_txp[5] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_main_tap=35" -to qsfpdd_txp[6] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_1=5" -to qsfpdd_txp[6] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_2=0" -to qsfpdd_txp[6] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_post_tap_1=0" -to qsfpdd_txp[6] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_main_tap=35" -to qsfpdd_txp[7] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_1=5" -to qsfpdd_txp[7] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_pre_tap_2=0" -to qsfpdd_txp[7] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "txeq_post_tap_1=0" -to qsfpdd_txp[7] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_ac_couple_enable=ENABLE" -to qsfpdd_rxp[0] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_ac_couple_enable=ENABLE" -to qsfpdd_rxp[1] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_ac_couple_enable=ENABLE" -to qsfpdd_rxp[2] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_ac_couple_enable=ENABLE" -to qsfpdd_rxp[3] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_ac_couple_enable=ENABLE" -to qsfpdd_rxp[4] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_ac_couple_enable=ENABLE" -to qsfpdd_rxp[5] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_ac_couple_enable=ENABLE" -to qsfpdd_rxp[6] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_ac_couple_enable=ENABLE" -to qsfpdd_rxp[7] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_onchip_termination=RX_ONCHIP_TERMINATION_R_2" -to qsfpdd_rxp[0] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_onchip_termination=RX_ONCHIP_TERMINATION_R_2" -to qsfpdd_rxp[1] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_onchip_termination=RX_ONCHIP_TERMINATION_R_2" -to qsfpdd_rxp[2] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_onchip_termination=RX_ONCHIP_TERMINATION_R_2" -to qsfpdd_rxp[3] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_onchip_termination=RX_ONCHIP_TERMINATION_R_2" -to qsfpdd_rxp[4] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_onchip_termination=RX_ONCHIP_TERMINATION_R_2" -to qsfpdd_rxp[5] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_onchip_termination=RX_ONCHIP_TERMINATION_R_2" -to qsfpdd_rxp[6] -entity devkit_demo
	set_instance_assignment -name HSSI_PARAMETER "rx_onchip_termination=RX_ONCHIP_TERMINATION_R_2" -to qsfpdd_rxp[7] -entity devkit_demo
	set_location_assignment PIN_K44 -to qsfpdd_fpga_i2c_scl
	set_location_assignment PIN_J43 -to qsfpdd_fpga_i2c_sda
	set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpdd_fpga_i2c_scl -entity devkit_demo
	set_instance_assignment -name IO_STANDARD "1.2 V" -to qsfpdd_fpga_i2c_sda -entity devkit_demo
	set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to qsfpdd_txp -entity devkit_demo
	set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to qsfpdd_rxp -entity devkit_demo

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
