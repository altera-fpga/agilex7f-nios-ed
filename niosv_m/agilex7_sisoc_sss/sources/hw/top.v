// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// Copyright (C) 2001-2022 Intel Corporation 
//
// This code and the related documents are Intel copyrighted materials, and
// your use of them is governed by the express license under which they were
// provided to you ("License"). Unless the License provides otherwise, you may
// not use, modify, copy, publish, distribute, disclose or transmit this
// code or the related documents without Intel's prior written permission
//
// This code and the related documents are provided as is, with no express
// or implied warranties, other than those that are expressly stated in the
// License.
//
// Warning for Reset Release IP: 
// =============================
// Do not instantiate this IP multiple time. Move this IP to your 
// top level if you are integrating this reference design into your design. 

module top (
   //Clock and Reset
   input wire          CLK_100M,     // 100MHz refclk internal FIFO, packet generator, packet monitor & AV-ST interface
   input wire          REF_CLK,			  // 125MHz refclk for PCS and MAC 
   input wire          RESET_N,			  // USER_PB0 - Global reset
   output wire         PHY_RESET_N,      // Marvell PHY reset 
	
	// Dummy refclk to protect xcvr channels 
	input wire          refclk_preserve_xcvr,

   // SGMII Status			
   output wire         LED_CHAR_ERR_N,	  // USER_LED_G4
   output wire         LED_DISP_ERR_N,	  // USER_LED_G3
   output wire         LED_LINK_N,		  // USER_LED_G0
   output wire         LED_PANEL_LINK_N, // USER_LED_G2

   //MDIO
   output wire         MDC,              // Marvell PHY management data refclk 
   inout wire          MDIO,             // Marvell PHY management data

   //SGMII 
   input wire          RXP,              // LVDS serial input
	input wire          RXN,              // LVDS serial input N
   output wire         TXP,              // LVDS serial output
	output wire         TXN,              // LVDS serial output N
	
	output [3:0]			user_led
);

// -------------------------------------------------------------------------
// Wires declaration 
// -------------------------------------------------------------------------

wire        init_done_n;
wire        global_reset;
wire        global_reset_n;
wire			sys_pll_locked;
wire			clk_out;

// Status I/O
wire 			led_char_err;
wire 			led_disp_err;
wire 			led_link;
wire			led_panel_link;
wire			lvds_tx_iopll_locked;

// MDIO
wire 			mdio_in;
wire 			mdio_oen;
wire 			mdio_out;



// -------------------------------------------------------------------------
// Reset Release IP
// -------------------------------------------------------------------------
// Warning: Do not instantiate this IP multiple time. Move this IP to your 
// top level if you are integrating this reference design into your design. 
reset_release reset_release_0 (
    .ninit_done (init_done_n)  //  output,  width = 1, ninit_done.ninit_done
);


//// -------------------------------------------------------------------------
//// Reset assignments- comment 2
//// -------------------------------------------------------------------------
assign global_reset_n = ~init_done_n;
assign PHY_RESET_N    = global_reset_n;	//modify for Agilex



//adding iopll for reset

  sys_pll sys_pll_inst(
  	.rst      (init_done_n), 
  	.refclk   (CLK_100M),
  	.locked   (sys_pll_locked),
  	.outclk_0 (clk_out)
  	);

assign global_reset = ~sys_pll_locked;
	


// -------------------------------------------------------------------------
// Status ports assignments
// -------------------------------------------------------------------------
assign LED_CHAR_ERR_N   = ~led_char_err;
assign LED_DISP_ERR_N   = ~led_disp_err;
assign LED_LINK_N       = ~(lvds_tx_iopll_locked & led_link);			//Modify for Agilex due to lvds_tx_iopll_locked
assign LED_PANEL_LINK_N = ~led_panel_link;

// -------------------------------------------------------------------------
// MDIO ports connection
// -------------------------------------------------------------------------
assign MDIO    = mdio_oen ? 1'bz : mdio_out;
assign mdio_in = MDIO;

// -------------------------------------------------------------------------	 
// Triple-speed Ethernet Platform Designer system
// ------------------------------------------------------------------------- 
qsys_top qsys_top_0 (
   .clk_clk                                        				(clk_out),   	     
	.reset_reset							                           (global_reset),  //(~pll_locked);modify for Agilex
	.triple_speed_ethernet_0_mac_mdio_connection_mdio_in        (mdio_in),   	     
	.triple_speed_ethernet_0_mac_mdio_connection_mdc            (MDC),         	  
	.triple_speed_ethernet_0_mac_mdio_connection_mdio_out       (mdio_out),    	  
	.triple_speed_ethernet_0_mac_mdio_connection_mdio_oen       (mdio_oen),		  
	.triple_speed_ethernet_0_mac_misc_connection_ff_tx_crc_fwd	(1'b0),
	.triple_speed_ethernet_0_mac_misc_connection_ff_tx_septy	   (), 
	.triple_speed_ethernet_0_mac_misc_connection_tx_ff_uflow	   (), 
	.triple_speed_ethernet_0_mac_misc_connection_ff_tx_a_full	(),
	.triple_speed_ethernet_0_mac_misc_connection_ff_tx_a_empty  (),
	.triple_speed_ethernet_0_mac_misc_connection_rx_err_stat	   (), 
	.triple_speed_ethernet_0_mac_misc_connection_rx_frm_type	   (), 
	.triple_speed_ethernet_0_mac_misc_connection_ff_rx_dsav		(),  
	.triple_speed_ethernet_0_mac_misc_connection_ff_rx_a_full	(),
	.triple_speed_ethernet_0_mac_misc_connection_ff_rx_a_empty  (),
	.triple_speed_ethernet_0_pcs_ref_clk_clock_connection_clk   (REF_CLK),	
	.triple_speed_ethernet_0_serdes_control_connection_export	() ,
   .triple_speed_ethernet_0_lvds_tx_pll_locked_export          (lvds_tx_iopll_locked),	// lvds_tx_pll_locked
	.triple_speed_ethernet_0_serial_connection_rxp_0				(RXP),             // pcs_only_serial_connection.rxp_0
	.triple_speed_ethernet_0_serial_connection_rxn_0				(RXN),             // pcs_only_serial_connection.rxn_0
	.triple_speed_ethernet_0_serial_connection_txp_0				(TXP),             //                           .txp_0
	.triple_speed_ethernet_0_serial_connection_txn_0				(TXN),             //                           .txn_0	
	.triple_speed_ethernet_0_status_led_connection_crs       	(),                // pcs_only_status_led_connection.crs
	.triple_speed_ethernet_0_status_led_connection_link         (led_link),        //                               .link
	.triple_speed_ethernet_0_status_led_connection_panel_link   (led_panel_link),  //                               .panel_link
	.triple_speed_ethernet_0_status_led_connection_col          (),                //                               .col
	.triple_speed_ethernet_0_status_led_connection_char_err     (led_char_err),    //                               .char_err
	.triple_speed_ethernet_0_status_led_connection_disp_err		(led_disp_err),    //                               .disp_err
	.led_pio_external_connection_export									(user_led)			 //conencted to opn board LEDs
);

endmodule 
