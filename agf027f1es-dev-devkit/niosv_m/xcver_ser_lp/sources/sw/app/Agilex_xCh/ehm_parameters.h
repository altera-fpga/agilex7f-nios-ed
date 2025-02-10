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

//Symbol defines for Core 0

#define BER_TARGET_EHM_DEFAULT_PAM4 6 //1E-6
#define BER_TARGET_EHM_DEFAULT_NRZ 6 //1E-6

#define NUMBER_OF_EHM_EXTRAPOLATIONS 2


#define POS 1
#define NEG 0

#define CONVERT_TO_MV      1.33

#define CORE0_SYMBOL_3		0xdb
#define CORE0_SYMBOL_1		0xc9
#define CORE0_SYMBOL_MIN_1	0xff
#define CORE0_SYMBOL_MIN_3	0xed


//Defines the eventrates for different BER targets

#define EVENT_RATE_1E3_POS_LSB1	0xa029
#define EVENT_RATE_1E3_POS_LSB2	0x419
#define EVENT_RATE_1E3_POS_MSB	0x100

#define EVENT_RATE_1E3_NEG_LSB1	0x5fd7
#define EVENT_RATE_1E3_NEG_LSB2	0xfbe6
#define EVENT_RATE_1E3_NEG_MSB	0xff



#define EVENT_RATE_1E4_POS_LSB1	0xde3a
#define EVENT_RATE_1E4_POS_LSB2	0x68
#define EVENT_RATE_1E4_POS_MSB	0x100

#define EVENT_RATE_1E4_NEG_LSB1	0x21c6
#define EVENT_RATE_1E4_NEG_LSB2	0xff97
#define EVENT_RATE_1E4_NEG_MSB	0xff



#define EVENT_RATE_1E5_POS_LSB1	0x7c61
#define EVENT_RATE_1E5_POS_LSB2	0xa
#define EVENT_RATE_1E5_POS_MSB	0x100

#define EVENT_RATE_1E5_NEG_LSB1	0x839f
#define EVENT_RATE_1E5_NEG_LSB2	0xfff5
#define EVENT_RATE_1E5_NEG_MSB	0xff



#define EVENT_RATE_1E6_POS_LSB1	0xc6f
#define EVENT_RATE_1E6_POS_LSB2	0x1
#define EVENT_RATE_1E6_POS_MSB	0x100

#define EVENT_RATE_1E6_NEG_LSB1	0xf391
#define EVENT_RATE_1E6_NEG_LSB2	0xfffe
#define EVENT_RATE_1E6_NEG_MSB	0xff



#define EVENT_RATE_1E7_POS_LSB1	0x1ad7
#define EVENT_RATE_1E7_POS_LSB2	0x0
#define EVENT_RATE_1E7_POS_MSB	0x100

#define EVENT_RATE_1E7_NEG_LSB1	0xe529
#define EVENT_RATE_1E7_NEG_LSB2	0xffff
#define EVENT_RATE_1E7_NEG_MSB	0xff



#define EVENT_RATE_1E8_POS_LSB1	0x2af
#define EVENT_RATE_1E8_POS_LSB2	0x0
#define EVENT_RATE_1E8_POS_MSB	0x100

#define EVENT_RATE_1E8_NEG_LSB1	0xfd51
#define EVENT_RATE_1E8_NEG_LSB2	0xffff
#define EVENT_RATE_1E8_NEG_MSB	0xff



#define EVENT_RATE_1E9_POS_LSB1	0x44
#define EVENT_RATE_1E9_POS_LSB2	0x0
#define EVENT_RATE_1E9_POS_MSB	0x100

#define EVENT_RATE_1E9_NEG_LSB1	0xffbc
#define EVENT_RATE_1E9_NEG_LSB2	0xffff
#define EVENT_RATE_1E9_NEG_MSB	0xff



#define EVENT_RATE_1E10_POS_LSB1	0x6
#define EVENT_RATE_1E10_POS_LSB2	0x0
#define EVENT_RATE_1E10_POS_MSB	0x100

#define EVENT_RATE_1E10_NEG_LSB1	0xfffa
#define EVENT_RATE_1E10_NEG_LSB2	0xffff
#define EVENT_RATE_1E10_NEG_MSB	0xff

//Using as input 2E-10 at https://keisan.casio.com/exec/system/1180573448 and taking the output from the erfcinv

#define ERINV_1E4 2.62974177621027292062
#define ERINV_1E5 3.015733201402907704931
#define ERINV_1E6 3.361178562625649511583
#define ERINV_1E7 3.676486862046609256299
#define ERINV_1E8 3.968284135783334800356
#define ERINV_1E9 4.24109001256018020449
#define ERINV_1E10 4.498147289529259741459
#define ERINV_1E11 4.741874448044620299479
#define ERINV_1E12 4.974131215017515297592
#define ERINV_1E13 5.19638355784763188435
#define ERINV_1E14 5.409811004850832504996
#define ERINV_1E15 5.61537913187960690036
#define ERINV_1E16 5.813890090499147685046
#define ERINV_1E17 6.006018786764245584355
#define ERINV_1E18 6.192339390443480909574
#define ERINV_1E19 6.373345153048964156624
#define ERINV_1E20 6.549463487152469532288

