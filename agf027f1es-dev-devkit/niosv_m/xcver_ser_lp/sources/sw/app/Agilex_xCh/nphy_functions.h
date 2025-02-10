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


/* nphy_functions.h */

unsigned int rd_channel (int phy,int offset);

void wr_channel (int phy,int offset, unsigned int value);

void rmw_channel (int phy, int offset,unsigned int bitmask, unsigned int newval);

unsigned int rd_pdp_channel (int phy,int offset);

void wr_pdp_channel (int phy,int offset, unsigned int value);

void rmw_pdp_channel (int phy, int offset,unsigned int bitmask, unsigned int newval);

void rmw_channel_ftile (int phy, int channel, int offset,int address, unsigned int bitmask, unsigned int newval);
						
unsigned int rd_channel_ftile (int phy, int channel, int offset,int address);






