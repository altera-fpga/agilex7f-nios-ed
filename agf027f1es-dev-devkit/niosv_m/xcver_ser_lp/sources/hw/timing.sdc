#Set this parameter to match the toplevel parameter

# Asynchronous clock groups


set_clock_groups -asynchronous \
-group {gt_refclk} \
-group [get_clocks {clock_divider_inst|intelclkctrl_0|clkdiv_inst|clock_div2}] \
-group [get_clocks {altera_reserved_tck}] \
-group [get_clocks {Generate_noise_logic.iopll_core_noise_inst|iopll_0_outclk0}] \
-group [get_clocks {Generate_transceiver_block[0].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[0].phy_direct_inst|directphy_f_0|rx_clkout|ch7}] \
-group [get_clocks {Generate_transceiver_block[0].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[0].phy_direct_inst|directphy_f_0|rx_clkout2|ch7}] \
-group [get_clocks {Generate_transceiver_block[0].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[0].phy_direct_inst|directphy_f_0|tx_clkout|ch7}] \
-group [get_clocks {Generate_transceiver_block[0].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[1].phy_direct_inst|directphy_f_0|rx_clkout|ch5}] \
-group [get_clocks {Generate_transceiver_block[0].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[1].phy_direct_inst|directphy_f_0|tx_clkout|ch5}] \
-group [get_clocks {Generate_transceiver_block[0].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[2].phy_direct_inst|directphy_f_0|rx_clkout|ch3}] \
-group [get_clocks {Generate_transceiver_block[0].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[2].phy_direct_inst|directphy_f_0|tx_clkout|ch3}] \
-group [get_clocks {Generate_transceiver_block[0].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[3].phy_direct_inst|directphy_f_0|rx_clkout|ch1}] \
-group [get_clocks {Generate_transceiver_block[0].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[3].phy_direct_inst|directphy_f_0|tx_clkout|ch1}] \
-group [get_clocks {Generate_transceiver_block[1].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[0].phy_direct_inst|directphy_f_0|rx_clkout|ch23}] \
-group [get_clocks {Generate_transceiver_block[1].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[0].phy_direct_inst|directphy_f_0|rx_clkout2|ch23}] \
-group [get_clocks {Generate_transceiver_block[1].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[0].phy_direct_inst|directphy_f_0|tx_clkout|ch23}] \
-group [get_clocks {Generate_transceiver_block[1].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[1].phy_direct_inst|directphy_f_0|rx_clkout|ch21}] \
-group [get_clocks {Generate_transceiver_block[1].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[1].phy_direct_inst|directphy_f_0|tx_clkout|ch21}] \
-group [get_clocks {Generate_transceiver_block[1].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[2].phy_direct_inst|directphy_f_0|rx_clkout|ch11}] \
-group [get_clocks {Generate_transceiver_block[1].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[2].phy_direct_inst|directphy_f_0|tx_clkout|ch11}] \
-group [get_clocks {Generate_transceiver_block[1].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[3].phy_direct_inst|directphy_f_0|rx_clkout|ch9}] \
-group [get_clocks {Generate_transceiver_block[1].instx|txrx_pcs_64b66b_fgt_x|Generate_phy_direct[3].phy_direct_inst|directphy_f_0|tx_clkout|ch9}] 



# signaltap false paths for core noise
#set_false_path -from {Generate_noise_logic.generate_wabs[*].synchro_dout|*} -to {auto_fab_0|alt_sld_fab_0|alt_sld_fab_0|auto_signaltap_internal_noise|sld_signaltap_inst|acq_trigger_in_reg[*]}
#set_false_path -from {Generate_noise_logic.generate_wabs[*].synchro_dout|*} -to {auto_fab_0|alt_sld_fab_0|alt_sld_fab_0|auto_signaltap_internal_noise|sld_signaltap_inst|acq_data_in_reg[*]}
#set_false_path -from {Generate_noise_logic.generate_wabs[*].prbsgenerate_10bit_inst|tx_data[*]} -to {auto_fab_0|alt_sld_fab_0|alt_sld_fab_0|auto_signaltap_internal_noise|sld_signaltap_inst|acq_trigger_in_reg[*]}
#set_false_path -from {Generate_noise_logic.generate_wabs[*].prbsgenerate_10bit_inst|tx_data[*]} -to {auto_fab_0|alt_sld_fab_0|alt_sld_fab_0|auto_signaltap_internal_noise|sld_signaltap_inst|acq_data_in_reg[*]}



# Additional Constraints for jtag clock (altera_reserved_tck)
# Can be removed normally

set_max_delay -from [get_clocks {altera_reserved_tck}] -to [get_clocks {clock_divider_inst|intelclkctrl_0|clkdiv_inst|clock_div2}] 200
set_min_delay -from [get_clocks {altera_reserved_tck}] -to [get_clocks {clock_divider_inst|intelclkctrl_0|clkdiv_inst|clock_div2}] -200

set_data_delay -from [get_clocks altera_reserved_tck] -to [get_clocks clock_divider_inst|intelclkctrl_0|clkdiv_inst|clock_div2] 6

set_max_delay -from [get_clocks {clock_divider_inst|intelclkctrl_0|clkdiv_inst|clock_div2}] -to [get_clocks {altera_reserved_tck}] 200
set_min_delay -from [get_clocks {clock_divider_inst|intelclkctrl_0|clkdiv_inst|clock_div2}] -to [get_clocks {altera_reserved_tck}] -200

set_data_delay -from [get_clocks {clock_divider_inst|intelclkctrl_0|clkdiv_inst|clock_div2}] -to [get_clocks {altera_reserved_tck}] 6



 






