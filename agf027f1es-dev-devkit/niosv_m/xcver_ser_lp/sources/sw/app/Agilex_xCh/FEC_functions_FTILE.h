//----------------------------------------------------------------------------------------------------------
// Copyright (C) 2021-2022 Intel Corporation
// 
// This code and the related documents are Intel copyrighted materials, and 
// your use of them is governed by the express license under which they were 
// provided to you ("License"). Unless the License provides otherwise, you may 
// not use, modify, copy, publish, distribute, disclose or transmit this 
// code or the related documents without Intel's prior written permission.
//
// This code and the related documents are provided as is, with no express 
// or implied warranties, other than those that are expressly stated in the 
// License.
//
//----------------------------------------------------------------------------------------------------------


/* FEC_functions_FTILE.h */

unsigned int Read_FEC_corr_codeword_Reg_L( int phy,int SelectedChannel, int ethernet_mode_base_address, int segment);

unsigned int Read_FEC_corr_codeword_Reg_H( int phy,int SelectedChannel, int ethernet_mode_base_address, int segment);

unsigned int Read_FEC_uncorr_codeword_Reg_L( int phy,int SelectedChannel, int ethernet_mode_base_address, int segment);

unsigned int Read_FEC_uncorr_codeword_Reg_H( int phy,int SelectedChannel, int ethernet_mode_base_address, int segment);

unsigned int Read_FEC_corr_symbols_Reg_L( int phy,int SelectedChannel, int ethernet_mode_base_address, int segment);

unsigned int Read_FEC_corr_symbols_Reg_H( int phy,int SelectedChannel, int ethernet_mode_base_address, int segment);

unsigned int Read_FEC_corr_bits_0_1_Reg_L( int phy,int SelectedChannel, int ethernet_mode_base_address, int segment);

unsigned int Read_FEC_corr_bits_0_1_Reg_H( int phy,int SelectedChannel, int ethernet_mode_base_address, int segment);

unsigned int Read_FEC_corr_bits_1_0_Reg_L( int phy,int SelectedChannel, int ethernet_mode_base_address, int segment);

unsigned int Read_FEC_corr_bits_1_0_Reg_H( int phy,int SelectedChannel, int ethernet_mode_base_address, int segment);

void Write_FEC_error_inject( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment,int pattern, int rate);

unsigned int Read_FEC_rx_lane_mapping( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment);

unsigned int Read_FEC_rx_lane_skew( int phy,int SelectedChannel, int ethernet_mode_base_address, int segment);

unsigned int Read_FEC_rsfec_corr_cwbin_cnt_0_3( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment);

unsigned int Read_FEC_rsfec_corr_cwbin_cnt_4_7( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment);

unsigned int Read_FEC_rsfec_corr_cwbin_cnt_8_11( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment);

unsigned int Read_FEC_rsfec_corr_cwbin_cnt_12_15( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment);

void fec_shadow_request( int phy,int SelectedChannel, int ethernet_mode_base_address, int segment);

void fec_clear_shadow_request( int phy,int SelectedChannel, int ethernet_mode_base_address, int segment);
 
void fec_clear_counters( int phy,int SelectedChannel, int ethernet_mode_base_address, int segment);



