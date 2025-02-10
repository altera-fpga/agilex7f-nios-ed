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


/* PMA_functions_FTILE.h */

int decode_tap_6bits (int tap_encoded);

int decode_tap_7bits (int tap_encoded);

int twos_complement(int value);

int twos_complement_12bit(int value);

unsigned int cpi_request(int phy, int offset, int data, int lane, int opcode,int assert, int set_getn);

unsigned int cpi_request_fgt(int phy, int channel, int offset, int data, int opcode,int assert,int set_getn);

void show_pma_settings_ftile (int phy, int offset, int number_of_lanes, int line_encoding[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX]);

int get_cpidata(int phy, int channel, int offset, int data, int opcode);

void set_media_mode(int phy, int offset, int number_of_lanes, int media_mode);

int get_ehm_fgt(int phy, int channel, int offset, int basic_measure_config, int ber_target, int pos);