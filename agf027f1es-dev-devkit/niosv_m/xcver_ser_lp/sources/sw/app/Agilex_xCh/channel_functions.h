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

/* channel_functions.h */

int Read_Channel_Reg( int phy, int SelectedChannel);

unsigned int Read_ErrorCount_L_Reg( int phy, int SelectedChannel);

unsigned int Read_ErrorCount_H_Reg( int phy, int SelectedChannel);

unsigned int Read_PrbsLock_Alarm_Reg( int phy, int SelectedChannel);

unsigned int Read_PrbsLock_Alarm_Reg_Alt( int phy, int SelectedChannel);

unsigned int read_counter_1ms_reg (int phy);

unsigned int read_bitrate_reg (int phy);

unsigned int read_rxclock_reg (int phy);

void write_control_reg(int phy,int Control_Reg);

void write_control2_reg(int phy,int Control2_Reg);

void write_ber_control_reg(int phy,int BER_Control);

void write_reset_control_reg(int phy,int Reset_Control);





