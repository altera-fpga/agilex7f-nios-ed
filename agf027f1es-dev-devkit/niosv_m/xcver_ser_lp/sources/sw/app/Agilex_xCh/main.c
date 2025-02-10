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



 
//Check if right encoding is used (UTF-8)
//		printf("■");//▪ ┌ ┐└ ┘ □ │ ─

//Author 	: Peter Schepers
//File 		: main.c used in F-tile demo designs

//Version   : 1.10
//Data		: 29/06/2022
//Changes	: 	Added reconvergence for the FHT Rx when doing a reset (WIP)
//					Support for Reset Control Register (used when using 8 individual channels per phy)
//					Added additional reset functions to be used in combination with reset
//					if 2nd w.c. bin is bin 0 don't show it because this doesn't make sense as bin 0 is the amount of codewords received
//					Add support for SI board to ask to enable I2C support or not (in case there are issues with I2C readout that can keep the software hanging)
//					Fix bug serial loopback (no individual serial loopback when PMA lanes > 1)
//					Added I2C support for QSDPDD-800 on SI kit
//					Add support for XGMII test design with soft 10Gbase-R and soft KR-FEC
//					Add support for FGT Vertical Eye Height Measurement 
//					Updated all functions to no longer use reverse_mapping but perform everything on lane readout
//					Added support for FM86 board using Q3 and Q2 on bank 12C which requires Tx polarity inversion on some of the lanes
//					Add pass/fail information (pass : all channels are locked + errorfree (when using FEC or NRZ) and all channels locked when PAM4 PMA direct
//					Add option to run without user-intervention with/without serial loopback enabled.

 
//Version   : 1.9
//Data		: 28/01/2022
//Changes	: Support for 2x200GBE Aggregate mode using 1 PHY which impacts the FEC statistics
//			     Use dedicated functions for FEC statistics gathering and FEC statistics printing (to be re-used by other designs like Superlite IV)	
//				  Fixed Totalbits calculation and derived statistics when FEC is in aggregate modes
//				  Added Aggregate statistics for aggregate FEC modes.
//				  Added support for PRBSLOCK_ALARM_COUNTER_ALT (with additional statistics for PRBS 128 verifier)
//				  WIP : Added support for BER control which allows to generate PRBS traffic with a certain amount of BER, this is using a new register BER_Control 
//				  Tx and Rx Polarity inversion are now using CPI commands instead.
//				  Added support to be used also for Superlite II/IV designs
//				  Asks for I2C support when PCIe devkit (requires modification to the hardware)
//				  Added skew display for Superlite IV designs
//				  Added FW version readout FHT
//				  Update for PRBS 128 bit when using FHT NRZ
//				  Update FEC statistics when using 100GbE Aggregate mode (2x53G or 4x25G)
//				  show_pma_settings_ftile support for FHT
//				  



//Version   : 1.8
//Data		: 06/12/2021
//Changes	: Bug Fixes and additional features for the Fec error tree
//				  Bug Fix Max #CS per CW




//Version   : 1.7
//Data		: 30/11/2021
//Changes	: Added support for Agilex SI/SOC kit (4 F tile device)
//				  Added bank information number
//				  Added support for I2C readout on Agilex SI/SOC kit
//				  Added support for dual clock pattern for PAM4 128 bit prbsgenerate
//				  Added support for detecting and reporting on FEC Bins
//				  Added "live" FEC Error Tree support




//Version   : 1.6
//Data		: 17/11/2021
//Changes	: Added support for 200GbE Aggregate mode and 400GbE Aggregate mode
//				  Fixed Bug in Pre-corrected BER for continuous update and added Totalbits as metric
//				  Updated CPI_Request function to return value by adding GET/SET functionality
//				  Updated functions using CPI request using the new parameters
//				  Added additional equalization parameters in show_pma_settings_ftile
//				  Updated sweep function to add FOM as additional metric
//				  Added dump function for the entire register space
//				  Fixed bug FGT_Quad readout
//				  Add information when FGT is muted

//Version 	: 1.5
//Date		: 29/10/2021
//Changes	: Added continuous update of errorcount and core temp measurement while changing dynamically the internal noise
//				  Added support for PrbsLock_Alarm_Count and bitslip injection and detection
//				  Updated loop_reset to wait for rx_ready to be asserted instead of using fixed time and also measure the time it takes for the adaptation to be succesfull
//				  Added support for "muting" FGT Transmitters and new stress test '7' that uses this feature to mimic cable plug-in/pull-out
//				  Added support for rx_am_lock_alarm and rx_am_lock_alarm_count for RSFEC designs that support this feature
//			     Added support for scrambled_idle pattern for rsfec designs that support item
//				  Fixed bug that prevented the scrambler to be enabled by default.
//				  Updated printout of function 'c' to also include fec statistics
//            Added decimal support for temperature measurement
//				  Fixed PMA Pre-tap settings and read-out (official register map swapped post-tap with pre-tap)
//				  Fixed naming on GUI for RSFEC designs


//Version 	: 1.4
//Date		: 08/10/2021
//Changes	: Add pre-emphasis settings 
//				  use new functions rmw_channel_ftile/rd_channel_ftile/cpi_request_fgt to simplify the code
//				  add show_pma_settings_ftile (FGT only so far)
//				  fixed clearing reverse parallel loopback on FGT (FHT reverse parallel not yet implemented).
//				  allows to set the tx pre-emphasis settings of the phy (option 'g')
//				  implemented sweep pma function to sweep the Tx settings (option 'u')
//				  added tx and rx polarity inversion on FGT (not working properly)
//				  added rx_reset and tx_reset only control
//				  add support for internal noise logic (if enabled in the design)
//				  fixed 400G-4 implementation not to display the 2nd RSFEC codeword statistics as they are not applicable
//				  added support for ppm calculation when using recovered clock/66

//Version 	: 1.3
//Date		: 22/09/2021
//Changes	: Serial loopback is no longer being reset using FW195 : change code + add reset of adaptation (rx_reset)

//Version 	: 1.2
//Date		: 20/09/2021
//Changes	: Add support for 4 PHY's + FHT support (loopback etc.) + 100GBE-1 mode

//Version 	: 1.1
//Date		: 16/09/2021
//Changes	: Reverse Parallel loopback implemented + readback + various small updates.

//Version 	: 1.0
//Date		: 15/09/2021
//Revision	: initial release
 

//!!!!!!!!!!!!Important note!!!!!!!!!!!!!!
//main.c is written so the same file can be used across multiple desigsn, PMA direct, FEC direct, NRZ, PAM4
//with different number of PHYs and Lanes
//To match the configuration one needs to set the correct parameters in parameters.h


///////////////////////////////////////////////////////////////////////				
// parameters.h 
// Includes all design specific settings
///////////////////////////////////////////////////////////////////////	

#include "parameters.h"


#include "ehm_parameters.h"

#include <stdio.h>
#include "system.h"
#include "string.h"
#include "altera_avalon_pio_regs.h"
#include <unistd.h> 
#include <stdlib.h>
#include "io.h"
#include "altera_avalon_jtag_uart_regs.h"
#include "altera_avalon_i2c.h"
#include <ctype.h>
#include <time.h>
#include <math.h>
#include "sys/alt_timestamp.h"
#include "alt_types.h"
#include <fcntl.h>
#include <altera_s10_mailbox_client.h>
#include "altera_avalon_sysid_qsys_regs.h"

///////////////////////////////////////////////////////////////////////				
// optional compilation parameters
///////////////////////////////////////////////////////////////////////	

#define SHOW_TEMPERATURE 1
#define DEBUG_TEMPERATURE 0


#define USE_RESET 1
#define DEBUG_RESET 0

#define VERBOSE_READOUT 1
#define VERBOSE_SEARCH 1
#define DEBUG_SEARCH 0
#define DEBUG_SERIAL_LOOP 0
#define PROGRAM_PMA_SETTINGS_FGT 1
#define PROGRAM_PMA_SETTINGS_FHT 1

#define STOP_DURING_LOOPTEST 0

#define FORCE_SWIZZLE 1 //not used 
#define FORCE_INVERT_TX_POLARITY 0
#define FORCE_INVERT_RX_POLARITY 0

#define ONES 0xF
#define ZEROES 0



///////////////////////////////////////////////////////////////////////				
// input_functions.c
///////////////////////////////////////////////////////////////////////	

char input_char(void);

int input_number(void);

int input_byte(void);

int input_double(void);

int input_word(void);

int input_double_word(void);

///////////////////////////////////////////////////////////////////////				
// nphy_functions.h
///////////////////////////////////////////////////////////////////////	
#include "nphy_functions.h"


///////////////////////////////////////////////////////////////////////				
// PMA_functions_FTILE.h
///////////////////////////////////////////////////////////////////////	
#include "PMA_functions_FTILE.h"


///////////////////////////////////////////////////////////////////////				
// FEC_functions_FTILE.h
///////////////////////////////////////////////////////////////////////	
#ifdef RSFEC_USED
#include "FEC_functions_FTILE.h"
#endif


///////////////////////////////////////////////////////////////////////				
// channel_functions.c
///////////////////////////////////////////////////////////////////////	
#include "channel_functions.h"


///////////////////////////////////////////////////////////////////////				
// Other functions
///////////////////////////////////////////////////////////////////////	

void print_alarm(int value, int ok_value);
void print_alarm_superlite(int value, int ok_value);
void print_stat_unsigned_correctable(unsigned int value);
void print_stat_unsigned_alarm(unsigned int value);
unsigned int set_bit(unsigned int data, int bitpos);
unsigned int clear_bit(unsigned int data, int bitpos);

///////////////////////////////////////////////////////////////////////				
//  median
///////////////////////////////////////////////////////////////////////	

#define ELEM_SWAP(a,b) { register int  t=(a);(a)=(b);(b)=t; }


///////////////////////////////////////////////////////////////////////				
// Temperature helper functions
///////////////////////////////////////////////////////////////////////	

float convert_temperature( alt_u32 temperature_raw);


	
// Define all variables as global to make sure they are accounted for in the memory footprint and do not result in stack overflow

	char rx_char;
	char c;
	int Control_Reg[NUMBER_OF_PHYS];
	int Control2_Reg[NUMBER_OF_PHYS]; 
	int BER_Control[NUMBER_OF_PHYS]; 
	int Reset_Control_Reg[NUMBER_OF_PHYS]; 
	
	float tx_clk_divider[NUMBER_OF_PHYS_MAX];
	float rx_clk_divider[NUMBER_OF_PHYS_MAX];
	int high_datarate[NUMBER_OF_PHYS];

	int Bitrate_reg[NUMBER_OF_PHYS];
	int RxClock_Reg[NUMBER_OF_PHYS];
	float RxClock_Reg_tmp[NUMBER_OF_PHYS];
	float temp_float;
	float RefClock_Calculated[NUMBER_OF_PHYS];
	float Clock_Ratio[NUMBER_OF_PHYS];
	int ppm_difference[NUMBER_OF_PHYS];

	int fractional;
	float fractional_temp;
	float ppm_offset;

	int Bitrate[NUMBER_OF_PHYS];
	float Bitrate_temp[NUMBER_OF_PHYS];
	float Total_Aggregate_Rate;

	int Coreclockmultiplier[NUMBER_OF_PHYS_MAX];
	unsigned int Channel_Reg[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];



unsigned int Counter_1ms_Reg[NUMBER_OF_PHYS];
double BER[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
float BER_PMA[MAX_SWEEP_RANGE];	
float veye_symmetry_PMA[MAX_SWEEP_RANGE];  
double Totalbits[NUMBER_OF_PHYS];
unsigned int Hours[NUMBER_OF_PHYS];
unsigned int Minutes[NUMBER_OF_PHYS];
unsigned int Seconds[NUMBER_OF_PHYS];
unsigned int temp;
int temp_input; 
unsigned int readout;


int SelectedChannel[NUMBER_OF_PHYS];
//int Selected_Physical_Channel[NUMBER_OF_PHYS];  
int number_of_lanes[NUMBER_OF_PHYS];  
int number_of_physical_lanes[NUMBER_OF_PHYS];   
int number_of_segments[NUMBER_OF_PHYS]; 
int number_of_segments_lane[NUMBER_OF_PHYS];   
int use_dual_rsfec_codeword[NUMBER_OF_PHYS];
int number_of_virtual_lanes[NUMBER_OF_PHYS];   
int ethernet_mode[NUMBER_OF_PHYS];
int ethernet_mode_segment[NUMBER_OF_PHYS];  
int PrbsSelect[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int PrbsPattern[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int Selectedphy;

int Locked[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int Powerdown[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int PLL_Locked[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int Rx_FreqLocked[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
double ErrorCount[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX]; 
double ErrorCount_previous;
double ErrorCount_difference;

unsigned int ErrorCount_Reg_L[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
unsigned int ErrorCount_Reg_H[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int rx_termination[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int Serial_Loop[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int serial_loop_rdback[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];  
int rx_digitalreset[NUMBER_OF_LANES_MAX];
int lpm_mode[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int rx_am_lock[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX]; 
int tristate[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX]; 

int tx_vodctrl[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int tx_pretap_1[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int tx_pretap_2[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int tx_pretap_3[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];  
int tx_posttap_1[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];

int fht_tx_maintap[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int fht_tx_posttap_1[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int fht_tx_posttap_2[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int fht_tx_posttap_3[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int fht_tx_posttap_4[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int fht_tx_pretap_1[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int fht_tx_pretap_2[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int fht_tx_pretap_3[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];  


int i;
int j;
int t;
int k;
int d;
int vl;
int z;
int zero;
int BERInterval;
int TimeInterval;
int sys_id; 


int Reg_data;
int Ravail;
//  int TxRatematcherFull[NUMBER_OF_LANES_MAX];
//  int NOK;
//int Loopback_All;







//    int High_nibble;
//  int Low_nibble;

int Temperature;
int Rev_Parallel[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int Show_ErrorCount;
int set_lock_to_ref[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];




int dump_register_before[40000];
int dump_register_after[40000];


//These are all PHY based parameters
unsigned int FEC_Correctable_Codeword_Reg_L[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
unsigned int FEC_Correctable_Codeword_Reg_H[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX]; 
unsigned int FEC_UnCorrectable_Codeword_Reg_L[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX]; 
unsigned int FEC_UnCorrectable_Codeword_Reg_H[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];

unsigned int FEC_Correctable_Symbols_Reg_L[NUMBER_OF_PHYS][NUMBER_OF_VIRTUAL_LANES];
unsigned int FEC_Correctable_Symbols_Reg_H[NUMBER_OF_PHYS][NUMBER_OF_VIRTUAL_LANES];

unsigned int FEC_Correctable_Bits_0_1_Reg_L[NUMBER_OF_PHYS][NUMBER_OF_VIRTUAL_LANES];
unsigned int FEC_Correctable_Bits_0_1_Reg_H[NUMBER_OF_PHYS][NUMBER_OF_VIRTUAL_LANES]; 

unsigned int FEC_Correctable_Bits_1_0_Reg_L[NUMBER_OF_PHYS][NUMBER_OF_VIRTUAL_LANES];
unsigned int FEC_Correctable_Bits_1_0_Reg_H[NUMBER_OF_PHYS][NUMBER_OF_VIRTUAL_LANES];  

unsigned int FEC_Rx_Lane_Skew[NUMBER_OF_PHYS][NUMBER_OF_VIRTUAL_LANES]; 

unsigned int rsfec_corr_cwbin_cnt_0_3_A[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
unsigned int rsfec_corr_cwbin_cnt_4_7_A[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX]; 
unsigned int rsfec_corr_cwbin_cnt_8_11_A[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
unsigned int rsfec_corr_cwbin_cnt_12_15_A[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX]; 
unsigned int FEC_corr_cwbin_cnt_A[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX][16];
unsigned int previous_FEC_corr_cwbin_cnt_A[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX][16];  
unsigned int FEC_corr_cwbin_cnt_A_overrun[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX][16];  
unsigned int rsfec_highest_bin_count_A[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];

unsigned int rsfec_corr_cwbin_cnt_0_3_B[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
unsigned int rsfec_corr_cwbin_cnt_4_7_B[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX]; 
unsigned int rsfec_corr_cwbin_cnt_8_11_B[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
unsigned int rsfec_corr_cwbin_cnt_12_15_B[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX]; 
unsigned int FEC_corr_cwbin_cnt_B[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX][16];
unsigned int previous_FEC_corr_cwbin_cnt_B[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX][16]; 
unsigned int FEC_corr_cwbin_cnt_B_overrun[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX][16];  
unsigned int rsfec_highest_bin_count_B[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];

int value_found;		    

int FEC_Lane_Mapping[NUMBER_OF_PHYS][NUMBER_OF_VIRTUAL_LANES];

//per virtual lane

double FEC_Correctable_Codeword[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
double FEC_UnCorrectable_Codeword[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];



// per virtual lane
double FEC_Correctable_Symbols[NUMBER_OF_PHYS][NUMBER_OF_VIRTUAL_LANES];	  
double FEC_Correctable_Bits_0_1[NUMBER_OF_PHYS][NUMBER_OF_VIRTUAL_LANES];	 
double FEC_Correctable_Bits_1_0[NUMBER_OF_PHYS][NUMBER_OF_VIRTUAL_LANES];		  
double Corrected_symbols_rate[NUMBER_OF_PHYS][NUMBER_OF_VIRTUAL_LANES];	  

double Ratio_Correctable_Bits_over_Corrected_Symbols[NUMBER_OF_PHYS][NUMBER_OF_VIRTUAL_LANES];
double Ratio_Correctable_Symbols_over_Corrected_Codeword[NUMBER_OF_PHYS][NUMBER_OF_VIRTUAL_LANES];	  

//per FEC	
double Precorrected_BER[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
double FEC_Correctable_Bits_Total[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];	 
double ErrorCount_Total[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];	 
double Total_Correctable_Symbols[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
double Total_Correctable_Codeword[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];	  
double Totalbits_per_fec[NUMBER_OF_PHYS];

//per phy  
double	Total_Correctable_Symbols_Aggr[NUMBER_OF_PHYS];
double	FEC_Correctable_Bits_Total_Aggr[NUMBER_OF_PHYS];
double	ErrorCount_Total_Aggr[NUMBER_OF_PHYS];
double	Totalbits_Aggr[NUMBER_OF_PHYS];
double BER_Aggr[NUMBER_OF_PHYS];

double Precorrected_BER_Aggr[NUMBER_OF_PHYS];	 
double Corrected_symbols_rate_Aggr[NUMBER_OF_PHYS];		  



//int control_bit;
//  int area;
//  int area_PMA[MAX_SWEEP_RANGE];
//  int eyeheight_Maximum;
//  int eyeheight_Maximum_setting;

float veye_symmetry_Maximum;	
int	 veye_symmetry_Maximum_setting;

int eyeheight_PMA[MAX_SWEEP_RANGE];
int eyeheight_Maximum;
int eyeheight_Maximum_setting;

int good_setting_found;
int method;
int tap1[MAX_SWEEP_RANGE];
int tap2[MAX_SWEEP_RANGE];
int tap3[MAX_SWEEP_RANGE];
int sign;

int stop_value;
int stop_value_found;
int ac_gain_optimal;
int ac_gain_original;

//int vref;


int sweep_max[NUMBER_OF_LANES_MAX];
int sweep_param[NUMBER_OF_LANES_MAX];
//  int sweep_param2[NUMBER_OF_LANES_MAX];
int channel;
int sweep_low;
int sweep_high;
int step_size;


int best_setting;
int best_setting_BER;
int best_setting_EYE;  
int best_setting_EYE_symmetry;
float BER_Minimum;
int BER_Minimum_setting;
int optimum_range;
int start_value;
int start_value_found;
int end_value;
int channel_type[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int cdr_refclk;

int dummy_read;





int HWVersion_Day;
int HWVersion_Month;
int HWVersion_Year;
int HWSubversion;
int connection_type[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];  


int silicon_rev;
clock_t timestamp,timestamp1,timestamp2,timestamp3;
double time_taken[LOOPCOUNT];

int tx;
int tx_phy;
int rx;

int pll_type;

int NOK;
int ChannelOK[NUMBER_OF_PHYS];

int datarate[NUMBER_OF_PHYS];

int ChannelOK_ch[NUMBER_OF_LANES_MAX];
int channel_is_locked;	

int readback;


int original_tx_vodctrl[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int line_encoding[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int gray_encoding[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int encoding_1_1plusd[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int swizzle[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];	
int invert_rx_polarity[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int invert_tx_polarity[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];  	
int rx_ready[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int tx_ready[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];	
int EID[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int use_EID[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int one_channel_only;
int vod;
int allchannels_locked;
int allchannels_errorfree;
int all_phys_locked;
int pma_direct_pam4_mode_used;
double allchannels_errorcount;
int stop;
double previous_value;


int lower_even;
int middle_even;
int upper_even;
int lower_odd;
int middle_odd;
int upper_odd;

int error_ureset;
int eye_correct;
int final_adaptation;

int phy_global;
int channel_offset_global;

int i2c_address;
int module_present[NUMBER_OF_PHYS];
int page;

int qsfpdd0_present;
int qsfpdd1_present;	
int qsfpdd800_present;

unsigned int module_output;
unsigned int module_input;

int etile_adaptation_start_condition;
int pma_configuration[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int pwm_duty_ctrl;
int temperature_module;
int vendor;
int dac;

int previous_adaptation;

int firmware;
int firmware_variant;
int first_time;

int insertion_detected;
int channel_is_locked;
int rx_ready_combined;
int rx_freqlocked_1ms[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int first_occurrence;
int EID_combined;

int GS1,GS2,B0,B1;
int LF_MAX,LF_MIN,HF_MAX,HF_MIN;	
int first_iadp;
int second_iadp;
int final_adaptation;

alt_u32 time1;
alt_u32 time2;
alt_u32 time3; 

int adaptation_busy;

int offset[NUMBER_OF_PHYS];
int offset_pdp[NUMBER_OF_PHYS];	
unsigned int address;
unsigned int address_dump[100];

int GainLF;
int GainHF;
int eyeheight;

int tx_pma_ready;
int rx_pma_ready;

int new_value;
int toggle = 0;


int display_phy[NUMBER_OF_PHYS];
int display_Selectedphy_only = 0;

int PrbsLockAlarm[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int rx_am_lock_alarm[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];	
int refclk_index[NUMBER_OF_PHYS];

int tx_reset_ack[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int rx_reset_ack[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];	
int tx_reset_ack_combined;
int rx_reset_ack_combined;

///////////////////////////////////////////////////////////////////////				
// Superlite II/IV variables
///////////////////////////////////////////////////////////////////////

int Userdatarate[NUMBER_OF_PHYS];
float Userdatarate_temp[NUMBER_OF_PHYS]; 
float Efficiency[NUMBER_OF_PHYS];
int WordAligned[NUMBER_OF_PHYS];
int LaneAligned[NUMBER_OF_PHYS];
int Error_Deskew[NUMBER_OF_PHYS];
int Fifo_Error[NUMBER_OF_PHYS];
int Latency_Max[NUMBER_OF_PHYS];
int Latency_Max_Reg[NUMBER_OF_PHYS];  
unsigned int Skew_Reg[NUMBER_OF_PHYS];
int Skew[NUMBER_OF_PHYS][NUMBER_OF_FECS_PHY];
float latency_max_measure_temp[NUMBER_OF_PHYS];
float latency_min_measure_temp[NUMBER_OF_PHYS];
int Lane_identifier[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX]; 
int Latency_Memory[RESET_CYCLES];
int Latency_Minimum;
int Latency_Maximum;
int hist[256];
float Ratio;
int LinkUp[NUMBER_OF_PHYS];
int XOFF_Received[NUMBER_OF_PHYS];
int XOFF[NUMBER_OF_PHYS]; 
int throttle_datarate[NUMBER_OF_PHYS];
int DataClock_Out_Reg[NUMBER_OF_PHYS];
int LockAlarm[NUMBER_OF_PHYS];



// Functions below rely on global variables.


void reset_phy(int phy, int use_reset);
void reset_channel(int phy,int channel);
void reset_assert_channel(int phy,int channel);
void reset_deassert_channel(int phy,int channel);
void reset_rx_channel(int phy,int channel);
void reset_tx_channel(int phy,int channel);
void reset_rx_assert_phy(int phy);
void reset_rx_deassert_phy(int phy);
void reset_rx_assert_channel(int phy,int channel);
void reset_rx_deassert_channel(int phy,int channel);
void clear_counters(int phy);



void loop_reset (int loopcount, int timeout_adaptation, int stresstest);
void loop_reset_2 (int loopcount);
void loop_reset_rx (int loopcount);
void loop_reset_rx_until_all_rx_good(int loopcount);
void loop_reset_rx_until_rx_good(int loopcount);
void loop_mute_tx(int loopcount);
void loop_avmm (int loopcount);
void loop_latency(int loopcount);

void readback_loopbacks(int phy);
void readback_polarity(int phy);
void set_serial_loopback_fgt(int phy);

void perform_ehm(int phy, int channel, int ber_target);
void show_time_estimate_ehm(int ber_target);



int serial_loopback_detected;

int clock_switch = 0;

int fec_mode[NUMBER_OF_PHYS];
int kpfec[NUMBER_OF_PHYS];
int clk_divider[NUMBER_OF_PHYS]; 
int pma_direct_mode[NUMBER_OF_PHYS];
int pam4_mode[NUMBER_OF_PHYS_MAX];
int pma_direct_pam4_mode[NUMBER_OF_PHYS];
int enable_scrambler[NUMBER_OF_PHYS];
int fec_read;

int enable_noise_chunks;
int enable_noise_chunks_Reg;
int internal_noise_enabled;
int number_of_noise_chunks;
int int_noise_percentage;
int noise_floor_max;

unsigned int PrbsLock_Alarm_Count[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
unsigned int PrbsLock_Alarm_Count_Alt[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
unsigned int rx_am_lock_alarm_count[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
unsigned int Bitslip_Count[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
unsigned int Bitslip_Count_Alt[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int prbslock_alarm_counter_present[NUMBER_OF_PHYS];
int rx_am_lock_alarm_counter_present[NUMBER_OF_PHYS];
int phy;
int chan;
double FEC_Correctable_Codeword_previous;
double Corrected_Codeword_difference;
int scrambled_idle_pattern[NUMBER_OF_PHYS];
int FGT_Quad[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int Quad_Channel[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int number_of_fecs[NUMBER_OF_PHYS];
int Fom[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int tx_channel_muted[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];

int BER_Rate[NUMBER_OF_PHYS];
int BER_Enable[NUMBER_OF_PHYS];
int Threshold[NUMBER_OF_PHYS];

int media_mode[NUMBER_OF_PHYS];
int fw_196_detected;
int i2c_access_enabled;

int vertical_eye_fgt_middle[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int vertical_eye_fgt_middle_pos[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int vertical_eye_fgt_middle_neg[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];

int vertical_eye_fgt_top[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int vertical_eye_fgt_top_pos[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int vertical_eye_fgt_top_neg[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];

int vertical_eye_fgt_bot[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int vertical_eye_fgt_bot_pos[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int vertical_eye_fgt_bot_neg[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];

int ehm_time_estimate_in_ms;


int fgt_pam4[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX];
int ber_target;

int stop;



///////////////////////////////////////////////////////////////////////				
//Mailbox client variables
///////////////////////////////////////////////////////////////////////		

//mailbox_client_send_cmd (intel_mailbox_client* fd, alt_u8 id, alt_u32 cmd, alt_u32* arg, int
//arg_length, int cmd_length, alt_u32* input_data, alt_u32* resp_buf, alt_u32* resp_buf_len)

#define ARG_SIZE 2
#define INPUT_DATA 1024			//ANY NUMBER IS FINE ( AT LEAST THE EXPECTED NUMBER )
#define RESP_BUF_SIZE 1024		//ANY NUMBER IS FINE ( AT LEAST THE EXPECTED NUMBER )


intel_mailbox_client* fp;
alt_u8 id;
alt_u32 cmd;
alt_u32 arg[ARG_SIZE];
int arg_length;
int cmd_length;
alt_u32 input_data[INPUT_DATA];
alt_u32 resp_buf[RESP_BUF_SIZE];
alt_u32 resp_buf_len;
int ret_code;

float sdm_temperature;
float core_temperature[4];
float tile_temperature[4];
int random_number; 
double random_factor;

///////////////////////////////////////////////////////////////////////				
// Sweep functions
///////////////////////////////////////////////////////////////////////


void sweep_pma_setting (int tx_phy, int tx, int rx_phy, int rx, int pma_setting, int method, int step_size);
int find_best_setting(int method, int step_size);


///////////////////////////////////////////////////////////////////////				
// Capture temperature
///////////////////////////////////////////////////////////////////////

void capture_temperature(void);

void print_bar (int input);
void print_bar_temperature (int input);
void print_bar_noise (int input);
void print_bar_tree (int input);
void print_bar_histogram(int input);
void print_chip (int Core_Temp,int Tile1_Temp,int Tile2_Temp, int Tile3_Temp, int Tile4_Temp, int Tile5_Temp, int Tile6_Temp);
void histogram(void);



///////////////////////////////////////////////////////////////////////				
// I2C functions
///////////////////////////////////////////////////////////////////////
void check_module_presence(void);
void check_module_presence_fpc202(int i2c_interface);
void i2c_readout(int i2c_interface,int slave_address);
void i2c_dump(int i2c_interface,int slave_address);
void i2c_setupfpc202(int i2c_interface); //not used right now


///////////////////////////////////////////////////////////////////////				
// Randomize functions
///////////////////////////////////////////////////////////////////////

void srand ( unsigned int seed );
int rand (void);

///////////////////////////////////////////////////////////////////////				
// Fec functions
///////////////////////////////////////////////////////////////////////
#ifdef RSFEC_USED
void collect_fec_statistics(void);
void calculate_fec_statistics(void);
void print_fec_statistics(int t);
int determine_channel(int z);
void fec_tree (int phy);
#endif

///////////////////////////////////////////////////////////////////////				
// FHT related functions 
///////////////////////////////////////////////////////////////////////
void program_tx_pma_settings_fht(int phy, int channel, int offsephy,int mute);


///////////////////////////////////////////////////////////////////////				
// Math functions 
///////////////////////////////////////////////////////////////////////

	float X_top[NUMBER_OF_EHM_EXTRAPOLATIONS];
	float X_middle[NUMBER_OF_EHM_EXTRAPOLATIONS];
	float X_bot[NUMBER_OF_EHM_EXTRAPOLATIONS];	
	float Q[NUMBER_OF_EHM_EXTRAPOLATIONS];
	float phase_step_per_sigma_top;
	float phase_step_per_sigma_middle;
	float phase_step_per_sigma_bot;
	int ber_target_extrapolate[NUMBER_OF_EHM_EXTRAPOLATIONS];
	

	float estimated_EYE_top;
	float estimated_EYE_middle;
	float estimated_EYE_bot;	
	
	float B_Depth[NUMBER_OF_EHM_EXTRAPOLATIONS];
	



double calculate_Q(int ber_target)
{
  //return M_SQRT2 * erfinv(1 - 2 * ber);
double Q;
 
  switch (ber_target)
  {
	 case 4 :  Q = M_SQRT2 * ERINV_1E4; break;
	 case 5 :  Q = M_SQRT2 * ERINV_1E5; break;
	 case 6 :  Q = M_SQRT2 * ERINV_1E6; break;
	 case 7 :  Q = M_SQRT2 * ERINV_1E7; break;
	 case 8 :  Q = M_SQRT2 * ERINV_1E8; break;
	 case 9 :  Q = M_SQRT2 * ERINV_1E9; break;
	 case 10 :  Q = M_SQRT2 * ERINV_1E10; break;
	 case 11 :  Q = M_SQRT2 * ERINV_1E11; break;
	 case 12 :  Q = M_SQRT2 * ERINV_1E12; break;
	 case 13 :  Q = M_SQRT2 * ERINV_1E13; break;
	 case 14 :  Q = M_SQRT2 * ERINV_1E14; break;
	 case 15 :  Q = M_SQRT2 * ERINV_1E15; break;
	 case 16 :  Q = M_SQRT2 * ERINV_1E16; break;
	 case 17 :  Q = M_SQRT2 * ERINV_1E17; break;
	 case 18 :  Q = M_SQRT2 * ERINV_1E18; break;
	 case 19 :  Q = M_SQRT2 * ERINV_1E19; break;
	 case 20 :  Q = M_SQRT2 * ERINV_1E20; break;
	 default :  Q = 1; break; 
  }
  return (Q);
}


int main()
{ 

		printf ("Print the value of System ID \n");
        sys_id = IORD_ALTERA_AVALON_SYSID_QSYS_ID(SYSID_QSYS_0_BASE);
        printf ("System ID from Peripheral core is 0x%X \n",sys_id);



srand(time(NULL));   // Initialization, should only be called once.

  //HWVersion = 	 IORD_ALTERA_AVALON_PIO_DATA(VERSION_BASE) >> 8;
  HWVersion_Day = (IORD_ALTERA_AVALON_PIO_DATA(VERSION_BASE) & (0xFF000000)) >> 24;
  HWVersion_Month = (IORD_ALTERA_AVALON_PIO_DATA(VERSION_BASE)  & (0x00FF0000)) >> 16;	
  HWVersion_Year = (IORD_ALTERA_AVALON_PIO_DATA(VERSION_BASE)  & (0x0000FF00)) >> 8;		
  HWSubversion = IORD_ALTERA_AVALON_PIO_DATA(VERSION_BASE) & (0x000000FF);
	
	printf("\nStarting design...");  
	printf("\n");



	
	//Enable  QSFPDD0 and QSFPDD1 modules by default (high power mode and reset set to high)
	module_output = 0x00733777;

  //pwm_duty_ctrl <= module_output_reg(26 downto 24);
	//Fan control (set to 3'b011") 
	//Not used here.
	pwm_duty_ctrl = 0x3;
	
	module_output = (pwm_duty_ctrl << 24) | module_output;	
	//module_output = 0x04333333;	
	
	i2c_access_enabled = 0;
	
	if (AGILEX_SI_BOARD)
	{
		printf("\nDo you want to enable I2C functionality (select No in case you have I2C devices that have issues with readout)");
		printf("\nSelect Y(Yes) or N(no) :");
		rx_char = input_char();
		if ((rx_char == 'Y') || (rx_char == 'y'))
			i2c_access_enabled = 1;
		else
			i2c_access_enabled = 0;
		
		if (i2c_access_enabled == 1)
		{
			IOWR_ALTERA_AVALON_PIO_DATA(MODULE_OUTPUT_REG_BASE,module_output);			
			check_module_presence();		
		}		
	}
	
	if (AGILEX_PCIE_DEVKIT)
	{ 
	printf("\nDo you want to enable I2C functionality (requires HW modification for Agilex I-Series PCIe devkit ES Version, otherwise it might hang with certain modules");
	printf("\nSelect Y(Yes) or N(no) :");
	rx_char = input_char();
	if ((rx_char == 'Y') || (rx_char == 'y'))
		i2c_access_enabled = 1;
	else
		i2c_access_enabled = 0;
	
	// printf("i2c_access_enabled = %d",i2c_access_enabled);
	// rx_char = input_char();

		if (i2c_access_enabled == 1)
		{
			check_module_presence_fpc202(0);		
			// rx_char = input_char();
		}
	}
	

  /*******************************/ 	
  /*  Internal noise specific    */
  /*******************************/ 			

   module_input = IORD_ALTERA_AVALON_PIO_DATA(MODULE_INPUT_REG_BASE); 
	internal_noise_enabled = 0x0001 & (module_input >> 31);	
	
      noise_floor_max = 0;
		
		for (i=0;i < NUMBER_OF_WABS;i++)
		{
			noise_floor_max = noise_floor_max + (1 << i);
		}
		if (internal_noise_enabled == 1)
			printf("\nnoise_floor_max = 0x%x",noise_floor_max);



  

  /**********************************************************************/
  /*  Setup design specific assignments    */
  /**********************************************************************/ 		


	  for (t = 0; t < NUMBER_OF_PHYS_MAX ; t++)
	  {
			switch (t)
			{
				case 0 : pam4_mode[0] = PHY0_PAM4_DESIGN; 
							Coreclockmultiplier[0] = PHY0_CORECLK_MULTIPLIER;
							tx_clk_divider[0] = PHY0_TX_CLK_DIVIDER;
							rx_clk_divider[0] = tx_clk_divider[0];
							break;
				case 1 : pam4_mode[1] = PHY1_PAM4_DESIGN; 
							Coreclockmultiplier[1] = PHY1_CORECLK_MULTIPLIER;
							tx_clk_divider[1] = PHY1_TX_CLK_DIVIDER;
							rx_clk_divider[1] = tx_clk_divider[1];
							break;
				case 2 : pam4_mode[2] = PHY2_PAM4_DESIGN; 
							Coreclockmultiplier[2] = PHY2_CORECLK_MULTIPLIER;
							tx_clk_divider[2] = PHY2_TX_CLK_DIVIDER;
							rx_clk_divider[2] = tx_clk_divider[2];
							break;
				case 3 : pam4_mode[3] = PHY3_PAM4_DESIGN; 
							Coreclockmultiplier[3] = PHY3_CORECLK_MULTIPLIER;
							tx_clk_divider[3] = PHY3_TX_CLK_DIVIDER;
							rx_clk_divider[3] = tx_clk_divider[3];
							break;						
				default:break;
			}
	  }
	
	  for (t = 0; t < NUMBER_OF_PHYS ; t++)
	  { 
  		
		Control_Reg[t]  = 0x0000;
	
		if (PAM4_50GBE) // this can be extended for other configurations.
		{
			fec_mode[t]  = FRACTURED_50GBE; 
			ethernet_mode[t] = GBE50;	
			ethernet_mode_segment[t] = 0;
		}
		else if (PAM4_100GBE_FRACTURED) 
		{
			fec_mode[t]  = FRACTURED_100GBE; 
			ethernet_mode[t] = GBE100;	 
			ethernet_mode_segment[t] = 2;		
		}
		else if (PAM4_100GBE_AGGREGATE) 
		{
			fec_mode[t]  = AGGREGATE_100GBE; 
			ethernet_mode[t] = GBE100;	 
			ethernet_mode_segment[t] = 2;		//should this be 0
		}			
		else if (PAM4_200GBE) 
		{
			fec_mode[t]  = AGGREGATE_200GBE; 
			ethernet_mode[t] = GBE200;	 
			ethernet_mode_segment[t] = 4;	
		}	
		else if (PAM4_400GBE) 
		{
			fec_mode[t]  = AGGREGATE_400GBE; 
			ethernet_mode[t] = GBE400;	 
			ethernet_mode_segment[t] = 8;		
		}		
		else if (NRZ_GBE25)
		{
			fec_mode[t]  = FRACTURED; 
			ethernet_mode[t] = GBE25;	 
			ethernet_mode_segment[t] = 0;					
		}
		else 
		{
		
	   fec_mode[t]  = FRACTURED;
		ethernet_mode[t] = 0;
		}

		number_of_lanes[t] = NUMBER_OF_LANES_PHY;	  
		number_of_physical_lanes[t] = NUMBER_OF_LANES_PHY;	 
		number_of_segments[t] = NUMBER_OF_SEGMENTS; //PER FEC
		number_of_segments_lane[t] = NUMBER_OF_SEGMENTS_LANE; 
		use_dual_rsfec_codeword[t] = DUAL_RSFEC_CODEWORD;
		number_of_virtual_lanes[t] = NUMBER_OF_VIRTUAL_LANES;

      pma_direct_mode[t] = PMA_DIRECT_MODE;	
		if ((pma_direct_mode[t] == 1) && (pam4_mode[t] == 1))
			pma_direct_pam4_mode[t] = 1;
		
      prbslock_alarm_counter_present[t] = PRBSLOCK_ALARM_COUNTER_USED;
      rx_am_lock_alarm_counter_present[t] = RX_AM_LOCK_ALARM_COUNTER_USED;		
		enable_scrambler[t] = USE_SCRAMBLER;	  
		if (SUPERLITE_USED == 0)
			Control_Reg[t] = (Control_Reg[t] & (0xEFFF)) | (enable_scrambler[t] << 12);			
      kpfec[t] = USE_KPFEC;	
		scrambled_idle_pattern[t] = 0;
		if (SUPERLITE_USED == 0)		
			Control_Reg[t] = (Control_Reg[t] & (0xFBFF)) | (scrambled_idle_pattern[t] << 10);					
		
		
		  
		Channel_Reg[t][0]      =  Read_Channel_Reg(t,0);	 
		  
		#ifdef SUPERLITE_ENABLED
			throttle_datarate[t] = 0;
		 
			if (throttle_datarate[t] == 1)
			  Control_Reg[t] = Control_Reg[t] | (0x0400);
			else
			  Control_Reg[t] = Control_Reg[t] & (0xFBFF);	
		#endif

			write_control_reg(t,Control_Reg[t]);			

		
			Control2_Reg[t] = 0x0000;
			write_control2_reg(t,Control2_Reg[t]);
	}

	
  /**********************************************************************/
  /*  Define channel setup matching hardware setup                      */
  /**********************************************************************/ 	

  for (t = 0; t < NUMBER_OF_PHYS ; t++)
  {
	SelectedChannel[t] = 0; // Default Selected Channel is channel 0 in each phy
  }


Selectedphy = 0;
	



/**********************************************************************/
/*  Setup channels 			                                          */
/**********************************************************************/  




	for (t = 0; t < NUMBER_OF_PHYS ; t++)
	{
		for (i = 0; i < number_of_physical_lanes[t] ; i++)
		{  
			if (FHT_USED)
				channel_type[t][i] = FHT_DEFAULT;
			else
				channel_type[t][i] = FGT_DEFAULT ;
			
			
			if (FHT_USED)
			{
				if (AGILEX_HS_DEMO_KIT)
					connection_type[t][i] = OSFP; 
				else if (AGILEX_SI_BOARD)
					connection_type[t][i] = QSFPDD800;
			}
			else 
			{
				if ((AGILEX_PCIE_DEVKIT) || (AGILEX_MUDV_BOARD) || (AGILEX_MGM_BOARD) || (AGILEX_FM86_BOARD))
					connection_type[t][i] = QSFPDD; 
				else if (AGILEX_SI_BOARD)
				{
					switch (t)
					{
					case 0 : connection_type[t][i] = AGILEX_SI_BOARD_PHY_0_CONNECTION_TYPE; break;
					case 1 : connection_type[t][i] = AGILEX_SI_BOARD_PHY_1_CONNECTION_TYPE; break;
					case 2 : connection_type[t][i] = AGILEX_SI_BOARD_PHY_2_CONNECTION_TYPE; break;
					case 3 : connection_type[t][i] = AGILEX_SI_BOARD_PHY_3_CONNECTION_TYPE; break;
					default : connection_type[t][i] = QSFPDD; 
					}
				}
				else if (AGILEX_HS_DEMO_KIT)
				{
					connection_type[t][i] = FMC;
				}
			}
					
			
			tristate[t][i] = 0;
			//rx_digitalreset[i] = 0;
			if (pam4_mode[t] == 1)
				line_encoding[t][i] = PAM4;		  
			else
				line_encoding[t][i] = NRZ;
			
			if (FORCE_SERIAL_LOOPBACK_FGT)
				Serial_Loop[t][i] = 1;
			else
				Serial_Loop[t][i] = 0;		
			
		}
		

		
		if (FHT_USED == 0)	
			readback_polarity(t);
	}
	

	
/**********************************************************************/
/*  Set PRBS-Pattern to PRBS31                                        */
/**********************************************************************/  


for (t = 0; t < NUMBER_OF_PHYS ; t++)
{
	for (i = 0; i < number_of_lanes[t] ; i++)
	{

		if (SUPERLITE_USED)
		PrbsSelect[t][i] = PRBS_23;
		else
		{
			if ((pam4_mode[t] == 1) || (USE_128BIT_PRBS_NRZ))
			{ 				 
				PrbsSelect[t][i] = PRBS_31_PAM4;
				//PrbsSelect[t][i] = PRBS_13_PAM4; 	  
				//PrbsSelect[t][i] = PRBS_7_PAM4;  
			}
			else
			{
				PrbsSelect[t][i] = PRBS_31;
				//PrbsSelect[t][i] = PRBS_7; 	  
			}
		}
		
		
		Control2_Reg[t] = (Control2_Reg[t] & (0xFFE0)) | ( i ); // Select channel
		write_control2_reg(t,Control2_Reg[t]);

		
		Control2_Reg[t] = Control2_Reg[t] | (0x1000); /* Latch PrbsPattern Assert */
		write_control2_reg(t,Control2_Reg[t]);
		usleep(10);  
		
		Control2_Reg[t] = (Control2_Reg[t] & (0xF8FF)) | (PrbsSelect[t][i] << 8); 
		write_control2_reg(t,Control2_Reg[t]);
		
		Control2_Reg[t] = Control2_Reg[t] & (0xEFFF); /* Latch PrbsPattern Deassert */
		write_control2_reg(t,Control2_Reg[t]);
	}
	

	
	

	
	//Control_Reg = reconfigure_channels(Control_Reg,Disable_FEC);	
	


	Control2_Reg[t] = (Control2_Reg[t] & (0xFFE0));
	write_control2_reg(t,Control2_Reg[t]);

	display_phy[t] = 1;

}

		
	  
/**********************************************************************/
/*  Configure PMA Settings                                                */
/**********************************************************************/  				 





for (t = 0; t < NUMBER_OF_PHYS ; t++)
{ 

	if (BYTE_ADDRESSING_USED == 1)
	{
		offset[t] = CHANNEL_OFFSET + 2;	
		offset_pdp[t] = CHANNEL_OFFSET_PDP + 2;
	}
	else
	{

		offset[t] = CHANNEL_OFFSET;	
		offset_pdp[t] = CHANNEL_OFFSET_PDP;
	}
	
	for (j = 0; j < number_of_lanes[t] ; j++)
	{ 
		
		

		
		// for (i=0x101c1;i<0x10722;i++)
		// {
		// temp = rd_channel(t,(j << offset[t]) + i);
		// printf("\n===> Phy %1d xcvr_reconfiguration_interface Ch %1d Address 0x%x Read = 0x%x",t,j,i, temp);		  
		// }

		// temp = rd_channel(t,(j << offset[t]) + 0x101c1);
		// printf("\n===> Phy %1d xcvr_reconfiguration_interface Ch %1d Address 0x%x Read = 0x%x",t,j,(j << offset[t]) + 0x101c1, temp);		
		
		temp = rd_channel(t,(j << offset[t]) + 0x44000);
		printf("\nPhy %1d xcvr_reconfiguration_interface Ch %1d Address 0x44000 Read = 0x%x",t,j, temp);	

		temp = rd_channel(t,(j << offset[t]) + 0x41BB8);
		printf("\nPhy %1d xcvr_reconfiguration_interface Ch %1d Address 0x41BB8 Read = 0x%x",t,j, temp);	
		
		
		temp = rd_channel(t,(j << offset[t]) + 0xFFFFC);
		printf("\nPhy %1d xcvr_reconfiguration_interface Ch %1d Address 0xFFFFC Read = 0x%x",t, j, temp);	
		
		temp = rd_channel(t,(j << offset[t]) + 0x7001C);
		printf("\nPhy %1d xcvr_reconfiguration_interface Ch %1d Address 0x%x Read = 0x%x",t,j,(j << offset[t]) + 0x7001C, temp);			
		
		printf("\n");
		


		for (i=0x60C0;i<=0x617C;i+=4)
		{
			temp = rd_pdp_channel(t,(j << offset_pdp[t]) + i);
			printf("\n===> Phy %1d pdp_reconfiguration_interface Ch %1d Address 0x%x Read = 0x%x",t,j,i, temp);		  
		}	
	}
}  

/**********************************************************************/
/*  Determine mapping of FGT_Quad and channels    */
/**********************************************************************/ 	
for (t = 0; t < NUMBER_OF_PHYS ; t++)
{  

	for (j = 0; j < number_of_lanes[t] ; j++)
	{ 
		temp = rd_channel(t,(j << offset[t]) + 0xFFFFC);
		FGT_Quad[t][j] = (temp & (0x0000000C)) >> 2;
		Quad_Channel[t][j] = temp & (0x00000003);
	}
}

if (FHT_USED)
	firmware = rd_channel(0,0x6187c); //FHT Firmware
else
	firmware = rd_channel(0,0x7001C); //FGT Firmware

if ((firmware & 0x0000FFFF) == 0x196)
	fw_196_detected = 1;
else
	fw_196_detected = 0;



	

  /**********************************************************************/
  /*  Set gray encoding, 1+1D encoding, swizzle and polarity            */
  /**********************************************************************/  
 
 
for (t = 0; t < NUMBER_OF_PHYS ; t++)
{ 
	for (j = 0; j < number_of_physical_lanes[t] ; j++)
	{ 
		if (line_encoding[t][j] == NRZ)
		{
			gray_encoding[t][j] = 0; // gray encoding disabled 
			encoding_1_1plusd[t][j] = 0; // disabled by default
			swizzle[t][j] = 0;		  
		}
		else
		{
			gray_encoding[t][j] = 1; // gray encoding enabled
			encoding_1_1plusd[t][j] = 0; // disabled by default
			
			if (FORCE_SWIZZLE)
			swizzle[t][j] = 1;
			else
			swizzle[t][j] = 0;
		}	  
		
		if (FORCE_INVERT_TX_POLARITY)
		invert_tx_polarity[t][j] = 1;
		else
		invert_tx_polarity[t][j] = 0;
		
		if (FORCE_INVERT_RX_POLARITY)
		invert_rx_polarity[t][j] = 1;
		else
		invert_rx_polarity[t][j] = 0;
		
		
	}
} 
 

  /**********************************************************************/
  /*  Invert polarity for FM86 board on Quad3 and quad 2 to match the swaps on the board                           			 */
  /**********************************************************************/  
  
if ((AGILEX_FM86_BOARD) && (FORCE_SERIAL_LOOPBACK_FGT == 0))
{
	//Quad 3
	invert_tx_polarity[0][1] = 1;
	invert_tx_polarity[0][2] = 1;
	invert_tx_polarity[0][3] = 1;	

	//Quad 2
	if (NUMBER_OF_PHYS > 1)
	{
	invert_tx_polarity[1][1] = 1;
	invert_tx_polarity[1][2] = 1;
	}
	
}
 
 
 
 
 Selectedphy = 0;
 

   /**********************************************************************/
  /*  Set Reverse Parallel Loopback                             			 */
  /**********************************************************************/  

 
 
for (t = 0; t < NUMBER_OF_PHYS ; t++)
{ 
	for (j = 0; j < number_of_physical_lanes[t] ; j++)
	{ 

		Rev_Parallel[t][j] = 0; // no reverse parallel loopback by default

	}
}  


	 

  /**********************************************************************/
  /*  Configure PMA Settings                                                */
  /**********************************************************************/  				 

for (t = 0; t < NUMBER_OF_PHYS ; t++)
{ 
	printf("\nProgram the PMA settings of the channels on phy %d ....",t);
	for (j = 0; j < number_of_physical_lanes[t] ; j++)
	{
		
		if (FHT_USED == 0)
		{

			if (channel_type[t][j] == BACKPLANE)
			{
				tx_vodctrl[t][j]    		= BACKPLANE_VOD; 
				tx_pretap_2[t][j] 		= PRE_TAP2_0;		 
				tx_pretap_1[t][j]   		= PRE_TAP1_0;
				tx_posttap_1[t][j]  		= POST_TAP1_0; 		  
			}
			else if (channel_type[t][j] == DAC)
			{
				
				tx_vodctrl[t][j]    		= QSFP_DD_VOD ; 
				tx_pretap_2[t][j] 		= PRE_TAP2_0;		 
				tx_pretap_1[t][j]   		= PRE_TAP1_0;
				tx_posttap_1[t][j]  		= POST_TAP1_0; 			  
			}	
			
			else if (channel_type[t][j] == FGT_DEFAULT)
			{
				tx_vodctrl[t][j]    		= 0x23; 
				tx_pretap_2[t][j] 		= 0x0;		 
				tx_pretap_1[t][j]   		= 0x5;
				tx_posttap_1[t][j]  		= 0x0;		  
				
			}	
			else if (channel_type[t][j] == ELECTRICAL)
			{
				tx_vodctrl[t][j]    		= ELECTRICAL_VOD; 
				tx_pretap_2[t][j] 		= PRE_TAP2_0;		 
				tx_pretap_1[t][j]   		= PRE_TAP1_0;
				tx_posttap_1[t][j]  		= POST_TAP1_0;		  
				
			}	 
			else if (channel_type[t][j] == CHIP2CHIP)
			{
				tx_vodctrl[t][j]    		= SERIAL_LPBK_VOD; 
				tx_pretap_3[t][j] 		= PRE_TAP3_0;
				tx_pretap_2[t][j] 		= PRE_TAP2_0;		 
				tx_pretap_1[t][j]   		= PRE_TAP1_0;
				tx_posttap_1[t][j]  		= POST_TAP1_0;	   
			}		
			
			else // SHORT
			{
				
				tx_vodctrl[t][j]    		= SERIAL_LPBK_VOD; 
				tx_pretap_3[t][j] 		= PRE_TAP3_0;
				tx_pretap_2[t][j] 		= PRE_TAP2_0;		 
				tx_pretap_1[t][j]   		= PRE_TAP1_0;
				tx_posttap_1[t][j]  		= POST_TAP1_0; 
			}	
			original_tx_vodctrl[t][j] = tx_vodctrl[t][j];			 
		}
		else //FHT
		{


			if (FHT_TX_SETTINGS_100G)
			{
				fht_tx_pretap_3[t][j] = 0;
				fht_tx_pretap_2[t][j] = 0;
				fht_tx_pretap_1[t][j] = 56;	//-4	
				fht_tx_maintap[t][j] = 30; //15
				fht_tx_posttap_1[t][j] = 60; //-2
				fht_tx_posttap_2[t][j] = 56; //-2
			} 
			else if (FHT_TX_SETTINGS_50G)
			{
				fht_tx_pretap_3[t][j] = 0;
				fht_tx_pretap_2[t][j] = 0;
				fht_tx_pretap_1[t][j] = 58; //-3	
				fht_tx_maintap[t][j] = 42;  //21
				fht_tx_posttap_1[t][j] = 54; //-5 
				fht_tx_posttap_2[t][j] = 62; //-0.5
			} 			
			else // user selectable
			{
				fht_tx_pretap_3[t][j] = 0;
				fht_tx_pretap_2[t][j] = 0;
				fht_tx_pretap_1[t][j] = 56;	
				fht_tx_maintap[t][j] = 30; 
				fht_tx_posttap_1[t][j] = 60; 
				fht_tx_posttap_2[t][j] = 56; 
			} 			
			
		}
		
	}

}
 


// program vod settings for FGT

if (FHT_USED == 0)
{
	//i=0;
	for (t=0; t < NUMBER_OF_PHYS; t++)
	{					
		for (j = 0; j < number_of_lanes[t] ; j++)
		{ 
			//i = i+1;
			if (PROGRAM_PMA_SETTINGS_FGT)
			{
				rmw_channel_ftile (t, j, offset[t],0x47830, 0x0000001F , tx_posttap_1[t][j]    	);	//set post-tap1	0x47830[4:0]
				rmw_channel_ftile (t, j, offset[t],0x47830, 0x000003E0 , tx_pretap_1[t][j] << 5 );	//set pre-tap1 	0x47830[9:5]				
				rmw_channel_ftile (t, j, offset[t],0x47830, 0x0000FC00 , tx_vodctrl[t][j] << 10	);  //set main-tap 	0x47830[15:10]
				//rmw_channel_ftile (t, j, offset[t],0x47830, 0x0000FC00 , i << 10	);  //set main-tap 	0x47830[15:10]			(useful for debug to have every lane a different VOD)
				rmw_channel_ftile (t, j, offset[t],0x47830, 0x00070000 , tx_pretap_2[t][j] << 16	);	//set pre-tap2		0x47830[18:16]
			}
			//Set tx_polarity
			if (invert_tx_polarity[t][j] == 1)
			{
				readout = cpi_request_fgt(t, j, offset[t], 0x01, 0x65,1,1);
				readout = cpi_request_fgt(t, j, offset[t], 0x01, 0x65,0,1);	
			}
			else
			{
				readout = cpi_request_fgt(t, j, offset[t], 0x00, 0x65,1,1);
				readout = cpi_request_fgt(t, j, offset[t], 0x00, 0x65,0,1);				
			}
			//Set rx_polarity
			if (invert_rx_polarity[t][j] == 1)
			{
				readout = cpi_request_fgt(t, j, offset[t], 0x01, 0x66,1,1);
				readout = cpi_request_fgt(t, j, offset[t], 0x01, 0x66,0,1);	
			}
			else
			{
				readout = cpi_request_fgt(t, j, offset[t], 0x00, 0x66,1,1);
				readout = cpi_request_fgt(t, j, offset[t], 0x00, 0x66,0,1);						
			}
			
		}
		
		set_serial_loopback_fgt(t);

		readback_loopbacks(t);			
	}							
}
else	
{
	//i=0;
	for (t=0; t < NUMBER_OF_PHYS; t++)
	{					
		for (j = 0; j < number_of_lanes[t] ; j++)
		{ 
			//i = i+1;
			if (PROGRAM_PMA_SETTINGS_FHT)
			{
				program_tx_pma_settings_fht(t, j, offset[t],0);
			}
		}
	}
}
	
	usleep(1000);					 

					

   
/**********************************************************************/
/*  set media mode for FGT  to FW Default (Startup condition)         */
/**********************************************************************/  
  
if (FHT_USED == 0)
{
	for (t=0; t < NUMBER_OF_PHYS; t++)
	{	  
		if (fw_196_detected)
		{
			media_mode[t] = MEDIA_MODE_FW_DEFAULT; //normal setting
			set_media_mode(t, offset[t], number_of_lanes[t] , media_mode[t]); 	
		}
	}
}	


   
  /**********************************************************************/
  /*  Reset Design and clear counters                                   */
  /**********************************************************************/  
 
  
  


		for (t = 0; t < NUMBER_OF_PHYS ; t++)
		{ 	 
			reset_phy(t,USE_RESET); 
	      usleep(100000); //Wait 100 ms	
			printf("\nReset phy %1d",t);			
		}
			
		for (t = 0; t < NUMBER_OF_PHYS ; t++)
		 { 	
				clear_counters(t);

		 } 

				
		 

    
   
   
   Show_ErrorCount = 0;    
   
   BERInterval = 2; // Set to 2 seconds as default; 

					
	usleep(1000000);


	





	
	
 /*

	for (t = 0; t < NUMBER_OF_PHYS ; t++)
 { 	
			//Clear FEC Counters
		wr_fec(t,0x108,0xF0);
	   usleep(10);
		wr_fec(t,0x108,0x00);	 
		  // reset also counter_1ms and this will reset errorcounters on all lanes
 }

*/	  

stop = 0;
   
  /**********************************************************************/
  /*  Main Program Loop                                                 */
  /**********************************************************************/  
  while (stop == 0)
	{
 
for (t = 0; t < NUMBER_OF_PHYS ; t++)
{ 

//readback serial loop
readback_loopbacks(t);

//readback polarity
if (FHT_USED == 0)
	readback_polarity(t);


 //Read out 1ms counter at this point to match as closely the RSFEC statistics and error statistics
   Counter_1ms_Reg[t] = read_counter_1ms_reg(t); 

//read out registers and errorcounters

   for (i = 0; i < number_of_lanes[t] ; i++)
  {   

  Channel_Reg[t][i]      =  Read_Channel_Reg(t,i);
  tx_ready[t][i] = 0x0001 & (Channel_Reg[t][i] >> 14);
  rx_ready[t][i] = 0x0001 & (Channel_Reg[t][i] >> 13);  
  

  tx_reset_ack[t][i] = 0x0001 & (Channel_Reg[t][i] >> 3);
  rx_reset_ack[t][i] = 0x0001 & (Channel_Reg[t][i] >> 2);	
  rx_freqlocked_1ms[t][i]  = 0x0001 & (Channel_Reg[t][i] >> 1);		
  
  ErrorCount_Reg_L[t][i] =  Read_ErrorCount_L_Reg(t,i);
  ErrorCount_Reg_H[t][i] =  Read_ErrorCount_H_Reg(t,i);
  
	#ifdef PRBSLOCK_ALARM_COUNTER_ENABLED
		PrbsLock_Alarm_Count[t][i] = Read_PrbsLock_Alarm_Reg(t,i) & (0xFFFF);
		Bitslip_Count[t][i] = (Read_PrbsLock_Alarm_Reg(t,i) >> 16) & (0xFFFF);	
		
		#ifdef RX_AM_LOCK_ALARM_COUNTER_USED
			rx_am_lock_alarm_count[t][i] = (Read_PrbsLock_Alarm_Reg(t,i) >> 16) & (0xFFFF);	
		#endif
	#endif
  }
  #ifdef SUPERLITE_ENABLED
	  WordAligned[t] 		= 0x0001 & (Channel_Reg[t][0] >> 12);
	  LaneAligned[t] 		= 0x0001 & (Channel_Reg[t][0] >> 11);
	  LinkUp[t] 			= 0x0001 & (Channel_Reg[t][0] >> 10);
	  XOFF_Received[t] 	= 0x0001 & (Channel_Reg[t][0] >> 8); 
	  Fifo_Error[t] 		= 0x0001 & (Channel_Reg[t][0] >> 7); 
	  Error_Deskew[t] 	= 0x0001 & (Channel_Reg[t][0] >> 6); 
	  LockAlarm[t]	      = 0x0001 & (Channel_Reg[t][0] >> 0);	  
  #endif
}


#ifdef RSFEC_USED
//readout all fec registers
collect_fec_statistics();
#endif	



  

  /**********************************************************************/
  /*  MEasure temperature of core and transceiver phys                 */
  /**********************************************************************/ 
  

		
	
 capture_temperature();

  
  for (i = 0; i < NUMBER_OF_PHYS ; i++)
  {    
  	  Bitrate_reg[i]		= read_bitrate_reg(i);

	  RxClock_Reg[i]      = read_rxclock_reg(i);
	  
	  RxClock_Reg_tmp[i] = ((float) RxClock_Reg[i] ); 
	  

	  RxClock_Reg[i] = RxClock_Reg_tmp[i];	  
	  
	  temp_float = (float) ((33 * RxClock_Reg_tmp[i])/(32));	  
	  
		if (USE_REC_CLOCK_DIV66)
			Clock_Ratio[i] = ((float) Bitrate_reg[i]  / (float) (temp_float) - 1) * 1000000;
		else
			Clock_Ratio[i] = ((float) Bitrate_reg[i]  / (float) (RxClock_Reg[i]) - 1) * 1000000;	
      

			// Calculate PPM
	ppm_difference[i] = Clock_Ratio[i] ; // convert float to integer
    
  } 
  
  

    


  //Temperature = IORD_ALTERA_AVALON_PIO_DATA(TEMP_DATA_BASE); 
  


for (t = 0; t < NUMBER_OF_PHYS ; t++)
{ 
 
  Bitrate_temp[t] =  ((float) Bitrate_reg[t]* Coreclockmultiplier[t] )/(1000000); 
  
  Bitrate[t] = (Bitrate_temp[t]); // Convert the floats to integer numbers
 
  RefClock_Calculated[t] = Bitrate_temp[t]/(tx_clk_divider[t]);

	#ifdef SUPERLITE_ENABLED	 
		DataClock_Out_Reg[t]  	= read_dataclock_out_reg(t);
		Latency_Max_Reg[t] 			= read_latency_reg(t);
		Skew_Reg[t] = read_skew_reg(t);
		for (i = 0; i < number_of_fecs[t]; i++)
		{
			Skew[t][i] = (Skew_Reg[t] >> i*5) & (0x1F);
		}
		
		Userdatarate_temp[t] = ((float)DataClock_Out_Reg[t] * 64 * NUMBER_OF_VIRTUAL_LANES )/(1000000);		
		Userdatarate[t] = (Userdatarate_temp[t]); // Convert the floats to integer numbers  		
		latency_max_measure_temp[t] = ((float)Latency_Max_Reg[t] * 1000000000)/((float)Bitrate_reg[t]);	
		Latency_Max[t] = (latency_max_measure_temp[t]); // Convert the floats to integer numbers 
		
		Efficiency[t]  = (Userdatarate[t] * 100) /(float) (Bitrate[t] * number_of_lanes[t]); 
		Ratio = ((float)(READ_LENGTH - IDLE_LENGTH))/(READ_LENGTH);		
	#endif 
	 
	  for (i = 0; i < number_of_lanes[t] ; i++)
	  {

		  
	  ErrorCount[t][i] =  ((double)(ErrorCount_Reg_H[t][i]) *  MULTIPLIER * MULTIPLIER) + (double) (ErrorCount_Reg_L[t][i]);

	  Locked[t][i]  = 0x0001 & (Channel_Reg[t][i] >> 15);    
	  PLL_Locked[t][i]  = 0x0001 & (Channel_Reg[t][i] >> 14);
	//  Rev_Serial[i] = readback_reverse_serial(0,i); 
	  if (PMA_DIRECT_MODE) 
	  	Rx_FreqLocked[t][i]   = 0x0001 & (Channel_Reg[t][i] >> 12); 
	  else
	  	Rx_FreqLocked[t][i]   = 0x0001 & (Channel_Reg[t][i] >> 1); //RSFEC Designs
	  
	  #ifdef RSFEC_USED
	  	rx_am_lock[t][i] = 0x0001 & (Channel_Reg[t][i] >> 12);  //For Superlite IV designs this is the WordAligned which is the combined rx_am_lock.  
	  #endif
	  PrbsLockAlarm[t][i]   = 0x0001 & (Channel_Reg[t][i] >> 0);  
	  rx_am_lock_alarm[t][i]   = 0x0001 & (Channel_Reg[t][i] >> 4);
	 
	 
	  }
	  
  Totalbits[t] = (double) (Counter_1ms_Reg[t]) * (double) (Bitrate[t]*1000); // for a physical channel

 
  Hours[t] =  Counter_1ms_Reg[t] / NUMBER_OF_MS_PER_HOUR ;
  Minutes[t] = (Counter_1ms_Reg[t] - (Hours[t] * NUMBER_OF_MS_PER_HOUR))/NUMBER_OF_MS_PER_MINUTE;
  Seconds[t] = (Counter_1ms_Reg[t] - (Hours[t] * NUMBER_OF_MS_PER_HOUR) - (Minutes[t] * NUMBER_OF_MS_PER_MINUTE)) / NUMBER_OF_MS_PER_SECOND;

	  
}

 
#ifdef RSFEC_USED
calculate_fec_statistics();
#endif 

for (t = 0; t < NUMBER_OF_PHYS ; t++)
{   
  for (i = 0; i < number_of_lanes[t] ; i++)
  {  

      if (ErrorCount[t][i] > 0)
        BER[t][i] = ((ErrorCount[t][i])) / Totalbits[t];
      else
        //BER[i] = 0;
        BER[t][i] = ((float) 3) / Totalbits[t]; /* confidence level (CL) of 95% = -ln(1-CL) = 3*/

	}  /* For Loop */  
	
  

  
  for (i = 0; i < number_of_lanes[t] ; i++)
  {
    switch(PrbsSelect[t][i])
    {
      case 0 : if ((pam4_mode[t] == 0) && (USE_128BIT_PRBS_NRZ == 0))
						PrbsPattern[t][i] = 7;
					else
						PrbsPattern[t][i] = 13;						
					break;
      case 1 : PrbsPattern[t][i] = 23;break;
      case 2 : PrbsPattern[t][i] = 31;break;
		
      case 3 : if ((pam4_mode[t] == 0) && (USE_128BIT_PRBS_NRZ == 0))
						PrbsPattern[t][i] = 15;
					else
						PrbsPattern[t][i] = 7;
					break;
		case 4:  PrbsPattern[t][i] = 0;break;
		case 5:  PrbsPattern[t][i] = 0;break;		
		case 6:  PrbsPattern[t][i] = 9;break;	
		case 7:  PrbsPattern[t][i] = 0;break;			
      default:break;
    }
  } /* For Loop */    

  
} //for t
  
       

    printf("\n\n\n");
    if (AGILEX_PCIE_DEVKIT)
	 {
		 if (SUPERLITE_USED)
		 {
			 if (SUPERLITEIV_USED)
				printf("Agilex I-series PCIe Devkit Superlite IV Demo \n");	
			 else
				printf("Agilex I-series PCIe Devkit Superlite II Demo \n");	
		 }
		 else 
		 {
		 if (PMA_DIRECT_MODE == 0)
		 {
			if (AGGREGATE_FECS == 1)
				printf("Agilex I-Series PCIe Devkit F-Tile Soft MultiPRBS with RSFEC Demo combining multiple FEC as aggregate\n");
			else
				printf("Agilex I-Series PCIe Devkit F-Tile Soft MultiPRBS with RSFEC Demo\n");				
		 }
		 else
			printf("Agilex I-Series PCIe Devkit F-Tile Soft MultiPRBS Demo\n");			 
		 }
	 }
	 else if (AGILEX_HS_DEMO_KIT)
	 {
		 if (PMA_DIRECT_MODE == 0)
			printf("Agilex I-Series High Speed Demo Board F-Tile Soft MultiPRBS with RSFEC Demo\n");
		 else
			printf("Agilex I-Series High Speed Demo Board F-Tile Soft MultiPRBS Demo\n");			 
	 }	
	 else if (AGILEX_MUDV_BOARD)
	 {
		 if (PMA_DIRECT_MODE == 0)
			printf("Agilex I-Series mUDV Board F-Tile Soft MultiPRBS with RSFEC Demo\n");
		 else
			printf("Agilex I-Series mUDV Board F-Tile Soft MultiPRBS Demo\n");			 
	 }	
	 else if (AGILEX_MGM_BOARD)
	 {
		 if (PMA_DIRECT_MODE == 0)
			printf("Agilex I-Series MGM Board F-Tile Soft MultiPRBS with RSFEC Demo\n");
		 else
			printf("Agilex I-Series MGM Board F-Tile Soft MultiPRBS Demo\n");			 
	 }	 	 
	 else if (AGILEX_SI_BOARD)
	 {
		 if (SUPERLITE_USED)
		 {
			 if (SUPERLITEIV_USED)
				printf("Agilex I-Series SI/SOC Board F-Tile Superlite IV Demo \n");	
			 else
				printf("Agilex I-Series SI/SOC Board F-Tile Superlite II Demo \n");	
		 }
		 else
		 {
		 if (PMA_DIRECT_MODE == 0)
			printf("Agilex I-Series SI/SOC Board F-Tile Soft MultiPRBS with RSFEC Demo\n");
		 else
			printf("Agilex I-Series SI/SOC Board F-Tile Soft MultiPRBS Demo\n");			 
		}	 	 
	 }
	 else if (AGILEX_FM86_BOARD)
	 {
		 if (PMA_DIRECT_MODE == 0)
			printf("Agilex I-Series FM86 Board F-Tile Soft MultiPRBS with RSFEC Demo\n");
		 else
			printf("Agilex I-Series FM86 Board F-Tile Soft MultiPRBS Demo\n");			 
	 }	
	 else
	 {
		 if (SUPERLITE_USED)
		 {
			 if (SUPERLITEIV_USED)
				printf("Agilex I-series PCIe Devkit Superlite IV Demo \n");	
			 else
				printf("Agilex I-series PCIe Devkit Superlite II Demo \n");	
		 }
		 else
		 {
		 if (PMA_DIRECT_MODE == 0)
			printf("Agilex I-Series Soft MultiPRBS with RSFEC Demo\n");
		 else
			printf("Agilex I-Series Soft MultiPRBS Demo\n");		 
		 }
	 }			 
    printf("--------------------------------------------------------------------------");
    for (t = 0; t < NUMBER_OF_PHYS ; t++)
    { 
      printf("---------");
	 }	    
	 printf("\n");	 
	 if (AGILEX_PCIE_DEVKIT)
		printf("|Board Revision          : Agilex I-Series PCIe Devkit F-tile (ES Version)\n"); 
	 else if (AGILEX_HS_DEMO_KIT)
		printf("|Board Revision          : Agilex I-Series HS Demo Board F-tile (ES Version)\n"); 		 
	 else if (AGILEX_MUDV_BOARD)
		printf("|Board Revision          : Agilex I-Series mUDV Board (fab B) F-tile (ES Version)\n"); 			
	 else if (AGILEX_MGM_BOARD)
		printf("|Board Revision          : Agilex I-Series MGM Board F-tile (ES Version)\n"); 				
	 else if (AGILEX_SI_BOARD)
		printf("|Board Revision          : Agilex I-Series SI/SOC Board 4 F-tiles (ES Version)\n"); 		
	 else if (AGILEX_FM86_BOARD)
		printf("|Board Revision          : Agilex I-Series FM86 Board 2 F-tiles (Rev B)\n"); 		
	
    printf("|Hardware Revision       : %02x/%02x/20%2x variant %02x\n",HWVersion_Month,HWVersion_Day,HWVersion_Year,HWSubversion);
	 if (PMA_DIRECT_MODE == 0)
		printf("|Clocking of PHY's       : System PLL clocking\n");
	 else if ((HWSubversion == 0) || (HWSubversion == 3))
		printf("|Clocking of PHY's       : PMA clocking\n");	
	 else if (HWSubversion == 1)
	 {
		if ((SUPERLITE_USED == 1) && (SUPERLITEIV_USED == 0)) //Superlite II (PMA Clocking)
			printf("|Clocking of PHY's       : PMA clocking\n");	  
		else
			printf("|Clocking of PHY's       : System PLL clocking\n");					
	 }
	 if (FHT_USED == 0)
		 printf("|FGT Firmware version    : 0x%x\n",firmware);  	 
	 else
		 printf("|FHT Firmware version    : %d\n",firmware); 
    printf("|Software Build Date     : %s  %s\n",__DATE__,__TIME__ );
    printf("--------------------------------------------------------------------------");
    for (t = 0; t < NUMBER_OF_PHYS ; t++)
    { 
      printf("---------");
	 }	
	 printf("\n");	 
    printf("|PHY                            |");	
		for (t = 0; t < NUMBER_OF_PHYS ; t++)
		{  
			printf("%8d|",t);
		}
		printf("\n");		
	 printf("|RefClock Measured (Mhz)        |");
		for (t = 0; t < NUMBER_OF_PHYS ; t++)
		{  
			printf("%8.4f|",RefClock_Calculated[t]);
		}	 
	 printf("\n");

	 printf("|Line rate (Gbps)               |");
		for (t = 0; t < NUMBER_OF_PHYS ; t++)
		{  
			printf("%8.4f|",(Bitrate_temp[t]/1000));
		}	 
	 printf("\n");

	 printf("|Number Of Lanes                |");	 
		for (t = 0; t < NUMBER_OF_PHYS ; t++)
		{  
			printf("%8d|",number_of_lanes[t]);
		}	 
	 printf("\n");
	 

	 printf("|Aggregate rate (Gbps)          |");
		for (t = 0; t < NUMBER_OF_PHYS ; t++)
		{  
			printf("%8.4f|",number_of_lanes[t]*(Bitrate_temp[t]/1000));
		}	 
	 printf("\n");
	 
	 Total_Aggregate_Rate = 0.0;
		for (t = 0; t < NUMBER_OF_PHYS ; t++)
		{  
			Total_Aggregate_Rate += number_of_lanes[t]*(Bitrate_temp[t]/1000);
		}	 
	  
 
	 printf("|Selected Channel               |");	 
		for (t = 0; t < NUMBER_OF_PHYS ; t++)
		{  
			printf("%8d|",SelectedChannel[t]);
		}	 
	 printf("\n");
	 printf("|Number of Phy's                |%8d", NUMBER_OF_PHYS);
    printf("\n");	 
 	 if (NUMBER_OF_PHYS > 1)	
	 {		 
	 printf("|Total Aggregate rate (Gbps)    |%8.3f",Total_Aggregate_Rate );		  
	 printf("\n");    
	 }	 
	 printf("|Selected Phy                   |%8d", Selectedphy);
    printf("\n");
	 
    printf("--------------------------------------------------------------------------");
    for (t = 0; t < NUMBER_OF_PHYS ; t++)
    { 
      printf("---------");
	 }	
	 printf("\n");
	 
#ifdef SUPERLITE_ENABLED
	 printf("|Superlite Related statistics:\n");
	 
    printf("|Read Length                    |");
    for (t = 0; t < NUMBER_OF_PHYS ; t++)
				{			 
      printf("%8d|",READ_LENGTH);
				}
    printf("\n");	 	 
  

    printf("|Idle Length                    |");
    for (t = 0; t < NUMBER_OF_PHYS ; t++)
	{
      printf("%8d|",IDLE_LENGTH);
					  
     }
     printf("\n");
	  
    printf("|Ratio                          |");
    for (t = 0; t < NUMBER_OF_PHYS ; t++)
	{
      printf("%8.6f|",Ratio);

		  }
    printf("\n");		 
	 
    printf("|Throttle Datarate              |");
    for (t = 0; t < NUMBER_OF_PHYS ; t++)
				{			 
      printf("%8d|",throttle_datarate[t]);
					  
     }
     printf("\n");

    printf("|Net Received Bandwidth (Gbps)  |");	
    for (t = 0; t < NUMBER_OF_PHYS ; t++)
     { 
      printf("%8.4f|",((float) Userdatarate[t])/1000);
		  }
    printf("\n");	
	 
    printf("|Efficiency (%%)                 |");
    for (t = 0; t < NUMBER_OF_PHYS ; t++)
			{
			printf("%8.5f|",Efficiency[t]);		  
			}
     printf("\n");
     
	 

		printf("|Measured Max Latency (ns)      |");
			for (t = 0; t < NUMBER_OF_PHYS ; t++)
			{		  
				printf("%8d|",Latency_Max[t]);

			}
				 printf(" (only valid with loopback (int or ext)\n");	
				 
		printf("|Measured Max Latency (clocks)  |");
			for (t = 0; t < NUMBER_OF_PHYS ; t++)
			{
				printf("%8d|",Latency_Max_Reg[t]);
			}
				 printf(" (only valid with loopback (int or ext)\n");	
    
	 printf("--------------------------------------------------------------------------");
    for (t = 0; t < NUMBER_OF_PHYS ; t++)
    { 
      printf("---------");
	 }	
	 printf("\n");			

			  

#endif	  


for (t = 0; t < NUMBER_OF_PHYS ; t++)
{  

	if (display_phy[t] == 1)
	{
	printf("\nPHY %1d",t);		
	printf("  F-Tile ");		
		if (t == 0)
			printf(PHY0_TILE);
		else if (t == 1)
			printf(PHY1_TILE);
		else if (t == 2)
			printf(PHY2_TILE);
		else if (t == 3)
			printf(PHY3_TILE);	
		
		if (t == 0)
			printf(PHY0_NAME);
		else if (t == 1)
			printf(PHY1_NAME);
		else if (t == 2)
			printf(PHY2_NAME);
		else if (t == 3)
			printf(PHY3_NAME);
	

	printf("\n==============================\n");
	

		if (AGGREGATE_FECS == 1)
		{
		  printf("FEC identifier     :|");					  
		  for (i = 0; i < number_of_virtual_lanes[t] ; i++)
		  { 
			  		
				if ( (i % number_of_segments[t]) == ((number_of_segments[t]/2)-1)) 
				{			 
					switch (i/number_of_segments[t])
					{
						case 0 : printf(COLOR_LIGHT_BLUE COLOR_INVERSE "       0 " COLOR_RESET);break;
						case 1 : printf(COLOR_LIGHT_CYAN COLOR_INVERSE "       1 " COLOR_RESET);break;
						case 2 : printf(COLOR_BLUE COLOR_INVERSE       "       2 " COLOR_RESET);break;
						case 3 : printf(COLOR_LIGHT_RED COLOR_INVERSE  "       3 " COLOR_RESET);break;						
						default : break;
					}			
				}
				else
					switch (i/number_of_segments[t])
					{
						case 0 : printf(COLOR_LIGHT_BLUE COLOR_INVERSE "         " COLOR_RESET);break;
						case 1 : printf(COLOR_LIGHT_CYAN COLOR_INVERSE "         " COLOR_RESET);break;
						case 2 : printf(COLOR_BLUE COLOR_INVERSE "         " COLOR_RESET);break;
						case 3 : printf(COLOR_LIGHT_RED COLOR_INVERSE "         " COLOR_RESET);break;						
						default : break;
					}

		  }
		  printf("\n");
		}
		  

		  printf("Channel            :|");		  
		  for (i = 0; i < number_of_virtual_lanes[t] ; i++)
		  { 
			  
			if (fec_mode[t] == FRACTURED)	
				 printf("%8d|",i);		
			else
			{
				
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
						printf("%8d|",i/number_of_segments_lane[t]);
				}
				else
						printf("        |");	
			}

		  }
		  printf("\n");		  
		  
		  if (pma_direct_mode[t] == 0)
		  {

			  printf("Segment            :|");
			  
			  for (i = 0; i < number_of_virtual_lanes[t] ; i++)
			  { 
					printf("%8d|",(i % number_of_segments[t]));		  
			  }
			  printf("\n");
		  }
		  


     printf("                    |");
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
     printf("--------|");
     }
     printf("\n");
		  printf("Transceiver Type   :|");
		  for (i = 0; i < number_of_virtual_lanes[t] ; i++)
		  { 
			  
			if (fec_mode[t] == FRACTURED)	
			{
				if (FHT_USED)
					printf("     FHT|");
				else
					printf("     FGT|");
			}
			else
			{
				
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
					if (FHT_USED)
						printf("     FHT|");
					else
						printf("     FGT|");
				}
				else
						printf("        |");	
			}

		  }
		  printf("\n");
		  
	  
			
		  if (FHT_USED == 0)				
			{			
			  printf("FGT Quad           :|");		  
			  for (i = 0; i < number_of_virtual_lanes[t] ; i++)
			  { 
				  
				if (fec_mode[t] == FRACTURED)	
				{
						printf("%8d|",FGT_Quad[t][i]);
				}
				else
				{
					
					if ( (i % number_of_segments_lane[t]) == 0) 
					{			 
						printf("%8d|",FGT_Quad[t][i/number_of_segments_lane[t]]);
					}
					else
							printf("        |");	
				}

			  }
			  printf("\n");
			}
			
		


			

		if (FHT_USED == 1)
			printf("FHT Lane           :|");		
		else
		   printf("FGT Lane           :|");	
		
	  
		  for (i = 0; i < number_of_virtual_lanes[t] ; i++)
		  { 
			  
			if (fec_mode[t] == FRACTURED)	
			{
					printf("%8d|",Quad_Channel[t][i]);
			}
			else
			{
				
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
					printf("%8d|",Quad_Channel[t][i/number_of_segments_lane[t]]);
				}
				else
						printf("        |");	
			}

		  }
		  printf("\n");		  
		 
			  

     printf("Native Phy Mode    :|");   	  
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
 	if (pma_direct_mode[t] == 0)
	{
		  if (fec_mode[t] == FRACTURED)
		  {		  
       	printf("FEC-FRAC|");
		  }
		  else if (fec_mode[t] == FRACTURED_50GBE)
		   {
				if ( (i % number_of_segments[t]) == 0) 
				{			 
					printf("FEC-50GE|");
				}
				else
					printf("        |");
			}
		  else if (fec_mode[t] == FRACTURED_100GBE)
		   {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
					printf("FEC100GE|");
				}
				else				
					printf("        |");
			}	
		  else if (fec_mode[t] == AGGREGATE_100GBE)
		   {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
					printf("AGG100GE|");
				}
				else				
					printf("        |");
			}					
		  else if (fec_mode[t] == AGGREGATE_200GBE)
		   {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
					printf("AGG200GE|");
				}
				else
					printf("        |");
			}	
		  else if (fec_mode[t] == AGGREGATE_400GBE)
		   {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
					printf("AGG400GE|");
				}
				else
					printf("        |");
			}				
			else
					printf("        |");				
	}
	else
	{
		  if (pam4_mode[t] == 0)
				printf(" PMA-DIR|");
		  else
				printf("PAM4-DIR|");			   
	}
					  
     }
     printf("\n");
	  
 	if (pma_direct_mode[t] == 0)
	{
     printf("FEC configuration  :|");	   	  
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
		  if (fec_mode[t] == FRACTURED)
		  {		
			if (kpfec[t] == 0)  
				printf(" 528,514|"); 
			else
				printf(" 544,514|"); 				 

		  }
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
						printf(" 544,514|");  
				}
				else
						printf("        |");
			}
					  
     }
     printf("\n");
  }
  
/*	  
	  
     printf("Rx Termination     :|");        
     for (i = 0; i < number_of_lanes[t] ; i++)
     { 
		  if (fec_mode[t] == FRACTURED)
		  {
			if (rx_termination[t][i] == RX_TERMINATION_VCC)
       	printf("     VCC|");
			else if (rx_termination[t][i] == RX_TERMINATION_FLOAT)
		printf("   FLOAT|");
			else if (rx_termination[t][i] == RX_TERMINATION_GND)
					printf("     GND|");
		  }
		  else
		  {
			if ( (i % 2) == 0) 
			{
			if (rx_termination[t][i/2] == RX_TERMINATION_VCC)
					printf("     VCC|");
			else if (rx_termination[t][i/2] == RX_TERMINATION_FLOAT)
				printf("   FLOAT|");
			else if (rx_termination[t][i/2] == RX_TERMINATION_GND)
				   printf("     GND|");
			}
			else
				   printf("        |");
		  }
		  
	  }
     printf("\n");
     


     printf("Tx Tristate        :|");     
     for (i = 0; i < number_of_lanes[t] ; i++)
     { 
		  if (fec_mode[t] == FRACTURED)
		  {		  
			  if (tristate[t][i] == 0)
							printf("     OFF|");
			  else
							printf(COLOR_YELLOW COLOR_INVERSE "      ON" COLOR_RESET "|");
		  }
		  else
		  {
				if ( (i % 2) == 0) 
				{			 
				  if (tristate[t][i/2] == 0)
								printf("     OFF|");
				  else
								printf(COLOR_YELLOW COLOR_INVERSE "      ON" COLOR_RESET "|");
				}
				else
						printf("        |");
			}
			  
     }
     printf("\n");    
 
*/

	    
     printf("Mute Tx            :|");       
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
		  
		  if (fec_mode[t] == FRACTURED)
		  {		  
		   if (tx_channel_muted[t][i] == 0)
       			printf("%8d|",Serial_Loop[t][i]);
			else
				printf(COLOR_YELLOW COLOR_INVERSE "      ON" COLOR_RESET "|");

		  }
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{	
		   			if (tx_channel_muted[t][i/number_of_segments_lane[t]] == 0)		 
						printf("%8d|",tx_channel_muted[t][i/number_of_segments_lane[t]]);
					else
						printf(COLOR_YELLOW COLOR_INVERSE "      ON" COLOR_RESET "|");

				}
				else
						printf("        |");
			}
			
     }
     printf("\n");
	  
     printf("Serial Loop        :|");        
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
		  
		  if (fec_mode[t] == FRACTURED)
		  {		  
		   if (Serial_Loop[t][i] == 0)
       			printf("%8d|",Serial_Loop[t][i]);
			else
				printf(COLOR_YELLOW COLOR_INVERSE "       1" COLOR_RESET "|");

		  }
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{	
		   			if (Serial_Loop[t][i/number_of_segments_lane[t]] == 0)		 
						printf("%8d|",Serial_Loop[t][i/number_of_segments_lane[t]]);
					else
						printf(COLOR_YELLOW COLOR_INVERSE "       1" COLOR_RESET "|");

				}
				else
						printf("        |");
			}
			
     }
     printf("\n");

     printf("Reverse // Loop    :|");       
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
		  if (fec_mode[t] == FRACTURED)
		  {		  
		   if (Rev_Parallel[t][i] == 1)
       			printf(COLOR_YELLOW COLOR_INVERSE "       1" COLOR_RESET "|");
			else
				printf("%8d|",Rev_Parallel[t][i]);
		  }
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
					if (Rev_Parallel[t][i/number_of_segments_lane[t]] == 1)
							printf(COLOR_YELLOW COLOR_INVERSE "       1" COLOR_RESET "|");
					else
						printf("%8d|",Rev_Parallel[t][i/number_of_segments_lane[t]]);
				}
				else
						printf("        |");
			}
			
       	
     }
     printf("\n");
	
     printf("Line Encoding      :|");        
     for (i = 0; i < number_of_virtual_lanes[t]; i++)
     { 
		  if (fec_mode[t] == FRACTURED)
		  {		  
				switch(line_encoding[t][i])
					{
						case NRZ 		: printf("     NRZ|");break;
						case PAM4 		: printf("    PAM4|");break;
						default 	    : printf("        |");break;
					}
		  }
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
				switch(line_encoding[t][i/number_of_segments_lane[t]])
					{
						case NRZ 		: printf("     NRZ|");break;
						case PAM4 		: printf("    PAM4|");break;
						default 		: printf("        |");break;
					}
				}
				else
						printf("        |");
			}
			

	  }
     printf("\n"); 

	  if (pam4_mode[t] == 1)
	  {
     printf("Gray Encoding      :|");        
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
		  
		  if (fec_mode[t] == FRACTURED)
		  {		  
			 if (gray_encoding[t][i] == 1)
				printf("    GRAY|");
			 else
				printf("        |");
		  }
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
					 if (gray_encoding[t][i/number_of_segments_lane[t]] == 1)
						printf("    GRAY|");
					 else
						printf("        |");
				}
				else
						printf("        |");
			}
			

	  }
     printf("\n");
	  }

	  if (pam4_mode[t] == 1)
	  {	  
     printf("1/1+D Encoding     :|");        
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 

		  if (fec_mode[t] == FRACTURED)
		  {		  
			 if (encoding_1_1plusd[t][i] == 1)		  
				printf("   1/1+D|");
			 else
				printf("        |");
		  }
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
				 if (encoding_1_1plusd[t][i/number_of_segments_lane[t]] == 1)		  
					printf("   1/1+D|");
				 else
					printf("        |");
				}
				else
						printf("        |");
			}
			

	  }
     printf("\n");
	  }

/*	  
	  printf("Swizzle            :|");      
     for (i = 0; i < number_of_lanes[t] ; i++)
     { 
		  if (fec_mode[t] == FRACTURED)
		  {		  
				 if (swizzle[t][i] == 1)
					printf(" SWIZZLE|");
				 else
					printf("        |");
		  }
		  else
		  {
				if ( (i % 2) == 0) 
				{			 
					 if (swizzle[t][i/2] == 1)
						printf(" SWIZZLE|");
					 else
						printf("        |");
				}
				else
						printf("        |");
			}
			

	  }
     printf("\n");
	 
	*/
 
	  printf("Invert Tx Polarity :|");      
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
		  if (fec_mode[t] == FRACTURED)
		  {		  
				 if (invert_tx_polarity[t][i] == 1)		 
					printf(COLOR_YELLOW COLOR_INVERSE "       1" COLOR_RESET "|");
				 else
					printf("        |");
		  }
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
				 if (invert_tx_polarity[t][i/number_of_segments_lane[t]] == 1)		 
					printf(COLOR_YELLOW COLOR_INVERSE "       1" COLOR_RESET "|");
				 else
					printf("        |");
				}
				else
						printf("        |");
			}		  

	  }
     printf("\n");

	  printf("Invert Rx Polarity :|");      
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
		  if (fec_mode[t] == FRACTURED)
		  {		  
				 if (invert_rx_polarity[t][i] == 1)		 
					printf(COLOR_YELLOW COLOR_INVERSE "       1" COLOR_RESET "|");
				 else
					printf("        |");
		  }
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
				 if (invert_rx_polarity[t][i/number_of_segments_lane[t]] == 1)		 
					printf(COLOR_YELLOW COLOR_INVERSE "       1" COLOR_RESET "|");
				 else
					printf("        |");
				}
				else
						printf("        |");
			}	
	  }
     printf("\n");	  
	  
	  if (fw_196_detected)
	  {
     printf("Media Mode         :|");         
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
		  if (fec_mode[t] == FRACTURED)
		  {		  
				 switch(media_mode[t])
				 {
					case MEDIA_MODE_FW_DEFAULT 			: printf(" DEFAULT|");break;
					case MEDIA_MODE_VSR_OPTICAL_MODULE 	: printf(" VSR/OPT|");break;	
					default										: printf("        |");break;
				 }
		  }
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
				 switch(media_mode[t])
				 {
					case MEDIA_MODE_FW_DEFAULT 			: printf(" DEFAULT|");break;
					case MEDIA_MODE_VSR_OPTICAL_MODULE 	: printf(" VSR/OPT|");break;	
					default										: printf("        |");break;
				 }
				}
				else
						printf("        |");
			}
			

     }
     printf("\n");
	 }

				

     // printf("Channel Type       :|");         
     // for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     // { 
		  // if (fec_mode[t] == FRACTURED)
		  // {		  
				 // switch(channel_type[t][i])
				 // {
			// case CHIP2CHIP : printf("     C2C|");break;
			// case BACKPLANE : printf(" BACKPLN|");break;
			// case SHORT 		: printf("   SHORT|");break;
			// case DAC 		: printf("     DAC|");break;				
			// case OPTICAL 	  : printf(" OPTICAL|");break;	
			// case FGT_DEFAULT : printf(" FGT_DEF|");break;	
			// case FHT_DEFAULT : printf(" FHT_DEF|");break;				
					// default			: printf("        |");break;
				 // }
		  // }
		  // else
		  // {
				// if ( (i % number_of_segments_lane[t]) == 0) 
				// {			 
				 // switch(channel_type[t][i/number_of_segments_lane[t]])
				 // {
					// case CHIP2CHIP : printf("     C2C|");break;
					// case BACKPLANE : printf(" BACKPLN|");break;
					// case SHORT 		: printf("   SHORT|");break;
					// case DAC 		: printf("     DAC|");break;				
					// case OPTICAL 	: printf(" OPTICAL|");break;	
					// case FGT_DEFAULT : printf(" FGT_DEF|");break;	
					// case FHT_DEFAULT : printf(" FHT_DEF|");break;						
					// default			: printf("        |");break;
				 // }
				// }
				// else
						// printf("        |");
			// }
			

     // }
     // printf("\n");
	  

     printf("Connection Type    :|");         
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     {

		  if (fec_mode[t] == FRACTURED)
		  {		  
				 switch(connection_type[t][i])
				 {
					case NONE 		: printf("        |");break;
					case FMC  		: printf("     FMC|");break;
					case QSFPDD 	: printf("  QSFPDD|");break;
					case BKP 		: printf(" BACKPLN|");break;
					case SMA			: printf("     SMA|");break;
					case LPBK		: printf("    LPBK|");break;
					case MXP			: printf("     MXP|");break;
					case OSFP		: printf(" OSFP800|");break;
					case QSFPDD800 : printf(" QSFP800|");break;
					default: printf("        |");break;
				 }
		  }
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
					 switch(connection_type[t][i/number_of_segments_lane[t]])
					 {
						case NONE 		: printf("        |");break;
						case FMC  		: printf("     FMC|");break;
						case QSFPDD 	: printf("  QSFPDD|");break;
						case BKP 		: printf(" BACKPLN|");break;
						case SMA			: printf("     SMA|");break;
						case LPBK		: printf("    LPBK|");break;
						case MXP			: printf("     MXP|");break;
						case OSFP		: printf(" OSFP800|");break;
						case QSFPDD800 : printf(" QSFP800|");break;					
						default: printf("        |");break;
					 }
				}
				else
						printf("        |");
			}
			

     }
     printf("\n");

 
	  if (scrambled_idle_pattern[t] == 0)
	  {
		  printf("PrbsPattern        :|");        
		  for (i = 0; i < number_of_virtual_lanes[t] ; i++)
		  { 
			  if (fec_mode[t] == FRACTURED)
		  { 
					printf("%8d|",PrbsPattern[t][i]);
			  }
			  else
			  {
					if ( (i % number_of_segments_lane[t]) == 0) 
						printf("%8d|",PrbsPattern[t][i/number_of_segments_lane[t]]);	
					else
						printf("        |");
			  }		
							
		  }
		  printf("\n");
	  }
	  else
	  {  
		  printf("Scrambled Idle     :|");        
		  for (i = 0; i < number_of_virtual_lanes[t] ; i++)
		  { 
			  if (fec_mode[t] == FRACTURED)
		  { 
				printf(COLOR_YELLOW COLOR_INVERSE "      ON" COLOR_RESET "|");		
			  }
			  else
			  {
					if ( (i % number_of_segments_lane[t]) == 0) 
						printf(COLOR_YELLOW COLOR_INVERSE "      ON" COLOR_RESET "|");		
					else
						printf("        |");
			  }		
							
		  }
		  printf("\n");
	  }		  
	  
	    
	  if (pma_direct_mode[t] == 0)
	  {
     printf("Scrambling         :|");     
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 

  		  if (fec_mode[t] == FRACTURED)
		  {
		   if (enable_scrambler[t] == 1)
       			printf("      ON|");
			else
				printf(COLOR_YELLOW COLOR_INVERSE "     OFF" COLOR_RESET "|");				
		  }
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
     { 

		   if (enable_scrambler[t] == 1)
       			printf("      ON|");
			else if ((fec_mode[t] == AGGREGATE_200GBE) || (fec_mode[t] == AGGREGATE_400GBE))
       			printf("     OFF|");	// In 200GbE and 400GbE mode FEC should be off as it is part of the FEC itself.				
			else
				printf(COLOR_YELLOW COLOR_INVERSE "     OFF" COLOR_RESET "|");
		}
				else
					printf("        |");
		  }	
		  
		}
     printf("\n");	  	  
		}

     	  
     
        
     // printf("PLLLocked          :|");        
     // for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     // {

		  // if (fec_mode[t] == FRACTURED)
		  // {		  
			// print_alarm(PLL_Locked[t][i],1); 
			// }
		  // else
		  // {
				// if ( (i % number_of_segments_lane[t]) == 0) 
				// {			 
					// print_alarm(PLL_Locked[t][i/number_of_segments_lane[t]],1); 
				// }
				// else
						// printf("        |");
			// }
			


   
     // }
     // printf("\n"); 
     
	  printf("tx_ready           :|");	       
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     {

		  if (fec_mode[t] == FRACTURED)
		  {		  
			print_alarm(tx_ready[t][i],1); 
			}
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
					print_alarm(tx_ready[t][i/number_of_segments_lane[t]],1); 
				}
				else
						printf("        |");
			}
			


   
     }
     printf("\n"); 

	  printf("rx_ready           :|");	       
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     {

		  if (fec_mode[t] == FRACTURED)
		  {		  
			print_alarm(rx_ready[t][i],1); 
			}
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
					print_alarm(rx_ready[t][i/number_of_segments_lane[t]],1); 
				}
				else
						printf("        |");
			}
			


   
     }
     printf("\n"); 
	  
     printf("FreqLocked 1ms     :|");        
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     {

		  if (fec_mode[t] == FRACTURED)
		  {		  
			print_alarm(rx_freqlocked_1ms[t][i],1);
				}
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{			 
			print_alarm(rx_freqlocked_1ms[t][i/number_of_segments_lane[t]],1);
				}
				else
						printf("        |");
			}
			



     }
     printf("\n");  
	

  if (SUPERLITE_USED == 0)
  {
     
	  if (XGMII_USED == 0)
		printf("PrbsLocked         :|");
	  else
		printf("XGMII_Locked       :|");

     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     {		  		  

  		  if (fec_mode[t] == FRACTURED)
     {		  		  

				print_alarm(Locked[t][i],1);
		  }
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
					print_alarm(Locked[t][i/number_of_segments_lane[t]],1);
				else
					printf("        |");
		  }	
		  
		}

     printf("\n");
	 

     printf("PrbsLockAlarm      :|");

     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     {		  		  

  		  if (fec_mode[t] == FRACTURED)
     {		  		  

				 if (PrbsLockAlarm[t][i] == 1)
					printf(COLOR_RED COLOR_INVERSE "     SET" COLOR_RESET "|");
				 else
					printf("        |");					
				}
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{
					if (PrbsLockAlarm[t][i/number_of_segments_lane[t]] == 1)
						printf(COLOR_RED COLOR_INVERSE "     SET" COLOR_RESET "|");
					else
						printf("        |");	 	
				}
				else
					printf("        |");
		  }
		  
	
		}

     printf("\n");

	  if ( ((pma_direct_mode[t] == 1) && (PRBSLOCK_ALARM_COUNTER_USED == 1)) || (RX_AM_LOCK_ALARM_COUNTER_USED == 1) )
	  {	  
     printf("PrbsLockAlarmCount :|");

     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     {		  		  

  		  if (fec_mode[t] == FRACTURED)
     {		  		  

				 if (PrbsLockAlarm[t][i] == 1)
					printf( COLOR_ALARM "%8d" COLOR_RESET "|" ,PrbsLock_Alarm_Count[t][i]);  
				 else
					printf("        |");					
				}
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{
					if (PrbsLockAlarm[t][i/number_of_segments_lane[t]] == 1)
						printf( COLOR_ALARM "%8d" COLOR_RESET "|" ,PrbsLock_Alarm_Count[t][i/number_of_segments_lane[t]]); 
					else
						printf("        |");	 	
				}
				else
					printf("        |");
		  }
		  
	
		}

     printf("\n");
	  }
	  
	  
	  if (RX_AM_LOCK_ALARM_COUNTER_USED == 1)
	  {
     printf("Rx AM Lock Alarm   :|");	  

     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     {		  		  

  		  if (fec_mode[t] == FRACTURED)
     {		  		  

				 if (rx_am_lock_alarm[t][i] == 1)
					printf(COLOR_RED COLOR_INVERSE "     SET" COLOR_RESET "|");
				 else
					printf("        |");					
				}
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{
					if (rx_am_lock_alarm[t][i/number_of_segments_lane[t]] == 1)
						printf(COLOR_RED COLOR_INVERSE "     SET" COLOR_RESET "|");
					else
						printf("        |");	 	
				}
				else
					printf("        |");
		  }
		  
	
		}

     printf("\n");
	  }
	  

	  if ((pma_direct_mode[t] == 1) && (PRBSLOCK_ALARM_COUNTER_USED == 1) && (SHOW_BITSLIP_COUNT == 1) )	  
	  {
      printf("BitSlip Count      :|");
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     {		  		  

  		  if (fec_mode[t] == FRACTURED)
     {		  		  

				 if (PrbsLockAlarm[t][i] == 1)
					printf( COLOR_ALARM "%8d" COLOR_RESET "|" ,Bitslip_Count[t][i]);  
				 else
					printf("        |");					
				}
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{
					if (PrbsLockAlarm[t][i/number_of_segments_lane[t]] == 1)
						printf( COLOR_ALARM "%8d" COLOR_RESET "|" ,Bitslip_Count[t][i/number_of_segments_lane[t]]); 
					else
						printf("        |");	 	
				}
				else
					printf("        |");
		  }
		  
	
		}

     printf("\n");
	  }
	  else if (RX_AM_LOCK_ALARM_COUNTER_USED == 1)
	  {
      printf("AM Lock Alarm Count:|");		  
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     {		  		  

  		  if (fec_mode[t] == FRACTURED)
     {		  		  

				 if (rx_am_lock_alarm[t][i] == 1)
					printf( COLOR_ALARM "%8d" COLOR_RESET "|" ,rx_am_lock_alarm_count[t][i]);  
				 else
					printf("        |");					
				}
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{
					if (rx_am_lock_alarm[t][i/number_of_segments_lane[t]] == 1)
						printf( COLOR_ALARM "%8d" COLOR_RESET "|" ,rx_am_lock_alarm_count[t][i/number_of_segments_lane[t]]); 
					else
						printf("        |");	 	
				}
				else
					printf("        |");
		  }
		  
	
		}

     printf("\n");
	  }	  
	
   
       
     printf("Errorcount         :|");
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
  
  		  if (fec_mode[t] == FRACTURED)
     { 
     if (Locked[t][i] == 0)
       printf("        |");

	  else
		 {
	     if (ErrorCount[t][i] == 0.0)
			  print_alarm((int) ErrorCount[t][i],0);
	     else if (ErrorCount[t][i] > 99999999)
	       printf(COLOR_ALARM "%.2e" COLOR_RESET "|" , ErrorCount[t][i]);
	     else	
	       printf( COLOR_ALARM "%8d" COLOR_RESET "|" ,ErrorCount_Reg_L[t][i]);      
		 }
     }
		  else
		  {
				if ( (i % number_of_segments_lane[t]) == 0) 
				{
				  if (Locked[t][i/number_of_segments_lane[t]] == 0)
					 printf("        |");

				  else
					 {
					  if (ErrorCount[t][i/number_of_segments_lane[t]] == 0.0)
						  print_alarm((int) ErrorCount[t][i/number_of_segments_lane[t]],0);
					  else if (ErrorCount[t][i/number_of_segments_lane[t]] > 99999999)
						 printf(COLOR_ALARM "%.2e" COLOR_RESET "|" , ErrorCount[t][i/number_of_segments_lane[t]]);
					  else	
						 printf( COLOR_ALARM "%8d" COLOR_RESET "|" ,ErrorCount_Reg_L[t][i/number_of_segments_lane[t]]);      
					 }	
				}
				else
					printf("        |");
		  }

     }

	  
     printf("\n");
	  
	#ifdef RSFEC_USED	 
	print_fec_statistics(t);
	#endif
  }
  else //Superlite statistics
  {

	#ifdef RSFEC_USED	 
	print_fec_statistics(t);
	#endif
	printf("\n");
   printf("XOFF Sent          :");       


		if (XOFF[t] == 0)
			printf("        0");
		else
			printf(COLOR_YELLOW COLOR_INVERSE "        1" COLOR_RESET);
		
     printf("\n");
	    
    printf("XOFF Received      :");       
			
		if (XOFF_Received[t] == 0)
			printf("        0");
				else
			printf(COLOR_YELLOW COLOR_INVERSE "        1" COLOR_RESET);
	
     printf("\n");	  	  
		  
    printf("Throttle Data      :");  	
			
		if (throttle_datarate[t] == 0)
			printf("        0");
		  else
			printf(COLOR_YELLOW COLOR_INVERSE "        1" COLOR_RESET);
	
     printf("\n"); 



    printf("Error Deskew       :");       

    
	 print_alarm_superlite(Error_Deskew[t],0);	

      
    printf("Fifo Error         :");
      
	 print_alarm_superlite(Fifo_Error[t],0);		 
 
    printf("WordAligned        :");       

  
	 print_alarm_superlite(WordAligned[t],1);	   

    printf("LaneAligned        :");       

   
	 print_alarm_superlite(LaneAligned[t],1);	    
	 
    printf("LinkUp             :");       

   
	 print_alarm_superlite(LinkUp[t],1);	
      
    printf("DataLocked         :");
   
	 print_alarm_superlite(Locked[t][0],1);	

	 printf("DataLocked Alarm   : ");
   
		if (LockAlarm[t] ==  1)
			printf(COLOR_RED COLOR_INVERSE "     SET" COLOR_RESET);	

    printf("\n");	 
      
    printf("Errorcount         :");

        if ((Locked[t][0] == 0) )
          printf("        ");
		  else
		  {
		  if (ErrorCount[t][0] == 0)
			  print_alarm_superlite(ErrorCount[t][0],0);
        else if (ErrorCount[t][0] > 99999999)
				printf(COLOR_ALARM "%e\n" COLOR_RESET,ErrorCount[t][0]);   
				else
          printf(COLOR_ALARM "%9d\n" COLOR_RESET,ErrorCount_Reg_L[t][0]);   
			}
	  
  }
  



     printf("\n\n");		

 if (SUPERLITE_USED == 0)
 {	 
    
    for (i = 0; i < number_of_lanes[t] ; i++)
    { 
     
		 
      if (Locked[t][i] == 1)
      {
 	    if (ErrorCount[t][i] > 0)
              printf("BER Estimate  Ch %2d  : " COLOR_ALARM "%e" COLOR_RESET "   (# Errors/Totalbits)\n",i,BER[t][i]);
          else
              printf("BER (CL=0.95) Ch %2d  : " COLOR_OK  "%e"   COLOR_RESET "\n",i,BER[t][i]);
      }
      else
        printf(COLOR_ALARM_INVERT "No Data Lock on Ch%2d" COLOR_RESET "\n",i);

    }

	 printf("\n");
    for (i = 0; i < number_of_lanes[t] ; i++)
    { 
      if (Show_ErrorCount  == 1)
        {
        
         if (Locked[t][i] == 1)  
        {
//			   if  (Disable_FEC[0][i] == 0)
//             printf("ErrorCount  Ch %1X  : %e  FEC correctable : %d  FEC uncorrectable : %d \n",i,ErrorCount[i],FEC_Correctable_ErrorCount_Reg[i],FEC_UnCorrectable_ErrorCount_Reg[i]);
//				else
 	    if (ErrorCount[t][i] > 0)			  
					printf("phy %1d ErrorCount  Ch %2d  : " COLOR_ALARM "%e" COLOR_RESET "\n",t,i,ErrorCount[t][i]);
		 else
					printf("phy %1d ErrorCount  Ch %2d  : " COLOR_OK "%e" COLOR_RESET  "\n",t,i,ErrorCount[t][i]);
				 
        }
        else
          printf(COLOR_ALARM_INVERT "phy %1d No Data Lock on Ch%2d " COLOR_RESET "\n",t,i);
        }
    }
    
    Show_ErrorCount = 0;
    
	allchannels_locked = 1; 
	allchannels_errorfree = 1;
	allchannels_errorcount = 0.0;
			

			for (i = 0; i < number_of_lanes[t] ; i++)
			{ 
				if ((rx_freqlocked_1ms[t][i] == 0) || (Locked[t][i] == 0)) 
				{
					allchannels_locked = 0;
				}
				if ((rx_freqlocked_1ms[t][i] == 1) && (Locked[t][i] == 1)) 
				{
						if (ErrorCount[t][i] > 0) 
						{
							allchannels_errorfree = 0;
							allchannels_errorcount += (double) ErrorCount[t][i];
						}
				}
			}
			

		if ((allchannels_locked == 1) && (allchannels_errorfree == 1))
			printf("\n" COLOR_OK "All channels PHY %1d are locked and errorfree" COLOR_RESET "\n",t);
		else if (allchannels_locked == 1) 
		{
			if (pma_direct_pam4_mode[t] == 1)	
			{
				printf("\n" COLOR_OK "All channels PHY %1d are locked" COLOR_RESET "\n",t);		
				printf("\nTotal amount of errors on PHY %1d    : " COLOR_YELLOW "%e" COLOR_RESET "\n",t,allchannels_errorcount);				
			}
			else
			{
				printf("\n" COLOR_YELLOW "All channels PHY %1d are locked but errors detected" COLOR_RESET "\n",t);
				printf("\nTotal amount of errors on PHY %1d    : " COLOR_ALARM "%e" COLOR_RESET "\n",t,allchannels_errorcount);
			}
		}
		else
		{
			printf("\n" COLOR_ALARM "Not all channels PHY %1d are locked" COLOR_RESET "\n",t);
			printf("\nTotal amount of errors on PHY %1d    : " COLOR_ALARM "%e" COLOR_RESET "\n",t,allchannels_errorcount);
		}			

		printf("\n");
	
	}
	else //Superlite
	{

	  
      if (Locked[t][0] == 1)
      {
		 if (SUPERLITEIV_USED)
		 {
		 if (ErrorCount[t][0] == 0)
			{
				BER_Aggr[t] = (double) (3) /(Totalbits_Aggr[t]); 
				//printf("\nTotalbits_Aggr[%d] = %e",t,Totalbits_Aggr[t]);
			}
		 else
			BER_Aggr[t] = (double) (ErrorCount[t][0]) /(Totalbits_Aggr[t]); 	
		 }
		 else //Superlite II
		 {
		 if (ErrorCount[t][0] == 0)
			BER_Aggr[t] = (double) (3) /(Totalbits[t]*number_of_lanes[t]); 
		 else
			BER_Aggr[t] = (double) (ErrorCount[t][0]) /(Totalbits[t]*number_of_lanes[t]); 	
		 }
		
        if (ErrorCount[t][0] > 0)
              printf("BER Estimate Link          : " COLOR_ALARM "%e" COLOR_RESET "   (# Errors/Totalbits)\n",BER_Aggr[t]);
		  else
              printf("BER (CL=0.95) Link         : " COLOR_OK "%e" COLOR_RESET "\n",BER_Aggr[t]);
		}
		else					
        printf(COLOR_ALARM "No Data Lock achieved" COLOR_RESET "\n");
	  
	 printf("\n");
	}

	
        printf("Test Time PHY %1d                    : %2dh %2dm %2ds\n",t,Hours[t],Minutes[t],Seconds[t]);                 
    
        printf("Tx Clkout Frequency                : %3.5f MHz\n",(float) (Bitrate_reg[t]/1E6));
		  if (SUPERLITE_USED)
		   {
		   if (DataClock_Out_Reg[t] == 0)
				printf("DataClock_out Frequency            : Measuring ...\n");				  
			else					
				printf("DataClock_out Frequency            : %3.5f Mhz\n",(float) (DataClock_Out_Reg[t]/1E6));	
			}
        printf("Recovered Clock Frequency (Lane %1d) : %3.5f MHz\n",REC_CLOCK_MEASURE_CHANNEL, (float) (RxClock_Reg[t]/1E6));
        printf("Measured ppm difference            : ");	  	
					if (ppm_difference[t] == 0) 
						printf("%d",ppm_difference[t]);					 
					else
						printf("\033[7m%d\033[m",ppm_difference[t]);	
	  printf("\n");	 
	  
	 printf("\n\n");
	}//display_phy

}



if (SHOW_TEMPERATURE)
{
    printf("\n");
    printf("                                       0         10        20        30        40        50        60        70        80        90\n");  
	 printf("                                       |.........|.........|.........|.........|.........|.........|.........|.........|.........|\n"); 

	printf("SDM Temperature                 : %3.1f" DEGREES " ",sdm_temperature);
    print_bar_temperature((int) sdm_temperature);	
    printf("\n");
	for (i = 0; i < 4;i++)
	{
    printf("Core %1d Temperature              : %3.1f" DEGREES " ",i,core_temperature[i]);
    print_bar_temperature((int) core_temperature[i]);		
    printf("\n");
	}
	
	// for (i = 0; i < 8; i++)
	// {
	// printf("Ftile Temperature               : %3.1f" DEGREES " ",tile_temperature[i]);
    // print_bar_temperature((int) tile_temperature[i]);		
    // printf("\n");
	// }

}




	 if (internal_noise_enabled == 1)
	 {

			int_noise_percentage =  (number_of_noise_chunks*100)/(NUMBER_OF_WABS);

    printf("\n");
    printf("                                      0         10        20        30        40        50        60        70        80        90       100\n");  
	 printf("                                      |.........|.........|.........|.........|.........|.........|.........|.........|.........|.........|\n"); 
    printf("Internal Core Noise Enable   : %3d %%  ",int_noise_percentage);
    print_bar_noise(int_noise_percentage);		 
	 }
	 printf("\n");

	allchannels_errorfree = 1;
	allchannels_errorcount = 0.0;
	all_phys_locked = 1;
	pma_direct_pam4_mode_used = 0;
			
   for (t = 0; t < NUMBER_OF_PHYS ; t++)
	{ 
	   if (SUPERLITE_USED == 0)
		{
			for (i = 0; i < number_of_lanes[t] ; i++)
			{ 
				if ((Locked[t][i] == 1) )
				{
					if (ErrorCount[t][i] > 0) 
					{
						allchannels_errorfree = 0;
						allchannels_errorcount += (double) ErrorCount[t][i];
					}
				}
				else
					all_phys_locked = 0;
			}
		}
		else
		{
			if (pma_direct_pam4_mode[t] == 1)
				pma_direct_pam4_mode_used = 1;
			
			if ((Locked[t][0] == 1) )
			{
				if (ErrorCount[t][0] > 0) 
				{
					allchannels_errorfree = 0;
					allchannels_errorcount += (double) ErrorCount[t][0];
				}
			}
			else
					all_phys_locked = 0;				
		}
	}
	
	
	if (all_phys_locked == 1)
	{
		if (allchannels_errorfree == 1)
			printf("\n" COLOR_OK "PASS : All channels are locked and errorfree" COLOR_RESET);
		else
		{
			if (pma_direct_pam4_mode_used == 1) // if one of the PHYS is using PAM4.
			{
				printf("\n" COLOR_OK "PASS : All channels are locked" COLOR_RESET);
				printf("\nTotal amount of errors : " COLOR_YELLOW "%e" COLOR_RESET,allchannels_errorcount);			
			}
			else
				printf("\n" COLOR_ALARM "FAIL : Total amount of errors :  %e" COLOR_RESET,allchannels_errorcount);	
		}
	}
	else
		printf("\n" COLOR_ALARM "FAIL : Not all channels are locked" COLOR_RESET);		
	
	printf("\n");
	
	if (AGILEX_SI_BOARD)
	{
		if (i2c_access_enabled == 1)		
			check_module_presence();
	}
	
	if (AGILEX_PCIE_DEVKIT)
	{
		if (i2c_access_enabled == 1)
			check_module_presence_fpc202(0);
	}
	  
	  
    printf("\n");
       
    printf("\nSelect Action : \n");
    printf("===============\n");
	 printf("P. Toggle Display to show info for All Phy's or only Selected Phy\n");
	 if ((fec_mode[0] != AGGREGATE_200GBE) && (fec_mode[0] != AGGREGATE_400GBE))	 
			printf(".. Set all channels in serial loopback except selected channel\n");   
	 if (ENABLE_MUTE_LANES)
	 {
		if (MUTE_ALL_CHANNELS)
			printf("[. Mute all transmitters\n");   		 
		else
		{
			if ((fec_mode[0] != AGGREGATE_200GBE) && (fec_mode[0] != AGGREGATE_400GBE))	
				printf("[. Mute all transmitters except selected channel\n");   
		}
		
		printf("]. Unmute all transmitters\n");
		if ((fec_mode[0] != AGGREGATE_200GBE) && (fec_mode[0] != AGGREGATE_400GBE))
		{
			printf("(. Reset all channels except selected channel\n");
			printf("). De-assert Reset on all channels\n");
		}
	 }
    printf("1. Perform a reset on the Selected Phy\n");
	 if ((fec_mode[0] != AGGREGATE_200GBE) && (fec_mode[0] != AGGREGATE_400GBE))	
	 {
		printf("~. Perform a reset on the Selected channel\n");
		printf("$. Perform a rx_reset on the Selected channel\n");	 
		printf("^. Perform a tx_reset on the Selected channel\n");	 	 
	 }
	 if (NUMBER_OF_PHYS > 1)
	 printf("2. Select Phy\n");
	 printf("3. Select Channel To Control\n");	
	 #ifdef PRBSLOCK_ALARM_COUNTER_ENABLED
	   if (pma_direct_mode[0] == 1) // only valid when pma_direct_mode is used
			printf("4. Do Tx bitslip on selected channel\n");	
		else if (SCRAMBLED_IDLE_PATTERN_SUPPORTED)
			printf("4. Toggle between Prbs and Scrambled Idle Pattern on Selected Phy\n");
	 #endif

	 if (BER_CONTROL_USED)
		printf("5. Insert Soft Prbs Biterror or enable BER errorpattern on Selected Channel\n");
	 else 
	 {
		if (SUPERLITE_USED == 0)
			printf("5. Insert Soft Prbs Biterror on Selected Channel\n"); 
		else
			printf("5. Insert Biterrors on Link (%1d at a time)\n",NUMBER_OF_VIRTUAL_LANES); 
	 }

	 
	 #ifdef RSFEC_USED
	 printf("*. Inject RSFEC errors during 1ms on Selected Channel/Segment in Selected PHY (pat=0x01,rate=0x01)\n"); 
	 printf("#. Build FEC Errortree live for Selected Phy\n");
	 #endif
	 if (SUPERLITE_USED == 0)
		printf("6. Reset ErrorCounter on selected Channel\n");	 
	 else
		printf("6. Reset ErrorCounter\n");	 		 
    printf("7. Show Status\n");
    printf("8. Control Serial loopback in Selected Phy\n");
    printf("{. Control Reverse Parallel loopback in Selected Phy\n");
	 if (SUPERLITE_USED == 0)
	 {
		printf("9. Reset Errorcount on all channels in Selected Phy\n");	
		printf("A. Select Prbs Pattern on Selected Channel\n");
	 }
	 #ifdef RSFEC_USED
	   if (SUPERLITE_USED == 0)
			printf("?. Enable/Disable Scrambling of the datapath on all Phys\n");
	 #endif
    //printf("B. Show detailed Errorcount\n");	  
    printf("C. continuously update BER and errorcount every %d seconds\n",BERInterval);
    printf("D. Input new BER Time Interval\n");
	 if (FHT_USED == 0)
		printf("E. Show Transceiver PMA Settings on all channels\n");	
	 if (fw_196_detected)
		printf("F. Change Media Mode on all channels of Selected Phy\n");	 
	 printf("G. Change TX PMA settings on the Selected Phy\n");
	 //printf("V. Change TX PMA settings on selected channel\n");	 
	 //if (pam4_mode[0] == 1)
	 //{
	 //printf("H. Enable/Disable Gray Encoding in Selected Phy\n"); 
	 //printf("I. Enable/Disable 1/1+D Encoding in Selected Phy\n"); 	
	 ////printf("J. Enable/Disable Swizzle in Selected Phy\n");
	 //}
	 if (FHT_USED == 0)
	 {
	 printf("M. Control Tx Polarity in Selected Phy\n");	 
	 printf("N. Control Rx Polarity in Selected Phy\n");	 
	 }
	 if (FHT_USED == 0)
	 {
	 printf("O. Perform Vertical Eye Height Measurement on selected Physical Channel\n");	
	 }
	 printf("Q. Clear Errorcounters on all Phys (including RSFEC counters)\n"); 
	 printf("R. Rerun adaptation on all channels in Selected Phy \n");
	 //printf("S. Store register space of Selected Channel\n");	 
	 //printf("T. Readout register space of Selected Channel and compare with previously stored register space and list differences\n");	 
	 if (FHT_USED == 0)
	 {
	 if (UPDATE == 1)	 
		 printf("U. Sweep PMA settings and program best setting on selected channel\n");
	  else
		 printf("U. Sweep PMA settings on selected channel\n");	 
	 }
	 if (SUPERLITE_USED)
	 {
		printf("K. Toggle Throttle Datarate (set to 50%% throughput) on Selected Phy\n");
		printf("X. Toggle XOFF to partner to stop/start sending traffic at remote side \n");
	 }

	
	 if ((AGILEX_SI_BOARD) || (AGILEX_PCIE_DEVKIT))
	 printf("}. Dump I2C registers of selected module (Lower Page and Page 00h)\n");

	if (internal_noise_enabled)
	{
	 printf("+. Increase internal core noise in discrete steps\n"); 
	 printf("-. Decrease internal core noise in discrete steps \n");  
	}

	 
	 printf("!. Read Register of PHY Direct in Selected Phy using rd_channel\n");
	 printf(":. Read Register of PHY Direct in Selected Phy using rd_channel_ftile\n");	 
	 //printf("+. Dump RSFEC major configuration and status registers of Selected Phy\n");
	 if (SUPERLITE_USED == 0)
		printf("L. Stress test functions\n");	 
	 else
		printf("L. Stress test functions including latency measurement\n");	 		 
 	 printf("Z. Dump address space\n");	 

	 

  
	 
		
	if (PASS_FAIL_MODE)
	{
		stop = 1;
		//printf("\nstop is %d",stop);
		printf("%c",0x04);
		return(0);
	}
	else
	{
 
    printf("To stop the test press CTRL-C (this will automatically create output.log file \n\n");
    printf("  Enter Choice :");
		rx_char = input_char();

		
		switch (rx_char)
		{
			

		



	   case 'q':
		case 'Q':
		
			for (t = 0; t < NUMBER_OF_PHYS ; t++)
		 { 	
				clear_counters(t);

		 }


			 
		
		break;
		 
		 

#ifdef RSFEC_USED
		case '*':
		
		printf("\nWhich segment do  you want to insert the errors on?");
		printf("\nFor S0  type 0");
		if (number_of_segments[Selectedphy] >= 2)	
			printf("\nFor S1  type 1");
		if (number_of_segments[Selectedphy] >= 4)
			{
			printf("\nFor S2  type 2");
			printf("\nFor S3  type 3");
			}
		if (number_of_segments[Selectedphy] > 4)
			{
			printf("\nFor S4  type 4");
			printf("\nFor S5  type 5");
			printf("\nFor S6  type 6");
			printf("\nFor S7  type 7");			
			}	
		if (number_of_segments[Selectedphy] > 8)
			{
			printf("\nFor S8  type 8");
			printf("\nFor S9  type 9");
			printf("\nFor S10 type 10");
			printf("\nFor S11 type 11");	
			printf("\nFor S12 type 12");
			printf("\nFor S13 type 13");
			printf("\nFor S14 type 14");
			printf("\nFor S15 type 15");				
			}			
		printf("\nChoice :");
		temp = input_double();
		
		Write_FEC_error_inject(Selectedphy,SelectedChannel[Selectedphy],ethernet_mode[Selectedphy],temp,0x01, 0x01);
		usleep(1000);
		Write_FEC_error_inject(Selectedphy,SelectedChannel[Selectedphy],ethernet_mode[Selectedphy],temp,0x00, 0x00);		
		
		break;
#endif
		
      case '1': /* Reset Phy*/

		
 	 
		reset_phy(Selectedphy,USE_RESET);
		
		usleep(1000000); //wait 1 second for reset affect to ripple through
		 
		#ifdef RSFEC_USED 
		clear_counters(Selectedphy);
		#endif
			
      printf("Reset phy %1d.\n\n\n",Selectedphy);
		 
			
		
		
		
		
        break; //case '1'


      case '~': /* Reset channel*/

		
 	 
		reset_channel(Selectedphy,SelectedChannel[Selectedphy]);
		
		usleep(1000000); //wait 1 second for reset affect to ripple through
		
		//clear_counters(Selectedphy);
		 
		
		 
			
		
		
		
		
        break; //case '~'
		  
      case '$': /* Reset Rx of selected channel*/

		
 	 
		reset_rx_channel(Selectedphy,SelectedChannel[Selectedphy]);
		
		usleep(1000000); //wait 1 second for reset affect to ripple through
		
		//clear_counters(Selectedphy);
		 
		
		 
			
		
		
		
		
        break; //case '~'
		  
      case '^': /* Reset Tx of selected channel*/

		
 	 
		reset_tx_channel(Selectedphy,SelectedChannel[Selectedphy]);
		
		usleep(1000000); //wait 1 second for reset affect to ripple through
		
		//clear_counters(Selectedphy);
		 
		
		 
			
		
		
		
		
        break; //case '~'
		  
		  
		  

	case '2' :/*Select phy To control */



      printf("\n2. Select Selected Phy \n");
      printf("Current Phy : %1d", Selectedphy);

		if (display_Selectedphy_only == 1)
			display_phy[Selectedphy] = 0;	

 		 
  
      printf("\nNew Phy (0-%2d)         :",NUMBER_OF_PHYS-1);
      Selectedphy = input_byte(); 

          
      printf("\n New phy %d : \n",Selectedphy);     
                   
	   display_phy[Selectedphy] = 1;


	 break; //case '2'

     case '3': /*Select Channel To Control*/
     printf("\n3. Select Channel To Control in Phy %1d\n",Selectedphy);
      printf("Current Channel : ");
		
		printf(" Channel %d: PRBS-%2d Bitrate %4d Mbps \n",SelectedChannel[Selectedphy],PrbsPattern[Selectedphy][SelectedChannel[Selectedphy]],Bitrate[Selectedphy]); 
 
  

      printf("New Channel (0-%d)         :",(number_of_lanes[Selectedphy]-1));
		  
      SelectedChannel[Selectedphy] = input_number(); 
	
		
          Control2_Reg[Selectedphy] = (Control2_Reg[Selectedphy] & (0xFFE0)) | (SelectedChannel[Selectedphy]);
          write_control2_reg(Selectedphy,Control2_Reg[Selectedphy]);
		
			     
                   

        
      break; //case '3'
	 

	   case '4' : //insert bitslip
		
		 
		if (pma_direct_mode[Selectedphy] == 1) // only valid when pma_direct_mode is used
		{

			Control_Reg[Selectedphy] = set_bit(Control_Reg[Selectedphy],SelectedChannel[Selectedphy]+BITSLIP_START_BIT_POSITION);
			write_control_reg(Selectedphy,Control_Reg[Selectedphy]);				
				
			usleep(10);		


			Control_Reg[Selectedphy] = clear_bit(Control_Reg[Selectedphy],SelectedChannel[Selectedphy]+BITSLIP_START_BIT_POSITION);				
			write_control_reg(Selectedphy,Control_Reg[Selectedphy]);				

		}
		else if (SCRAMBLED_IDLE_PATTERN_SUPPORTED)	
		{
			if (scrambled_idle_pattern[Selectedphy] == 0)
				scrambled_idle_pattern[Selectedphy] = 1;
			else
				scrambled_idle_pattern[Selectedphy]= 0;
			
		Control_Reg[Selectedphy] = (Control_Reg[Selectedphy] & (0xFBFF)) | (scrambled_idle_pattern[Selectedphy] << 10);					
		write_control_reg(Selectedphy,Control_Reg[Selectedphy]);			
		}
		
		break;
			


        
		case '5': /* Insert SoftPRBS Biterrors */
     
	   if (BER_CONTROL_USED == 0)
		{
        printf("\n5. Insert Biterror on Selected Channel\n\n\n");


        Control_Reg[Selectedphy] = Control_Reg[Selectedphy] | (0x4000);
        write_control_reg(Selectedphy,Control_Reg[Selectedphy]);

			usleep(10);
        
        Control_Reg[Selectedphy] = Control_Reg[Selectedphy] & (0xBFFF);
        write_control_reg(Selectedphy,Control_Reg[Selectedphy]);
		}
		else //BER_CONTROL_ENABLED AND USED
		{
			
        printf("\nPress 1 if you want to insert 1 soft PRBS error on the Selected Channel");
		  printf("\nPress 2 if you want to generate a BER of 1.17E-4 on the Selected Channel (this will reset the entire PHY)");
		  temp = input_number();
		  
		  if (temp == 1) 
		  {
        Control_Reg[Selectedphy] = Control_Reg[Selectedphy] | (0x4000);
        write_control_reg(Selectedphy,Control_Reg[Selectedphy]);

			usleep(10);
        
        Control_Reg[Selectedphy] = Control_Reg[Selectedphy] & (0xBFFF);
        write_control_reg(Selectedphy,Control_Reg[Selectedphy]);			  
		  }
		  else if (temp == 2)
		  {
		#ifdef BER_CONTROL_ENABLED
		
		// -- Select the BER rate to use : BER_Control_Reg(15 downto 0)
		// --  ber_rate setting (decimal) -- 
		// --     1 => don't use this
		// --     2 => 1 error word per 5 cycles -- 1.56e-03
		// --     4 => 1 error word per 7 cycles -- 1.12e-03
		// --     8 => 1 error word per 11 cycles -- 7.10e-04
		// --     16 => 1 error word per 19 cycles -- 4.11e-04
		// --     32 => 1 error word per 35 cycles -- 2.23e-04
		// --     64 => 1 error word per 67 cycles -- 1.17e-04
		// --     128 => 1 error word per 131 cycles -- 5.96e-05
		// --     256 => 1 error word per 259 cycles -- 3.02e-05
		// --     512 => 1 error word per 515 cycles -- 1.52e-05
		// --     1024 => 1 error word per 1027 cycles -- 7.61e-06
		// --     2048 => 1 error word per 2051 cycles -- 3.81e-06
		// --     4096 => 1 error word per 4099 cycles -- 1.91e-06
		// --     8192 => 1 error word per 8195 cycles -- 9.53e-07
		// --     16384 => 1 error word per 16387 cycles -- 4.77e-07
		// --     32768 => 1 error word per 32771 cycles -- 2.38e-07


		// -- Enable PRBS with BER : BER_Control_Reg(23 downto 16);

		// -- PRBSlock enter threshold : BER_Control_Reg(31 downto 24) (decimal)
		// -- Recommended setting for entering when BER is 1.17E-4 or lower
		// -- 1 => don't use
		// -- 2 => threshold set to 2 (allows entering lock when 1.12e-03 or lower) 
		// -- 4 => threshold set to 3 (allows entering lock when 7.10e-04 or lower)
		// -- 8 => threshold set to 4 (allows entering lock when 4.11E-04 or lower) -- Default setting
		// -- 16 => threshold set to 5 (allows entering lock when 2.23e-04 or lower)
		// -- 32 => threshold set to 6 (allows entering lock when 1.17e-04 or lower) 
		// -- 64 => threshold set to 7 (allows entering lock when 5.96e-05 or lower) -- This was the setting for previous generations
		
			BER_Rate[Selectedphy] = 16;
		BER_Enable[Selectedphy] = 1; // lane 0
			Threshold[Selectedphy] = 3;
		
		BER_Control[Selectedphy] = (Threshold[Selectedphy] << 24) + (BER_Enable[Selectedphy] << 16) + BER_Rate[Selectedphy];
		
		write_ber_control_reg(Selectedphy,BER_Control[Selectedphy]);
		
		reset_phy(Selectedphy,USE_RESET);
		
		#endif	
		}
		}
		

       
         
		break; /* Case 5 */
		
		/*
		
		case '=': // Insert Burst of PMA Errors 
     
      printf("\nSpecify how many PMA errors you want to insert on Phy %d Channel %d (1-99): ",Selectedphy,SelectedChannel[Selectedphy]);
		
		temp = input_double();
		
		inject_error_etile (Selectedphy,SelectedChannel[Selectedphy], temp,high_datarate[Selectedphy]);
         
		break; // Case =
		
		*/
	
		case '6': /* Reset ErrorCounter */
        
	      printf("\n6. Reset ErrorCounter \n\n\n");
   
      
        Control_Reg[Selectedphy] = Control_Reg[Selectedphy] | (0x2000);
        write_control_reg(Selectedphy,Control_Reg[Selectedphy]);

		  usleep(10);
        
        Control_Reg[Selectedphy] = Control_Reg[Selectedphy] & (0xDFFF);
        write_control_reg(Selectedphy,Control_Reg[Selectedphy]);
        
        usleep(100000);   

         // Reset PrbsLockAlarm
		
		
            Control2_Reg[Selectedphy] = Control2_Reg[Selectedphy] | (0x8000);
            write_control2_reg(Selectedphy,Control2_Reg[Selectedphy]);

			usleep(10);
            
            Control2_Reg[Selectedphy] = Control2_Reg[Selectedphy] & (0x7FFF);
            write_control2_reg(Selectedphy,Control2_Reg[Selectedphy]);			  


		  usleep(10);
		  
            
       break;
	
      case '7': /* Show Status */ 
            
       break;    

      case '8': /*Control Serial Loop */
			
	


			
    	printf("\nCurrent Status of Serial Loopback in Phy %1d:\n",Selectedphy);

		printf("Channel           |");    
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{ 
		  printf("%2X|",i);
		}
		printf("\n");
		printf("                  |");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{ 
		printf("--|");
		}
		printf("\n");
	
		printf("Serial Loop       :");        
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{     
		  printf("%2d|",Serial_Loop[Selectedphy][i]);   
		}
		printf("\n"); 
  

               printf("\n");  
               
              printf("    Toggling Serial Loopback               \n");
               printf("    =========================              \n");
		
					if (PMA_BONDING == 0)
					{
               printf("    Toggle Serial Loopback on Channel  0    choose '0' \n");
               printf("    Toggle Serial Loopback on Channel  1    choose '1' \n");
				   if (number_of_physical_lanes[Selectedphy] > 2)
					{	
               printf("    Toggle Serial Loopback on Channel  2    choose '2' \n");
               printf("    Toggle Serial Loopback on Channel  3    choose '3' \n");
					}		
               printf("    ............ \n");
					if (number_of_physical_lanes[Selectedphy] >= 8)
						printf("    Toggle Serial Loopback on Channel  7    choose '7' \n");	
					if (number_of_physical_lanes[Selectedphy] >= 10)
						printf("    Toggle Serial Loopback on Channel  9    choose '9' \n");						
					if (number_of_physical_lanes[Selectedphy] >= 24)
               printf("    Toggle Serial Loopback on Channel 23    choose '23' \n");	
               // printf("    Enable Serial Loopback on FGT Quad0 choose \n");					
               printf("    Enable Serial Loopback on FGT Quad1     choose '10'\n");
               // printf("    Enable Serial Loopback on FGT Quad2 choose 20\n");
               // printf("    Enable Serial Loopback on FGT Quad3 choose 30\n");		
               printf("    Toggle Serial Loopback on Channel  3    choose '3' \n");						
					}
               printf("    Enable Serial Loopback on all Channels  choose '99' \n");
               printf("    Disable Serial Loopback on all Channels choose '50' \n");                    
               printf("    No Change                     choose '40' \n"); 
               printf("    Choice :");      
               
               temp    = input_double();

	  one_channel_only = 0; 
					 
					if (temp == 40)
					{
					// do nothing
					}
					else if (temp == 99)
					{
						 for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
							{ 
							Serial_Loop[Selectedphy][i] = 1;
							}					
					}
					else if (temp == 50)
					{
						 for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
							{ 
							Serial_Loop[Selectedphy][i] = 0;						
							}					
					}
					else if (temp == 10)
					{
						 for (i = 8; i < number_of_physical_lanes[Selectedphy] ; i++)
							{ 
							Serial_Loop[Selectedphy][i] = 1;						
							}					
					}					
					else
					{
					one_channel_only = 1;
							if (Serial_Loop[Selectedphy][temp] == 1)
							{
								Serial_Loop[Selectedphy][temp] = 0;							
							}
							else
							{
								Serial_Loop[Selectedphy][temp] = 1;
							}
							
					}
 
       	
		
		if (FHT_USED == 0)
		{

			if (temp != 40)
			{
				
			
				
				if (one_channel_only == 0)
				{      	
		
				//Assert Rx Reset on all lanes
				reset_rx_assert_phy(Selectedphy);
				
				usleep(100);
				
					
					for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
					{ 	
					
				
						if (Serial_Loop[Selectedphy][i] == 1)
						{
						//enable SILB CPI command 
						
						//void cpi_request(int phy, int offset, int data, int lane, int opcode, int assert)
						//Issue CPI request for serial loopback
						//Data : 0x0006 : PMA Tx to Rx buffered serial loopback, loops back the Tx serializer output into Rx Eq.
						//Opcode : 0x40
						
						//Lane : this is the physical lane (can be determined by reading out 0xFFFFC (only supported in production silicon)
						
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x0006, 0x40,1,1);
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x0006, 0x40,0,1);
						}
						else //serial loopback not set
						{
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x0000, 0x40,1,1);
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x0000, 0x40,0,1);							
						}
								

					} // for i
					
					//de-assert Rx reset on all lanes	
					reset_rx_deassert_phy(Selectedphy);
					
					// readback serial loopback 
					// this takes time before this bit is set.
					// also adaptation takes time before the link is up so this why a wait time of 100 ms is used.
					
					usleep(100000);
					
					readback_loopbacks(Selectedphy);
					
					
					
				} 
				else //One channel
				{
				//Assert Rx Reset Selected channel				
				reset_rx_assert_channel(Selectedphy,temp);

				usleep(100);
				
					if (Serial_Loop[Selectedphy][temp] == 1)
					{
					//enable SILB CPI command 
					
					//void cpi_request(int phy, int offset, int data, int lane, int opcode)
					//Issue CPI request for serial loopback
					//Data : 0x0006 : PMA Tx to Rx buffered serial loopback, loops back the Tx serializer output into Rx Eq.
					//Opcode : 0x40
					//Lane : this is the physical lane (can be determined by reading out 0xFFFFC (only supported in production silicon)
				
						readout = cpi_request_fgt(Selectedphy, temp, offset[Selectedphy], 0x0006, 0x40,1,1);
						readout = cpi_request_fgt(Selectedphy, temp, offset[Selectedphy], 0x0006, 0x40,0,1);
							
					} 
				
					else //serial loopback not set
					{
						readout = cpi_request_fgt(Selectedphy, temp, offset[Selectedphy], 0x0000, 0x40,1,1);
						readout = cpi_request_fgt(Selectedphy, temp, offset[Selectedphy], 0x0000, 0x40,0,1);
					}
								


		
					//de-assert Reset_Rx on selected channel (the others are already de-asserted)
					reset_rx_deassert_channel(Selectedphy,temp);
					
					// readback serial loopback 
					// this takes time before this bit is set.
					// also adaptation takes time before the link is up so this why a wait time of 100 ms is used.
					
					usleep(100000);
					
					readback_loopbacks(Selectedphy);

					
					
				} 
			 printf("\nChanged serial loop.\n\n\n");	
			usleep(1000000);
			}    
		}
		else //FHT
		{

			if (temp != 40)
			{
				
				if (one_channel_only == 0)
				{      	
									
					for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
					{ 	
					
				
						if (Serial_Loop[Selectedphy][i] == 1)
						{
							//set bit[14] of address 0x45800
							// rmw_channel(Selectedphy,(i << offset[Selectedphy]) + 0x45800,0x00004000,0x4000);
							rmw_channel_ftile (Selectedphy, i, offset[Selectedphy],LOOPBACK_ADDR_FHT, 0x00004000,0x4000 );
		
						}
						else //serial loopback not set
						{
							rmw_channel_ftile (Selectedphy, i, offset[Selectedphy],LOOPBACK_ADDR_FHT, 0x00004000,0x0000 );							

						}
								

					} // for i
		
					//de-assert Reset_Rx
					//Control_Reg[Selectedphy] = Control_Reg[Selectedphy] & (0xFF0F);	
					//write_control_reg(Selectedphy,Control_Reg[Selectedphy]);		
		
					//if (DEBUG_RESET) printf("\nPhy %1d reset_rx de-asserted on all lanes",Selectedphy);	
					
					// readback serial loopback 
					// this takes time before this bit is set.
					// also adaptation takes time before the link is up so this why a wait time of 100 ms is used.
					
					usleep(100000);
					
					readback_loopbacks(Selectedphy);
					
					
					
				} 
				else //One channel
				{
				//Assert Rx Reset Selected channel
				//Control_Reg[Selectedphy] = Control_Reg[Selectedphy] | (0x10 << temp);	
				//write_control_reg(Selectedphy,Control_Reg[Selectedphy]);	
		
				//if (DEBUG_RESET) printf("\nPhy %1d reset_rx asserted on channel %d",Selectedphy,temp);
		
				// do 
				// {
						// Channel_Reg[Selectedphy][temp]      =  Read_Channel_Reg(Selectedphy,temp);
						// rx_reset_ack[Selectedphy][temp] = 0x0001 & (Channel_Reg[Selectedphy][temp] >> 2);				

				// } while (rx_reset_ack[Selectedphy][temp]  == 0);

				
					if (Serial_Loop[Selectedphy][temp] == 1)
					{
							rmw_channel_ftile (Selectedphy, temp, offset[Selectedphy],LOOPBACK_ADDR_FHT, 0x00004000,0x4000 );						
							
					} 			
					else //serial loopback not set
					{
							//clear bit[14] of address 0x45800
							rmw_channel_ftile (Selectedphy, temp, offset[Selectedphy],LOOPBACK_ADDR_FHT, 0x00004000,0x0000 );								

					}
								


		
					//de-assert Reset_Rx on selected channel (the others are already de-asserted)
					// Control_Reg[Selectedphy] = Control_Reg[Selectedphy] & (0xFF0F);	
					// write_control_reg(Selectedphy,Control_Reg[Selectedphy]);		
		
					// if (DEBUG_RESET) printf("\nPhy %1d reset_rx de-asserted on channel %d",Selectedphy,temp);	
					
					// readback serial loopback 
					// this takes time before this bit is set.
					// also adaptation takes time before the link is up so this why a wait time of 100 ms is used.
					
					usleep(100000);
					
					readback_loopbacks(Selectedphy);

					
					
				} 
			 printf("\nChanged serial loop.\n\n\n");						
			}    
	       

		  
		} //FHT
		



        break; //case '8'   

		case '{':	
		
	 
    
			
    	printf("\nCurrent Status of Reverse Parallel Loopback :\n");
    
		printf("Channel           |");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{ 
		  printf("%2d|",i);
		}
		printf("\n");
		printf("                  |");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{ 
		printf("--|");
		}
		printf("\n");
		
		printf("Reverse // Loop   :");  		
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{     
				if (Rev_Parallel[Selectedphy][i] == 1)
						printf(" 1|");
				else
						printf(" 0|");					
		}
		printf("\n"); 
  

               printf("\n");  
               
              printf("    Toggling Reverse Parallel loopback \n");
               printf("    =================================              \n");
               printf("    Toggle Reverse Parallel loopback on Channel  0  choose '0' \n");
               printf("    Toggle Reverse Parallel loopback on Channel  1  choose '1' \n");
					if (number_of_physical_lanes[Selectedphy] >= 2)	
					{	
               printf("    Toggle Reverse Parallel loopback on Channel  2  choose '2' \n");
               printf("    Toggle Reverse Parallel loopback on Channel  3  choose '3' \n");
					}
               printf("    ............ \n");
					if (number_of_physical_lanes[Selectedphy] >= 8)
						printf("    Toggle Reverse Parallel loopback on Channel  7  choose '7' \n");	
					if (number_of_physical_lanes[Selectedphy] >= 10)
						printf("    Toggle Reverse Parallel loopback on Channel  9  choose '9' \n");						
					if (number_of_physical_lanes[Selectedphy] >= 24)
               printf("    Toggle Reverse Parallel loopback on Channel 23  choose '23' \n");			
               printf("    Enable Reverse Parallel loopback on all Channels choose '99' \n");
               printf("    Disable Reverse Parallel loopback on all Channels choose '50' \n"); 
               printf("    IMPORTANT : You cannot set Reverse Parallel loopback on a channel which already has serial loopback enabled \n"); 						
               printf("    No Change                 choose '40' \n");  
               printf("    Choice :");      
               
               temp    = input_double();
					 
					if (temp == 40)
					{
					printf("\nNo change");
					}
					else
					{				
						
						if (temp == 99)
						{
							 for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
								{ 

								Rev_Parallel[Selectedphy][i] = 1;
								rmw_channel_ftile (Selectedphy, i, offset[Selectedphy],LOOPBACK_ADDR_FGT, 0x00000004,0x04 );															
								usleep(100000);
								}		
								
						}
						else if (temp == 50)
						{
							 for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
								{ 
								Rev_Parallel[Selectedphy][i] = 0;
								rmw_channel_ftile (Selectedphy, i, offset[Selectedphy],LOOPBACK_ADDR_FGT, 0x00000004,0x00 );										
								usleep(100000);									
								}					
						}
						else
						{
								if (Rev_Parallel[Selectedphy][temp] == 1)
								{	
									Rev_Parallel[Selectedphy][temp] = 0;
									rmw_channel_ftile (Selectedphy, temp, offset[Selectedphy],LOOPBACK_ADDR_FGT, 0x00000004,0x00 );	
									usleep(100000);																		
								}
								else
								{
									Rev_Parallel[Selectedphy][temp] = 1;
									rmw_channel_ftile (Selectedphy, temp, offset[Selectedphy],LOOPBACK_ADDR_FGT, 0x00000004,0x04 );
									usleep(100000);										
								}


						}
	 
			

						printf("\nChanged Reverse Parallel loopback mode .\n\n\n");
						
					
					
					}	 //else
					
				



	 break; //case '{'      
  

		case '9' : //Reset errorcount on Selected Phy
	
       Control2_Reg[Selectedphy] = (Control2_Reg[Selectedphy] & (0xFFE0)) | (0x1F); // Select all channels
        write_control2_reg(Selectedphy,Control2_Reg[Selectedphy]);  
		 
 	
		 // Reset errorcount on all channels.
        Control_Reg[Selectedphy] = Control_Reg[Selectedphy] | (0x2000);
        write_control_reg(Selectedphy,Control_Reg[Selectedphy]);

 		  
		  usleep(10);
        
        Control_Reg[Selectedphy] = Control_Reg[Selectedphy] & (0xDFFF);
        write_control_reg(Selectedphy,Control_Reg[Selectedphy]);
		
		  usleep(10);
       		
		
          // Reset PrbsLockAlarm
		
		
            Control2_Reg[Selectedphy] = Control2_Reg[Selectedphy] | (0x8000);
            write_control2_reg(Selectedphy,Control2_Reg[Selectedphy]);

			usleep(10);
            
            Control2_Reg[Selectedphy] = Control2_Reg[Selectedphy] & (0x7FFF);
            write_control2_reg(Selectedphy,Control2_Reg[Selectedphy]);				  

			usleep(10);

	
		 // set back channel to selectedchannel.
	

          Control2_Reg[Selectedphy] = (Control2_Reg[Selectedphy] & (0xFFE0)) | (SelectedChannel[Selectedphy]);
        write_control2_reg(Selectedphy,Control2_Reg[Selectedphy]);  
			
     
			break; //case '9'
			
			
      case 'a':
      case 'A': /*Select Prbs Pattern*/

      printf("\nA. Select Prbs Pattern on Selected Channel %d and Reset\n",SelectedChannel[Selectedphy]);
      printf("    Current Prbs Pattern Selected   : ");
		if ((pam4_mode[Selectedphy] == 0) && (USE_128BIT_PRBS_NRZ == 0))
		{
      switch (PrbsSelect[Selectedphy][SelectedChannel[Selectedphy]])
       {
       case  0  : printf(" PRBS-7\n"); break;
       case  1  : printf(" PRBS-23\n"); break;
       case  2  : printf(" PRBS-31\n"); break;
       case  3  : printf(" PRBS-15\n"); break;
		 case  6  : printf(" PRBS-9\n"); break;
       case  4  : printf(" High Frequency Pattern (no verification)\n"); break;
		 case  5  : printf(" Low Frequency Pattern (no verification)\n"); break;	
		 case  7  : printf(" Special clock pattern (9 bits '1', 9 bits '0' (no verification)\n"); break;				 
       default : break;
       }  
		}
		else
		{
      switch (PrbsSelect[Selectedphy][SelectedChannel[Selectedphy]])
       {
       case  0  : printf(" PRBS-13\n"); break;
       case  1  : printf(" PRBS-23\n"); break;
       case  2  : printf(" PRBS-31\n"); break;		 
       case  3  : if ((FHT_HIGHEST_RATE == 1) || (USE_PAM4_CLOCK_PATTERN_INSTEAD_OF_PRBS7))
							printf(" Clock Pattern (no checking)\n");		
						else
							printf(" PRBS-7\n"); 						
						break;	
		 case  4  : if (USE_PAM4_DUAL_CLOCK_PATTERN)
							printf(" FF00 Pattern (no checking) \n");
						break;
		 case  5  : if (USE_PAM4_DUAL_CLOCK_PATTERN)
							printf(" FFFF0000 Pattern (no checking) \n");
						break;						
       default : break;
       }  
		}			
     
     

        printf("\n");  
 		if ((pam4_mode[Selectedphy] == 0) && (USE_128BIT_PRBS_NRZ == 0))
		{     
        do {			
        printf("    New Prbs Pattern on Channel %1d               \n",SelectedChannel[Selectedphy]);
        printf("    ============================                \n");
        printf("    For PRBS-7   choose '0' \n");
        printf("    For PRBS-9   choose '1' \n");
        printf("    For PRBS-15  choose '2' \n"); 
        printf("    For PRBS-23  choose '3' \n");
        printf("    For PRBS-31  choose '4' \n");
        printf("    For High Frequency Pattern choose '5' \n");  
        printf("    For Low Frequency Pattern choose '6' \n"); 
        printf("    For Special clock pattern (9 bits '1', 9 bits '0' choose '7' \n"); 		
        printf("    No Change    choose 'X' \n\n");    
        printf("    Choice :");             
        
        temp_input = 0xffff;
                                             
        rx_char   = input_char();
        switch (rx_char)
        {
        case '0': temp_input =  PRBS_7; break;
        case '1': temp_input =  PRBS_9; break;
        case '2': temp_input =  PRBS_15; break;
        case '3': temp_input =  PRBS_23; break; 
        case '4': temp_input =  PRBS_31; break; 
        case '5': temp_input =  HIGH_FREQUENCY; break; 
        case '6': temp_input =  LOW_FREQUENCY; break; 
        case '7': temp_input =  FRAMED; break; 			  
        case 'x': 
        case 'X': temp_input =  PrbsSelect[Selectedphy][SelectedChannel[Selectedphy]];break;
        default : break;
        }
        } while (temp_input == 0xffff);
	   }
		else
		{   
        do {				
        printf("    New Prbs Pattern on Channel %1d               \n",SelectedChannel[Selectedphy]);
        printf("    ============================                \n");
        printf("    For PRBS-13        choose '0' \n");
        printf("    For PRBS-23        choose '1' \n");
        printf("    For PRBS-31        choose '2' \n"); 
		  if ((FHT_HIGHEST_RATE == 1) || (USE_PAM4_CLOCK_PATTERN_INSTEAD_OF_PRBS7 == 1))
				printf("    For Clock Pattern    choose '3' \n");  			  
		  else
				printf("    For PRBS-7         choose '3' \n");			  
		  if (USE_PAM4_DUAL_CLOCK_PATTERN)
				printf("    For FF00 pattern     choose '4' \n");			  
	     if (USE_PAM4_DUAL_CLOCK_PATTERN)
				printf("    For FFFF0000 pattern choose '5' \n");			  
		  
        printf("    No Change          choose 'X' \n\n");    
        printf("    Choice :");             
        
        temp_input = 0xffff;
                                             
        rx_char   = input_char();
        switch (rx_char)
        {
        case '0': temp_input =  PRBS_13_PAM4; break;
        case '1': temp_input =  PRBS_23_PAM4; break;
        case '2': temp_input =  PRBS_31_PAM4; break;
        case '3': temp_input =  PRBS_7_PAM4; break; 	  
        case '4': temp_input =  PATTERN_FF00; break; 		
        case '5': temp_input =  PATTERN_FFFF0000; break; 			  
        case 'x': 
        case 'X': temp_input =  (unsigned int) PrbsSelect[Selectedphy][SelectedChannel[Selectedphy]];break;
        default : break;
        }
        } while (temp_input == 0xffff);
		  
		}			
			
 
        PrbsSelect[Selectedphy][SelectedChannel[Selectedphy]] = temp_input; 
		  
		  

		  
		  
     Control2_Reg[Selectedphy] = Control2_Reg[Selectedphy] | (0x1000); /* Latch PrbsPattern Assert */
     write_control2_reg(Selectedphy,Control2_Reg[Selectedphy]);  
	  usleep(10);  
		  
     Control2_Reg[Selectedphy] = (Control2_Reg[Selectedphy] & (0xF8FF)) | (PrbsSelect[Selectedphy][SelectedChannel[Selectedphy]] << 8); 
     write_control2_reg(Selectedphy,Control2_Reg[Selectedphy]);  
     
     Control2_Reg[Selectedphy] = Control2_Reg[Selectedphy] & (0xEFFF); /* Latch PrbsPattern Deassert */
     write_control2_reg(Selectedphy,Control2_Reg[Selectedphy]);  

	  

          
          Control_Reg[Selectedphy] = Control_Reg[Selectedphy] | (0x8000);
          write_control_reg(Selectedphy,Control_Reg[Selectedphy]);  


	  
          usleep(100);
          
          Control_Reg[Selectedphy] = Control_Reg[Selectedphy] & (0x7FFF);
          write_control_reg(Selectedphy,Control_Reg[Selectedphy]); 
	  

      usleep(1000000); 
      break; //case 'A'

	 #ifdef RSFEC_USED
	 case '?':
		 
        
	     if (enable_scrambler[0] == 0) 
			  printf("\nScrambling is disabled on both phys, press '1' to enable scrambling on both phys (not applicable for PMA direct modes) : ");
		  else
			  printf("\nScrambling is enabled on both phys, press '0' to disable scrambling on both phys (not applicable for PMA direct modes) : ");

		  temp = input_byte();

			for (t = 0; t < NUMBER_OF_PHYS ; t++)
			{ 		  
				 if (temp == 0)
					enable_scrambler[t] = 0;
				 else if (temp == 1)
					enable_scrambler[t] = 1;
				 else
					 enable_scrambler[t] = enable_scrambler[t];
				 
				Control_Reg[t] = (Control_Reg[t] & (0xEFFF)) | (enable_scrambler[t] << 12);	
				write_control_reg(t,Control_Reg[t]);
				 
				usleep(1000);
				 
				//Reset errorcounter on all phy's				
				clear_counters(t); 
				
		 
			 }
			 

            
       break;
	   
	 #endif
      
     case 'b':
     case 'B': 
        Show_ErrorCount = 1;
        break;

	 
     case 'c': //continuously update BER and errorcount every BERInterval seconds
     case 'C': 

		 //re-assign to some shorter names for readibility		  
		 phy = Selectedphy;
		 chan = SelectedChannel[Selectedphy];

        printf("\n");  
        printf("Phy %1d Ch %1d BER related statistics every %d seconds              \n",phy, chan,BERInterval);
		  if (internal_noise_enabled)
		  {
			printf("\nPress + (and enter) to increase internal noise");
			printf("\nPress - (and enter) to decrease internal noise");		
			printf("\nPress s (and enter) to stop");		
			//printf("\nPress Control + C to exit the program");
		  }
		  else
		  {
	        printf("Press Enter to stop the loop\n");	
		  }
        printf("\n============================================== \n");
		  

		 
		  

				printf(">>>> HH:MM:SS");
				printf(",Core_Temp[0],Core_Temp[1],Core_Temp[2],Core_Temp[3]");
				if (internal_noise_enabled == 1)
					printf(",Internal Noise %%");					
				if (Locked[phy][chan] == 1)
				{
					printf(",PrbsLockAlarm");	
					if (prbslock_alarm_counter_present[phy] == 1)
					{							
						printf(",PrbsLock_Alarm_Count");
						#ifdef PRBSLOCK_ALARM_COUNTER_ALT_ENABLED
							printf(",False_PrbsLock_Count");
						#endif
						if (pma_direct_mode[phy] == 1)
						{
							printf(",Bitslip_Count");
							#ifdef PRBSLOCK_ALARM_COUNTER_ALT_ENABLED
								printf(",Alt_Bitslip_Count");
							#endif								
						}							
					}											
					printf(",BER,Errorcount(63:32),ErrorCount(31:0),Errorcount(float)");
					if (pma_direct_mode[phy] == 1)
					{
						printf(",Incremental Errorcount") ;
					}
					else
					{
						if (rx_am_lock[phy][chan] == 1)					
						{
							if (rx_am_lock_alarm_counter_present[phy] == 1)	//rsfec
								{
									printf(",Rx_AM_LockAlarm");	
									printf(",Rx_AM_LockAlarm_Count");	
								}						
							printf(",Uncorrected CW,Corrected CW,Incremental Corrected CW,Precorrected BER,Totalbits");
						}
					}					
					
				}
				else //no Locked
				{
					if (pma_direct_mode[phy] == 0)
					{
						if (rx_am_lock[phy][chan] == 1)				
						{
							if (rx_am_lock_alarm_counter_present[phy] == 1)	//rsfec
								{
									printf(",Rx_AM_LockAlarm");	
									printf(",Rx_AM_LockAlarm_Count");	
								}						
								printf(",Uncorrected CW,Corrected CW,Incremental Corrected CW,Precorrected BER,Totalbits");					
						}
					}			
				}
			printf("\n");
			
        temp = 0;
			
		int fd = fileno(stdin);
		
		//set stdin non-blocking
		
		int flags = fcntl(fd, F_GETFL, 0);
		//printf("\nflags : 0x%x\n",flags);
		fcntl(fd, F_SETFL, flags | O_NONBLOCK);				
        		
	    // int corrected_min = 99999999;
	    // int corrected_max = 0;
	    // int corrected_avg = 0;
	    // int corrected_sum = 0;	
		 

		 

		 
		 FEC_Correctable_Codeword[phy][chan] = 0.0; //initialize
		 FEC_UnCorrectable_Codeword[phy][chan] = 0.0; //initialize
		 
		 //Clear errorcounters at start and start the time
		 
		      Control_Reg[phy] = Control_Reg[phy] | (0x2000);
            write_control_reg(phy,Control_Reg[phy]); 

				usleep(10);
            
            Control_Reg[phy] = Control_Reg[phy] & (0xDFFF);
            write_control_reg(phy,Control_Reg[phy]); 

				#ifdef PRBSLOCK_ALARM_COUNTER_ENABLED
				for (j=0; j < number_of_lanes[phy] ; j ++)
				{				
					PrbsLock_Alarm_Count[phy][j] = Read_PrbsLock_Alarm_Reg(phy,j) & (0xFFFF);
					Bitslip_Count[phy][j] = (Read_PrbsLock_Alarm_Reg(phy,j) >> 16) & (0xFFFF);	
					
					#ifdef PRBSLOCK_ALARM_COUNTER_ALT_ENABLED
					PrbsLock_Alarm_Count_Alt[phy][j] = Read_PrbsLock_Alarm_Reg_Alt(phy,j) & (0xFFFF);
					Bitslip_Count_Alt[phy][j] = (Read_PrbsLock_Alarm_Reg_Alt(phy,j) >> 16) & (0xFFFF);						
					#endif
					
				}
				#endif	
				
				#ifdef RX_AM_LOCK_ALARM_COUNTER_ENABLED
				for (j=0; j < number_of_lanes[phy] ; j ++)
				{				
					//PrbsLock_Alarm_Count[phy][j] = Read_PrbsLock_Alarm_Reg(phy,j) & (0xFFFF);
					rx_am_lock_alarm_count[phy][j] = (Read_PrbsLock_Alarm_Reg(phy,j) >> 16) & (0xFFFF);	
					
				}
				#endif	
				
	

				
				
				#ifdef RSFEC_USED

							for (j=0; j < number_of_segments[phy] ; j ++)
							{
									fec_clear_counters(phy,chan,ethernet_mode[phy],j);
							}
				#endif
				
	 
        
			do
         {
        
			// readout temperatures
			capture_temperature();
			
			
				if (ACCUMULATE_ERRORS == 0) 
				{
					// Reset ErrorCount on Selected Channel
					temp = temp+1;
						 

				if (SUPERLITE_USED == 0)
					Control_Reg[phy] = Control_Reg[phy] | (0x2000);
				else
					Control_Reg[phy] = Control_Reg[phy] | (0x2200); //reset LockAlarm (Control_Reg(9))
				
			  write_control_reg(phy, Control_Reg[phy]);

			  
			  usleep(10);
				if (SUPERLITE_USED == 0)        
					Control_Reg[phy] = Control_Reg[phy] & (0xDFFF);
				else
					Control_Reg[phy] = Control_Reg[phy] & (0xDDFF);	
				
			  write_control_reg(phy, Control_Reg[phy]);
					
					
					// Reset PrbsLockAlarm
			
			
					Control2_Reg[phy] = Control2_Reg[phy] | (0x8000);
					write_control2_reg(phy,Control2_Reg[phy]);

					usleep(10);
					
					Control2_Reg[phy] = Control2_Reg[phy] & (0x7FFF);
					write_control2_reg(phy,Control2_Reg[phy]);
					
					
					
					#ifdef RSFEC_USED

								for (j=0; j < number_of_segments[phy] ; j ++)
								{
										fec_clear_counters(phy,chan,ethernet_mode[phy],j);
								}
					#endif
				
				}
	
				 
            
			TimeInterval = BERInterval * 1000000;
        
			usleep(TimeInterval);
			
					
			Counter_1ms_Reg[phy]     = read_counter_1ms_reg(phy);			

			#ifdef RSFEC_USED

			   //Issue a FEC shadow request	
			   for (j = 0; j < number_of_segments[phy] ; j++)
				{
					fec_shadow_request(phy,chan,ethernet_mode[phy],j);	
				}

				//Read FEC statistics

				  if (number_of_segments[phy] <= 2)
				  {
				  FEC_Correctable_Codeword_Reg_L[phy][chan] 		= Read_FEC_corr_codeword_Reg_L(phy,chan,ethernet_mode[phy],0);
				  FEC_Correctable_Codeword_Reg_H[phy][chan] 		= Read_FEC_corr_codeword_Reg_H(phy,chan,ethernet_mode[phy],0);
				  FEC_UnCorrectable_Codeword_Reg_L[phy][chan] 	= Read_FEC_uncorr_codeword_Reg_L(phy,chan,ethernet_mode[phy],0);	
				  FEC_UnCorrectable_Codeword_Reg_H[phy][chan] 	= Read_FEC_uncorr_codeword_Reg_H(phy,chan,ethernet_mode[phy],0);		  

				  }
				  else
				  {
				  FEC_Correctable_Codeword_Reg_L[phy][chan] 		= Read_FEC_corr_codeword_Reg_L(phy,chan,ethernet_mode[phy],0) + Read_FEC_corr_codeword_Reg_L(phy,chan,ethernet_mode[phy],ethernet_mode_segment[phy]);
				  FEC_Correctable_Codeword_Reg_H[phy][chan] 		= Read_FEC_corr_codeword_Reg_H(phy,chan,ethernet_mode[phy],0) + Read_FEC_corr_codeword_Reg_H(phy,chan,ethernet_mode[phy],ethernet_mode_segment[phy]);
				  FEC_UnCorrectable_Codeword_Reg_L[phy][chan] 	= Read_FEC_uncorr_codeword_Reg_L(phy,chan,ethernet_mode[phy],0) + Read_FEC_uncorr_codeword_Reg_L(phy,chan,ethernet_mode[phy],ethernet_mode_segment[phy]);	
				  FEC_UnCorrectable_Codeword_Reg_H[phy][chan] 	= Read_FEC_uncorr_codeword_Reg_H(phy,chan,ethernet_mode[phy],0) + Read_FEC_uncorr_codeword_Reg_H(phy,chan,ethernet_mode[phy],ethernet_mode_segment[phy]);		    
				  }	
			
				  for (j = 0; j < number_of_segments[phy] ; j++)
					{
					//define virtual lane
					vl = chan * number_of_segments[phy]  + j ; // lane 0 : vl= 0,1 lane 1 : vl = 2,3 ... 	

					if ((vl >= 0) && (vl < NUMBER_OF_VIRTUAL_LANES))
					{
						FEC_Correctable_Bits_0_1_Reg_L[phy][vl] 		= Read_FEC_corr_bits_0_1_Reg_L(phy,chan,ethernet_mode[phy],j);
						FEC_Correctable_Bits_0_1_Reg_H[phy][vl] 		= Read_FEC_corr_bits_0_1_Reg_H(phy,chan,ethernet_mode[phy],j);
						FEC_Correctable_Bits_1_0_Reg_L[phy][vl] 		= Read_FEC_corr_bits_1_0_Reg_L(phy,chan,ethernet_mode[phy],j);
						FEC_Correctable_Bits_1_0_Reg_H[phy][vl] 		= Read_FEC_corr_bits_1_0_Reg_H(phy,chan,ethernet_mode[phy],j);
					}
				 }


 
  
				//Clear shadow request	  
			   for (j = 0; j < number_of_segments[phy] ; j++)
				{
					fec_clear_shadow_request(phy,chan,ethernet_mode[phy],j);
				}
				
			#endif
       
            //Read ErrorCount registers
            
            Counter_1ms_Reg[phy]     = read_counter_1ms_reg(phy);
				
				Hours[phy] =  Counter_1ms_Reg[phy] / NUMBER_OF_MS_PER_HOUR ;
				Minutes[phy] = (Counter_1ms_Reg[phy] - (Hours[phy] * NUMBER_OF_MS_PER_HOUR))/NUMBER_OF_MS_PER_MINUTE;
				Seconds[phy] = (Counter_1ms_Reg[phy] - (Hours[phy] * NUMBER_OF_MS_PER_HOUR) - (Minutes[phy] * NUMBER_OF_MS_PER_MINUTE)) / NUMBER_OF_MS_PER_SECOND;
         
            
				ErrorCount_previous       =  ErrorCount[phy][chan];
				
				ErrorCount_Reg_L[phy][chan] =  Read_ErrorCount_L_Reg(phy,chan);
				ErrorCount_Reg_H[phy][chan] =  Read_ErrorCount_H_Reg(phy,chan);
            ErrorCount[phy][chan] = ((double) (ErrorCount_Reg_H[phy][chan]) *  MULTIPLIER * MULTIPLIER) + (double) (ErrorCount_Reg_L[phy][chan]);
 
				ErrorCount_difference =  ErrorCount[phy][chan] - ErrorCount_previous;
				
				Channel_Reg[phy][chan]      =  Read_Channel_Reg(phy,chan);
							
				
				rx_ready[phy][chan] = 0x0001 & (Channel_Reg[phy][chan] >> 13); 
				
				Locked[phy][chan]  = 0x0001 & (Channel_Reg[phy][chan] >> 15); 
	  
				PrbsLockAlarm[phy][chan]   = 0x0001 & (Channel_Reg[phy][chan] >> 0); 
				
				#ifdef RSFEC_USED
					rx_am_lock[phy][chan] = 0x0001 & (Channel_Reg[phy][chan] >> 12); 					
				#endif	

				#ifdef PRBSLOCK_ALARM_COUNTER_ENABLED 
					PrbsLock_Alarm_Count[phy][chan] = Read_PrbsLock_Alarm_Reg(phy,chan) & (0xFFFF);
					Bitslip_Count[phy][chan] = (Read_PrbsLock_Alarm_Reg(phy,chan) >> 16) & (0xFFFF);
				#endif
				
				#ifdef PRBSLOCK_ALARM_COUNTER_ALT_ENABLED
				PrbsLock_Alarm_Count_Alt[phy][chan] = Read_PrbsLock_Alarm_Reg_Alt(phy,chan) & (0xFFFF);
				Bitslip_Count_Alt[phy][chan] = (Read_PrbsLock_Alarm_Reg_Alt(phy,chan) >> 16) & (0xFFFF);						
				#endif
				
				
				#ifdef RX_AM_LOCK_ALARM_COUNTER_USED 
					rx_am_lock_alarm[phy][chan]   = 0x0001 & (Channel_Reg[phy][chan] >> 4); 					
					rx_am_lock_alarm_count[phy][chan] = Bitslip_Count[phy][chan];					
				#endif	
				
			
            Totalbits[phy] = (double) (Counter_1ms_Reg[phy]) * (double) (Bitrate[phy]*1000);

  
				if (ErrorCount[phy][chan] > 0)
					BER[phy][chan] = ((ErrorCount[phy][chan])) / Totalbits[phy];
				else
					BER[phy][chan] = 0;    
            
				int_noise_percentage =  (number_of_noise_chunks*100)/(NUMBER_OF_WABS);

				#ifdef RSFEC_USED				
				//per fec statistic (across all segments)
					FEC_Correctable_Bits_Total[phy][chan] = 0.0;  //per FEC
					ErrorCount_Total[phy][chan] = 0.0;
					Total_Correctable_Symbols[phy][chan] = 0.0;	

						
			  
				  for (j = 0; j < number_of_segments[phy]; j++)
				  {	
					if ((vl >= 0) && (vl < NUMBER_OF_VIRTUAL_LANES))
					{			  
						vl = chan * number_of_segments[phy]  + j ;
						FEC_Correctable_Bits_0_1[phy][vl] = ((double)(FEC_Correctable_Bits_0_1_Reg_H[phy][vl]) *  MULTIPLIER * MULTIPLIER) + (double) (FEC_Correctable_Bits_0_1_Reg_L[phy][vl]);	
						FEC_Correctable_Bits_1_0[phy][vl] = ((double)(FEC_Correctable_Bits_1_0_Reg_H[phy][vl]) *  MULTIPLIER * MULTIPLIER) + (double) (FEC_Correctable_Bits_1_0_Reg_L[phy][vl]);		  						
						FEC_Correctable_Bits_Total[phy][chan] += FEC_Correctable_Bits_0_1[phy][vl] + FEC_Correctable_Bits_1_0[phy][vl]; 
						ErrorCount_Total[phy][chan] += ErrorCount[phy][vl];
						//Total_Correctable_Symbols[phy][chan] += FEC_Correctable_Symbols[phy][vl]; 			
					}
				  }

				//printf("\nFEC_Correctable_Bits_Total[%1d][%1d] = %12e\n",phy,chan, FEC_Correctable_Bits_Total[phy][chan]);
				
				Precorrected_BER[phy][chan] = (double) (FEC_Correctable_Bits_Total[phy][chan] + ErrorCount_Total[phy][chan]) /(double) (Totalbits[phy]); 
				//Corrected_symbols_rate[phy][chan] =  (double) Total_Correctable_Symbols[phy][chan]/(Totalbits[phy]/(10)); // Totalbits for a virtual lane	  
	
				FEC_Correctable_Codeword_previous       =  FEC_Correctable_Codeword[phy][chan];

				FEC_Correctable_Codeword[phy][chan] = ((double)(FEC_Correctable_Codeword_Reg_H[phy][chan]) *  MULTIPLIER * MULTIPLIER) + (double) (FEC_Correctable_Codeword_Reg_L[phy][chan]);	
				FEC_UnCorrectable_Codeword[phy][chan] = ((double)(FEC_UnCorrectable_Codeword_Reg_H[phy][chan]) *  MULTIPLIER * MULTIPLIER) + (double) (FEC_UnCorrectable_Codeword_Reg_L[phy][chan]);	
		  
				Corrected_Codeword_difference = FEC_Correctable_Codeword[phy][chan] - FEC_Correctable_Codeword_previous;

			#endif				
				
				
				printf(">>>> %2dh:%2dm:%2ds",Hours[phy],Minutes[phy],Seconds[phy]);
				printf(", %3.1f, %3.1f, %3.1f, %3.1f",core_temperature[0], core_temperature[1], core_temperature[2], core_temperature[3]);
				if (internal_noise_enabled == 1)
					printf(", %3d%%",int_noise_percentage);					
				if (Locked[phy][chan] == 1)
				{
					printf(", %2d",PrbsLockAlarm[phy][chan]);	
					if (prbslock_alarm_counter_present[phy] == 1)
					{
						printf(", %4d",PrbsLock_Alarm_Count[phy][chan]);
							#ifdef PRBSLOCK_ALARM_COUNTER_ALT_ENABLED	
								printf(", %4d",PrbsLock_Alarm_Count_Alt[phy][chan]);								
							#endif
						if (pma_direct_mode[phy] == 1)
						{
							printf(", %4d",Bitslip_Count[phy][chan]);
							#ifdef PRBSLOCK_ALARM_COUNTER_ALT_ENABLED 	
								printf(", %4d",Bitslip_Count_Alt[phy][chan]);								
							#endif
						}							
					}											
					printf(", %12e, %10u, %10u, %12e",BER[phy][chan],ErrorCount_Reg_H[phy][chan],ErrorCount_Reg_L[phy][chan],ErrorCount[phy][chan]);
					if (pma_direct_mode[phy] == 1)
					{
						printf(", %8u",(unsigned int) ErrorCount_difference) ;
					}
					else //rsfec
					{
						if (rx_am_lock[phy][chan] == 1)					
						{
							if (rx_am_lock_alarm_counter_present[phy] == 1)	//rsfec
								{
									printf(", %2d",rx_am_lock_alarm[phy][chan]);	
									printf(", %4d",rx_am_lock_alarm_count[phy][chan]);	
								}						
							printf(", %8u, %12e, %8u, %12e, %12e",(unsigned int) FEC_UnCorrectable_Codeword[phy][chan], FEC_Correctable_Codeword[phy][chan],
							(unsigned int) Corrected_Codeword_difference, Precorrected_BER[phy][chan],Totalbits[phy] );
						}
					}
					
				}
				else //no Locked
				{
					if (pma_direct_mode[phy] == 0)
					{
						if (rx_am_lock[phy][chan] == 1)				
						{
							if (rx_am_lock_alarm_counter_present[phy] == 1)	//rsfec
								{
									printf(", %2d",rx_am_lock_alarm[phy][chan]);	
									printf(", %4d",rx_am_lock_alarm_count[phy][chan]);	
								}						
							printf(", %8u, %12e, %8u, %12e, %12e",(unsigned int) FEC_UnCorrectable_Codeword[phy][chan], FEC_Correctable_Codeword[phy][chan],
							(unsigned int) Corrected_Codeword_difference, Precorrected_BER[phy][chan], Totalbits[phy] );
						}
						else if (rx_ready[phy][chan] == 0)	
							printf(", rx_ready de-asserted");	
						else
							printf(", rx_am_lock de-asserted");
					}
					else // PMA direct mode
					{
						if (rx_ready[phy][chan] == 0)					
							printf(", rx_ready de-asserted");
						else
							printf(", No Prbs Lock");		
					}
				
			
				}
				printf("\n");

         
			//Check if enter is pressed	
                                                 
			char c;

				
			c = getchar();
		   d = (c);

			if (internal_noise_enabled)
			{
				#ifdef INTERNAL_NOISE_REGISTER_PRESENT
				if (c == '+')
				{
					printf("\nIncrease core noise\n");
					  if (enable_noise_chunks < noise_floor_max) 
						 {
							number_of_noise_chunks = number_of_noise_chunks + 1;
							enable_noise_chunks = (enable_noise_chunks << 1) + 1;
							//printf("\n\nIncrease Internal noise logic 0x%2x. \n",enable_noise_chunks);
						 
							enable_noise_chunks_Reg =  (enable_noise_chunks_Reg & (0x0000)) | (enable_noise_chunks );
							//printf("\nenable_noise_chunks_Reg 0x%2x. \n",enable_noise_chunks_Reg);
							IOWR_ALTERA_AVALON_PIO_DATA(INTERNAL_NOISE_BASE,enable_noise_chunks_Reg); 
						 }					
				}
				else if (c == '-')
				{
					printf("\nDecrease core noise\n");
				  if (enable_noise_chunks > 0)
				  {
						number_of_noise_chunks = number_of_noise_chunks - 1;
						enable_noise_chunks = (enable_noise_chunks >>  1);
						//printf("\n\nDecrease Internal Noise logic.\n");
						enable_noise_chunks_Reg =  (enable_noise_chunks_Reg & (0x0000)) | (enable_noise_chunks );
						IOWR_ALTERA_AVALON_PIO_DATA(INTERNAL_NOISE_BASE,enable_noise_chunks_Reg); 
				  }
				}
				else if (c == 's')
				{
					break;
				}
				#endif
			}
			else if ((c == '\n') || (d == 13)) break; //19.3 and 19.1 case
	  
        } while(1);
		  
		  //set stdin blocking again
		  fcntl(fd, F_SETFL, flags);
		  
        
        printf("\n Stopped\n");
		  
	  
        
      break;
		
	
		  

      case 'd':
      case 'D': /* New BER Time Interval */
        
        printf("\nD. Provide BER Time Interval\n");
        printf("   Current BER Time Interval   : %2d seconds\n", BERInterval);
        printf("   Insert new BER Interval, Hexadecimal Number from 01 to FF : ");    
        
        BERInterval = input_byte();
              
        printf("\n    New Time interval is %2d seconds:\n",BERInterval);               
            
       break; /* Case D */

      case 'e': /* Show Transceiver PMA Settings on all channels */
      case 'E':
			
			 for (t = 0; t < NUMBER_OF_PHYS ; t++)			
				{


					if (display_phy[t] == 1)
					{
						printf("\nphy %1d\n",t);							
						show_pma_settings_ftile (t, offset[t], number_of_physical_lanes[t], line_encoding);
					}
					
				}

				
		if (PAUSE_AFTER_SHOW_PMA_SETTINGS)
		{
		 
		 printf("\n\n Press a key and enter to continue ...  \n");
       rx_char   = input_char();		 
			  
		  }			
			
									 
    	  break; // Case E		
    	     


		


		case 'g':
      case 'G': // Provide new TX PMA settings value for the PHY 
			
		///////////////////////////////////////////////////////////////////////		
		//Main tap
		///////////////////////////////////////////////////////////////////////	
		
		tx_vodctrl[Selectedphy][0] = (rd_channel_ftile (Selectedphy, 0, offset[Selectedphy], 0x47830) & 0x0000FC00) >> 10;
		
      printf("\nCurrent Value main tap       : %2d", tx_vodctrl[Selectedphy][0]);
		do
		{
			printf("\nInsert new main tap, Decimal Number from 0 to 47 : ");    
        
			i = input_double();
		} while (i<0 || i>47);
		
		
		for (j = 0; j < number_of_physical_lanes[Selectedphy] ; j++)
		{ 	  		  
			tx_vodctrl[Selectedphy][j] = i;
			//Set Maintap	 
			rmw_channel_ftile (Selectedphy, j, offset[Selectedphy],0x47830, 0x0000FC00 , tx_vodctrl[Selectedphy][j] << 10	);  //set vod 
		}
					
		///////////////////////////////////////////////////////////////////////					
		//Pre-tap 2
		///////////////////////////////////////////////////////////////////////	
		
		tx_pretap_2[Selectedphy][0]			= (rd_channel_ftile (Selectedphy, 0, offset[Selectedphy], 0x47830) & 0x00070000) >> 16;						
					
		printf("\nCurrent Value Pretap 2        : %2d", tx_pretap_2[Selectedphy][0]);
		do
		{		    
			printf("\nNew Value Pre Tap 2, Decimal Number from 0 to 7 : ");

			i = input_number();
		} while (i<0 || i>7);		
		  
		for (j = 0; j < number_of_physical_lanes[Selectedphy] ; j++)
		{ 	  
			tx_pretap_2[Selectedphy][j] = i;	  
			//Set Pre-tap2 
			rmw_channel_ftile (Selectedphy, j, offset[Selectedphy],0x47830, 0x00070000 , tx_pretap_2[Selectedphy][j] << 16	); 
		}		

		///////////////////////////////////////////////////////////////////////			
		//Pre-tap1
		///////////////////////////////////////////////////////////////////////				

		
		tx_pretap_1[Selectedphy][0]			= (rd_channel_ftile (Selectedphy, 0, offset[Selectedphy], 0x47830)  & 0x000003E0) >> 5;				
					
		printf("\nCurrent Value Pre Tap 1        : %2d", tx_pretap_1[Selectedphy][0]);
		do
		{		    
			printf("\nNew Value Pre Tap 1, Decimal Number from 0 to 15 : ");

			i = input_double();
		} while (i<0 || i>15);		
		  

		for (j = 0; j < number_of_physical_lanes[Selectedphy] ; j++)
		{ 	  
			tx_pretap_1[Selectedphy][j] = i;	  
			//Set Pre-tap1 
			rmw_channel_ftile (Selectedphy, j, offset[Selectedphy],0x47830, 0x000003E0 , tx_pretap_1[Selectedphy][j] << 5	); 
		}	
		
		///////////////////////////////////////////////////////////////////////						
		//Post-tap 1
		///////////////////////////////////////////////////////////////////////			
		
		tx_posttap_1[Selectedphy][0]			= (rd_channel_ftile (Selectedphy, 0, offset[Selectedphy], 0x47830)  & 0x0000001F);						
								
      printf("\nCurrent Value Post Tap 1        : %2d", tx_posttap_1[Selectedphy][0]);
		do
		{		    
			printf("\nNew Value Post Tap 1, Decimal Number from 0 to 19 : ");
			i = input_double();
		} while (i<0 || i>19);		
		 
		for (j = 0; j < number_of_physical_lanes[Selectedphy] ; j++)
		{ 	  		  
			tx_posttap_1[Selectedphy][j] = i;	  
			//Set Post-tap1 
			rmw_channel_ftile (Selectedphy, j, offset[Selectedphy],0x47830, 0x0000001F , tx_posttap_1[Selectedphy][j]	); 
		}	
		  

            			 
            
   break; // Case G 
						
		
/*		
     case 'v':
      case 'V': // Provide new TX PMA settings value for the selected channel 
			
		
 
        printf("\nV. Set Tx PMA settings on Channel %d from Phy %d ",SelectedChannel[Selectedphy],Selectedphy);	 
		  printf("\n");
 
		if (adapt_sip_busy[Selectedphy] == 1)
			{
			printf("\nPhy %1d is currently being accessed by the soft ADAPT IP, no additional access possible.",Selectedphy);	
			printf("\nPress any key :");
			rx_char = input_char();
			}	
		else
		{		
      lock_avmm(Selectedphy,adapt_sip_control_reg[Selectedphy]);
			
		tx_vodctrl[Selectedphy][SelectedChannel[Selectedphy]] = (rcfg_etile (Selectedphy,(SelectedChannel[Selectedphy] << CHANNEL_OFFSET), 0x15,0x4100,0x0015,0,high_datarate[Selectedphy]) & 0x00FF);
		
//Attenuation
			
        printf("\nCurrent Value attenuation        : %2d", tx_vodctrl[Selectedphy][SelectedChannel[Selectedphy]]);
        printf("\nInsert new attenuation value, Decimal Number from 01 to 26 : ");    
        
        i = input_double();
		
		
	  
				  
				  tx_vodctrl[Selectedphy][SelectedChannel[Selectedphy]] = i;
				  
				 //Set Maintap	 
				  new_value = 0x4000 + tx_vodctrl[Selectedphy][SelectedChannel[Selectedphy]];
				  readback = rcfg_etile (Selectedphy,(SelectedChannel[Selectedphy] << CHANNEL_OFFSET), 0x15,new_value,0x0015,1,high_datarate[Selectedphy]);	
					
//Pre-tap 3
					
					
				 tx_pretap_3[Selectedphy][SelectedChannel[Selectedphy]]			= (rcfg_etile (Selectedphy,(SelectedChannel[Selectedphy] << CHANNEL_OFFSET), 0x15,0x3100,0x0015,0,high_datarate[Selectedphy]) & 0x00FF);	
					
					
        printf("\nCurrent Value Pretap 3        : %2d", decode_2complement(tx_pretap_3[Selectedphy][SelectedChannel[Selectedphy]]));
		  
					
		  printf("\nTo select Pre Tap 3 value of -1  : input 2");
		  printf("\nTo select Pre Tap 3 value of 0   : input 0");
		  printf("\nTo select Pre Tap 3 value of 1   : input 1");
		  printf("\nNew Value : ");

        i = input_double();
		
			switch(i)
			{
				case 2 : temp = PRE_TAP3_1N;break;
				case 0 : temp = PRE_TAP3_0;break;
				case 1 : temp = PRE_TAP3_1;break;
				default : break;
			}
		

			
				  tx_pretap_3[Selectedphy][SelectedChannel[Selectedphy]] = temp;
				  
				  //Set Pre-tap3 
				  new_value = 0x3000 + tx_pretap_3[Selectedphy][SelectedChannel[Selectedphy]];
				  readback = rcfg_etile (Selectedphy,(SelectedChannel[Selectedphy] << CHANNEL_OFFSET), 0x15,new_value,0x0015,1,high_datarate[Selectedphy]);	


				
//Pre-tap 2

				 tx_pretap_2[Selectedphy][SelectedChannel[Selectedphy]]			= (rcfg_etile (Selectedphy,(SelectedChannel[Selectedphy] << CHANNEL_OFFSET), 0x15,0xC100,0x0015,0,high_datarate[Selectedphy]) & 0x00FF);					
					
					
        printf("\nCurrent Value Pretap 2        : %2d", decode_2complement(tx_pretap_2[Selectedphy][SelectedChannel[Selectedphy]]));
		  
		  printf("\nTo select Pre Tap 2 value of -15 : input 30 ");
		  printf("\nTo select Pre Tap 2 value of -14 : input 29 ");
		  printf("\nTo select Pre Tap 2 value of -13 : input 28 ");
		  printf("\nTo select Pre Tap 2 value of -12 : input 27 ");
		  printf("\nTo select Pre Tap 2 value of -11 : input 26 ");
		  printf("\nTo select Pre Tap 2 value of -10 : input 25 ");
		  printf("\nTo select Pre Tap 2 value of -9  : input 24 ");		  
		  printf("\nTo select Pre Tap 2 value of -8  : input 23 ");
		  printf("\nTo select Pre Tap 2 value of -7  : input 22 ");		  
		  printf("\nTo select Pre Tap 2 value of -6  : input 21");
		  printf("\nTo select Pre Tap 2 value of -5  : input 20 ");		  
		  printf("\nTo select Pre Tap 2 value of -4  : input 19");
		  printf("\nTo select Pre Tap 2 value of -3  : input 18 ");		  
		  printf("\nTo select Pre Tap 2 value of -2  : input 17");
		  printf("\nTo select Pre Tap 2 value of -1  : input 16 ");		  
		  printf("\nTo select Pre Tap 2 value of 0   : input 0");
		  printf("\nTo select Pre Tap 2 value of 1   : input 1");
		  printf("\nTo select Pre Tap 2 value of 2   : input 2");
		  printf("\nTo select Pre Tap 2 value of 3   : input 3");
		  printf("\nTo select Pre Tap 2 value of 4   : input 4");
		  printf("\nTo select Pre Tap 2 value of 5   : input 5");
		  printf("\nTo select Pre Tap 2 value of 6   : input 6");
		  printf("\nTo select Pre Tap 2 value of 7   : input 7");
		  printf("\nTo select Pre Tap 2 value of 8   : input 8");
		  printf("\nTo select Pre Tap 2 value of 9   : input 9");
		  printf("\nTo select Pre Tap 2 value of 10   : input 10");
		  printf("\nTo select Pre Tap 2 value of 11   : input 11");
		  printf("\nTo select Pre Tap 2 value of 12   : input 12");
		  printf("\nTo select Pre Tap 2 value of 13   : input 13");
		  printf("\nTo select Pre Tap 2 value of 14   : input 14");
		  printf("\nTo select Pre Tap 2 value of 15   : input 15");		  
		  printf("\nNew Value : ");

        i = input_double();
		
			switch(i)
			{
				case 30 : temp = PRE_TAP2_15N;break;
				case 29 : temp = PRE_TAP2_14N;break;
				case 28 : temp = PRE_TAP2_13N;break;
				case 27 : temp = PRE_TAP2_12N;break;
				case 26 : temp = PRE_TAP2_11N;break;
				case 25 : temp = PRE_TAP2_10N;break;
				case 24 : temp = PRE_TAP2_9N;break;
				case 23 : temp = PRE_TAP2_8N;break;
				case 22 : temp = PRE_TAP2_7N;break;
				case 21 : temp = PRE_TAP2_6N;break;
				case 20 : temp = PRE_TAP2_5N;break;
				case 19 : temp = PRE_TAP2_4N;break;
				case 18 : temp = PRE_TAP2_3N;break;
				case 17 : temp = PRE_TAP2_2N;break;
				case 16 : temp = PRE_TAP2_1N;break;
				case 0 : temp = PRE_TAP2_0;break;
				case 1 : temp = PRE_TAP2_1;break;
				case 2 : temp = PRE_TAP2_2;break;
				case 3 : temp = PRE_TAP2_3;break;
				case 4 : temp = PRE_TAP2_4;break;
				case 5 : temp = PRE_TAP2_5;break;
				case 6 : temp = PRE_TAP2_6;break;
				case 7 : temp = PRE_TAP2_7;break;
				case 8 : temp = PRE_TAP2_8;break;
				case 9 : temp = PRE_TAP2_9;break;
				case 10 : temp = PRE_TAP2_10;break;
				case 11 : temp = PRE_TAP2_11;break;
				case 12 : temp = PRE_TAP2_12;break;
				case 13 : temp = PRE_TAP2_13;break;
				case 14 : temp = PRE_TAP2_14;break;
				case 15 : temp = PRE_TAP2_15;break;					
				default : break;
			}
		
	  
				  
				  tx_pretap_2[Selectedphy][SelectedChannel[Selectedphy]] = temp;
				  
				  //Set Pre-tap2 
				  new_value = 0xC000 + tx_pretap_2[Selectedphy][SelectedChannel[Selectedphy]];
				  readback = rcfg_etile (Selectedphy,(SelectedChannel[Selectedphy] << CHANNEL_OFFSET), 0x15,new_value,0x0015,1,high_datarate[Selectedphy]);	
	

//Pre-Tap1					
					

					
				 tx_pretap_1[Selectedphy][SelectedChannel[Selectedphy]]			= (rcfg_etile (Selectedphy,(SelectedChannel[Selectedphy] << CHANNEL_OFFSET), 0x15,0x0100,0x0015,0,high_datarate[Selectedphy]) & 0x00FF);
					
					
        printf("\nCurrent Value Pretap 1        : %2d", decode_2complement(tx_pretap_1[Selectedphy][SelectedChannel[Selectedphy]]));
		  
					
		  printf("\nTo select Pre Tap 1 value of -10 : input 10 ");
		  printf("\nTo select Pre Tap 1 value of -8  : input 9 ");
		  printf("\nTo select Pre Tap 1 value of -6  : input 8");
		  printf("\nTo select Pre Tap 1 value of -4  : input 7");
		  printf("\nTo select Pre Tap 1 value of -2  : input 6");
		  printf("\nTo select Pre Tap 1 value of 0   : input 0");
		  printf("\nTo select Pre Tap 1 value of 2   : input 1");
		  printf("\nTo select Pre Tap 1 value of 4   : input 2");
		  printf("\nTo select Pre Tap 1 value of 6   : input 3");
		  printf("\nTo select Pre Tap 1 value of 8   : input 4");
		  printf("\nTo select Pre Tap 1 value of 10  : input 5");
		  printf("\nNew Value : ");

        i = input_double();
		
			switch(i)
			{
				case 10 : temp = PRE_TAP1_10N;break;
				case 9 : temp = PRE_TAP1_8N;break;
				case 8 : temp = PRE_TAP1_6N;break;
				case 7 : temp = PRE_TAP1_4N;break;
				case 6 : temp = PRE_TAP1_2N;break;
				case 0 : temp = PRE_TAP1_0;break;
				case 1 : temp = PRE_TAP1_2;break;
				case 2 : temp = PRE_TAP1_4;break;
				case 3 : temp = PRE_TAP1_6;break;
				case 4 : temp = PRE_TAP1_8;break;
				case 5 : temp = PRE_TAP1_10;break;	
				default : break;
			}
		
	  
				  
				  tx_pretap_1[Selectedphy][SelectedChannel[Selectedphy]] = temp;
				  
				  //Set Pre-tap1 
				  new_value = 0x0000 + tx_pretap_1[Selectedphy][SelectedChannel[Selectedphy]];
				  readback = rcfg_etile (Selectedphy,(SelectedChannel[Selectedphy] << CHANNEL_OFFSET), 0x15,new_value,0x0015,1,high_datarate[Selectedphy]);	
	
		  

//Post-tap
					
					
					
				 tx_posttap_1[Selectedphy][SelectedChannel[Selectedphy]]			= (rcfg_etile (Selectedphy,(SelectedChannel[Selectedphy] << CHANNEL_OFFSET), 0x15,0x8100,0x0015,0,high_datarate[Selectedphy]) & 0x00FF);		




       printf("\nCurrent Value Posttap 1        : %2d", decode_2complement(tx_posttap_1[Selectedphy][SelectedChannel[Selectedphy]]));
		  
					
		  printf("\nTo select Post Tap 1 value of -18 : input 18 ");
		  printf("\nTo select Post Tap 1 value of -16 : input 17 ");
		  printf("\nTo select Post Tap 1 value of -14 : input 16 ");
		  printf("\nTo select Post Tap 1 value of -12 : input 15 ");
		  printf("\nTo select Post Tap 1 value of -10 : input 14 ");		  
		  printf("\nTo select Post Tap 1 value of -8  : input 13 ");
		  printf("\nTo select Post Tap 1 value of -6  : input 12");
		  printf("\nTo select Post Tap 1 value of -4  : input 11");
		  printf("\nTo select Post Tap 1 value of -2  : input 10");
		  printf("\nTo select Post Tap 1 value of 0   : input 0");
		  printf("\nTo select Post Tap 1 value of 2   : input 1");
		  printf("\nTo select Post Tap 1 value of 4   : input 2");
		  printf("\nTo select Post Tap 1 value of 6   : input 3");
		  printf("\nTo select Post Tap 1 value of 8   : input 4");
		  printf("\nTo select Post Tap 1 value of 10  : input 5");
		  printf("\nTo select Post Tap 1 value of 12  : input 6");
		  printf("\nTo select Post Tap 1 value of 14  : input 7");
		  printf("\nTo select Post Tap 1 value of 16  : input 8");
		  printf("\nTo select Post Tap 1 value of 18  : input 9");		  
		  printf("\nNew Value : ");

        i = input_double();
		
			switch(i)

					{ 	  
				  
				case 18 : temp = POST_TAP1_18N;break;
				case 17 : temp = POST_TAP1_16N;break;
				case 16 : temp = POST_TAP1_14N;break;
				case 15 : temp = POST_TAP1_12N;break;					
				case 14 : temp = POST_TAP1_10N;break;
				case 13 : temp = POST_TAP1_8N;break;
				case 12 : temp = POST_TAP1_6N;break;
				case 11 : temp = POST_TAP1_4N;break;
				case 10 : temp = POST_TAP1_2N;break;
				case 0 : temp = POST_TAP1_0;break;
				case 1 : temp = POST_TAP1_2;break;
				case 2 : temp = POST_TAP1_4;break;
				case 3 : temp = POST_TAP1_6;break;
				case 4 : temp = POST_TAP1_8;break;
				case 5 : temp = POST_TAP1_10;break;	
				case 6 : temp = POST_TAP1_12;break;	
				case 7 : temp = POST_TAP1_14;break;	
				case 8 : temp = POST_TAP1_16;break;	
				case 9 : temp = POST_TAP1_18;break;							
				default : break;
					}
						 	 
			 
	  
				  
				  tx_posttap_1[Selectedphy][SelectedChannel[Selectedphy]] = temp;
				  
				  //Set Post-tap1 
				  new_value = 0x8000 +  tx_posttap_1[Selectedphy][SelectedChannel[Selectedphy]];					
				  readback = rcfg_etile (Selectedphy,(SelectedChannel[Selectedphy] << CHANNEL_OFFSET), 0x15,new_value,0x0015,1,high_datarate[Selectedphy]);	

			 
			 
			 
		 }
            			 
            
       break; // Case v 	
	   
*/	   
		 
/*
		 
     case 'H':		
      case 'h': //Control Gray Encoding
			
		if (adapt_sip_busy[Selectedphy] == 1)
			{
			printf("\nPhy %1d is currently being accessed by the soft ADAPT IP, no additional access possible.",Selectedphy);	
			printf("\nPress any key :");
			rx_char = input_char();
			}	
		else
		{		
    	
    	printf("\nCurrent Status of Gray, 1/1+D Encoding and swizzle :\n");
    

		printf("Physical Lane     |");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{ 
		  printf("%2d|",i);
		}
		printf("\n");
		printf("                  |");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{ 
		printf("--|");
		}
		printf("\n");
		

		printf("Gray Encoding     :");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{     
			printf("%2d|",gray_encoding[Selectedphy][i]);	 
		}
		printf("\n"); 
		
		printf("1/1+D Encoding    :");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{     
			printf("%2d|",encoding_1_1plusd[Selectedphy][i]);	 
		}
		printf("\n"); 		
	
		printf("Swizzle           :");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{     
			printf("%2d|",swizzle[Selectedphy][i]);	 
		}
		printf("\n"); 			
  

               printf("\n");  
               
              printf("    Toggling Gray Encoding             \n");
               printf("    =========================              \n");
               printf("    Toggle Gray Encoding on Lane  0  choose '0' \n");
               printf("    Toggle Gray Encoding on Lane  1  choose '1' \n");
					if (number_of_physical_lanes[Selectedphy] > 2)	
					{	
               printf("    Toggle Gray Encoding on Lane  2  choose '2' \n");
               printf("    Toggle Gray Encoding on Lane  3  choose '3' \n");
					}
               printf("    ............ \n");
					if (number_of_physical_lanes[Selectedphy] >= 8)
						printf("    Toggle Gray Encoding on Lane  7  choose '7' \n");	
					if (number_of_physical_lanes[Selectedphy] >= 10)
						printf("    Toggle Gray Encoding on Lane  9  choose '9' \n");						
					if (number_of_physical_lanes[Selectedphy] >= 24)
               printf("    Toggle Gray Encoding on Lane 23  choose '23' \n");			
               printf("    Enable Gray Encoding on all lanes choose '99' \n");
               printf("    Disable Gray Encoding all lanes choose '50' \n");                      
               printf("    No Change                 choose '40' \n\n");  
               printf("    Choice :");      
               
               temp    = input_double();
					 
					if (temp == 40)
					{
					//no change
					}
					else if (temp == 99)
					{
						 for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
							{ 
							gray_encoding[Selectedphy][i] = 1;
							}					
					}
					else if (temp == 50)
					{
						 for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
							{ 
							gray_encoding[Selectedphy][i] = 0;								
							}					
					}
					else
					{
							if (gray_encoding[Selectedphy][temp] == 1)
							{	
								gray_encoding[Selectedphy][temp] = 0;
							}
							else
							{
								gray_encoding[Selectedphy][temp] = 1;
							}
					}
 
       	
			if (temp != 40)
			{
			lock_avmm(Selectedphy,adapt_sip_control_reg[Selectedphy]);
				
 	 
				
			 //Assert resets for reset controller bypass (mandatory when the PMA is being disabled)					
			tx_reset_assert_phy(Selectedphy, 1 , 0, 0);
			rx_reset_assert_phy(Selectedphy, 1 , 0, 0);
					

				

			for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
			{ 	 
			set_mode_etile (Selectedphy,i, rx_termination[Selectedphy][i], line_encoding[Selectedphy][i], high_datarate[Selectedphy],  
			tx_clk_divider[Selectedphy], rx_clk_divider[Selectedphy],  
				gray_encoding[Selectedphy][i], encoding_1_1plusd[Selectedphy][i],swizzle[Selectedphy][i],invert_tx_polarity[Selectedphy][i],invert_rx_polarity[Selectedphy][i],tristate[Selectedphy][i]);	
			 usleep(100);
				
				
				
			}		
	
			tx_reset_deassert_phy(Selectedphy, 1, 0);
			rx_reset_deassert_phy(Selectedphy, 1, pma_direct_mode[Selectedphy], 0);					

			}	
//			if (do_initial_adaptation[Selectedphy] == 1)
//				set_pma_adaptation_phy_etile(Selectedphy,number_of_physical_lanes[Selectedphy],media_mode,pma_configuration,1);
	 
		
			
 
//        reset_design();		
//        
//        usleep(1000000);
        
        printf("\nChanged gray encoding (please run adaptation again).\n\n\n");
        release_avmm(Selectedphy,adapt_sip_control_reg[Selectedphy]);			
			
		  }
		  
	  
	  
		  
        break; //case 'h'      			
	
	*/

	/*
     case 'I':		
      case 'i': //Control 1/1+D Encoding

		if (adapt_sip_busy[Selectedphy] == 1)
			{
			printf("\nPhy %1d is currently being accessed by the soft ADAPT IP, no additional access possible.",Selectedphy);	
			printf("\nPress any key :");
			rx_char = input_char();
			}	
		else
		{    	
    	printf("\nCurrent Status of Gray, 1/1+D Encoding and swizzle:\n");
    

		printf("Physical Lane     |");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{ 
		  printf("%2d|",i);
		}
		printf("\n");
		printf("                  |");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{ 
		printf("--|");
		}
		printf("\n");
		

		printf("Gray Encoding     :");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{     
			printf("%2d|",gray_encoding[Selectedphy][i]);	 
		}
		printf("\n"); 
		
		printf("1/1+D Encoding    :");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{     
			printf("%2d|",encoding_1_1plusd[Selectedphy][i]);	 
		}
		printf("\n"); 		
	
		printf("Swizzle           :");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{     
			printf("%2d|",swizzle[Selectedphy][i]);	 
		}
		printf("\n"); 			
  

               printf("\n");  
               
              printf("    Toggling 1/1+D Encoding             \n");
               printf("    =========================              \n");
               printf("    Toggle 1/1+D Encoding on Lane  0  choose '0' \n");
               printf("    Toggle 1/1+D Encoding on Lane  1  choose '1' \n");
					if (number_of_physical_lanes[Selectedphy] > 1)
					{
               printf("    Toggle 1/1+D Encoding on Lane  2  choose '2' \n");
               printf("    Toggle 1/1+D Encoding on Lane  3  choose '3' \n");
					}
               printf("    ............ \n");
					if (number_of_physical_lanes[Selectedphy] >= 8)
						printf("    Toggle 1/1+D Encoding on Lane  7  choose '7' \n");	
					if (number_of_physical_lanes[Selectedphy] >= 10)
						printf("    Toggle 1/1+D Encoding on Lane  9  choose '9' \n");						
					if (number_of_physical_lanes[Selectedphy] >= 24)
               printf("    Toggle 1/1+D Encoding on Lane 23  choose '23' \n");			
               printf("    Enable 1/1+D Encoding on all lanes choose '99' \n");
               printf("    Disable 1/1+D Encoding all lanes choose '50' \n");                      
               printf("    No Change                 choose '40' \n\n");  
               printf("    Choice :");      
               
               temp    = input_double();
					 
					if (temp == 40)
					{
					//no change
					}
					else if (temp == 99)
					{
						 for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
							{ 
							encoding_1_1plusd[Selectedphy][i] = 1;
							}					
					}
					else if (temp == 50)
					{
						 for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
							{ 
							encoding_1_1plusd[Selectedphy][i] = 0;								
							}					
					}
					else
					{
							if (encoding_1_1plusd[Selectedphy][temp] == 1)
							{	
								encoding_1_1plusd[Selectedphy][temp] = 0;
							}
							else
							{
								encoding_1_1plusd[Selectedphy][temp] = 1;
							}
					}
 
       	
			if (temp != 40)
			{
			lock_avmm(Selectedphy,adapt_sip_control_reg[Selectedphy]);
								
	 
			 //Assert resets for reset controller bypass (mandatory when the PMA is being disabled)					
			tx_reset_assert_phy(Selectedphy, 1 , 0, 0);
			rx_reset_assert_phy(Selectedphy, 1 , 0, 0);
					

				

			for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
			{ 	 
			set_mode_etile (Selectedphy,i, rx_termination[Selectedphy][i], line_encoding[Selectedphy][i], high_datarate[Selectedphy],  tx_clk_divider[Selectedphy], 
				rx_clk_divider[Selectedphy],  gray_encoding[Selectedphy][i], encoding_1_1plusd[Selectedphy][i],swizzle[Selectedphy][i],invert_tx_polarity[Selectedphy][i],invert_rx_polarity[Selectedphy][i],tristate[Selectedphy][i]);	
			 usleep(100);
				
				
				
			}		
	
			tx_reset_deassert_phy(Selectedphy, 1, 0);
			rx_reset_deassert_phy(Selectedphy, 1, pma_direct_mode[Selectedphy], 0);		
	
//			if (do_initial_adaptation[Selectedphy] == 1)
//				set_pma_adaptation_phy_etile(Selectedphy,number_of_physical_lanes[Selectedphy],media_mode,pma_configuration,1);
	 
		
			
 
//        reset_design();		
//        
//        usleep(1000000);
        
        printf("\nChanged 1/1+D encoding (please run adaptation again)\n\n\n");
        release_avmm(Selectedphy,adapt_sip_control_reg[Selectedphy]);			
		  }
		  
	  }
	  
		  
        break; //case 'i'      

     */
 

 
		case 'M':		
      case 'm': 
			
		
    	
    	printf("\nCurrent Status of Invert Tx Polarity :\n");
    

		printf("Lane              |");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{ 
		  printf("%2d|",i);
		}
		printf("\n");
		printf("                  |");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{ 
		printf("--|");
		}
		printf("\n");
		
		printf("Tx Polarity Invert:");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{     
			printf("%2d|",invert_tx_polarity[Selectedphy][i]);	 
		}
		printf("\n"); 
			
  

               printf("\n");  
               
              printf("    Toggling Invert Tx Polarity             \n");
              printf("    ===========================              \n");
               printf("    Toggle Invert Tx Polarity on Lane  0  choose '0' \n");
               printf("    Toggle Invert Tx Polarity on Lane  1  choose '1' \n");
					if (number_of_physical_lanes[Selectedphy] >= 2)	
					{						
               printf("    Toggle Invert Tx Polarity on Lane  2  choose '2' \n");
               printf("    Toggle Invert Tx Polarity on Lane  3  choose '3' \n");
					}
               printf("    ............ \n");
					if (number_of_physical_lanes[Selectedphy] >= 8)
						printf("    Toggle Invert Tx Polarity on Lane  7  choose '7' \n");	
					if (number_of_physical_lanes[Selectedphy] >= 10)
						printf("    Toggle Invert Tx Polarity on Lane  9  choose '9' \n");						
					if (number_of_physical_lanes[Selectedphy] >= 24)
               printf("    Toggle Invert Tx Polarity on Lane 23  choose '23' \n");			
               printf("    Enable Invert Tx Polarity on all lanes choose '99' \n");
               printf("    Disable Invert Tx Polarity all lanes choose '50' \n");                      
               printf("    No Change                 choose '40' \n\n");  
               printf("    Choice :");      
               
               temp    = input_double();
					 
					if (temp == 40)
					{
					//no change
					}
					else if (temp == 99)
					{
						 for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
							{ 
							invert_tx_polarity[Selectedphy][i] = 1;
							//Register does not work
							//rmw_channel_ftile (Selectedphy, i, offset[Selectedphy],0x41428, 0x00000080,0x80 );																						
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x01, 0x65,1,1);
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x01, 0x65,0,1);
							}					
					}
					else if (temp == 50)
					{
						 for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
							{ 
							invert_tx_polarity[Selectedphy][i] = 0;
							//rmw_channel_ftile (Selectedphy, i, offset[Selectedphy],0x41428, 0x00000080,0x00 );	
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x00, 0x65,1,1);
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x00, 0x65,0,1);							
							
							}					
					}
					else
					{
							if (invert_tx_polarity[Selectedphy][temp] == 1)
							{	
								invert_tx_polarity[Selectedphy][temp] = 0;
								//rmw_channel_ftile (Selectedphy, temp, offset[Selectedphy],0x41428, 0x00000080,0x00 );
								readout = cpi_request_fgt(Selectedphy, temp, offset[Selectedphy], 0x00, 0x65,1,1);
								readout = cpi_request_fgt(Selectedphy, temp, offset[Selectedphy], 0x00, 0x65,0,1);								
								
							}
							else
							{
								invert_tx_polarity[Selectedphy][temp] = 1;
								//rmw_channel_ftile (Selectedphy, temp, offset[Selectedphy],0x41428, 0x00000080,0x80 );	
								readout = cpi_request_fgt(Selectedphy, temp, offset[Selectedphy], 0x01, 0x65,1,1);
								readout = cpi_request_fgt(Selectedphy, temp, offset[Selectedphy], 0x01, 0x65,0,1);									
								
							}
					}
 
        
        printf("\nChanged Tx Polarity Inversion (please run adaptation again).\n\n\n");		
			
		  
	  
	  
		  
        break; //case 'm'    	
	  
		
    case 'N':		
      case 'n': 
			
	
    	
    	printf("\nCurrent Status of Invert Rx Polarity :\n");
    

		printf("Lane              |");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{ 
		  printf("%2d|",i);
		}
		printf("\n");
		printf("                  |");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{ 
		printf("--|");
		}
		printf("\n");
		
		printf("Rx Polarity Invert:");
		for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
		{     
			printf("%2d|",invert_rx_polarity[Selectedphy][i]);	 
		}
		printf("\n"); 
			
  

               printf("\n");  
               
              printf("    Toggling Invert Rx Polarity             \n");
              printf("    ===========================              \n");
               printf("    Toggle Invert Rx Polarity on Lane  0  choose '0' \n");
               printf("    Toggle Invert Rx Polarity on Lane  1  choose '1' \n");
					if (number_of_physical_lanes[Selectedphy] >= 2)	
					{					
               printf("    Toggle Invert Rx Polarity on Lane  2  choose '2' \n");
               printf("    Toggle Invert Rx Polarity on Lane  3  choose '3' \n");
					}
               printf("    ............ \n");
					if (number_of_physical_lanes[Selectedphy] >= 8)
						printf("    Toggle Invert Rx Polarity on Lane  7  choose '7' \n");	
					if (number_of_physical_lanes[Selectedphy] >= 10)
						printf("    Toggle Invert Rx Polarity on Lane  9  choose '9' \n");						
					if (number_of_physical_lanes[Selectedphy] >= 24)
               printf("    Toggle Invert Rx Polarity on Lane 23  choose '23' \n");			
               printf("    Enable Invert Rx Polarity on all lanes choose '99' \n");
               printf("    Disable Invert Rx Polarity all lanes choose '50' \n");                      
               printf("    No Change                 choose '40' \n\n");  
               printf("    Choice :");      
               
               temp    = input_double();
					 
					if (temp == 40)
					{
					//no change
					}
					else if (temp == 99)
					{
						 for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
							{ 
							invert_rx_polarity[Selectedphy][i] = 1;
							//Register does not work							
							//rmw_channel_ftile (Selectedphy, i, offset[Selectedphy],0x41428, 0x00000040,0x40 );																												
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x01, 0x66,1,1);
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x01, 0x66,0,1);

							}					
					}
					else if (temp == 50)
					{
						 for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
							{ 
							invert_rx_polarity[Selectedphy][i] = 0;
							//rmw_channel_ftile (Selectedphy, i, offset[Selectedphy],0x41428, 0x00000040,0x00 );																												
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x00, 0x66,1,1);
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x00, 0x66,0,1);							
							
							}					
					}
					else
					{
							if (invert_rx_polarity[Selectedphy][temp] == 1)
							{	
								invert_rx_polarity[Selectedphy][temp] = 0;
								//rmw_channel_ftile (Selectedphy, temp, offset[Selectedphy],0x41428, 0x00000040,0x00 );																						
								readout = cpi_request_fgt(Selectedphy, temp, offset[Selectedphy], 0x00, 0x66,1,1);
								readout = cpi_request_fgt(Selectedphy, temp, offset[Selectedphy], 0x00, 0x66,0,1);								
								
							}
							else
							{
								invert_rx_polarity[Selectedphy][temp] = 1;
								//rmw_channel_ftile (Selectedphy, temp, offset[Selectedphy],0x41428, 0x00000040,0x40 );																						
								readout = cpi_request_fgt(Selectedphy, temp, offset[Selectedphy], 0x01, 0x66,1,1);
								readout = cpi_request_fgt(Selectedphy, temp, offset[Selectedphy], 0x01, 0x66,0,1);									
								
							}
					}
 
        
        printf("\nChanged Rx Polarity Inversion (please run adaptation again).\n\n\n");		
			
		  
		  
	  
		  
        break; //case 'n'    

     





	


//     case 'y':
//     case 'Y': /* Slave mode "listening" to the master */
//       NOK = 0;
//	    j = -1;
//	   printf("\nListening mode enabled\n");
//	  
//		 do
//       {
//		  j = j+1;
//			
//		  //wait for rx_digitalreset to transition from low to high and low again
//			
//			 // detect rx_digitalreset going down
//			timestamp1 = clock();			 
//			do
//			{
//			Channel_Reg[0]      =  Read_Channel_Reg(0);
//			rx_digitalreset[0]   = 0x0001 & (Channel_Reg[0] >> 1);
//			timestamp = clock();	
//	      time_taken = ((double)(timestamp - timestamp1)/CLOCKS_PER_SEC);					
//			} while ((rx_digitalreset[0]     ==  0) && (time_taken < 2.0));
//			
//			 // detect rx_digitalreset going up		
//			//printf("\nrx_digitalreset[0] asserted"); 
//			
//			timestamp1 = clock();
//			do
//			{
//			Channel_Reg[0]      =  Read_Channel_Reg(0);
//			rx_digitalreset[0]   = 0x0001 & (Channel_Reg[0] >> 1);
//
//			timestamp = clock();	
//	      time_taken = ((double)(timestamp - timestamp1)/CLOCKS_PER_SEC);			
//				
//			} while ((rx_digitalreset[0]     ==  1) && (time_taken < 2.0));	
//			//printf("\nrx_digitalreset[0] de-asserted");
//			
//			
//        usleep(300000); // Wait for 300 ms (at this point the receiver should be up and running
//	
//
//			//read status on all receive channels
//		  for (i =0 ; i < 4; i ++)
//		  {
//	
//		  
//		   Channel_Reg[i]      =  Read_Channel_Reg(i);
//		   Locked[i]  = 0x0001 & (Channel_Reg[i] >> 15); 
//			ErrorCount_Reg_L[i] =  Read_ErrorCount_L_Reg(i);
//			ErrorCount_Reg_H[i] =  Read_ErrorCount_H_Reg(i);	    
//
//		  
//
//       if ((Locked[i] == 1) && (ErrorCount_Reg_L[i] == 0) && (ErrorCount_Reg_H[i] == 0) )
//			ChannelOK_ch[i] = 1;
//		 else
//			ChannelOK_ch[i] = 0;
//			}
//	 
//	 if  ( (ChannelOK_ch[0] == 1) &&  (ChannelOK_ch[1] == 1) &&  (ChannelOK_ch[2] == 1) && (ChannelOK_ch[3] == 1) )
//		 ChannelOK = 1;
//	 else
//		 ChannelOK = 0;
//		
//		
//		if (ChannelOK == 0) 
//			{
//			//Sent biterror to the remote side to stop the loop on the transmit side  
//		 
//        Control_Reg = Control_Reg | (0x4000);
//        IOWR_ALTERA_AVALON_PIO_DATA(CONTROL_REG_BASE,Control_Reg);
//
//			usleep(10);
//        
//        Control_Reg = Control_Reg & (0xBFFF);
//        IOWR_ALTERA_AVALON_PIO_DATA(CONTROL_REG_BASE,Control_Reg);
//           
//			NOK = NOK + 1;
//			  for (i =0 ; i < 4; i ++)
//				  {
//					printf("\nChannelOK_ch[%1d] : %1d",i,ChannelOK_ch[i]);
//					printf("\nLocked[%1d]  : %1d",i,Locked[i] );		
//					printf("\nErrorCount_Reg_L[%1d]  : %d",i,ErrorCount_Reg_L[i] );	
//					printf("\nErrorCount_Reg_H[%1d]  : %d",i,ErrorCount_Reg_H[i] );		
//				  }
//				printf("\npress any key to continue\n");
//		  
//				rx_char = input_char(); 
//				break;
//
//			}
//		else
//			printf(" %d",j);
//			
//        } while (1); //infinite loop
//        printf("\n\nTotal NOK : %d", NOK);
//        break; //case 'y'		  
	

		
		
	 
	 case 'z': //Dump register space
	 case 'Z':
	
	/*
			   address_dump[0] = 0x47830;	
				// address_dump[1] = 0x41914;
				// address_dump[2] = 0x41BB8;
			   address_dump[1] = 0x4174C;	
			   address_dump[2] = 0x41750;					
			   address_dump[3] = 0x41808;		
				

				
				//for (i= 0; i < 4; i++)
				for (i= 0x40080; i < 0x91008; i++)					
				{
					for (t=0; t < NUMBER_OF_PHYS; t++)
					{
						for (j = 0; j < number_of_lanes[t] ; j++)
						 { 	 

						  //temp = rd_channel(t,(j << offset[t]) + address_dump[i]); 
						  temp = rd_channel(t,(j << offset[t]) + i); 
						  printf("\n>>>>>>Phy %2d Ch %1d Address 0x%x value : 0x%x",t,j,i,temp);
						 }
					}
				}
				*/
				 //This is ok							
				 //temp = rd_channel_ftile(1, 2, offset[1],0x47830);
				 //printf("\n>>>>>>Phy %2d Ch %1d Address 0x%x value : 0x%x",0,2,0x47830,temp);
				 
				 //This is nok : results in read access on PHY0, and doesn't jump into the code properly (no printf)
				 temp = rd_channel_ftile(1, 3, offset[1],0x47830);
				 printf("\n>>>>>>Phy %2d Ch %1d Address 0x%x value : 0x%x",1,3,0x47830,temp);
				 
				
				// temp = rd_channel_ftile(0, 4, offset[0],0x47830);
				// printf("\n>>>>>>Phy %2d Ch %1d Address 0x%x value : 0x%x",0,4,0x47830,temp);
				
				//measure SNR FHT
				
				
				
				
				rx_char =input_char();

			
	 break; 				

/*
	 case 's': //Dump register space of SelectedChannel[Selectedphy]
	 case 'S':	
	 	 	

	   j =0;
		for (i = 0x40000; i <= 0x50000 ; i+=4)
			{   
					j = j + 1;
					//offset = (j<<11)+i;
					dump_register_before[j] = rd_channel(Selectedphy,(SelectedChannel[Selectedphy] << offset[Selectedphy])+i); 
			}	
			printf("\n\nStored all registers from channel %2d phy %1d in memory\n\n",SelectedChannel[Selectedphy],Selectedphy);


			
			
			
	 break; 
		
	 case 't': //Dump register space of selected channel after and compare
	 case 'T':	
		 

	   j =0;	 
		for (i = 0x40000; i <= 0x50000 ; i+=4)
			{   
		
					j = j + 1;		
					dump_register_after[j] = rd_channel(Selectedphy,(SelectedChannel[Selectedphy] << offset[Selectedphy])+i); 
				   if (dump_register_after[j] != dump_register_before[j])
						printf("\nChannel %2d phy %1d: Register 0x%3x : Stored Value :0x%2x  New Value : 0x%2x",SelectedChannel[Selectedphy],Selectedphy,i,dump_register_before[j],dump_register_after[j]);
			}	
			printf("\n\n");
			


	 break; 				 
*/
	 

case 'o': //Vertical Eye Height Measurement on Selected Phy
case 'O':


   fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]] = (rd_channel_ftile (Selectedphy, SelectedChannel[Selectedphy], offset[Selectedphy], 0x47800) & 0x00000004) >> 2;

  Channel_Reg[Selectedphy][SelectedChannel[Selectedphy]]       =  Read_Channel_Reg(Selectedphy,SelectedChannel[Selectedphy]);
  rx_ready[Selectedphy][SelectedChannel[Selectedphy]] = 0x0001 & (Channel_Reg[Selectedphy][SelectedChannel[Selectedphy]] >> 13);  
  
	if (rx_ready[Selectedphy][SelectedChannel[Selectedphy]] == 1)
	{

		if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
			printf("\nPAM4 EHM measurement on Phy %d Channel %d",Selectedphy, SelectedChannel[Selectedphy]);
		else
			printf("\nNRZ EHM measurement on Phy %d Channel %d",Selectedphy, SelectedChannel[Selectedphy]);

		printf("\n=========================================");
		printf("\nPlease Select BER Target");
		if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1) 
		{		
		printf("\nFor BER Target 1E-3  : select 3");
		printf("\nFor BER Target 1E-4  : select 4");
		}
		printf("\nFor BER Target 1E-5  : select 5");
		printf("\nFor BER Target 1E-6  : select 6");
		printf("\nFor BER Target 1E-7  : select 7");
		printf("\nFor BER Target 1E-8  : select 8");
		if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 0) 
		{
		printf("\nFor BER Target 1E-9  : select 9");
		printf("\nFor BER Target 1E-10 : select A");
		}
		printf("\n\nTo Extrapolate the EHM using %d EHM measurements : select E", NUMBER_OF_EHM_EXTRAPOLATIONS );
		printf("\nCAUTION : Extrapolation function is work in progress");
		printf("\n\nChoice : ");
		

		ber_target = input_byte();
		

		if (ber_target < 11)
		{
			printf("\n\nPerform EHM on Phy %d Ch %d at BER Target 1E-%d ",Selectedphy,SelectedChannel[Selectedphy],ber_target);

		  	show_time_estimate_ehm(ber_target);
			
			timestamp = clock();

			perform_ehm(Selectedphy, SelectedChannel[Selectedphy], ber_target);
			

			timestamp = clock() - timestamp;	
					//printf("\ntimestamp = %e",(double) timestamp);
			
			time_taken[0] = ((double)timestamp)/(CLOCKS_PER_SEC/1000); // in milliseconds		  

			vertical_eye_fgt_top[Selectedphy][SelectedChannel[Selectedphy]] = vertical_eye_fgt_top_pos[Selectedphy][SelectedChannel[Selectedphy]] - vertical_eye_fgt_top_neg[Selectedphy][SelectedChannel[Selectedphy]];
			vertical_eye_fgt_middle[Selectedphy][SelectedChannel[Selectedphy]] = vertical_eye_fgt_middle_pos[Selectedphy][SelectedChannel[Selectedphy]] - vertical_eye_fgt_middle_neg[Selectedphy][SelectedChannel[Selectedphy]];
			vertical_eye_fgt_bot[Selectedphy][SelectedChannel[Selectedphy]] = -(vertical_eye_fgt_bot_neg[Selectedphy][SelectedChannel[Selectedphy]]) - (- vertical_eye_fgt_bot_pos[Selectedphy][SelectedChannel[Selectedphy]]);

			printf("\n----------------------------------------------------------");
			if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
			{
			printf("\nPhy : %d  Channel : %d Top Eye Positive         : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_top_pos[Selectedphy][SelectedChannel[Selectedphy]]);
			printf("\nPhy : %d  Channel : %d Top Eye Negative         : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_top_neg[Selectedphy][SelectedChannel[Selectedphy]]);
			printf("\nPhy : %d  Channel : %d Top Eye Height           : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_top[Selectedphy][SelectedChannel[Selectedphy]]);	
			printf("\n----------------------------------------------------------");
			}
			
			if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
			{	
			printf("\nPhy : %d  Channel : %d Middle Eye Positive      : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_middle_pos[Selectedphy][SelectedChannel[Selectedphy]]);
			printf("\nPhy : %d  Channel : %d Middle Eye Negative      : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_middle_neg[Selectedphy][SelectedChannel[Selectedphy]]);
			printf("\nPhy : %d  Channel : %d Middle Eye Height        : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_middle[Selectedphy][SelectedChannel[Selectedphy]]);	
			printf("\n----------------------------------------------------------");
			}
			else
			{	
			printf("\nPhy : %d  Channel : %d Eye Positive      : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_middle_pos[Selectedphy][SelectedChannel[Selectedphy]]);
			printf("\nPhy : %d  Channel : %d Eye Negative      : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_middle_neg[Selectedphy][SelectedChannel[Selectedphy]]);
			printf("\nPhy : %d  Channel : %d Eye Height        : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_middle[Selectedphy][SelectedChannel[Selectedphy]]);	
			printf("\n----------------------------------------------------------");
			}
			
			if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
			{
			printf("\nPhy : %d  Channel : %d Bottom Eye Positive      : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_bot_pos[Selectedphy][SelectedChannel[Selectedphy]]);
			printf("\nPhy : %d  Channel : %d Bottom Eye Negative      : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_bot_neg[Selectedphy][SelectedChannel[Selectedphy]]);
			printf("\nPhy : %d  Channel : %d Bottom Eye Height        : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_bot[Selectedphy][SelectedChannel[Selectedphy]]);	
			printf("\n----------------------------------------------------------");
			}

			
			printf ("\nTime spent to perform EHM : %f ms",time_taken[0]);	
		} //ber target < 11
		else //Extrapolate function (using 2 points)
		{
			ber_target_extrapolate[0] = 6;
			ber_target_extrapolate[1] = 8;
			
			for (j = 0;j < 2; j++)
			{
				//set 1st target
				ber_target = ber_target_extrapolate[j];
				
				printf("\n\nEstimate %d : Perform EHM on Phy %d Ch %d at BER Target 1E-%d ",j+1,Selectedphy,SelectedChannel[Selectedphy],ber_target);
				show_time_estimate_ehm(ber_target);		
				
				printf("\n========================================================================================================");
				
				perform_ehm(Selectedphy, SelectedChannel[Selectedphy], ber_target);

				vertical_eye_fgt_top[Selectedphy][SelectedChannel[Selectedphy]] = vertical_eye_fgt_top_pos[Selectedphy][SelectedChannel[Selectedphy]] - vertical_eye_fgt_top_neg[Selectedphy][SelectedChannel[Selectedphy]];
				vertical_eye_fgt_middle[Selectedphy][SelectedChannel[Selectedphy]] = vertical_eye_fgt_middle_pos[Selectedphy][SelectedChannel[Selectedphy]] - vertical_eye_fgt_middle_neg[Selectedphy][SelectedChannel[Selectedphy]];
				vertical_eye_fgt_bot[Selectedphy][SelectedChannel[Selectedphy]] = -(vertical_eye_fgt_bot_neg[Selectedphy][SelectedChannel[Selectedphy]]) - (- vertical_eye_fgt_bot_pos[Selectedphy][SelectedChannel[Selectedphy]]);

				X_top[j] = (float) vertical_eye_fgt_top[Selectedphy][SelectedChannel[Selectedphy]];
				X_middle[j] = (float) vertical_eye_fgt_middle[Selectedphy][SelectedChannel[Selectedphy]];
				X_bot[j] = (float) vertical_eye_fgt_bot[Selectedphy][SelectedChannel[Selectedphy]];
				
				B_Depth[j] = 1/(pow(10,ber_target));
				Q[j] = calculate_Q(ber_target);
				
				
			
				if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
				{
				printf("\nPhy : %d  Channel : %d Top Eye Height           : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_top[Selectedphy][SelectedChannel[Selectedphy]]);					
				printf("\nPhy : %d  Channel : %d Middle Eye Height        : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_middle[Selectedphy][SelectedChannel[Selectedphy]]);	
				printf("\nPhy : %d  Channel : %d Bottom Eye Height        : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_bot[Selectedphy][SelectedChannel[Selectedphy]]);	

				}
				else
				{	
				printf("\nPhy : %d  Channel : %d Eye Height               : %8.2f mV",Selectedphy,SelectedChannel[Selectedphy],CONVERT_TO_MV * vertical_eye_fgt_middle[Selectedphy][SelectedChannel[Selectedphy]]);	
				}
		
			  printf("\n");
			  printf("\nBER Depth                                     : %5e",B_Depth[j]);
			  printf("\nQ factor at BER Depth                         : %5e",Q[j]);	
			  
				
			

			}
			//phase_step_per_sigma = (X1-X2)/(Q1-Q2);
			
			printf("\n");			
			
			phase_step_per_sigma_top = (X_top[0]-X_top[1])/(Q[0]-Q[1]);  
			phase_step_per_sigma_middle = (X_middle[0]-X_middle[1])/(Q[0]-Q[1]);  
			phase_step_per_sigma_bot = (X_bot[0]-X_bot[1])/(Q[0]-Q[1]);  
			
			if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)			
				printf("\nPhase step per sigma top    is %5e",phase_step_per_sigma_top);
			
			printf("\nPhase step per sigma middle is %5e",phase_step_per_sigma_middle);	
			
			if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)					
				printf("\nPhase step per sigma bottom is %5e",phase_step_per_sigma_bot);				
			
			printf("\n");
			
			if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
			{
			   printf("\n                                                                        Top       |Middle     |Bottom ");
			   printf("\n======================================================================================================");	
			}
		
			for (i = 9; i <= 20 ; i++)
			{
				//ber_target = 1/(pow(10,i));
				
				//estimated_EYE = X2 + phase_step_per_sigma * (calculate_Q(i) - Q2);
				estimated_EYE_top = X_top[1] + phase_step_per_sigma_top * (calculate_Q(i) - Q[1]);
				estimated_EYE_middle = X_middle[1] + phase_step_per_sigma_middle * (calculate_Q(i) - Q[1]);
				estimated_EYE_bot = X_bot[1] + phase_step_per_sigma_bot * (calculate_Q(i) - Q[1]);
				
				if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
				{			
					printf("\nEstimated Eye Opening at BER Target of 1E-%2d, Q factor %5e  : %8.2f mV|%8.2f mV|%8.2f mV",i,calculate_Q(i),CONVERT_TO_MV * estimated_EYE_top,CONVERT_TO_MV * estimated_EYE_middle,CONVERT_TO_MV * estimated_EYE_bot);
				}
				else
				{			
					printf("\nEstimated Eye Opening at BER Target of 1E-%2d, Q factor %5e  : %8.2f mV",i,calculate_Q(i),CONVERT_TO_MV * estimated_EYE_middle);
				}					
			} //for loop			
		
		} //extrapolate function
	}
	else
	{
		printf("\nrx_ready not asserted on Phy %d Channel %d, EHM skipped",Selectedphy, SelectedChannel[Selectedphy]);
	}

	printf("\nPress any key to continue:");
	rx_char = input_char();
					
					

break;




		
	 case 'p': //Toggle Display PHY
	 case 'P':		
		 
	 	 if (display_Selectedphy_only == 0)
		 {
			 display_Selectedphy_only = 1;
			 
			 for (t=0; t < NUMBER_OF_PHYS; t++)
			 {
				 display_phy[t] = 0;
			 }
			 display_phy[Selectedphy] = 1;
			 
		 }
		 else
		 {
			 display_Selectedphy_only = 0;
			 for (t=0; t < NUMBER_OF_PHYS; t++)
			 {
				 display_phy[t] = 1;
			 }			 
		 }

		

		
	 break; 			
	

	 
	 case 'r': //Rerun adaptation on selected phy issue rx reset
	 case 'R':
	 
			if (FHT_USED)
			{
				//Set reconverge on ppm detection and reconverge on bad status to 0x0 (0xF03F8)
				
					for (i=0; i < number_of_lanes[Selectedphy]; i++)
					{				
						rmw_channel(Selectedphy,(i << offset[Selectedphy]) + 0xF03F8           ,0xFF000000,0x00000000);	
					}
					usleep(1000);
					
					for (i=0; i < number_of_lanes[Selectedphy]; i++)
					{				
						temp = rd_channel(Selectedphy,(i << offset[Selectedphy]) + 0xF03F8);	
						printf("\nphy %d Ch %d 0xF03F8 = 0x%x",Selectedphy,i,temp);
					}	

					//issue reconvergence (0xF03E0) bit[0] set to '1' and then to '0'
					
					for (i=0; i < number_of_lanes[Selectedphy]; i++)
					{				
						rmw_channel(Selectedphy,(i << offset[Selectedphy]) + 0xF03E0          ,0x00000001,0x1);	
					}
					usleep(100);		

					for (i=0; i < number_of_lanes[Selectedphy]; i++)
					{				
						rmw_channel(Selectedphy,(i << offset[Selectedphy]) + 0xF03E0          ,0x00000001,0x0);	
					}
					usleep(100);

				//Set reconverge on ppm detection and reconverge on bad status to 0x1 (0xF03F8)
				
					for (i=0; i < number_of_lanes[Selectedphy]; i++)
					{				
						rmw_channel(Selectedphy,(i << offset[Selectedphy]) + 0xF03F8           ,0xFF000000,0xFF000000);	
					}
					usleep(1000);
					
					for (i=0; i < number_of_lanes[Selectedphy]; i++)
					{				
						temp = rd_channel(Selectedphy,(i << offset[Selectedphy]) + 0xF03F8);	
						printf("\nphy %d Ch %d 0xF03F8 = 0x%x",Selectedphy,i,temp);
					}	
			usleep(1000);
			}
			

				//Assert Rx Reset on all lanes
				reset_rx_assert_phy(Selectedphy);
				
				usleep(100);
				
				reset_rx_deassert_phy(Selectedphy);
		
					if (DEBUG_RESET) printf("\nPhy %1d reset_rx de-asserted on all lanes",Selectedphy);	

				  timestamp1 = clock();

				  do
				  {
						rx_ready_combined = 1;
						for (i = 0; i < number_of_lanes[Selectedphy] ; i++)
						{   
							Channel_Reg[Selectedphy][i]      =  Read_Channel_Reg(Selectedphy,i);	
							rx_ready[Selectedphy][i]  			= 0x0001 & (Channel_Reg[Selectedphy][i] >> 13);
							if (rx_ready[Selectedphy][i] == 0)
									rx_ready_combined  = 0;						
						}	
						timestamp2 = clock();
						time_taken[0] = ((double) timestamp2 - (double) timestamp1)/(CLOCKS_PER_SEC/1000); // in milliseconds
				  } while ((rx_ready_combined == 0) && (time_taken[0] < TIMEOUT_ADAPTATION_MS)); 

					if (SHOW_ADAPT_TIME)
					{
					printf("\nTotal Adaptation time phy %d :%d milliseconds",Selectedphy,(int) time_taken[0]);
					printf("\nPress any key to continue :");
					rx_char = input_char();
					}

		  
					usleep(100); //wait for prbslock
					
					// readback serial loopback 
					// this takes time before this bit is set.
					// also adaptation takes time before the link is up so this why a wait time of 100 ms is used.
				
					
					readback_loopbacks(Selectedphy);			
				
				
		

	break;




			

			
			



	 
	case 'u':
	case 'U': //Sweep PMA parameter and measure BER  on selected channel 
	
		 printf("\nSelect index for local phy (DUT) (0-%1d) : ",NUMBER_OF_PHYS-1);
		 Selectedphy = input_byte();
		 rx = SelectedChannel[Selectedphy];

		 printf("\nSelect index for remote phy (the one where Tx parameters will be updated) (0-%1d) : ",NUMBER_OF_PHYS-1);
		 tx_phy = input_byte();
		 tx = SelectedChannel[Selectedphy];
		 
		 if (CHANGE_TX_PMA_SETTINGS_ALL_LANES)
			printf("\n\nTest will be done changing Tx settings on phy %1d (all channels) connected to phy %1d, channel %1d is used for monitoring",tx_phy,Selectedphy,rx);
		 else
			printf("\n\nTest will be done changing Tx settings on phy %1d channel %1d connected to phy %1d channel %1d",tx_phy,tx,Selectedphy,rx);			 
		
			
		printf("\n\n");
		printf("\nWhat FGT Tx parameter do you want to sweep :\n");
		printf("        For Maintap            press '0'\n");
	   printf("        For PreTap 2           press '1'\n");
		printf("        For PreTap 1           press '2'\n");	 
		printf("        For PostTap 1          press '3'\n");	  
		printf("Selection :");
		  do 
		  {
		  temp = input_number(); 
		  } while ((temp < 0) || (temp > 3));
        printf("\n\n");		   
	   

      switch (temp)
            {
			   case 0 : sweep_low = 0  ; sweep_high = 47; step_size = 1;break; // VOD
			   case 1 : sweep_low = 0 	; sweep_high = 7; step_size = 1;break; // Pre Tap 2
			   case 2 : sweep_low = 0  ; sweep_high = 15 ;step_size = 1 ; break; // Pre Tap 1					
				case 3 : sweep_low = 0  ; sweep_high = 19; step_size = 1;break; // Post Tap 1			
				}
		if (SHOW_ADVANCED_EQUALIZATION_PARAMETERS)
			method = FOM_EYE;
		else
			method = FOM_BER;
		
		sweep_pma_setting (tx_phy, tx, Selectedphy,rx,temp,method,step_size);	// note method not used.		
		
		
	
		//Reset ErrorCount in selected phy
			
	
 
       usleep(1000000);		
	
	
				break; //case 'u' 
					

case 'f':
case 'F': // set adaptation to manual (work in progress)

/*
				//Assert Rx Reset on all lanes
				Control_Reg[Selectedphy] = Control_Reg[Selectedphy] | (0x00F0);	
				write_control_reg(Selectedphy,Control_Reg[Selectedphy]);	
		
				if (DEBUG_RESET) printf("\nPhy %1d reset_rx asserted on all lanes",Selectedphy);
		
				do 
				{
					rx_reset_ack_combined = 1;
					for (i=0; i < number_of_lanes[Selectedphy]; i++)
					{
						Channel_Reg[Selectedphy][i]      =  Read_Channel_Reg(Selectedphy,i);
						rx_reset_ack[Selectedphy][i] = 0x0001 & (Channel_Reg[Selectedphy][i] >> 2);				
						if (rx_reset_ack[Selectedphy][i] == 0)
							rx_reset_ack_combined  = 0;
					}
				} while ((rx_reset_ack_combined == 0));
				
					
					for (i = 0; i < number_of_physical_lanes[Selectedphy] ; i++)
					{ 	
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x0007, 0x0F,1,1);
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x0007, 0x0F,0,1);							
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x0007, 0x03,1,1);
							readout = cpi_request_fgt(Selectedphy, i, offset[Selectedphy], 0x0007, 0x03,0,1);							
							
					}
					
					//de-assert Reset_Rx
					Control_Reg[Selectedphy] = Control_Reg[Selectedphy] & (0xFF0F);	
					write_control_reg(Selectedphy,Control_Reg[Selectedphy]);		
		
					if (DEBUG_RESET) printf("\nPhy %1d reset_rx de-asserted on all lanes",Selectedphy);	
					
	*/
			if (fw_196_detected)
			{

			printf("\nCurrent selected media mode for phy %1d : ",Selectedphy);
			
			if (media_mode[Selectedphy] == MEDIA_MODE_FW_DEFAULT)
				printf("FW Default");
			else if (media_mode[Selectedphy] == MEDIA_MODE_VSR_OPTICAL_MODULE)
				printf("VSR/Optical Module");
			printf("\n");
			printf("\nPress '0' to select FW Default ");			
			printf("\nPress '1' to select VSR/Optical Module ");		
			printf("\nNo change press '9'");
			printf("\nSelection :");
			
			temp = input_number();
			
				if (temp == 9)
				{
					//do nothing
				}
				else
				{
					if (temp == 0)
						media_mode[Selectedphy] = MEDIA_MODE_FW_DEFAULT;
					else if (temp == 1)
						media_mode[Selectedphy] = MEDIA_MODE_VSR_OPTICAL_MODULE;

					set_media_mode(Selectedphy, offset[Selectedphy], number_of_physical_lanes[Selectedphy], media_mode[Selectedphy]);

					//Assert Rx Reset on all lanes
					Control_Reg[Selectedphy] = Control_Reg[Selectedphy] | (0x00F0);	
					write_control_reg(Selectedphy,Control_Reg[Selectedphy]);	
					
					usleep(100);
					
					//de-assert Reset_Rx
					Control_Reg[Selectedphy] = Control_Reg[Selectedphy] & (0xFF0F);	
					write_control_reg(Selectedphy,Control_Reg[Selectedphy]);	
					
				}
			}
				
	
					
				

	break;
	
	#ifdef SUPERLITE_ENABLED
	
		case 'k': /* Throttle Datarate */
		case 'K': /* Throttle Datarate */			
     

		if (throttle_datarate[Selectedphy] == 1)
        throttle_datarate[Selectedphy] = 0;
		else
        throttle_datarate[Selectedphy] = 1;
	 
		if (throttle_datarate[Selectedphy] == 1)
        Control_Reg[Selectedphy] = Control_Reg[Selectedphy] | (0x0400);
		else
        Control_Reg[Selectedphy] = Control_Reg[Selectedphy] & (0xFBFF);

		write_control_reg(Selectedphy,Control_Reg[Selectedphy]);

		usleep(100);


       
         
		break; /* Case K */
		
		
		
      case 'x': /* Toggle XOFF */
		case 'X':	
		
		  if (XOFF[Selectedphy] == 0)
		  {
			  XOFF[Selectedphy] = 1;
			  printf("XOFF active.\n\n\n");
		  }
		  else
		  {
			  XOFF[Selectedphy] = 0;
			  printf("XOFF not active.\n\n\n");
		  }

		 Control_Reg[Selectedphy] = (Control_Reg[Selectedphy] & (0xF7FF)) | (XOFF[Selectedphy] << 11); 		  
		write_control_reg(Selectedphy,Control_Reg[Selectedphy]);

        usleep(100000);
		
		//Reset Errorcounter on Selectedphy to make sure the DataClock_Out_Reg is being correctly resetted.
		
        Control_Reg[Selectedphy] = Control_Reg[Selectedphy] | (0x2000);
        write_control_reg(Selectedphy,Control_Reg[Selectedphy]);

	    usleep(10);
        
        Control_Reg[Selectedphy] = Control_Reg[Selectedphy] & (0xDFFF);
        write_control_reg(Selectedphy,Control_Reg[Selectedphy]);		

        break; //case 'x'	 
	#endif
		  
	
	  #ifdef INTERNAL_NOISE_REGISTER_PRESENT
	  case '+':
	  
	     if (enable_noise_chunks < noise_floor_max) 
		    {
				number_of_noise_chunks = number_of_noise_chunks + 1;
				enable_noise_chunks = (enable_noise_chunks << 1) + 1;
			   printf("\n\nIncrease Internal noise logic 0x%2x. \n",enable_noise_chunks);
			 
				enable_noise_chunks_Reg =  (enable_noise_chunks_Reg & (0x0000)) | (enable_noise_chunks );
				printf("\nenable_noise_chunks_Reg 0x%2x. \n",enable_noise_chunks_Reg);
				IOWR_ALTERA_AVALON_PIO_DATA(INTERNAL_NOISE_BASE,enable_noise_chunks_Reg); 
		    }

			 

	     break;
		  
	  case '-':
		   
	     if (enable_noise_chunks > 0)
		  {
			   number_of_noise_chunks = number_of_noise_chunks - 1;
				enable_noise_chunks = (enable_noise_chunks >>  1);
		      printf("\n\nDecrease Internal Noise logic.\n");
				enable_noise_chunks_Reg =  (enable_noise_chunks_Reg & (0x0000)) | (enable_noise_chunks );
				IOWR_ALTERA_AVALON_PIO_DATA(INTERNAL_NOISE_BASE,enable_noise_chunks_Reg); 
		  }

		  break;
	#endif

	 case '!': //read register of selected phy selected using rd_channel
	
 			
			 printf("\nProvide address (using 8 bytes hexadecimal) : 0x");
			 address = input_double_word();
		
					for (j = 0; j < number_of_lanes[Selectedphy] ; j++)
					{ 	 
				
					  temp = rd_channel(Selectedphy,(j << offset[Selectedphy]) + address); 					  
					  printf("\nPhy %2d Ch %1d Address 0x%x rd_channel value : 0x%08x",Selectedphy,j,address,temp);
					}
					 				 
					 
			 printf("\n\nPress any key to continue .");
			 rx_char = input_char();
			 					 
			 break;	
			 
	 case ':': //read register of selected phy using rd_channel_ftile
	
 			
			 printf("\nProvide address (using 8 bytes hexadecimal) : 0x");
			 address = input_double_word();
		
					for (j = 0; j < number_of_lanes[Selectedphy] ; j++)
					{ 	 
				
					  temp = rd_channel_ftile (Selectedphy,j, offset[Selectedphy],address);					  
					  printf("\nPhy %2d Ch %1d Address 0x%x rd_channel_ftile value : 0x%08x",Selectedphy,j,address,temp);
					}
					 				 
					 
			 printf("\n\nPress any key to continue .");
			 rx_char = input_char();
			 					 
			 break;	
			 
	
/*	
	 case '!': //read pdp register of selected channel in selected PHY
	
 			
			 printf("\nProvide address (4 bytes hexadecimal) : ");
			 address = input_word();
		
					for (j = 0; j < number_of_lanes[Selectedphy] ; j++)
					 { 	 
					  // temp = rd_pdp_channel(Selectedphy,(j << offset[Selectedphy]) + address); 
					  // printf("\nPhy %2d Ch %1d Address 0x%x value : 0x%x",Selectedphy,j,address,temp);
					  temp = rd_pdp_channel(Selectedphy,address); 
					  printf("\nPhy %2d Address 0x%x value : 0x%x",Selectedphy,address,temp);					  
					 }
					 				 
					 
			 printf("\n\nPress any key to continue .");
			 rx_char = input_char();
			 					 
			 break;	
		
		
*/
		
	

	 case 'l':
	 case 'L':
			printf("\nPress 1 if you want to reset only the Selected PHY and check it status");
			printf("\nPress 2 if you want to reset the Selected PHY and check if both PHY's come up properly (requires connection between the PHY's)");
			printf("\nPress 3 if you want to do rx_reset of the Selected PHY and check it status");	
			printf("\nPress 4 if you want to stress test AVMM accesses to the reconfiguration interface and the PDP interface");
			printf("\nPress 5 to reset the rx of all lanes of the Selected Phy until the link is up on all lanes of the Selected Phy");
			printf("\nPress 6 to reset the Selected Rx channel until the link is up on that Channel");		
			printf("\nPress 7 to run a test mimicing cable pull/plug-in using Tx mute option on local phy and verify if remote PHY comes up properly");	
			printf("\nPress 8 to run the same test as test 1 but specifically when used in combination with SiPh which take seconds to come up");
			if (SUPERLITE_USED)
				printf("\nPress 9 to measure latency across %d resets",LOOPCOUNT);
			
			printf("\nChoice : ");
			rx_char = input_char();
			if (rx_char == '1')
				loop_reset(LOOPCOUNT,TIMEOUT_ADAPTATION_MS,1);
			else if (rx_char == '2')
				loop_reset_2(LOOPCOUNT);
			else if (rx_char == '3')
				loop_reset_rx(LOOPCOUNT);
			else if (rx_char == '4')
				loop_avmm(LOOPCOUNT);
			else if (rx_char == '5')
				loop_reset_rx_until_all_rx_good(LOOPCOUNT);	
			else if (rx_char == '6')
				loop_reset_rx_until_rx_good(LOOPCOUNT);		
			else if (rx_char == '7')
				loop_mute_tx(LOOPCOUNT);
			else if (rx_char == '8')
				loop_reset(LOOPCOUNT,TIMEOUT_ADAPTATION_MS_OPTICS,8);	
			else if (rx_char == '9')
			{
				#ifdef SUPERLITE_ENABLED
					loop_latency(LOOPCOUNT);
				#endif
			}
  
			
	break;
	
     
		  
	case '}' :
			if ((qsfpdd0_present == 1) && (ENABLE_I2C_ACCESS_QSFPDD0))
				printf("\nDump I2C registers (Lower Page and Page 00h) of QSFPDD0 choose '0'");
			if ((qsfpdd1_present == 1) && (ENABLE_I2C_ACCESS_QSFPDD1))
				printf("\nDump I2C registers (Lower Page and Page 00h) of QSFPDD1 choose '1'");		
			if ((qsfpdd800_present == 1) && (ENABLE_I2C_ACCESS_QSFPDD800))
				printf("\nDump I2C registers (Lower Page and Page 00h) of QSFPDD800 choose '2'");				
		
			printf("\nChoice :");
			
		  do 
		  {
		  temp = input_number(); 
		  } while ((temp < 0) || (temp > 1));
        printf("\n\n");					
		
		  switch(temp)
		  {


			
			case 0 :
			if ((qsfpdd0_present == 1) && (ENABLE_I2C_ACCESS_QSFPDD0))
			{			
				if (AGILEX_SI_BOARD)
				{
					//Enable I2C access to QSFPDD0 module
					module_output = (module_output & (0xFFFF0FFF)) | (0x2 << 12);
					IOWR_ALTERA_AVALON_PIO_DATA(MODULE_OUTPUT_REG_BASE,module_output);
			
			
					i2c_dump(0,0x50);	
					
					//Disable I2C access to QSFPDD0 module
					module_output = (module_output & (0xFFFF0FFF)) | (0x3 << 12);
					IOWR_ALTERA_AVALON_PIO_DATA(MODULE_OUTPUT_REG_BASE,module_output);
				}
				else if (AGILEX_PCIE_DEVKIT)
				{
					if (i2c_access_enabled == 1)
						i2c_dump(0,0x78);	
					else
						printf("\nI2C access is disabled");
				}
				
			}
			
			break;
			
			case 1 :
				
			if ((qsfpdd1_present == 1) && (ENABLE_I2C_ACCESS_QSFPDD1))
			{
				if (AGILEX_SI_BOARD)
				{				
					//Enable I2C access to QSFPDD1 module
					module_output = (module_output & (0xFFF0FFFF)) | (0x2 << 16);
					IOWR_ALTERA_AVALON_PIO_DATA(MODULE_OUTPUT_REG_BASE,module_output);
			
			
					i2c_dump(1,0x50);	
					
					//Disable I2C access to QSFPDD1 module
					module_output = (module_output & (0xFFF0FFFF)) | (0x3 << 16);
					IOWR_ALTERA_AVALON_PIO_DATA(MODULE_OUTPUT_REG_BASE,module_output);
				}
				else if (AGILEX_PCIE_DEVKIT)
				{
					if (i2c_access_enabled == 1)					
						i2c_dump(0,0x7C);	
					else
						printf("\nI2C access is disabled");					
					
				}				
				
			}			
			
			break;
			
			case 2 :
			if ((qsfpdd800_present == 1) && (ENABLE_I2C_ACCESS_QSFPDD800))
			{			
				if (AGILEX_SI_BOARD)
				{
					//Enable I2C access to QSFPDD800 module
					module_output = (module_output & (0xFFFF0FFF)) | (0x2 << 12);
					IOWR_ALTERA_AVALON_PIO_DATA(MODULE_OUTPUT_REG_BASE,module_output);
			
			
					i2c_dump(0,0x50);	
					
					//Disable I2C access to QSFPDD800 module
					module_output = (module_output & (0xFFFF0FFF)) | (0x3 << 12);
					IOWR_ALTERA_AVALON_PIO_DATA(MODULE_OUTPUT_REG_BASE,module_output);
				}
				
			}
			
			break;			
				
			
			default : break;
				  
		}
		
		printf("\n\nPress any key to continue");
		rx_char = input_char();
		
		  
break; //case '}'



		
/*

	 case '*': //Dump register space of selected channel
		j = 0;
		printf("\n>>>>unsigned int xcvr_dump[564] = {");
		for (i = 0x0; i < 0x100 ; i++)
			{   
					temp = rd_channel(Selectedphy,(SelectedChannel[Selectedphy] << offset[Selectedphy]) + i ); 
					//printf("\nChannel %1d Register 0x%3x : 0x%2x",SelectedChannel[Selectedphy],i,temp);
					printf("\n>>>>0x%03xFF%02x,",i,temp);
				j++;
			}	
		for (i = 0x200; i < 0x334 ; i++)
			{   
					temp = rd_channel(Selectedphy,(SelectedChannel[Selectedphy] << offset[Selectedphy]) + i ); 
					//printf("\nChannel %1d Register 0x%3x : 0x%2x",SelectedChannel[Selectedphy],i,temp);		
				   printf("\n>>>>0x%03xFF%02x,",i,temp);
				j++;				
			}	

		printf("\n>>>>};");
		break;
*/

/*			
case '+': // Dumpt RSFEC registers on selected PHY

			printf("\nRSFEC Registers (Selectedphy %d)",Selectedphy);
			printf("\n================================");	
			
			//Register 0x04 : rsfec_top_clk_cfg
			fec_read = rd_fec_32bit(Selectedphy,0x04);
			printf("\nRS-FEC Register 0x04 rsfec_top_clk_cfg   : 0x%x",fec_read);		
	
			//Register 0x10 : rsfec_top_tx_cfg
			fec_read = rd_fec_32bit(Selectedphy,0x10);
			printf("\nRS-FEC Register 0x10 rsfec_top_tx_cfg    : 0x%x",fec_read);
			
			//Register 0x14 : rsfec_top_rx_cfg
			fec_read = rd_fec_32bit(Selectedphy,0x14);
			printf("\nRS-FEC Register 0x14 rsfec_top_rx_cfg    : 0x%x",fec_read);

			//Register 0x20 : tx_aib_dsk_conf
			fec_read = rd_fec_32bit(Selectedphy,0x20);
			printf("\nRS-FEC Register 0x20 tx_aib_dsk_conf     : 0x%x",fec_read);			
			
			//Register 0x30 : rsfec_core_cfg
			fec_read = rd_fec_32bit(Selectedphy,0x30);
			printf("\nRS-FEC Register 0x30 rsfec_core_cfg      : 0x%x",fec_read);

			//Register 0x40 : rsfec_lane_cfg			
			fec_read = rd_fec_32bit(Selectedphy,0x40);
			printf("\nRS-FEC Register 0x40 rsfec_lane_cfg_0    : 0x%x",fec_read);
				
			//Register 0x44 : rsfec_lane_cfg			
			fec_read = rd_fec_32bit(Selectedphy,0x44);
			printf("\nRS-FEC Register 0x44 rsfec_lane_cfg_1    : 0x%x",fec_read);

			//Register 0x48 : rsfec_lane_cfg			
			fec_read = rd_fec_32bit(Selectedphy,0x48);
			printf("\nRS-FEC Register 0x48 rsfec_lane_cfg_2    : 0x%x",fec_read);

			//Register 0x4C : rsfec_lane_cfg			
			fec_read = rd_fec_32bit(Selectedphy,0x4C);
			printf("\nRS-FEC Register 0x4C rsfec_lane_cfg_3    : 0x%x",fec_read);

			//Register 0x104 : tx_aib_dsk_status
			fec_read = rd_fec_32bit(Selectedphy,0x104);
			printf("\nRS-FEC Register 0x104 tx_aib_dsk_status  : 0x%x",fec_read);	
			printf("\n");
			
			for (i = 0; i < number_of_lanes[Selectedphy] ; i++)
			{
				printf("\nFEC_Correctable_Symbols_Reg_H[%1d][%1d]  : %u",Selectedphy,i,FEC_Correctable_Symbols_Reg_H[Selectedphy][i]);
			   printf("\nFEC_Correctable_Symbols_Reg_L[%1d][%1d]  : %u",Selectedphy,i,FEC_Correctable_Symbols_Reg_L[Selectedphy][i]);
			   printf("\nFEC_Correctable_Symbols[%1d][%1d]        : %e",Selectedphy,i,FEC_Correctable_Symbols[Selectedphy][i]);				
				printf("\n");
				printf("\nFEC_Correctable_Bits_0_1_Reg_H[%1d][%1d] : %u",Selectedphy,i,FEC_Correctable_Bits_0_1_Reg_H[Selectedphy][i]);
				printf("\nFEC_Correctable_Bits_0_1_Reg_L[%1d][%1d] : %u",Selectedphy,i,FEC_Correctable_Bits_0_1_Reg_L[Selectedphy][i]);
				printf("\nFEC_Correctable_Bits_0_1[%1d][%1d]       : %e",Selectedphy,i,FEC_Correctable_Bits_0_1[Selectedphy][i]);		
				printf("\n");				
				printf("\nFEC_Correctable_Bits_1_0_Reg_H[%1d][%1d] : %u",Selectedphy,i,FEC_Correctable_Bits_1_0_Reg_H[Selectedphy][i]);
				printf("\nFEC_Correctable_Bits_1_0_Reg_L[%1d][%1d] : %u",Selectedphy,i,FEC_Correctable_Bits_1_0_Reg_L[Selectedphy][i]);
				printf("\nFEC_Correctable_Bits_1_0[%1d][%1d]       : %e",Selectedphy,i,FEC_Correctable_Bits_1_0[Selectedphy][i]);	
				printf("\n");				
				
			}			
			
			printf("\nPress any key to continue:");
			rx_char = input_char();
	

break;	

*/
			

  
      case '#': //Fectree	
		#ifdef RSFEC_USED
			fec_tree(Selectedphy);
		#endif
			


	


        break; //case '#'

		
  case '.' : //Set all FGT channels in serial loopback except the selected channel

			//Enable serialloopback on all phys  
			for (t = 0; t < NUMBER_OF_PHYS; t++)
  			{

					for (i = 0; i < number_of_lanes[t] ; i++)
					{
							Serial_Loop[t][i] = 1;	

					}
			}
			
			//Disable serial loopback on selected chhannel
			Serial_Loop[Selectedphy][SelectedChannel[Selectedphy]] = 0;
		
 
			for (t = 0; t < NUMBER_OF_PHYS; t++)
  			{ 
		
				//Assert Rx Reset on all lanes
				reset_rx_assert_phy(t);
		
				if (DEBUG_RESET) printf("\nPhy %1d reset_rx asserted on all lanes",t);
		
				
					
					for (i = 0; i < number_of_lanes[t] ; i++)
					{ 	
					
				
						if (Serial_Loop[t][i] == 1)
						{
						//enable SILB CPI command 
						
						//void cpi_request(int phy, int offset, int data, int lane, int opcode, int assert)
						//Issue CPI request for serial loopback
						//Data : 0x0006 : PMA Tx to Rx buffered serial loopback, loops back the Tx serializer output into Rx Eq.
						//Opcode : 0x40
						
						//Lane : this is the physical lane (can be determined by reading out 0xFFFFC (only supported in production silicon)
						
							readout = cpi_request_fgt(t, i, offset[t], 0x0006, 0x40,1,1);
							readout = cpi_request_fgt(t, i, offset[t], 0x0006, 0x40,0,1);
						}
						else //serial loopback not set
						{
							readout = cpi_request_fgt(t, i, offset[t], 0x0000, 0x40,1,1);
							readout = cpi_request_fgt(t, i, offset[t], 0x0000, 0x40,0,1);
						}
								

					} // for i
		
					//de-assert Reset_Rx
					reset_rx_deassert_phy(t);		
		
					if (DEBUG_RESET) printf("\nPhy %1d reset_rx de-asserted on all lanes",t);	
					
					// readback serial loopback 
					// this takes time before this bit is set.
					// also adaptation takes time before the link is up so this why a wait time of 100 ms is used.
					
					usleep(100000);
					
					readback_loopbacks(t);
					
					
					
			} 

			
			
		break; //case '.'
		

  case '(' : //Keep all FGT channels in reset except the selected channel.

			for (t = 0; t < NUMBER_OF_PHYS; t++)
  			{
				for (i = 0; i < number_of_lanes[t] ; i++)
				{ 					
					if ((t == Selectedphy) && (i == SelectedChannel[Selectedphy]))
					{
						//don't reset Selectedchannel
					}
					else
					{
						reset_assert_channel(t,i);
					}
				}
				
			}
			
			printf("\nReset asserted on all lanes except selected channel");
			
	break;
	

  case ')' : //De-assert reset on all lanes

			for (t = 0; t < NUMBER_OF_PHYS; t++)
  			{
				for (i = 0; i < number_of_lanes[t] ; i++)
				{ 					
						reset_deassert_channel(t,i);
				}
				
			}
			
			printf("\nReset de-asserted on all lanes except selected channel");
			
	break;
	

  case '[' : //Mute all transmitters except the selected channel

			for (t = 0; t < NUMBER_OF_PHYS; t++)
  			{
				for (i = 0; i < number_of_lanes[t] ; i++)
				{ 					
					if ((t == Selectedphy) && (i == SelectedChannel[Selectedphy]))
					{
						if (MUTE_ALL_CHANNELS)
						{
							if (FHT_USED == 0)
								rmw_channel_ftile(t,i,offset[t], 0x41750,0x03000000,0x03000000); //Mute FGT tx driver
							else
								program_tx_pma_settings_fht(t,i,offset[t],1); // Mute FHT tx driver by setting all Tx PMA settings to zero
							
						   tx_channel_muted[t][i] = 1;
						}
					}
					else
					{
						if (FHT_USED == 0)
							rmw_channel_ftile(t,i,offset[t], 0x41750,0x03000000,0x03000000); //Mute FGT Tx driver
						else
							program_tx_pma_settings_fht(t,i,offset[t],1); // Mute FHT tx driver by setting all Tx PMA settings to zero
						
						tx_channel_muted[t][i] = 1;						
					}
				}
				
			}
			
			printf("\nReset asserted on all lanes except selected channel");
			
	break;
	

  case ']' : //UnMute all transmitters

			for (t = 0; t < NUMBER_OF_PHYS; t++)
  			{
				for (i = 0; i < number_of_lanes[t] ; i++)
				{ 	
						if (FHT_USED == 0)			
							rmw_channel_ftile(t,i,offset[t], 0x41750,0x03000000,0x00000000); //UnMute FGT tx driver
						else
							program_tx_pma_settings_fht(t,i,offset[t],0); // Unmute FHT tx driver be reloading previous TX PMA settings					
					
					tx_channel_muted[t][i] = 0;
				}
				
			}
			
			
	break;
	
	
	
		

		
		
     case '0':
        printf("\nTerminating Program.\n");
        return 0;
       break;
  
      default:
        printf("\n\tPlease enter a value from 0 to Z\n\n\n");
        break;
	
	
		
		
    
    } // switch
	}
	
 } // while
 return 0;
}






void reset_phy(int phy,int use_reset)
{

if ((phy >= 0) && (phy < NUMBER_OF_PHYS))
{
		
	if (use_reset == 1)
	{
	//Assert Reset
	

		
   Control_Reg[phy] = Control_Reg[phy] | (0x8000);
   write_control_reg(phy,Control_Reg[phy]);

   usleep(10000);	
	
	if (DEBUG_RESET) printf("\nPhy %1d Reset asserted",phy);
	}

	// Reset_tx and Reset_rx at the same time (duplex)
	if (RESET_CONTROL_REG_USED)
	{
		Reset_Control_Reg[phy] = 0xFFFFFFFF;
		#ifdef RESET_CONTROL_REG_ENABLED
			write_reset_control_reg(phy,Reset_Control_Reg[phy]);
		#endif
	}
	else
	{
		Control_Reg[phy] = Control_Reg[phy] | (0x00FF);	
		write_control_reg(phy,Control_Reg[phy]);	
	}
	
	if (DEBUG_RESET) printf("\nPhy %1d reset_tx and reset_rx asserted on all lanes",phy);
	
	do 
	{
		tx_reset_ack_combined = 1;
		rx_reset_ack_combined = 1;
		for (i=0; i < number_of_lanes[phy]; i++)
		{
			Channel_Reg[phy][i]      =  Read_Channel_Reg(phy,i);
			//if (DEBUG_RESET) printf("\nChannel_Reg[%1d][%1d] = 0x%x",phy,i,Channel_Reg[phy][i] );			
		   tx_reset_ack[phy][i] = 0x0001 & (Channel_Reg[phy][i] >> 3);
			rx_reset_ack[phy][i] = 0x0001 & (Channel_Reg[phy][i] >> 2);				
			if (tx_reset_ack[phy][i] == 0)
				tx_reset_ack_combined = 0;	
			if (rx_reset_ack[phy][i] == 0)
				rx_reset_ack_combined  = 0;
		}
	} while ((tx_reset_ack_combined == 0) || (rx_reset_ack_combined == 0));
	
	//rx_char = input_char();
	if (DEBUG_RESET) printf("\nPhy %1d tx_reset_ack and rx_reset_ack asserted on all lanes",phy);	
	
	
	// do 
	// {
		// rx_reset_ack_combined = 1;
		// for (i=0; i < number_of_lanes[phy]; i++)
		// {	
			// Channel_Reg[phy][i]      =  Read_Channel_Reg(phy,i);
			// rx_reset_ack[phy][i] = 0x0001 & (Channel_Reg[phy][i] >> 2);	
			// if (rx_reset_ack[phy][i] == 0)
				// rx_reset_ack_combined = 0;			
		// }
	// } while (rx_reset_ack_combined == 0);
		
	//if (DEBUG_RESET) printf("\nPhy %1d rx_reset_ack asserted on all lanes",phy);	
	
	//de-assert Reset_tx and Reset_Rx
	if (RESET_CONTROL_REG_USED)
	{
		Reset_Control_Reg[phy] = 0x00000000;
		#ifdef RESET_CONTROL_REG_ENABLED
			write_reset_control_reg(phy,Reset_Control_Reg[phy]);
		#endif
	}
	else
	{
		Control_Reg[phy] = Control_Reg[phy] & (0xFF00);	
		write_control_reg(phy,Control_Reg[phy]);		
	}
	
	if (DEBUG_RESET) printf("\nPhy %1d reset_tx and reset_rx de-asserted on all lanes",phy);		
	
	usleep(100);
	
	//rx_char = input_char();
	
	//de-assert Reset_rx
   // Control_Reg[phy] = Control_Reg[phy] & (0xFF0F);		
   // write_control_reg(phy,Control_Reg[phy]);
	// if (DEBUG_RESET) printf("\nPhy %1d reset_rx de-asserted on all lanes",phy);			
		
	//rx_char = input_char();
	
	
	if (use_reset == 1)
	{	
	//De-Assert Reset	
	
	 
   Control_Reg[phy] = Control_Reg[phy] & (0x7FFF);
   write_control_reg(phy,Control_Reg[phy]);
	
	if (DEBUG_RESET) printf("\nPhy %1d Reset de-asserted",phy);	
	}	
	
   usleep(100000);

}
}


void reset_rx_assert_phy(int phy)
{

	if ((phy >= 0) && (phy < NUMBER_OF_PHYS))
	{
		// Reset_rx on all channels
		if (RESET_CONTROL_REG_USED)
		{
			Reset_Control_Reg[phy] = 0xFFFF0000;
			#ifdef RESET_CONTROL_REG_ENABLED
				write_reset_control_reg(phy,Reset_Control_Reg[phy]);
			#endif
		}
		else
		{
			Control_Reg[phy] = Control_Reg[phy] | (0x00F0);	
			write_control_reg(phy,Control_Reg[phy]);	
		}
		
		if (DEBUG_RESET) printf("\nPhy %1d reset_rx asserted on all lanes",phy);
		
		do 
		{
			rx_reset_ack_combined = 1;
			for (i=0; i < number_of_lanes[phy]; i++)
			{
				Channel_Reg[phy][i]      =  Read_Channel_Reg(phy,i);
				//if (DEBUG_RESET) printf("\nChannel_Reg[%1d][%1d] = 0x%x",phy,i,Channel_Reg[phy][i] );			
				rx_reset_ack[phy][i] = 0x0001 & (Channel_Reg[phy][i] >> 2);				
				if (rx_reset_ack[phy][i] == 0)
					rx_reset_ack_combined  = 0;
			}
		} while ((rx_reset_ack_combined == 0));
		
		//rx_char = input_char();
		if (DEBUG_RESET) printf("\nPhy %1d rx_reset_ack asserted on all lanes",phy);	
		
	}	
}

void reset_rx_deassert_phy(int phy)
{

	if ((phy >= 0) && (phy < NUMBER_OF_PHYS))
	{	
		//de-assert Reset_Rx on all lanes
		if (RESET_CONTROL_REG_USED)
		{
			Reset_Control_Reg[phy] = 0x00000000;
			#ifdef RESET_CONTROL_REG_ENABLED
				write_reset_control_reg(phy,Reset_Control_Reg[phy]);
			#endif
		}
		else
		{
			Control_Reg[phy] = Control_Reg[phy] & (0xFF0F);	
			write_control_reg(phy,Control_Reg[phy]);		
		}
		
		if (DEBUG_RESET) printf("\nPhy %1d reset_rx de-asserted on all lanes",phy);		
		
		usleep(100);
	}	
}

void reset_channel(int phy,int channel)
{

	if ((phy >= 0) && (phy < NUMBER_OF_PHYS))
	{
		// Reset_tx and Reset_rx of the channel at the same time (duplex)

		if (RESET_CONTROL_REG_USED)
		{
			switch (channel)
			{
				case 0 : Reset_Control_Reg[phy] = 0x00010001;	break;
				case 1 : Reset_Control_Reg[phy] = 0x00020002;	break;
				case 2 : Reset_Control_Reg[phy] = 0x00040004;	break;
				case 3 : Reset_Control_Reg[phy] = 0x00080008;	break;
				case 4 : Reset_Control_Reg[phy] = 0x00100010;	break;
				case 5 : Reset_Control_Reg[phy] = 0x00200020;	break;
				case 6 : Reset_Control_Reg[phy] = 0x00400040;	break;
				case 7 : Reset_Control_Reg[phy] = 0x00800080;	break;			
				default : ;	break;
			}	
			#ifdef RESET_CONTROL_REG_ENABLED
				write_reset_control_reg(phy,Reset_Control_Reg[phy]);
			#endif
		}
		else
		{
		
			switch (channel)
			{
				case 0 : Control_Reg[phy] = Control_Reg[phy] | (0x0011);	break;
				case 1 : Control_Reg[phy] = Control_Reg[phy] | (0x0022);	break;
				case 2 : Control_Reg[phy] = Control_Reg[phy] | (0x0044);	break;
				case 3 : Control_Reg[phy] = Control_Reg[phy] | (0x0088);	break;
				default : Control_Reg[phy] = Control_Reg[phy] | (0x0011);	break;
			}	
				
			write_control_reg(phy,Control_Reg[phy]);	
		}
		
		if (DEBUG_RESET) printf("\nPhy %1d reset_tx and reset_rx asserted on lane %1d",phy,channel);
		
		do 
		{
				Channel_Reg[phy][channel]      =  Read_Channel_Reg(phy,channel);
				tx_reset_ack[phy][channel] = 0x0001 & (Channel_Reg[phy][channel] >> 3);
				rx_reset_ack[phy][channel] = 0x0001 & (Channel_Reg[phy][channel] >> 2);				
		} while ((tx_reset_ack[phy][channel] == 0) || (rx_reset_ack[phy][channel] == 0));
		
		//rx_char = input_char();
		if (DEBUG_RESET) printf("\nPhy %1d tx_reset_ack and rx_reset_ack asserted on lane %1d",phy,channel);	
		
		usleep(100);

		if (RESET_CONTROL_REG_USED)
		{
			Reset_Control_Reg[phy] = 0x00000000;
			
			#ifdef RESET_CONTROL_REG_ENABLED
				write_reset_control_reg(phy,Reset_Control_Reg[phy]);
			#endif
		}
		else
		{	
			switch (channel)
			{
				case 0 : Control_Reg[phy] = Control_Reg[phy] & (0xFFEE);	break;
				case 1 : Control_Reg[phy] = Control_Reg[phy] & (0xFFDD);	break;
				case 2 : Control_Reg[phy] = Control_Reg[phy] & (0xFFBB);	break;
				case 3 : Control_Reg[phy] = Control_Reg[phy] & (0xFF77);	break;
				default : Control_Reg[phy] = Control_Reg[phy] & (0xFFEE); break;
			}
			write_control_reg(phy,Control_Reg[phy]);				
		}
		

		
		if (DEBUG_RESET) printf("\nPhy %1d reset_tx and reset_rx de-asserted on lane %1d",phy,channel);		
		
		usleep(100);
		
	}
}

void reset_assert_channel(int phy,int channel)
{
	if ((phy >= 0) && (phy < NUMBER_OF_PHYS))
	{
		if (RESET_CONTROL_REG_USED)
		{
			switch (channel)
			{
				case 0 : Reset_Control_Reg[phy] = 0x00010001;	break;
				case 1 : Reset_Control_Reg[phy] = 0x00020002;	break;
				case 2 : Reset_Control_Reg[phy] = 0x00040004;	break;
				case 3 : Reset_Control_Reg[phy] = 0x00080008;	break;
				case 4 : Reset_Control_Reg[phy] = 0x00100010;	break;
				case 5 : Reset_Control_Reg[phy] = 0x00200020;	break;
				case 6 : Reset_Control_Reg[phy] = 0x00400040;	break;
				case 7 : Reset_Control_Reg[phy] = 0x00800080;	break;			
				default : ;	break;
			}	
			#ifdef RESET_CONTROL_REG_ENABLED
				write_reset_control_reg(phy,Reset_Control_Reg[phy]);
			#endif
		}
		else
		{
			// Reset_tx and Reset_rx of the channel at the same time (duplex)
			switch (channel)
			{
				case 0 : Control_Reg[phy] = Control_Reg[phy] | (0x0011);	break;
				case 1 : Control_Reg[phy] = Control_Reg[phy] | (0x0022);	break;
				case 2 : Control_Reg[phy] = Control_Reg[phy] | (0x0044);	break;
				case 3 : Control_Reg[phy] = Control_Reg[phy] | (0x0088);	break;
				default : Control_Reg[phy] = Control_Reg[phy] | (0x0011);	break;
			}	
			write_control_reg(phy,Control_Reg[phy]);			
		}
			

		
		if (DEBUG_RESET) printf("\nPhy %1d reset_tx and reset_rx asserted on lane %1d",phy,channel);
		
		do 
		{
				Channel_Reg[phy][channel]      =  Read_Channel_Reg(phy,channel);
				tx_reset_ack[phy][channel] = 0x0001 & (Channel_Reg[phy][channel] >> 3);
				rx_reset_ack[phy][channel] = 0x0001 & (Channel_Reg[phy][channel] >> 2);				
		} while ((tx_reset_ack[phy][channel] == 0) || (rx_reset_ack[phy][channel] == 0));
		
		//rx_char = input_char();
		if (DEBUG_RESET) printf("\nPhy %1d tx_reset_ack and rx_reset_ack asserted on lane %1d",phy,channel);	
	}	
}

void reset_rx_assert_channel(int phy,int channel)
{
	if ((phy >= 0) && (phy < NUMBER_OF_PHYS))
	{
		if (RESET_CONTROL_REG_USED)
		{
			switch (channel)
			{
				case 0 : Reset_Control_Reg[phy] = 0x00010000;	break;
				case 1 : Reset_Control_Reg[phy] = 0x00020000;	break;
				case 2 : Reset_Control_Reg[phy] = 0x00040000;	break;
				case 3 : Reset_Control_Reg[phy] = 0x00080000;	break;
				case 4 : Reset_Control_Reg[phy] = 0x00100000;	break;
				case 5 : Reset_Control_Reg[phy] = 0x00200000;	break;
				case 6 : Reset_Control_Reg[phy] = 0x00400000;	break;
				case 7 : Reset_Control_Reg[phy] = 0x00800000;	break;			
				default : ;	break;
			}	
			#ifdef RESET_CONTROL_REG_ENABLED
				write_reset_control_reg(phy,Reset_Control_Reg[phy]);
			#endif
		}
		else
		{
			// Reset_rx of the channel
			switch (channel)
			{
				case 0 : Control_Reg[phy] = Control_Reg[phy] | (0x0010);	break;
				case 1 : Control_Reg[phy] = Control_Reg[phy] | (0x0020);	break;
				case 2 : Control_Reg[phy] = Control_Reg[phy] | (0x0040);	break;
				case 3 : Control_Reg[phy] = Control_Reg[phy] | (0x0080);	break;
				default : ;	break;
			}	
			write_control_reg(phy,Control_Reg[phy]);			
		}
			

		
		if (DEBUG_RESET) printf("\nPhy %1d reset_tx and reset_rx asserted on lane %1d",phy,channel);
		
		do 
		{
				Channel_Reg[phy][channel]      =  Read_Channel_Reg(phy,channel);
				rx_reset_ack[phy][channel] = 0x0001 & (Channel_Reg[phy][channel] >> 2);				
		} while ((rx_reset_ack[phy][channel] == 0));
		
		//rx_char = input_char();
		if (DEBUG_RESET) printf("\nPhy %1d rx_reset_ack asserted on lane %1d",phy,channel);	
	}		
}


void reset_deassert_channel(int phy,int channel)
{
	if ((phy >= 0) && (phy < NUMBER_OF_PHYS))
	{
		if (RESET_CONTROL_REG_USED)
		{
			Reset_Control_Reg[phy] = 0x00000000;
			
			#ifdef RESET_CONTROL_REG_ENABLED
				write_reset_control_reg(phy,Reset_Control_Reg[phy]);
			#endif
		}
		else
		{
			switch (channel)
			{
				case 0 : Control_Reg[phy] = Control_Reg[phy] & (0xFFEE);	break;
				case 1 : Control_Reg[phy] = Control_Reg[phy] & (0xFFDD);	break;
				case 2 : Control_Reg[phy] = Control_Reg[phy] & (0xFFBB);	break;
				case 3 : Control_Reg[phy] = Control_Reg[phy] & (0xFF77);	break;
				default : Control_Reg[phy] = Control_Reg[phy] & (0xFFEE); break;
			}
			write_control_reg(phy,Control_Reg[phy]);			
		}
		
		
		
		if (DEBUG_RESET) printf("\nPhy %1d reset_tx and reset_rx de-asserted on lane %1d",phy,channel);		
	}		
}

void reset_rx_deassert_channel(int phy,int channel)
{
	if ((phy >= 0) && (phy < NUMBER_OF_PHYS))
	{
		if (RESET_CONTROL_REG_USED)
		{
			Reset_Control_Reg[phy] = 0x00000000;
			
			#ifdef RESET_CONTROL_REG_ENABLED
				write_reset_control_reg(phy,Reset_Control_Reg[phy]);
			#endif
		}
		else
		{
			switch (channel)
			{
				case 0 : Control_Reg[phy] = Control_Reg[phy] & (0xFFEF);	break;
				case 1 : Control_Reg[phy] = Control_Reg[phy] & (0xFFDF);	break;
				case 2 : Control_Reg[phy] = Control_Reg[phy] & (0xFFBF);	break;
				case 3 : Control_Reg[phy] = Control_Reg[phy] & (0xFF7F);	break;
				default : ; break;
			}
			write_control_reg(phy,Control_Reg[phy]);			
		}
			
		
		if (DEBUG_RESET) printf("\nPhy %1d reset_tx and reset_rx de-asserted on lane %1d",phy,channel);		
	}		
}




void reset_rx_channel(int phy,int channel)
{
	if ((phy >= 0) && (phy < NUMBER_OF_PHYS))
	{
		if (RESET_CONTROL_REG_USED)
		{
			switch (channel)
			{
				case 0 : Reset_Control_Reg[phy] = 0x00010000;	break;
				case 1 : Reset_Control_Reg[phy] = 0x00020000;	break;
				case 2 : Reset_Control_Reg[phy] = 0x00040000;	break;
				case 3 : Reset_Control_Reg[phy] = 0x00080000;	break;
				case 4 : Reset_Control_Reg[phy] = 0x00100000;	break;
				case 5 : Reset_Control_Reg[phy] = 0x00200000;	break;
				case 6 : Reset_Control_Reg[phy] = 0x00400000;	break;
				case 7 : Reset_Control_Reg[phy] = 0x00800000;	break;			
				default : ;	break;
			}	
			#ifdef RESET_CONTROL_REG_ENABLED
				write_reset_control_reg(phy,Reset_Control_Reg[phy]);
			#endif
		}
		else
		{
			// Reset_rx of the channel 
			switch (channel)
			{
				case 0 : Control_Reg[phy] = Control_Reg[phy] | (0x0010);	break;
				case 1 : Control_Reg[phy] = Control_Reg[phy] | (0x0020);	break;
				case 2 : Control_Reg[phy] = Control_Reg[phy] | (0x0040);	break;
				case 3 : Control_Reg[phy] = Control_Reg[phy] | (0x0080);	break;
				default : Control_Reg[phy] = Control_Reg[phy] | (0x0010);	break;
			}		
			write_control_reg(phy,Control_Reg[phy]);	
		}
		
		if (DEBUG_RESET) printf("\nPhy %1d reset_rx asserted on lane %1d",phy,channel);
		
		do 
		{
				Channel_Reg[phy][channel]      =  Read_Channel_Reg(phy,channel);
				rx_reset_ack[phy][channel] = 0x0001 & (Channel_Reg[phy][channel] >> 2);				
		} while  (rx_reset_ack[phy][channel] == 0);
		
		//rx_char = input_char();
		if (DEBUG_RESET) printf("\nPhy %1d rx_reset_ack asserted on lane %1d",phy,channel);	
		
		usleep(100);

		if (RESET_CONTROL_REG_USED)
		{
			Reset_Control_Reg[phy] = 0x00000000;
			
			#ifdef RESET_CONTROL_REG_ENABLED
				write_reset_control_reg(phy,Reset_Control_Reg[phy]);
			#endif
		}
		else
		{	
			switch (channel)
			{
				case 0 : Control_Reg[phy] = Control_Reg[phy] & (0xFFEF);	break;
				case 1 : Control_Reg[phy] = Control_Reg[phy] & (0xFFDF);	break;
				case 2 : Control_Reg[phy] = Control_Reg[phy] & (0xFFBF);	break;
				case 3 : Control_Reg[phy] = Control_Reg[phy] & (0xFF7F);	break;
				default : Control_Reg[phy] = Control_Reg[phy] & (0xFFEF); break;
			}	
			
			write_control_reg(phy,Control_Reg[phy]);		
		}
		
		if (DEBUG_RESET) printf("\nPhy %1d reset_rx de-asserted on lane %1d",phy,channel);		
		
		usleep(100);
		
	}	
}

void reset_tx_channel(int phy,int channel)
{
	if ((phy >= 0) && (phy < NUMBER_OF_PHYS))
	{
		if (RESET_CONTROL_REG_USED)
		{
			switch (channel)
			{
				case 0 : Reset_Control_Reg[phy] = 0x00000001;	break;
				case 1 : Reset_Control_Reg[phy] = 0x00000002;	break;
				case 2 : Reset_Control_Reg[phy] = 0x00000004;	break;
				case 3 : Reset_Control_Reg[phy] = 0x00000008;	break;
				case 4 : Reset_Control_Reg[phy] = 0x00000010;	break;
				case 5 : Reset_Control_Reg[phy] = 0x00000020;	break;
				case 6 : Reset_Control_Reg[phy] = 0x00000040;	break;
				case 7 : Reset_Control_Reg[phy] = 0x00000080;	break;			
				default : ;	break;
			}	
			#ifdef RESET_CONTROL_REG_ENABLED
				write_reset_control_reg(phy,Reset_Control_Reg[phy]);
			#endif
		}
		else
		{
			// Reset_tx of the channel 
			switch (channel)
			{
				case 0 : Control_Reg[phy] = Control_Reg[phy] | (0x0001);	break;
				case 1 : Control_Reg[phy] = Control_Reg[phy] | (0x0002);	break;
				case 2 : Control_Reg[phy] = Control_Reg[phy] | (0x0004);	break;
				case 3 : Control_Reg[phy] = Control_Reg[phy] | (0x0008);	break;
				default : Control_Reg[phy] = Control_Reg[phy] | (0x0001);	break;
			}	
				
			write_control_reg(phy,Control_Reg[phy]);	
		}
		
		if (DEBUG_RESET) printf("\nPhy %1d reset_tx asserted on lane %1d",phy,channel);
		
		do 
		{
				Channel_Reg[phy][channel]      =  Read_Channel_Reg(phy,channel);
				tx_reset_ack[phy][channel] = 0x0001 & (Channel_Reg[phy][channel] >> 3);				
		} while  (tx_reset_ack[phy][channel] == 0);
		
		//rx_char = input_char();
		if (DEBUG_RESET) printf("\nPhy %1d tx_reset_ack asserted on lane %1d",phy,channel);	
		
		usleep(100);

		if (RESET_CONTROL_REG_USED)
		{
			Reset_Control_Reg[phy] = 0x00000000;
			
			#ifdef RESET_CONTROL_REG_ENABLED
				write_reset_control_reg(phy,Reset_Control_Reg[phy]);
			#endif
		}
		else
		{		
			switch (channel)
			{
				case 0 : Control_Reg[phy] = Control_Reg[phy] & (0xFFFE);	break;
				case 1 : Control_Reg[phy] = Control_Reg[phy] & (0xFFFD);	break;
				case 2 : Control_Reg[phy] = Control_Reg[phy] & (0xFFFB);	break;
				case 3 : Control_Reg[phy] = Control_Reg[phy] & (0xFFF7);	break;
				default : Control_Reg[phy] = Control_Reg[phy] & (0xFFFE); break;
			}	
			
			write_control_reg(phy,Control_Reg[phy]);		
		}
		
		if (DEBUG_RESET) printf("\nPhy %1d reset_tx de-asserted on lane %1d",phy,channel);		
		
		usleep(100);
		
	}	
}



void clear_counters(int phy)
{

	if ((phy >= 0) && (phy < NUMBER_OF_PHYS))
	{	

	  //reset counter 1ms	
		
			  Control2_Reg[phy] = (Control2_Reg[phy] & (0xFFE0)) | (0x1F); // Select all channels
			  write_control2_reg(phy,  Control2_Reg[phy]);  
						  
		
			 // Reset errorcount on all channels 
				if (SUPERLITE_USED == 0)
					Control_Reg[phy] = Control_Reg[phy] | (0x2000);
				else
					Control_Reg[phy] = Control_Reg[phy] | (0x2200); //reset LockAlarm (Control_Reg(9))
				
			  write_control_reg(phy, Control_Reg[phy]);

			  
			  usleep(10);
				if (SUPERLITE_USED == 0)        
					Control_Reg[phy] = Control_Reg[phy] & (0xDFFF);
				else
					Control_Reg[phy] = Control_Reg[phy] & (0xDDFF);	
				
			  write_control_reg(phy, Control_Reg[phy]);
					  
			  


			  usleep(100000);
			  
				// Reset PrbsLockAlarm
			
			
					Control2_Reg[phy] = Control2_Reg[phy] | (0x8000);
					write_control2_reg(phy,Control2_Reg[phy]);

				usleep(10);
					
					Control2_Reg[phy] = Control2_Reg[phy] & (0x7FFF);
					write_control2_reg(phy,Control2_Reg[phy]);	
				
				usleep(10);      
		
			 // set back channel to selectedchannel.
		

			  Control2_Reg[phy] = (Control2_Reg[phy] & (0xFFE0)) | (SelectedChannel[phy]);
			  write_control2_reg(phy,Control2_Reg[phy]);
			 
	  

	#ifdef RSFEC_USED
			for (i=0; i < number_of_lanes[phy]; i++)
			{
				for (j=0; j < number_of_segments[phy] ; j ++)
				{
						fec_clear_counters(phy,i,ethernet_mode[phy],j);
				}
				
				for (j=0; j < 16 ; j ++)
				{			
					FEC_corr_cwbin_cnt_A_overrun[phy][i][j] = 0;
					FEC_corr_cwbin_cnt_B_overrun[phy][i][j] = 0;				
				}
			}
	#endif
	}	
}





	


void sweep_pma_setting (int tx_phy, int tx, int rx_phy, int rx, int pma_setting, int method, int step_size)
{

	if ((tx_phy >= 0) && (tx_phy < NUMBER_OF_PHYS) && (tx >= 0) && (tx < NUMBER_OF_LANES_MAX))
	{
		
				timestamp = clock();
			


		//Store current settings before sweeping
		

			tx_vodctrl[tx_phy][tx]					= (rd_channel_ftile (tx_phy, tx, offset[tx_phy], 0x47830) & 0x0000FC00) >> 10;
			tx_pretap_2[tx_phy][tx]					= (rd_channel_ftile (tx_phy, tx, offset[tx_phy], 0x47830) & 0x00070000) >> 16;		
			tx_pretap_1[tx_phy][tx]					= (rd_channel_ftile (tx_phy, tx, offset[tx_phy], 0x47830) & 0x000003E0) >> 5;			
			tx_posttap_1[tx_phy][tx]				= (rd_channel_ftile (tx_phy, tx, offset[tx_phy], 0x47830) & 0x0000003F);		
					
		 
				
			 
			if (WAIT_AFTER_CHANGING_TX_PMA_SETTING)
				printf("\nWait time after setting TX PMA setting : %d seconds",WAIT_TIME_AFTER_CHANGING_TX_PMA_SETTING/1000);
			
			printf("\nWait time after Rx reset               : %d seconds\n", PMA_SWEEP_TIME_MS/1000);

			  TimeInterval = PMA_SWEEP_TIME_MS;
			  
			i = -1;	
			// Sweep range
			j = sweep_low;
			do
			{

				
				i=i+1;
				
				if ((i >= 0) && (i < MAX_SWEEP_RANGE))
				{
				
										
				switch (pma_setting)
				{
				case 0 : // Sweep VOD 
						if (CHANGE_TX_PMA_SETTINGS_ALL_LANES)
						{
							for (tx = 0; tx < number_of_lanes[tx_phy]; tx++)
							{
								rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x0000FC00 , j << 10	);  //set vod 
							}
						}
						else
							rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x0000FC00 , j << 10	);  //set vod 
						if (WAIT_AFTER_CHANGING_TX_PMA_SETTING) 
							usleep(WAIT_TIME_AFTER_CHANGING_TX_PMA_SETTING*1000); //Wait WAIT_TIME_AFTER_CHANGING_TX_PMA_SETTING seconds to let the new setting ripple through
						else
							usleep(100);
						
						reset_rx_channel (rx_phy,rx);
						usleep(PMA_SWEEP_WAIT_TIME_AFTER_RX_RESET);
						break;

				case 1 :  //Sweep Pre-tap2
						if (CHANGE_TX_PMA_SETTINGS_ALL_LANES)
						{
							for (tx = 0; tx < number_of_lanes[tx_phy]; tx++)
							{			
								rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x00070000 , j << 16	);  //set pre-tap2
							}
						}
						else
								rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x00070000 , j << 16	);  //set pre-tap2
							
						if (WAIT_AFTER_CHANGING_TX_PMA_SETTING) 
							usleep(WAIT_TIME_AFTER_CHANGING_TX_PMA_SETTING*1000); //Wait WAIT_TIME_AFTER_CHANGING_TX_PMA_SETTING seconds to let the new setting ripple through
						else
							usleep(100);
						reset_rx_channel (rx_phy,rx);
						usleep(PMA_SWEEP_WAIT_TIME_AFTER_RX_RESET);		
						break;	
				case 2 :  //Set Pre-tap1
						if (CHANGE_TX_PMA_SETTINGS_ALL_LANES)
						{
							for (tx = 0; tx < number_of_lanes[tx_phy]; tx++)
							{			
								rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x000003E0 , j << 5	);  //set pre-tap1
							}
						}
						else
							rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x000003E0 , j << 5	);  //set pre-tap1
						
						if (WAIT_AFTER_CHANGING_TX_PMA_SETTING) 
							usleep(WAIT_TIME_AFTER_CHANGING_TX_PMA_SETTING*1000); //Wait WAIT_TIME_AFTER_CHANGING_TX_PMA_SETTING seconds to let the new setting ripple through
						else
							usleep(100);
						reset_rx_channel (rx_phy,rx);
						usleep(PMA_SWEEP_WAIT_TIME_AFTER_RX_RESET);		
						break;						
				case 3 : //Sweep Post-tap1
						if (CHANGE_TX_PMA_SETTINGS_ALL_LANES)
						{
							for (tx = 0; tx < number_of_lanes[tx_phy]; tx++)
							{
								rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x0000001F , j	);  //set post-tap1 
							}
						}
						else
							rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x0000001F , j	);  //set post-tap1 	
						
						if (WAIT_AFTER_CHANGING_TX_PMA_SETTING) 
							usleep(WAIT_TIME_AFTER_CHANGING_TX_PMA_SETTING*1000); //Wait WAIT_TIME_AFTER_CHANGING_TX_PMA_SETTING seconds to let the new setting ripple through
						else
							usleep(100);
						reset_rx_channel (rx_phy,rx);
						usleep(PMA_SWEEP_WAIT_TIME_AFTER_RX_RESET);			
						break;	
				

				
				default : break;
				}
				
					

		if (DO_BER_MEASUREMENT == 1)
		  {
			  
			  
	 
			  // Reset ErrorCount on Selected Channel

				if (SUPERLITE_USED == 0)
					Control_Reg[rx_phy] = Control_Reg[rx_phy] | (0x2000);
				else
					Control_Reg[rx_phy] = Control_Reg[rx_phy] | (0x2200); //reset LockAlarm (Control_Reg(9))
				
			  write_control_reg(rx_phy, Control_Reg[rx_phy]);

			  
			  usleep(10);
				if (SUPERLITE_USED == 0)        
					Control_Reg[rx_phy] = Control_Reg[rx_phy] & (0xDFFF);
				else
					Control_Reg[rx_phy] = Control_Reg[rx_phy] & (0xDDFF);	
				
			  write_control_reg(rx_phy, Control_Reg[rx_phy]);
		  

				// Reset PrbsLockAlarm
			
			
				Control2_Reg[rx_phy] = Control2_Reg[rx_phy] | (0x8000);
				write_control2_reg(rx_phy,Control2_Reg[rx_phy]);

				usleep(10);
					
				Control2_Reg[rx_phy] = Control2_Reg[rx_phy] & (0x7FFF);
				write_control2_reg(rx_phy,Control2_Reg[rx_phy]);			  
			  
		

					

			  
			  usleep(TimeInterval*1000);
			  
			Channel_Reg[rx_phy][rx]      =  Read_Channel_Reg(rx_phy,rx);
			Locked[rx_phy][rx]  = 0x0001 & (Channel_Reg[rx_phy][rx] >> 15); 
			PrbsLockAlarm[rx_phy][rx]   = 0x0001 & (Channel_Reg[rx_phy][rx] >> 0); 	 
			rx_ready[rx_phy][rx]  			= 0x0001 & (Channel_Reg[rx_phy][rx] >> 13);
			
			  
			 //printf("\nLocked : %1d",Locked[rx]);
			  
		  
		  
		  
					//Read ErrorCount registers
		
					ErrorCount_Reg_L[rx_phy][rx] =  Read_ErrorCount_L_Reg(rx_phy,rx);
					ErrorCount_Reg_H[rx_phy][rx] =  Read_ErrorCount_H_Reg(rx_phy,rx);
	//				printf("\nErrorcount_reg_L : %d",ErrorCount_Reg_L[rx]);
	//				printf("\nErrorcount_reg_H : %d",ErrorCount_Reg_H[rx]);				
					ErrorCount[rx_phy][rx] =  ((double)(ErrorCount_Reg_H[rx_phy][rx]) *  MULTIPLIER * MULTIPLIER) + (double) (ErrorCount_Reg_L[rx_phy][rx]);

		  
					Fom[rx_phy][rx]  		= twos_complement(get_cpidata(rx_phy,rx,offset[rx_phy],(3<<13),0x94));	//ConvData
					
					eyeheight				= Fom[rx_phy][rx];	         
					eyeheight_PMA[i]     = eyeheight;
		  
			 Counter_1ms_Reg[rx_phy] = read_counter_1ms_reg(rx_phy); // NUMBER_OF_MS_PER_SECOND;


			 Totalbits[rx_phy] = (double) (Counter_1ms_Reg[rx_phy]) * (double) (Bitrate[rx_phy]*1000);        
					
				  if ((Locked[rx_phy][rx] == 1) && (PrbsLockAlarm[rx_phy][rx] == 0))
				  {
						 if (ErrorCount[rx_phy][rx] > 0)
							BER_PMA[i] = ((ErrorCount[rx_phy][rx])) / Totalbits[rx_phy]; // create array of measured BER's to later find the optimum
						 else
							BER_PMA[i] = 0;  
					 }
				else BER_PMA[i] = 1;
			}    					
					

				 if ((Locked[rx_phy][rx] == 1) && (PrbsLockAlarm[rx_phy][rx] == 0))
				{
					//if (ErrorCount[channel] > 0)		
					//{
						if (CHANGE_TX_PMA_SETTINGS_ALL_LANES)
						{
						switch (pma_setting)
							{
							case 0 : printf("\nsetting %3d Tx_phy %1d Rx_phy %1d Ch %d : VOD : %2d , BER : %e, ErrorCount : %e",i,tx_phy,rx_phy,rx,j, BER_PMA[i], ErrorCount[rx_phy][rx]);break;		
							case 1 : printf("\nsetting %3d Tx_phy %1d Rx_phy %1d Ch %d : Pre Tap 2 : %2d, BER : %e, ErrorCount : %e",i,tx_phy,rx_phy,rx,j, BER_PMA[i], ErrorCount[rx_phy][rx]);break;
							case 2 : printf("\nsetting %3d Tx_phy %1d Rx_phy %1d Ch %d : Pre Tap 1 : %2d, BER : %e, ErrorCount : %e",i,tx_phy,rx_phy,rx,j, BER_PMA[i], ErrorCount[rx_phy][rx]);break;	
							case 3 : printf("\nsetting %3d Tx_phy %1d Rx_phy %1d Ch %d : Post Tap 1 : %2d, BER : %e, ErrorCount : %e",i,tx_phy,rx_phy,rx,j, BER_PMA[i], ErrorCount[rx_phy][rx]);break;					

							default : break;
							}	
						if (SHOW_ADVANCED_EQUALIZATION_PARAMETERS)
							printf(" Vertical Eye : %d",eyeheight);						
						}
						else
						{
						switch (pma_setting)
							{
							case 0 : printf("\nsetting %3d Tx_phy %1d Ch %d Rx_phy %1d Ch %d : VOD : %2d , BER : %e, ErrorCount : %e",i,tx_phy,tx,rx_phy,rx,j, BER_PMA[i], ErrorCount[rx_phy][rx]);break;		
							case 1 : printf("\nsetting %3d Tx_phy %1d Ch %d Rx_phy %1d Ch %d : Pre Tap 2 : %2d, BER : %e, ErrorCount : %e",i,tx_phy,tx,rx_phy,rx,j, BER_PMA[i], ErrorCount[rx_phy][rx]);break;
							case 2 : printf("\nsetting %3d Tx_phy %1d Ch %d Rx_phy %1d Ch %d : Pre Tap 1 : %2d, BER : %e, ErrorCount : %e",i,tx_phy,tx,rx_phy,rx,j, BER_PMA[i], ErrorCount[rx_phy][rx]);break;	
							case 3 : printf("\nsetting %3d Tx_phy %1d Ch %d Rx_phy %1d Ch %d : Post Tap 1 : %2d, BER : %e, ErrorCount : %e",i,tx_phy,tx,rx_phy,rx,j, BER_PMA[i], ErrorCount[rx_phy][rx]);break;					

							default : break;
							}	
						if (SHOW_ADVANCED_EQUALIZATION_PARAMETERS)
							printf(" Vertical Eye : %d",eyeheight);								
						}					
					//}
					//else
					//{
	//					switch (pma_setting)
	//						{
	//						case 0 : printf("\nphy %1d Ch %2d : VOD : %2d , BER : 0, ErrorCount : 0",phy,channel,j);break;		
	//						case 1 : printf("\nphy %1d Ch %2d : Pre Tap 2 : %2d, BER : 0, ErrorCount : 0",phy,channel,j);break;	
	//						case 2 : printf("\nphy %1d Ch %2d : Pre Tap 1 : %2d, BER : 0, ErrorCount : 0",phy,channel,j);break;	
	//						case 3 : printf("\nphy %1d Ch %2d : Post Tap 1 : %2d, BER : 0, ErrorCount : 0",phy,channel,j);break;
	//						case 4 : printf("\nphy %1d Ch %2d : Post Tap 2 : %2d, BER : 0, ErrorCount : 0",phy,channel,j);break;	
	//						case 5 : printf("\nphy %1d Ch %2d : DC gain : %2d, BER : 0, ErrorCount : 0",phy,channel,j);break;	
	//						case 6 : printf("\nphy %1d Ch %2d : AC gain : %2d, BER :0, ErrorCount : 0",phy,channel,j);break;					
	//						case 7 : printf("\nphy %1d Ch %2d : VGA gain : %2d, BER :0, ErrorCount :0",phy,channel,j);break;
	//						default : break;
	//						}	
					//}
				} // if locked	
				else // no lock
				{
						if (CHANGE_TX_PMA_SETTINGS_ALL_LANES)
						{
						switch (pma_setting)
							{
							case 0 : printf("\nsetting %3d Tx_phy %1d Rx_phy %1d Ch %d : VOD : %2d , rx_ready : %d, no_lock",i,tx_phy,rx_phy,rx,j,rx_ready[rx_phy][rx]);break;		
							case 1 : printf("\nsetting %3d Tx_phy %1d Rx_phy %1d Ch %d : Pre Tap 2 : %2d, rx_ready : %d, no_lock",i,tx_phy,rx_phy,rx,j,rx_ready[rx_phy][rx]);break;
							case 2 : printf("\nsetting %3d Tx_phy %1d Rx_phy %1d Ch %d : Pre Tap 1 : %2d, rx_ready : %d, no_lock",i,tx_phy,rx_phy,rx,j,rx_ready[rx_phy][rx]);break;	
							case 3 : printf("\nsetting %3d Tx_phy %1d Rx_phy %1d Ch %d : Post Tap 1 : %2d, rx_ready : %d, no_lock",i,tx_phy,rx_phy,rx,j,rx_ready[rx_phy][rx]);break;												
							default : break;
							}	
						if (SHOW_ADVANCED_EQUALIZATION_PARAMETERS)
							printf(", Vertical Eye : %d",eyeheight);								
						}
						else
						{
						switch (pma_setting)
							{
							case 0 : printf("\nsetting %3d Tx_phy %1d Ch %d Rx_phy %1d Ch %d : VOD : %2d , rx_ready : %d, no_lock",i,tx_phy,tx,rx_phy,rx,j,rx_ready[rx_phy][rx]);break;		
							case 1 : printf("\nsetting %3d Tx_phy %1d Ch %d Rx_phy %1d Ch %d : Pre Tap 2 : %2d, rx_ready : %d, no_lock",i,tx_phy,tx,rx_phy,rx,j,rx_ready[rx_phy][rx]);break;
							case 2 : printf("\nsetting %3d Tx_phy %1d Ch %d Rx_phy %1d Ch %d : Pre Tap 1 : %2d, rx_ready : %d, no_lock",i,tx_phy,tx,rx_phy,rx,j,rx_ready[rx_phy][rx]);break;	
							case 3 : printf("\nsetting %3d Tx_phy %1d Ch %d Rx_phy %1d Ch %d : Post Tap 1 : %2d, rx_ready : %d, no_lock",i,tx_phy,tx,rx_phy,rx,j,rx_ready[rx_phy][rx]);break;												
							default : break;
							}
						if (SHOW_ADVANCED_EQUALIZATION_PARAMETERS)
							printf(", Vertical Eye : %d",eyeheight);													
						}						
					
					}
				
		
					
					j = j + step_size;
				} //i
					
				} 
				while (j <= sweep_high);
				
				
		best_setting_BER = find_best_setting(FOM_BER,step_size);
		best_setting_EYE = find_best_setting(FOM_EYE,step_size);

		timestamp = clock() - timestamp;	
				
		if (best_setting_BER == 1000)  // no good setting found do not update
			{
			good_setting_found = 0;
			printf("\n\nNo setting found keeping original PMA setting");
			}
		else
			{
			good_setting_found = 1;		
			switch (pma_setting)
				{
				case 0 : printf("\n\nOriginal Vod setting Tx_phy %1d Ch %d Rx_phy %1d Ch %d : %2d",tx_phy,tx,rx_phy,rx,tx_vodctrl[tx_phy][tx]);break;		
				case 1 : printf("\n\nOriginal PreTap2 setting Tx_phy %1d Ch %d Rx_phy %1d Ch %d :  %2d",tx_phy,tx,rx_phy,rx,tx_pretap_2[tx_phy][tx]);break;
				case 2 : printf("\n\nOriginal PreTap1 setting Tx_phy %1d Ch %d Rx_phy %1d Ch %d  : %2d",tx_phy,tx,rx_phy,rx,tx_pretap_1[tx_phy][tx]);break;
				case 3 : printf("\n\nOriginal PostTap1 setting Tx_phy %1d Ch %d Rx_phy %1d Ch %d  : %2d",tx_phy,tx,rx_phy,rx,tx_posttap_1[tx_phy][tx]);break;									
				default : break;
				}				
										
				printf("\nBest SETTING found based on BER measurement (middle of window with 0 BER) : %d",best_setting_BER);
				if (SHOW_ADVANCED_EQUALIZATION_PARAMETERS)
					printf("\nBest SETTING found based on Vertical Eye : %d",best_setting_EYE);			

				
				printf("\n\nWhich SETTING do you want to use (please enter best SETTING, note you can enter your own SETTING as well) enter '99' for keeping original setting : ");
				
				best_setting = input_double();
				
				if (best_setting == 99)
					{
					good_setting_found = 0;
					printf("\nKeeping original setting");
					}
				else
				{
				switch (pma_setting)
					{	
					case 0 : printf("\n\nTx_phy %1d Ch %d Rx_phy %1d Ch %d : Best VOD : %2d  ",tx_phy,tx,rx_phy,rx,best_setting + sweep_low); break;
					case 1 : printf("\n\nTx_phy %1d Ch %d Rx_phy %1d Ch %d : Best Pre Tap 2 : %2d  ",tx_phy,tx,rx_phy,rx,best_setting + sweep_low); break;
					case 2 : printf("\n\nTx_phy %1d Ch %d Rx_phy %1d Ch %d : Best Pre Tap 1 : %2d  ",tx_phy,tx,rx_phy,rx,best_setting*step_size + sweep_low); break;
					case 3 : printf("\n\nTx_phy %1d Ch %d Rx_phy %1d Ch %d : Best Post Tap 1 : %2d  ",tx_phy,tx,rx_phy,rx,best_setting*step_size + sweep_low); break;				
					default : break;
					}	
				}
					
				printf("\n\n");
			}		
			
		

				time_taken[0] = ((double)timestamp)/CLOCKS_PER_SEC; // in seconds
	 
				printf("\nSweep time took %f seconds to execute \n", time_taken[0]);
			  
				
			 
			 printf("\n\n Press a key and enter to continue ...  \n");
			 rx_char   = input_char();		 
						
		
		  
				
				
				if ((UPDATE == 1) && (good_setting_found == 1))
					{
					printf("\nUpdating PMA settings");
					switch (pma_setting)
						{
						case 0 : if (CHANGE_TX_PMA_SETTINGS_ALL_LANES)
									{
										for (tx = 0; tx < number_of_lanes[tx_phy]; tx++)
										{	
											tx_vodctrl[tx_phy][tx] = best_setting + sweep_low;								
											rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x0000FC00 , tx_vodctrl[tx_phy][tx] << 10	);	
										}
									}
									else
									{
										tx_vodctrl[tx_phy][tx] = best_setting + sweep_low;
										rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x0000FC00 , tx_vodctrl[tx_phy][tx] << 10	);	
									}
									break;
						
						case 1 : 
									if (CHANGE_TX_PMA_SETTINGS_ALL_LANES)
									{
										for (tx = 0; tx < number_of_lanes[tx_phy]; tx++)
										{
										tx_pretap_2[tx_phy][tx] = best_setting + sweep_low;
										rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x00070000 , tx_pretap_2[tx_phy][tx] << 16	); 
										}
									}
									else
									{
										tx_pretap_2[tx_phy][tx] = best_setting + sweep_low;
										rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x00070000 , tx_pretap_2[tx_phy][tx] << 16	); 
									}
									break;
						
						case 2 : 
									if (CHANGE_TX_PMA_SETTINGS_ALL_LANES)
									{
										for (tx = 0; tx < number_of_lanes[tx_phy]; tx++)
										{	
											tx_pretap_1[tx_phy][tx] = best_setting*step_size + sweep_low;								
											rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x000003E0 , tx_pretap_1[tx_phy][tx] << 5	); 		
										}
									}
									else 
									{
										tx_pretap_1[tx_phy][tx] = best_setting*step_size + sweep_low;											
										rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x000003E0 , tx_pretap_1[tx_phy][tx] << 5	); 		
									}
									break;

						case 3 : 
									if (CHANGE_TX_PMA_SETTINGS_ALL_LANES)
									{
										for (tx = 0; tx < number_of_lanes[tx_phy]; tx++)
										{	
											tx_posttap_1[tx_phy][tx] = best_setting*step_size + sweep_low;								
											rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x0000003F , tx_posttap_1[tx_phy][tx]	); 
										}
									}
									else
									{
										tx_posttap_1[tx_phy][tx] = best_setting*step_size + sweep_low;											
										rmw_channel_ftile (tx_phy, tx, offset[tx_phy],0x47830, 0x000003E0 , tx_pretap_1[tx_phy][tx] << 5	); 											
									}
									break;
						default : break;
						}
						
					} //UPDATE == 1
					else // no update or no good setting
					{

						// Reprogram original PMA settings
						printf("\nDo not update, program original PMA settings");				

						if (CHANGE_TX_PMA_SETTINGS_ALL_LANES)
						{
							for (tx = 0; tx < number_of_lanes[tx_phy]; tx++)
							{					
							 //Set Maintap	 
							rmw_channel_ftile (tx_phy, tx, offset[tx],0x47830, 0x0000FC00 , tx_vodctrl[tx_phy][tx] << 10	);			
							  
										  
							 //Set Pre-tap2 
							rmw_channel_ftile (tx_phy, tx, offset[tx],0x47830, 0x00070000 , tx_pretap_2[tx_phy][tx] << 16	); 
							 
							 //Set Pre-tap1
							rmw_channel_ftile (tx_phy, tx, offset[tx],0x47830, 0x000003E0 , tx_pretap_1[tx_phy][tx] << 5	); 
							
							 //Set Post-tap1
							rmw_channel_ftile (tx_phy, tx, offset[tx],0x47830, 0x0000001F , tx_posttap_1[tx_phy][tx]	); 	
							}
						}
						else
						{
							rmw_channel_ftile (tx_phy, tx, offset[tx],0x47830, 0x0000FC00 , tx_vodctrl[tx_phy][tx] << 10	);			
							  
										  
							 //Set Pre-tap2 
							rmw_channel_ftile (tx_phy, tx, offset[tx],0x47830, 0x00070000 , tx_pretap_2[tx_phy][tx] << 16	); 
							 
							 //Set Pre-tap1
							rmw_channel_ftile (tx_phy, tx, offset[tx],0x47830, 0x000003E0 , tx_pretap_1[tx_phy][tx] << 5	); 
							
							 //Set Post-tap1
							rmw_channel_ftile (tx_phy, tx, offset[tx],0x47830, 0x0000001F , tx_posttap_1[tx_phy][tx]	); 					
						}
					
						 
					}
		 
			usleep(100); // Let PMA setting take effect.		
					
								
								
			
	usleep(1000);		
		 
	}
}

///////////////////////////////////////////////////////////////////////				
// Find Optimum PMA setting
///////////////////////////////////////////////////////////////////////				
int find_best_setting(int method, int step_size)
{

	int end_value_found;
	int range_best_setting;
	
	range_best_setting = (sweep_high-sweep_low)/step_size;
	
	if (method == FOM_BER) // Use BER as figure of merit
	{

		optimum_range = 0;
		BER_Minimum = 1.0f;
		BER_Minimum_setting = 0;
		
		BER_PMA[((range_best_setting)+1)] = 1; // set as end point
		
        for (i = 0; i <= ((range_best_setting)+0) ;i++)
        {
//			if (BER_PMA[i] == 0)
//				optimum_range = optimum_range + 1;
         if (BER_PMA[i] < BER_Minimum )
				{
				BER_Minimum = BER_PMA[i];
				BER_Minimum_setting = i;
				}
        }
		  
        start_value = 0;
		  start_value_found = 0;
        end_value = 0;
		  end_value_found = 0;
        

		  if (BER_PMA[0] == 0)
			 {
				start_value_found = 1;
			   start_value = 0;
			 }

        for (i = 1; i <= ((range_best_setting)+1) ;i++)
        {
          if (BER_PMA[i] != BER_PMA[i-1]) 	 
          {
               if ((BER_PMA[i] == 0) && (start_value_found == 0))
						{
						start_value = i;
						start_value_found = 1; // This is to avoid a glitch generating a new wrong startvalue.
						}
				
               else if ((BER_PMA[i-1] == 0) && (BER_PMA[i-2] == 0) && (BER_PMA[i-3] == 0) && (BER_PMA[i-4] == 0) && (BER_PMA[i-5] == 0) && (BER_PMA[i-6] == 0) && (end_value_found == 0) )// This is to avoid a glitch generating a new wrong startvalue and make sure the window is big enough
					{
                     end_value = i-1;
						   end_value_found = 1;
							//printf("\nend value %d", end_value);
					}
           }
        }

		optimum_range = end_value - start_value;


		if (optimum_range <= 0) // if negative it means no valid setting has been found
			best_setting = BER_Minimum_setting;
		else	
			best_setting	= (start_value + (optimum_range+1)/2);
		
	  if (1)
	  {
		  printf("\nRange               : %3d",((sweep_high-sweep_low)/step_size));
		  printf("\nOptimum range       : %3d",optimum_range+1);
		  printf("\nBer_Minimum         : %e",BER_Minimum);
        printf("\nStart_value         : %3d",start_value);
        printf("\nEnd_value           : %3d",end_value);
        printf("\nsweep_low           : %3d",sweep_low);		  
        printf("\nbest_setting BER    : %3d",best_setting);		  
	  }
	  
	} // BER sweep
	else if (method == FOM_EYE) // use area info // using ODI
		{

		eyeheight_Maximum = 0;	
	   eyeheight_Maximum_setting = 1000;	
			
        for (i = 0; i <= ((range_best_setting)+0) ;i++)
        {
			  
         if (eyeheight_PMA[i] > eyeheight_Maximum )
				{
				eyeheight_Maximum = eyeheight_PMA[i];
				eyeheight_Maximum_setting = i;			
				}
        }
		  
 


		if (eyeheight_Maximum_setting == 1000)
			best_setting = 1000; // no valid setting found
		else	
			best_setting	= eyeheight_Maximum_setting;			
	}
	else if (method == FOM_EYE_SYMMETRY)
		{

		veye_symmetry_Maximum = 0.0;	
	   veye_symmetry_Maximum_setting = 1000;	
			
        for (i = 0; i <= ((range_best_setting)+0) ;i++)
        {
			  
         if (veye_symmetry_PMA[i] > veye_symmetry_Maximum )
				{
				veye_symmetry_Maximum = veye_symmetry_PMA[i];
				veye_symmetry_Maximum_setting = i;			
				}
        }
		  
 


		if (veye_symmetry_Maximum_setting == 1000)
			best_setting = 1000; // no valid setting found
		else	
			best_setting	= veye_symmetry_Maximum_setting;			
	}		
   else
			best_setting  = 1000; // to cover all cases
		
return (best_setting);
}







float convert_temperature( alt_u32 temperature_raw) // needs to be updated to behind the comman
{
int degrees;
int degrees_decimals;
float degrees_final;

if (temperature_raw == 0x80000000) // invalid location
	degrees_final = 1000.0; //to indicate it is invalid
else 
	{
	if (temperature_raw > 0xF0000)
		degrees = (signed) ((temperature_raw >> 8) + 0xFF000000);
	else	
		degrees = (signed) (temperature_raw >> 8);
	
	degrees_decimals = (temperature_raw  & 0x000000FF);
	
	degrees_final = (float) (degrees) + ((float) (degrees_decimals)/ ((float) 256.0) );
	}
	
return(degrees_final);
}

void capture_temperature(void)
 { 
	 
//OPEN MAILBOX CLIENT IP

 fp = mailbox_client_open("/dev/s10_mailbox_client_0"); //This must match what is defined in system.h

//SDM Temperature read
id = 1;
cmd = 0x19;
arg[0] = 0x00000001;
arg_length = 1;
cmd_length = 1;
resp_buf_len = 1;

ret_code = mailbox_client_send_cmd(fp, id, cmd, arg, arg_length, cmd_length, input_data, resp_buf, resp_buf_len);
if(ret_code == 0)
{
	//printf("\nSDM Temperature is 0x%08lX.", resp_buf[0]);
	//resp_buf[0] = 0xFFFFFE80; (this is to test negative temperatures)
	sdm_temperature = convert_temperature(resp_buf[0]);
	if (DEBUG_TEMPERATURE)
		printf("\nSDM Temperature in Celsius is %3.1fC", sdm_temperature);
}

//Core Temperature[0] read
id = 1;
cmd = 0x19;
arg[0] = 0x00010001;
arg_length = 1;
cmd_length = 1;
resp_buf_len = 1;

ret_code = mailbox_client_send_cmd(fp, id, cmd, arg, arg_length, cmd_length, input_data, resp_buf, resp_buf_len);
if(ret_code == 0)
{
	//printf("\nSDM Temperature is 0x%08lX.", resp_buf[0]);
	//resp_buf[0] = 0xFFFFFE80; (this is to test negative temperatures)
	core_temperature[0] = convert_temperature(resp_buf[0]);
	if (DEBUG_TEMPERATURE)
		printf("\nCore Temperature[0] in Celsius is %3.1fC", core_temperature[0]);
}

//Core Temperature[1] read
id = 1;
cmd = 0x19;
arg[0] = 0x00020001;
arg_length = 1;
cmd_length = 1;
resp_buf_len = 1;

ret_code = mailbox_client_send_cmd(fp, id, cmd, arg, arg_length, cmd_length, input_data, resp_buf, resp_buf_len);
if(ret_code == 0)
{
	//printf("\nSDM Temperature is 0x%08lX.", resp_buf[0]);
	core_temperature[1] = convert_temperature(resp_buf[0]);
	if (DEBUG_TEMPERATURE)
		printf("\nCore Temperature[1] in Celsius is %3.1fC", core_temperature[1]);
}

//Core Temperature[2] read
id = 1;
cmd = 0x19;
arg[0] = 0x00030001;
arg_length = 1;
cmd_length = 1;
resp_buf_len = 1;

ret_code = mailbox_client_send_cmd(fp, id, cmd, arg, arg_length, cmd_length, input_data, resp_buf, resp_buf_len);
if(ret_code == 0)
{
	//printf("\nSDM Temperature is 0x%08lX.", resp_buf[0]);
	core_temperature[2] = convert_temperature(resp_buf[0]);
	if (DEBUG_TEMPERATURE)
		printf("\nCore Temperature[2] in Celsius is %3.1fC", core_temperature[2]);
}

//Core Temperature[3] read
id = 1;
cmd = 0x19;
arg[0] = 0x00040001;
arg_length = 1;
cmd_length = 1;
resp_buf_len = 1;

ret_code = mailbox_client_send_cmd(fp, id, cmd, arg, arg_length, cmd_length, input_data, resp_buf, resp_buf_len);
if(ret_code == 0)
{
	//printf("\nSDM Temperature is 0x%08lX.", resp_buf[0]);
	core_temperature[3] = convert_temperature(resp_buf[0]);
	if (DEBUG_TEMPERATURE)
		printf("\nCore Temperature[3] in Celsius is %3.1fC", core_temperature[3]);
}

//Tile Temperature[0] read
id = 1;
cmd = 0x19;
arg[0] = 0x00050001;
arg_length = 1;
cmd_length = 1;
resp_buf_len = 1;

ret_code = mailbox_client_send_cmd(fp, id, cmd, arg, arg_length, cmd_length, input_data, resp_buf, resp_buf_len);
if(ret_code == 0)
{
	//printf("\nSDM Temperature is 0x%08lX.", resp_buf[0]);
	tile_temperature[0] = convert_temperature(resp_buf[0]);
	if (DEBUG_TEMPERATURE)
		printf("\nTile Temperature[0] in Celsius is %3.1fC", tile_temperature[0]);
}

//Debug command to read temperature
id = 1;
cmd = 0x19;
arg[0] = 0x000500FF;
arg_length = 1;
cmd_length = 1;
resp_buf_len = 8;

ret_code = mailbox_client_send_cmd(fp, id, cmd, arg, arg_length, cmd_length, input_data, resp_buf, resp_buf_len);
if(ret_code == 0)
{
	for (i=0;i < 8; i++)
	{
	//printf("\nSDM Temperature is 0x%08lX.", resp_buf[0]);
	tile_temperature[i] = convert_temperature(resp_buf[i]);
	if (DEBUG_TEMPERATURE)
		printf("\nTile Temperature[%d] in Celsius is %3.1fC", i,tile_temperature[i]);
	}
}

/*
proc read_idcode {} {
	global omp b0 b1 b2 b3 b4 b5 b6 b7 b8
	#writing a command without argument
	#writing the command header to offset 1 of the SDM Mailbox IP (eg Get_IDCODE)
	set command 0x10
	set arg [list]
	exec_command $command $arg
	set response [read_response]
	
	if {[llength $response] != 1} {
		puts "Read IDCODE error"
		return
	}

	set idcode [lindex $response 0]
	puts [format {IDCODE: 0x%08x} $idcode]
}
*/

//Read ID code
id = 1;
cmd = 0x10;
arg[0] = 0x0;
arg_length = 0;
cmd_length = 1;
resp_buf_len = 1;

ret_code = mailbox_client_send_cmd(fp, id, cmd, arg, arg_length, cmd_length, input_data, resp_buf, resp_buf_len);
if(ret_code == 0)
{
	if (DEBUG_TEMPERATURE)	
		printf("\nIDCode is 0x%08lX.", resp_buf[0]);
}
else
{
	if (DEBUG_TEMPERATURE)	
		printf("\nRead IDCODE error");
}



//Tile Temperature[1] read
id = 1;
cmd = 0x19;
arg[0] = 0x00080001;
arg_length = 1;
cmd_length = 1;
resp_buf_len = 1;

ret_code = mailbox_client_send_cmd(fp, id, cmd, arg, arg_length, cmd_length, input_data, resp_buf, resp_buf_len);
if(ret_code == 0)
{
	//printf("\nSDM Temperature is 0x%08lX.", resp_buf[0]);
	tile_temperature[1] = convert_temperature(resp_buf[0]);
	if (DEBUG_TEMPERATURE)
		printf("\nTile Temperature[1] in Celsius is %3.1fC", tile_temperature[1]);
}
	
}
	
void print_bar (int input)
{
	int i;
	
	for (i = 0; i <= input ;i++)
   
	{ 
		if (FANCY_GRAPHICS)
		printf(BLACKBOX); 		
		else
		printf("*");
	}
}


void print_bar_temperature (int input)
{
	int i;
	
	for (i = 0; i <= input ;i++)
   
	{ 
		if (i < 25)
			printf(COLOR_LIGHT_BLUE  BLACKBOX COLOR_RESET); 
		else if ((i>=25) && (i < 40))
			printf(COLOR_LIGHT_CYAN  BLACKBOX COLOR_RESET); 
		else if ((i>=40) && (i < 60))
			printf(COLOR_YELLOW  BLACKBOX COLOR_RESET);
		else
			printf(COLOR_LIGHT_RED  BLACKBOX COLOR_RESET); 		
	}	
	
}

void print_bar_noise (int input)
{
	int i;
	
	for (i = 0; i <= input ;i++)
   
	{ 
		if (i <= 25)
			printf(COLOR_LIGHT_BLUE  BLACKBOX COLOR_RESET); 
		else if ((i>25) && (i <= 50))
			printf(COLOR_LIGHT_CYAN  BLACKBOX COLOR_RESET); 
		else if ((i>50) && (i <= 75))
			printf(COLOR_YELLOW  BLACKBOX COLOR_RESET);
		else
			printf(COLOR_LIGHT_RED  BLACKBOX COLOR_RESET); 		
	}	
	
}

// void print_bar_tree (int input)
// {
	// int i;

	// if (input != 0)
	// {
		// if (input >= 8)
		// {
			// for (i = 0; i < 8 ;i++)
			// { 					
				// printf(COLOR_LIGHT_RED  BLACKBOX COLOR_RESET);				
			// }
			// printf("|");
		// }
		// else
		// {
			// for (i = 0; i <= input ;i++)
			// { 		
			// printf(COLOR_LIGHT_BLUE  BLACKBOX COLOR_RESET); 
			// }
			// printf("|");			
		// }
	// }
// }


void print_bar_tree(int input) // in powers of 2
{
	//int i;
	if (input > 256)
		printf(COLOR_LIGHT_RED  BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX COLOR_RESET   "|");
	else
	{
		if (input == 0)
			printf("        |");
		else if ((input >=1) && (input  <= 2))
			printf(COLOR_LIGHT_BLUE BLACKBOX COLOR_RESET "       |") ;
		else if ((input > 2) && (input  <= 4))
			printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX COLOR_RESET "      |");
		else if ((input > 4) && (input  <= 8))
			printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX BLACKBOX COLOR_RESET "     |");
		else if ((input > 8) && (input  <= 16))
			printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX BLACKBOX BLACKBOX COLOR_RESET  "    |");
		else if ((input > 16) && (input  <= 32))
			printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX COLOR_RESET  "   |");
		else if ((input > 32) && (input  <= 64))		
			printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX COLOR_RESET   "  |");
		else if ((input > 64) && (input  <= 128))	
			printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX COLOR_RESET   " |");
		else if ((input > 128) && (input  <= 256))
			printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX COLOR_RESET   "|");
	}
		// switch (input)
		// {
			// case 1 : printf(COLOR_LIGHT_BLUE BLACKBOX COLOR_RESET "       |") ;	break;
			// case 2 : printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX COLOR_RESET "      |");	break;
			// case 3 : printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX BLACKBOX COLOR_RESET "     |");	break;
			// case 4 : printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX BLACKBOX BLACKBOX COLOR_RESET  "    |");	break;
			// case 5 : printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX COLOR_RESET  "   |");	break;	
			// case 6 : printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX COLOR_RESET   "  |");	break;	
			// case 7 : printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX COLOR_RESET   " |");	break;	
			// case 8 : printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX BLACKBOX COLOR_RESET   "|");	break;				
			// default : printf("        |") ;	break;
		// }	
}



void print_bar_histogram(int input)
{
	//int i;
	
	switch (input)
	{
		case 0 : printf(COLOR_LIGHT_BLUE BLACKBOX COLOR_RESET "       |") ;	break;
		case 1 : printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX COLOR_RESET "      |");	break;
		case 2 : printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX COLOR_LIGHT_CYAN BLACKBOX COLOR_RESET "     |");	break;
		case 3 : printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX COLOR_LIGHT_CYAN BLACKBOX BLACKBOX COLOR_RESET  "    |");	break;
		case 4 : printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX COLOR_LIGHT_CYAN BLACKBOX BLACKBOX COLOR_YELLOW BLACKBOX COLOR_RESET  "   |");	break;	
		case 5 : printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX COLOR_LIGHT_CYAN BLACKBOX BLACKBOX COLOR_YELLOW BLACKBOX BLACKBOX COLOR_RESET   "  |");	break;	
		case 6 : printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX COLOR_LIGHT_CYAN BLACKBOX BLACKBOX COLOR_YELLOW BLACKBOX BLACKBOX COLOR_LIGHT_RED BLACKBOX COLOR_RESET   " |");	break;	
		case 7 : printf(COLOR_LIGHT_BLUE BLACKBOX BLACKBOX COLOR_LIGHT_CYAN BLACKBOX BLACKBOX COLOR_YELLOW BLACKBOX BLACKBOX COLOR_LIGHT_RED BLACKBOX BLACKBOX COLOR_RESET   "|");	break;				
		default : printf("        |") ;	break;
	}	
	
}


void check_module_presence(void)
{

// Below is copied from RTL top level (devkit_demo)
	
//		module_input_reg(0) <= ddq1x2_modprsL1; -- ModPrsL (LVTTL-O signal) is pulled up to Vcc on the host board and grounded in the module. The ModPrsL pin is asserted ?Low? when inserted and de-asserted ?High? when the module is physically absent from the host connector
//		module_input_reg(4) <= ddq1x2_modprsL2; -- ModPrsL (LVTTL-O signal) is pulled up to Vcc on the host board and grounded in the module. The ModPrsL pin is asserted ?Low? when inserted and de-asserted ?High? when the module is physically absent from the host connector
//		module_input_reg(8) <= ddq1x1_modprsL; -- ModPrsL (LVTTL-O signal) is pulled up to Vcc on the host board and grounded in the module. The ModPrsL pin is asserted ?Low? when inserted and de-asserted ?High? when the module is physically absent from the host connector
//		module_input_reg(12) <= ddq2x1_modprsL1; -- ModPrsL (LVTTL-O signal) is pulled up to Vcc on the host board and grounded in the module. The ModPrsL pin is asserted ?Low? when inserted and de-asserted ?High? when the module is physically absent from the host connector
//		module_input_reg(16) <= ddq2x1_modprsL2; -- ModPrsL (LVTTL-O signal) is pulled up to Vcc on the host board and grounded in the module. The ModPrsL pin is asserted ?Low? when inserted and de-asserted ?High? when the module is physically absent from the host connector
//		module_input_reg(20) <= ddq1x1_1_modprsL; -- ModPrsL (LVTTL-O signal) is pulled up to Vcc on the host board and grounded in the module. The ModPrsL pin is asserted ?Low? when inserted and de-asserted ?High? when the module is physically absent from the host connector

//		ddq1x2_modselL1		<= module_output_reg(0); -- The ModSelL (LVTTL-I signal) is an input pin. When held low by the host, the module responds to 2-wire serial communication commands, otherwise it does not. The ModSelL signal has weak pull-up on module connected to Vcc.
//		ddq1x2_resetL1			<= module_output_reg(1);	-- A low level on the ResetL pin for longer than the minimum pulse length (t_Reset_init > 2?s) initiates a complete module reset and returns all user module settings to their default state.
//		ddq1x2_Initmode1		<= module_output_reg(2); -- LPMode (LVTTL-I signal) is an input signal. When LPMode is set ?Low?, the module will boot into its standard default state. When LPMode is set ?High?, the module will boot into ?low power mode? and only the management interface is active (high-speed TX and RX are shut down). The LPMode signal has a weak pull-up on the module connected to Vcc.
//
//		ddq1x2_modselL2		<= module_output_reg(4); -- The ModSelL (LVTTL-I signal) is an input pin. When held low by the host, the module responds to 2-wire serial communication commands, otherwise it does not. The ModSelL signal has weak pull-up on module connected to Vcc.
//		ddq1x2_resetL2			<= module_output_reg(5);	-- A low level on the ResetL pin for longer than the minimum pulse length (t_Reset_init > 2?s) initiates a complete module reset and returns all user module settings to their default state.
//		ddq1x2_Initmode2		<= module_output_reg(6); -- LPMode (LVTTL-I signal) is an input signal. When LPMode is set ?Low?, the module will boot into its standard default state. When LPMode is set ?High?, the module will boot into ?low power mode? and only the management interface is active (high-speed TX and RX are shut down). The LPMode signal has a weak pull-up on the module connected to Vcc.
//
//		ddq1x1_modselL		<= module_output_reg(8); -- The ModSelL (LVTTL-I signal) is an input pin. When held low by the host, the module responds to 2-wire serial communication commands, otherwise it does not. The ModSelL signal has weak pull-up on module connected to Vcc.
//		ddq1x1_resetL		<= module_output_reg(9);	-- A low level on the ResetL pin for longer than the minimum pulse length (t_Reset_init > 2?s) initiates a complete module reset and returns all user module settings to their default state.
//		ddq1x1_Initmode	<= module_output_reg(10); -- LPMode (LVTTL-I signal) is an input signal. When LPMode is set ?Low?, the module will boot into its standard default state. When LPMode is set ?High?, the module will boot into ?low power mode? and only the management interface is active (high-speed TX and RX are shut down). The LPMode signal has a weak pull-up on the module connected to Vcc.
//
//		ddq2x1_modselL1		<= module_output_reg(12); -- The ModSelL (LVTTL-I signal) is an input pin. When held low by the host, the module responds to 2-wire serial communication commands, otherwise it does not. The ModSelL signal has weak pull-up on module connected to Vcc.
//		ddq2x1_resetL1			<= module_output_reg(13);	-- A low level on the ResetL pin for longer than the minimum pulse length (t_Reset_init > 2?s) initiates a complete module reset and returns all user module settings to their default state.
//		ddq2x1_Initmode1		<= module_output_reg(14); -- LPMode (LVTTL-I signal) is an input signal. When LPMode is set ?Low?, the module will boot into its standard default state. When LPMode is set ?High?, the module will boot into ?low power mode? and only the management interface is active (high-speed TX and RX are shut down). The LPMode signal has a weak pull-up on the module connected to Vcc.
//
//
//		ddq2x1_modselL2		<= module_output_reg(16); -- The ModSelL (LVTTL-I signal) is an input pin. When held low by the host, the module responds to 2-wire serial communication commands, otherwise it does not. The ModSelL signal has weak pull-up on module connected to Vcc.
//		ddq2x1_resetL2			<= module_output_reg(17);	-- A low level on the ResetL pin for longer than the minimum pulse length (t_Reset_init > 2?s) initiates a complete module reset and returns all user module settings to their default state.
//		ddq2x1_Initmode2		<= module_output_reg(18); -- LPMode (LVTTL-I signal) is an input signal. When LPMode is set ?Low?, the module will boot into its standard default state. When LPMode is set ?High?, the module will boot into ?low power mode? and only the management interface is active (high-speed TX and RX are shut down). The LPMode signal has a weak pull-up on the module connected to Vcc.
//
//		ddq1x1_1_modselL		<= module_output_reg(20); -- The ModSelL (LVTTL-I signal) is an input pin. When held low by the host, the module responds to 2-wire serial communication commands, otherwise it does not. The ModSelL signal has weak pull-up on module connected to Vcc.
//		ddq1x1_1_resetL		<= module_output_reg(21);	-- A low level on the ResetL pin for longer than the minimum pulse length (t_Reset_init > 2?s) initiates a complete module reset and returns all user module settings to their default state.
//		ddq1x1_1_Initmode		<= module_output_reg(22); -- LPMode (LVTTL-I signal) is an input signal. When LPMode is set ?Low?, the module will boot into its standard default state. When LPMode is set ?High?, the module will boot into ?low power mode? and only the management interface is active (high-speed TX and RX are shut down). The LPMode signal has a weak pull-up on the module connected to Vcc.

	
	temp = IORD_ALTERA_AVALON_PIO_DATA(MODULE_INPUT_REG_BASE);
	

	
	if (ENABLE_I2C_ACCESS_QSFPDD0)
	{
	
	if (((temp & 0x00001000) >> 12)  == 0)
	{

		if (I2C_PRINT_PHY_INFO)
			printf("\nPHY 2 bank 9B DDQ_2x1 L1    plugged in");		
		else		
		printf("\nQSFPDD0 plugged in");		
		qsfpdd0_present = 1;
		if ((qsfpdd0_present == 1) && (ENABLE_I2C_ACCESS_QSFPDD0))
		{
		//Enable I2C access to QSFPDD0 module
		module_output = (module_output & (0xFFFF0FFF)) | (0x2 << 12);
		IOWR_ALTERA_AVALON_PIO_DATA(MODULE_OUTPUT_REG_BASE,module_output);


		i2c_readout(0,0x50);	
		
		//Disable I2C access to QSFPDD0 module
		module_output = (module_output & (0xFFFF0FFF)) | (0x3 << 12);
		IOWR_ALTERA_AVALON_PIO_DATA(MODULE_OUTPUT_REG_BASE,module_output);
			
		}		
	}
	else
	{			
		qsfpdd0_present = 0;	
	}
	}

	
	
	if (ENABLE_I2C_ACCESS_QSFPDD1)
	{

	if (((temp & 0x00010000) >> 16)  == 0)
	{
		if (I2C_PRINT_PHY_INFO)
			printf("\nPHY 2 bank 9B DDQ_2x1 L2    plugged in");		
		else
		printf("\nQSFPDD1 plugged in");	
		qsfpdd1_present = 1;
		if ((qsfpdd1_present == 1) && (ENABLE_I2C_ACCESS_QSFPDD1))
		{
		//Enable I2C access to QSFPDD1 module
		module_output = (module_output & (0xFFF0FFFF)) | (0x2 << 16);
		IOWR_ALTERA_AVALON_PIO_DATA(MODULE_OUTPUT_REG_BASE,module_output);


		i2c_readout(1,0x50);	
		
		//Disable I2C access to QSFPDD1 module
		module_output = (module_output & (0xFFF0FFFF)) | (0x3 << 16);
		IOWR_ALTERA_AVALON_PIO_DATA(MODULE_OUTPUT_REG_BASE,module_output);
			
		}				
	}
	else
	{
		qsfpdd1_present = 0;		
	}
	}

	if (ENABLE_I2C_ACCESS_QSFPDD800)
	{
	
	if (((temp & 0x00001000) >> 12)  == 0)
	{

		if (I2C_PRINT_PHY_INFO)
			printf("\nPHY 2 bank 9B DDQ_2x1 L1    plugged in");		
		else		
		printf("\nQSFPDD800 plugged in");		
		qsfpdd800_present = 1;
		if ((qsfpdd800_present == 1) && (ENABLE_I2C_ACCESS_QSFPDD800))
		{
		//Enable I2C access to QSFPDD800 module
		module_output = (module_output & (0xFFFF0FFF)) | (0x2 << 12);
		IOWR_ALTERA_AVALON_PIO_DATA(MODULE_OUTPUT_REG_BASE,module_output);


		i2c_readout(0,0x50);	
		
		//Disable I2C access to QSFPDD800 module
		module_output = (module_output & (0xFFFF0FFF)) | (0x3 << 12);
		IOWR_ALTERA_AVALON_PIO_DATA(MODULE_OUTPUT_REG_BASE,module_output);
			
		}		
	}
	else
	{			
		qsfpdd800_present = 0;	
	}
	}	

}

void check_module_presence_fpc202(int i2c_interface)
{

int i;
ALT_AVALON_I2C_DEV_t *i2c_dev; //pointer to instance structure
alt_u8 txbuffer[0x200];
alt_u8 rxbuffer[0x200];	
ALT_AVALON_I2C_STATUS_CODE status;
	
	
//storage for the optional provided interrupt handler structure
//IRQ_DATA_t irq_data;
	
int i2c_address;

	//clear rxbuffer
	
			for (i = 0; i < 0x200;i++)
			{	
				rxbuffer[i] = 0;
			}

		if (i2c_interface == 0)
		{
		i2c_dev = alt_avalon_i2c_open("/dev/i2c_0");
		
			if (NULL==i2c_dev)
			{
			printf("Error: Cannot find /dev/i2c_0\n");
			//return 1;
			}

		}
		else
		{
		i2c_dev = alt_avalon_i2c_open("/dev/i2c_1");
		
			if (NULL==i2c_dev)
			{
			printf("Error: Cannot find /dev/i2c_1\n");
			//return 1;
			}

		}
		

			
		alt_avalon_i2c_master_target_set(i2c_dev,0x0F); // 7-bit address of FPC202
		


		
		i2c_address = 0x7; 
		
		// IN_B and IN_C Status Register (offset = 0x07)		
		//Bit 0 : Presence detect QSFPDD0 (0=present)
		//Bit 2 : Presence detect QSFPDD1 (0=present)

		
		txbuffer[0] = i2c_address;
		status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 1, ALT_AVALON_I2C_NO_INTERRUPTS);		
			if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed");
		//printf("\nFPC202 Register 0x7 is 0x%x",rxbuffer[0]);
	

	
	if (ENABLE_I2C_ACCESS_QSFPDD0)
	{
		if (((rxbuffer[0] & 0x00000001) >> 0)  == 0)
		{

			if (I2C_PRINT_PHY_INFO)
				printf("\nPHY 2 bank 9B DDQ_2x1 L1    plugged in");		
			else		
			printf("\nQSFPDD0 plugged in");		
			qsfpdd0_present = 1;
			if ((qsfpdd0_present == 1) && (ENABLE_I2C_ACCESS_QSFPDD0))
			{
				i2c_readout(0,0x78);								
			}				
		}
		else
		{			
			qsfpdd0_present = 0;	
		}
	}
	
	
	if (ENABLE_I2C_ACCESS_QSFPDD1)
	{

		if (((rxbuffer[0] & 0x00000004) >> 2)  == 0)
		{
			if (I2C_PRINT_PHY_INFO)
				printf("\nPHY 2 bank 9B DDQ_2x1 L2    plugged in");		
			else
			printf("\nQSFPDD1 plugged in");	
			qsfpdd1_present = 1;
			if ((qsfpdd1_present == 1) && (ENABLE_I2C_ACCESS_QSFPDD1))
			{
				i2c_readout(0,0x7C);							
			}				
		}
		else
		{
			qsfpdd1_present = 0;		
		}
	}
}


void i2c_readout(int i2c_interface, int slave_address)
{
int i;
ALT_AVALON_I2C_DEV_t *i2c_dev; //pointer to instance structure
alt_u8 txbuffer[0x200];
alt_u8 rxbuffer[0x200];	
ALT_AVALON_I2C_STATUS_CODE status;	

//ALT_AVALON_I2C_MASTER_CONFIG_t i2c_cfg;
//alt_u32 speed_in_hz;
	
int i2c_address;
float cable_length;
int cable_base;
int cable_multiplier;
int module_type;
	

		if (i2c_interface == 0)
		{
		i2c_dev = alt_avalon_i2c_open("/dev/i2c_0");
		
			if (NULL==i2c_dev)
			{
			printf("Error: Cannot find /dev/i2c_0\n");
			//return 1;
			}

		}
		else
		{
		i2c_dev = alt_avalon_i2c_open("/dev/i2c_1");
		
			if (NULL==i2c_dev)
			{
			printf("Error: Cannot find /dev/i2c_1\n");
			//return 1;
			}

		} 

/*
	int i2c_cfg;
	long speed_in_hz;		
		 
		alt_avalon_i2c_master_config_get(i2c_dev,&i2c_cfg);
		
		status = alt_avalon_i2c_master_config_speed_get (i2c_dev, &i2c_cfg, &speed_in_hz);
		if (status!=ALT_AVALON_I2C_SUCCESS) 
			printf("\nI2C get config speed failed \n");
		else
			printf("\nIC2 speed is %ld Hz\n",speed_in_hz);

		
      //alt_avalon_i2c_master_config_speed_set(i2c_dev, i2c_cfg, speed_in_hz);

*/
		
			
		alt_avalon_i2c_master_target_set(i2c_dev,slave_address);
		
		//read type
		
		i2c_address = 85;
		txbuffer[0] = i2c_address;
		
		status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 1, ALT_AVALON_I2C_NO_INTERRUPTS);
		//printf("\nstatus %ld",status);
		if (status!=ALT_AVALON_I2C_SUCCESS) 
		{
			printf("   Stopped accessing I2C device because I2C access failed");
		//printf("\nstatus %ld",status);
		}
		else
		{
		module_type = rxbuffer[0]; // if 0 : undefined (Multilane, SiPh, Amphenol QSFP28 cable), if 3 : passive cable (QSFP-DD)
		
		//printf("\nmodule_type %d",module_type);
		if (module_type == 0) //Tested with Multilane and SiPh (25 Gbps)
		{
			//read vendor name
			vendor = 0;
			i2c_address = 148;
			
			txbuffer[0]=i2c_address;
			status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 16, ALT_AVALON_I2C_NO_INTERRUPTS); 
			//status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 256, ALT_AVALON_I2C_NO_INTERRUPTS); 			
			if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed");
			
			if ((toascii(rxbuffer[0]) == 'M') && (toascii(rxbuffer[1]) == 'U') && (toascii(rxbuffer[2]) == 'L'))
				vendor = MULTILANE;
			else if ((toascii(rxbuffer[0]) == 'M') && (toascii(rxbuffer[1]) == 'L') ) //ML 112Gbps module
				vendor = ML4062;	

				
			printf(" Vendor : ");
			if (vendor == ML4062)
			{
				printf("MULTILANE       ");
				
				printf(" Part  : ");				
				for (i = 0; i < 16;i++)
				//for (i = 0; i < 255;i++)				
				{
					printf("%c", toascii(rxbuffer[i]));
					
					//printf("%d %c\n", i,toascii(rxbuffer[i]));				
				}				
			}
			else
			{
				for (i = 0; i < 16;i++)
				//for (i = 0; i < 255;i++)				
				{
					printf("%c", toascii(rxbuffer[i]));
					//printf("%d %c\n", i,toascii(rxbuffer[i]));				
				}
			}

			
			//read if it is a DAC
			i2c_address = 147;
			txbuffer[0] = i2c_address;
			status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 1, ALT_AVALON_I2C_NO_INTERRUPTS);
			if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed");			
			//printf("\nAddress 147 : 0x%2x",rxbuffer[0]);
			
			if (rxbuffer[0] == 0xa0) // Copper cable unequalized 
			{
				dac = 1;
			}
			else
			{
				dac = 0;
			}
			
			//read vendor partname
			i2c_address = 168;	
			txbuffer[0]=i2c_address;
			status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 16, ALT_AVALON_I2C_NO_INTERRUPTS);
			if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed");
			if (vendor != ML4062)
			{			
				printf(" Part  : ");

					
				for (i = 0; i < 16;i++)
				{
					printf("%c", toascii(rxbuffer[i]));
				}		
			}
			
			
			if (dac == 0)
			{
			
			
	
			//read temperature
			//read data from address 26 and 27 (26 is MSB, 27 is LSB)
			if ((vendor == MULTILANE) || (vendor == ML4062))
				i2c_address = 26; //MULTILANE is not using standard SFF8636 addressing.
			else
				i2c_address = 22;
			
			
			txbuffer[0] = i2c_address;
			status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 2, ALT_AVALON_I2C_NO_INTERRUPTS);
			if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed");
				
	//		printf("\nI2C Address %d: Read value : 0x%x",i2c_address,rxbuffer[0]);
	//		printf("\nI2C Address %d: Read value : 0x%x",i2c_address+1,rxbuffer[1]);
			temperature_module = ((rxbuffer[0] << 8) + (rxbuffer[1]))/256;
			printf(" Measured module temperature is %2d degrees",temperature_module);
			}
			else
			{

			//read length
			i2c_address = 146;
			txbuffer[0] = i2c_address;
			status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 1, ALT_AVALON_I2C_NO_INTERRUPTS);
			if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed");

			printf(" QSFPDD Passive Cable with length %2d m",rxbuffer[0]);				
			}
			
		}
		else if (module_type == 3)  //passive cable
		{
			
			//read vendor name
			i2c_address = 129;
			
			txbuffer[0]=i2c_address;
			status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 16, ALT_AVALON_I2C_NO_INTERRUPTS);
			if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed");
			printf(" Vendor : ");
			for (i = 0; i < 16;i++)
			{
				printf("%c", toascii(rxbuffer[i]));
			}
			//read vendor partname
			i2c_address = 148;	
			txbuffer[0]=i2c_address;
			status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 16, ALT_AVALON_I2C_NO_INTERRUPTS);
			if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed");
			printf(" Part  : ");
			for (i = 0; i < 16;i++)
			{
				printf("%c", toascii(rxbuffer[i]));
			}		
			
			//read length cable
			i2c_address = 202;	
			txbuffer[0]=i2c_address;
			status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 1, ALT_AVALON_I2C_NO_INTERRUPTS);
			if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed");	
				
			cable_base = (0x3F & rxbuffer[0]); //this assumes multiplier is set to 0.1 (bit 7 to 6 set to 0
			cable_multiplier = (rxbuffer[0] >> 6);
			switch (cable_multiplier)
			{
				case 0 : cable_length = ((float) cable_base * 0.1); break;
				case 1 : cable_length = ((float) cable_base * 1); break;
				case 2 : cable_length = ((float) cable_base * 10); break;
				case 3 : cable_length = ((float) cable_base * 100); break;	
			}
			printf(" QSFP-DD Passive Cable with length %1.2f m",cable_length);
		} //module_type ==3
		
		else if ((module_type == 1) || (module_type == 2))  //400G QSFP-DD Optical module according to Common management specification Rev 3.0 (byte 0 should be 0x18 byte 1 should be 0x30)
											// module type 1 (address 85) means Optical Interfaces: MMF (see Table 79)			
		{
			
			//read vendor name
			i2c_address = 129;
			
			txbuffer[0]=i2c_address;
			status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 16, ALT_AVALON_I2C_NO_INTERRUPTS);
			if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed");
			printf(" Vendor : ");
			for (i = 0; i < 16;i++)
			{
				printf("%c", toascii(rxbuffer[i]));
			}
			//read vendor partname
			i2c_address = 148;	
			txbuffer[0]=i2c_address;
			status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 16, ALT_AVALON_I2C_NO_INTERRUPTS);
			if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed");
			printf(" Part  : ");
			for (i = 0; i < 16;i++)
			{
				printf("%c", toascii(rxbuffer[i]));
			}		

			//read temperature
			//read data from address 14 and 15 (14 is MSB, 15 is LSB)
			i2c_address = 14;
			
			
			txbuffer[0] = i2c_address;
			status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 2, ALT_AVALON_I2C_NO_INTERRUPTS);
			if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed");
				
	//		printf("\nI2C Address %d: Read value : 0x%x",i2c_address,rxbuffer[0]);
	//		printf("\nI2C Address %d: Read value : 0x%x",i2c_address+1,rxbuffer[1]);
			temperature_module = ((rxbuffer[0] << 8) + (rxbuffer[1]))/256;
			printf(" Measured module temperature is %2d degrees ",temperature_module);

			//read supported lenght of fiber
			if (module_type == 1)
			{
			i2c_address = 202;	
			txbuffer[0]=i2c_address;
			status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 1, ALT_AVALON_I2C_NO_INTERRUPTS);
			if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed");	
				
			cable_base = (0x3F & rxbuffer[0]); 
			cable_multiplier = (rxbuffer[0] >> 6);
			switch (cable_multiplier)
			{
				case 0 : cable_length = ((float) cable_base * 0.1); break;
				case 1 : cable_length = ((float) cable_base * 1); break;
				case 2 : cable_length = ((float) cable_base * 10); break;
				case 3 : cable_length = ((float) cable_base * 100); break;	
			}
				printf("	Maximum length MMF %2.0f m",cable_length);	
			}
			if (module_type == 2)
			{
				//TBC
			}

		} //module_type ==1 or module_type ==2
		

	} //I2C access ok
		
}


void i2c_dump(int i2c_interface, int slave_address)
{
int i;
ALT_AVALON_I2C_DEV_t *i2c_dev; //pointer to instance structure
alt_u8 txbuffer[0x200];
alt_u8 rxbuffer[0x200];	
ALT_AVALON_I2C_STATUS_CODE status;	
	
//storage for the optional provided interrupt handler structure
//IRQ_DATA_t irq_data;
	
int i2c_address;

	//clear rxbuffer
	
			for (i = 0; i < 0x200;i++)
			{	
				rxbuffer[i] = 0;
			}

		if (i2c_interface == 0)
		{
		i2c_dev = alt_avalon_i2c_open("/dev/i2c_0");
		
			if (NULL==i2c_dev)
			{
			printf("Error: Cannot find /dev/i2c_0\n");
			//return 1;
			}

		}
		else
		{
		i2c_dev = alt_avalon_i2c_open("/dev/i2c_1");
		
			if (NULL==i2c_dev)
			{
			printf("Error: Cannot find /dev/i2c_1\n");
			//return 1;
			}

		}
		
	//register the optional interrupt callback.
	//alt_avalon_i2c_register_optional_irq_handler(i2c_dev,&irq_data);		
			
		alt_avalon_i2c_master_target_set(i2c_dev,slave_address);
		
		//read type
		
		// Select page

		/*
		i2c_address = 127;
		txbuffer[0] = i2c_address;
		txbuffer[1] = 0; //page 0
		//txbuffer[1] = 17; //page 17	
		printf("\nPage number : %d", txbuffer[1]);
		
		status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 2, rxbuffer, 1, ALT_AVALON_I2C_NO_INTERRUPTS);		
		if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed : status %ld",status);
		*/
		
		for (j = 0; j < 64; j++)
		{
		i2c_address = j*4;
		txbuffer[0] = i2c_address;
		status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 4, ALT_AVALON_I2C_NO_INTERRUPTS);		
		if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed : status %ld",status);
		//printf("\nstatus %ld",status);
		
			for (i = 0; i < 4;i++)
			{
				if (rxbuffer[i] != 0)
				{
					if ((rxbuffer[i] >= 0x20) && (rxbuffer[i] <= 0x7E)) // only valid ASCII codes
						printf("\naddress : %3d data hex : 0x%2x  data dec : %3d  ASCII :  %c", i+i2c_address,rxbuffer[i],rxbuffer[i],toascii(rxbuffer[i]));
					else
						printf("\naddress : %3d data hex : 0x%2x  data dec : %3d", i+i2c_address,rxbuffer[i],rxbuffer[i]);
				}
			}	
		
		}
		

//		i2c_address = 0;
//		txbuffer[0] = i2c_address;
//		status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 256, ALT_AVALON_I2C_NO_INTERRUPTS);		
//		if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed");
//		//printf("\nstatus %ld",status);
//		
//			for (i = 0; i < 256;i++)
//			{
//				if (rxbuffer[i] != 0)
//				{
//					if ((rxbuffer[i] >= 0x20) && (rxbuffer[i] <= 0x7E)) // only valid ASCII codes
//						printf("\naddress : %3d data hex : 0x%2x  data dec : %3d  ASCII :  %c", i+i2c_address,rxbuffer[i],rxbuffer[i],toascii(rxbuffer[i]));
//					else
//						printf("\naddress : %3d data hex : 0x%2x  data dec : %3d", i+i2c_address,rxbuffer[i],rxbuffer[i]);
//				}
//			}	
		
		
}

void i2c_setupfpc202(int i2c_interface)
{
int i;
ALT_AVALON_I2C_DEV_t *i2c_dev; //pointer to instance structure
alt_u8 txbuffer[0x200];
alt_u8 rxbuffer[0x200];	
ALT_AVALON_I2C_STATUS_CODE status;	
	
//storage for the optional provided interrupt handler structure
//IRQ_DATA_t irq_data;
	
int i2c_address;

	//clear rxbuffer
	
			for (i = 0; i < 0x200;i++)
			{	
				rxbuffer[i] = 0;
			}

		if (i2c_interface == 0)
		{
		i2c_dev = alt_avalon_i2c_open("/dev/i2c_0");
		
			if (NULL==i2c_dev)
			{
			printf("Error: Cannot find /dev/i2c_0\n");
			//return 1;
			}

		}
		else
		{
		i2c_dev = alt_avalon_i2c_open("/dev/i2c_1");
		
			if (NULL==i2c_dev)
			{
			printf("Error: Cannot find /dev/i2c_1\n");
			//return 1;
			}

		}
		
	//register the optional interrupt callback.
	//alt_avalon_i2c_register_optional_irq_handler(i2c_dev,&irq_data);		
			
		alt_avalon_i2c_master_target_set(i2c_dev,0x0F); // 7-bit address of FPC202
		

		//set register 0x1 to 0x1E
		printf("\nFPC202 : set register 0x1 to 0x1E (8-bit address)/0x0F (7-bit address)"); //which makes it listen to 0x0F (7-bit)
		i2c_address = 1;
		txbuffer[0] = i2c_address;
		txbuffer[1] = 0x1E; 
		
		//write
		status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 2, rxbuffer, 1, ALT_AVALON_I2C_NO_INTERRUPTS);		
		if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed : status %ld",status);
		
		//dump entire register space of fpc202
		printf("\nFPC202 dump");
		printf("\n===========");
		
		for (j = 0; j < 64; j++)
		{
		i2c_address = j*4;
		txbuffer[0] = i2c_address;
		status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 4, ALT_AVALON_I2C_NO_INTERRUPTS);		
		if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed : status %ld",status);
		//printf("\nstatus %ld",status);
		
			for (i = 0; i < 4;i++)
			{
				if (rxbuffer[i] != 0)
				{
					if ((rxbuffer[i] >= 0x20) && (rxbuffer[i] <= 0x7E)) // only valid ASCII codes
						printf("\naddress : %3d data hex : 0x%2x  data dec : %3d  ASCII :  %c", i+i2c_address,rxbuffer[i],rxbuffer[i],toascii(rxbuffer[i]));
					else
						printf("\naddress : %3d data hex : 0x%2x  data dec : %3d", i+i2c_address,rxbuffer[i],rxbuffer[i]);
				}
			}	
		
		}
		

//		i2c_address = 0;
//		txbuffer[0] = i2c_address;
//		status = alt_avalon_i2c_master_tx_rx(i2c_dev, txbuffer, 1, rxbuffer, 256, ALT_AVALON_I2C_NO_INTERRUPTS);		
//		if (status!=ALT_AVALON_I2C_SUCCESS) printf("\nI2C access failed");
//		//printf("\nstatus %ld",status);
//		
//			for (i = 0; i < 256;i++)
//			{
//				if (rxbuffer[i] != 0)
//				{
//					if ((rxbuffer[i] >= 0x20) && (rxbuffer[i] <= 0x7E)) // only valid ASCII codes
//						printf("\naddress : %3d data hex : 0x%2x  data dec : %3d  ASCII :  %c", i+i2c_address,rxbuffer[i],rxbuffer[i],toascii(rxbuffer[i]));
//					else
//						printf("\naddress : %3d data hex : 0x%2x  data dec : %3d", i+i2c_address,rxbuffer[i],rxbuffer[i]);
//				}
//			}	
		
		
}



void print_alarm(int value, int ok_value)
{
		if (value == ok_value)
			printf("%7s" COLOR_OK "%1d" COLOR_RESET "|" ," ",ok_value);
		else
			printf("%7s" COLOR_ALARM "%1d" COLOR_RESET  "|"," ",!(ok_value));	
  
}

void print_alarm_superlite(int value, int ok_value)
{
		if (value == ok_value)
			printf("%8s" COLOR_OK "%1d" COLOR_RESET," ",ok_value);
		else
			printf("%8s" COLOR_ALARM "%1d" COLOR_RESET," ",!(ok_value));	

    printf("\n"); 
  
}

void print_stat_unsigned_correctable(unsigned int value)
{

if (value > 99999999)
	printf(COLOR_CORRECTABLE "%.2e" COLOR_RESET "|" , (float) value);		  
else
	printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" , value);		
}

void print_stat_unsigned_alarm(unsigned int value)
{
if (value > 99999999)
	printf(COLOR_ALARM "%.2e" COLOR_RESET "|" , (float) value);		  
else
	printf(COLOR_ALARM "%8d" COLOR_RESET "|" , value);			
}

 
void loop_reset (int loopcount, int timeout_adaptation, int stresstest)
{
	int stop;
	int loop;
	int min_adapt_time;
	int max_adapt_time;
	
       NOK = 0;
		 stop = 0;
		 min_adapt_time = 20000;
		 max_adapt_time = 0;
		 
		 
       for (loop = 1; loop <= loopcount; loop++)
       {

		  
			 
		  reset_phy(Selectedphy, USE_RESET);	


		  timestamp1 = clock();

		  do
		  {
			  	rx_ready_combined = 1;
				for (i = 0; i < number_of_lanes[Selectedphy] ; i++)
				{   
					Channel_Reg[Selectedphy][i]      =  Read_Channel_Reg(Selectedphy,i);	
					rx_ready[Selectedphy][i]  			= 0x0001 & (Channel_Reg[Selectedphy][i] >> 13);
					if (rx_ready[Selectedphy][i] == 0)
							rx_ready_combined  = 0;						
				}	
				timestamp2 = clock();
				time_taken[loop] = ((double) timestamp2 - (double) timestamp1)/(CLOCKS_PER_SEC/1000); // in milliseconds
				
		  } while ((rx_ready_combined == 0) && (time_taken[loop] < timeout_adaptation)); 
		  
			if (time_taken[loop] < min_adapt_time)
				min_adapt_time = time_taken[loop];
			if (time_taken[loop] > max_adapt_time)
				max_adapt_time = time_taken[loop];
		  
		  usleep(100); //wait for prbslock
		  clear_counters(Selectedphy);
		  usleep(100000); //wait 100ms after clearing counters.


		  ChannelOK[Selectedphy] = 1;
		  if (SHOW_ADAPT_TIME) 
		  {
			  if (time_taken[loop] == timeout_adaptation)
					printf("\nTest:%4d phy:%1d Adaptation Timeout after %d milliseconds", loop,Selectedphy,(int) time_taken[loop]);	
			  else 
				   printf("\nTest:%4d phy:%1d Total Adaptation time :%d milliseconds", loop,Selectedphy,(int) time_taken[loop]);	
		  }

		  
			for (i = 0; i < number_of_lanes[Selectedphy] ; i++)
		  {   
		  Channel_Reg[Selectedphy][i]      =  Read_Channel_Reg(Selectedphy,i);
		  Locked[Selectedphy][i]  				= 0x0001 & (Channel_Reg[Selectedphy][i] >> 15);	
		  //rx_am_lock[Selectedphy][i]        = 0x0001 & (Channel_Reg[Selectedphy][i] >> 3);	  
		  ErrorCount_Reg_L[Selectedphy][i] =  Read_ErrorCount_L_Reg(Selectedphy,i);
		  ErrorCount_Reg_H[Selectedphy][i] =  Read_ErrorCount_H_Reg(Selectedphy,i);
		  ErrorCount[Selectedphy][i] =  ((double)(ErrorCount_Reg_H[Selectedphy][i]) *  MULTIPLIER * MULTIPLIER) + (double) (ErrorCount_Reg_L[Selectedphy][i]);	
		  if (pma_direct_pam4_mode[Selectedphy] == 0)
		  {
		  //if ((Locked[Selectedphy][i] == 0) || (ErrorCount[Selectedphy][i] != 0.0) ||  (rx_am_lock[Selectedphy][i] == 0))
			if ((Locked[Selectedphy][i] == 0) || (ErrorCount[Selectedphy][i] != 0.0))	  
				ChannelOK[Selectedphy] = 0;  
		  }
		  else
		  {
		  //if ((Locked[Selectedphy][i] == 0) || (ErrorCount[Selectedphy][i] != 0.0) ||  (rx_am_lock[Selectedphy][i] == 0))
			if ((Locked[Selectedphy][i] == 0))	  //Biterrors are expected in PAM4 raw PRBS mode
				ChannelOK[Selectedphy] = 0;  
		  }			  
		  //printf("\nTest:%4d phy:%1d rx_am_lock:%1d Channel:%1d Locked:%1d  ErrorCount:%f ChannelOK: %d",j, Selectedphy,rx_am_lock[Selectedphy][i], i, Locked[Selectedphy][i],ErrorCount[Selectedphy][i],ChannelOK); 
		  printf("\nTest:%4d phy:%1d Channel:%1d Locked:%1d  ErrorCount:%f ChannelOK: %d",loop, Selectedphy, i, Locked[Selectedphy][i],ErrorCount[Selectedphy][i],ChannelOK[Selectedphy]);   
		  }
			 
		  
			if (ChannelOK[Selectedphy] == 0) 
				{
				NOK = NOK + 1;
					if (STOP_DURING_LOOPTEST)
					{
					printf("\nLink NOK  press any key to continue, s to stop %d :\n",NOK);
					rx_char = input_char(); 
					//break;
					if (rx_char == 's')
						{
						printf("\nStop selected");
						stop = 1;
						break;
						}
					}
					else
					 printf("\nLink NOK %d", NOK);
				}
		if (stop == 1)
			break;				
				 
		}
  printf("\n\nTotal NOK : %d", NOK);
  printf("\nStress test %d ended",stresstest);
  if (SHOW_ADAPT_TIME)
  {
  printf("\nMinimum adaptation time observed : %d ms",min_adapt_time);
  printf("\nMaximum adaptation time observed : %d ms",max_adapt_time);  
  histogram();
  printf("\n\nPress any key to continue");
  rx_char = input_char();
  }

}

void loop_reset_2 (int loopcount)
{
	int stop;
	int loop;
	int min_adapt_time;
	int max_adapt_time;
	
       NOK = 0;
		 stop = 0;
		 min_adapt_time = 20000;
		 max_adapt_time = 0;

		 
       for (loop = 1; loop <= loopcount; loop++)
       {


			 
		  reset_phy(Selectedphy, USE_RESET);	

		  timestamp1 = clock();

		  do
		  {
			  	rx_ready_combined = 1;
				for (t = 0; t < NUMBER_OF_PHYS; t++)
				{
					for (i = 0; i < number_of_lanes[t] ; i++)
					{   
						Channel_Reg[t][i]      =  Read_Channel_Reg(t,i);	
						rx_ready[t][i]  			= 0x0001 & (Channel_Reg[t][i] >> 13);
						if (rx_ready[t][i] == 0)
								rx_ready_combined  = 0;						
					}	
					timestamp2 = clock();
					time_taken[loop] = ((double) timestamp2 - (double) timestamp1)/(CLOCKS_PER_SEC/1000); // in milliseconds
		
				}
		  } while ((rx_ready_combined == 0) && (time_taken[loop] < TIMEOUT_ADAPTATION_MS)); 
			if (time_taken[loop] < min_adapt_time)
				min_adapt_time = time_taken[loop];
			if (time_taken[loop] > max_adapt_time)
				max_adapt_time = time_taken[loop];
		  
		  usleep(100); //wait for prbslock
		  
			for (t = 0; t < NUMBER_OF_PHYS; t++)
			{		  
			clear_counters(t);
			}
		  usleep(100000); //wait 100ms after clearing counters.
		  

		  if (SHOW_ADAPT_TIME) 
		  {
			  if (time_taken[loop] == TIMEOUT_ADAPTATION_MS)
					printf("\nTest:%4d Adaptation Timeout after %d milliseconds", loop,(int) time_taken[loop]);	
			  else 
				   printf("\nTest:%4d Total Adaptation time all phys :%d milliseconds", loop,(int) time_taken[loop]);	
		  }
		  

		for (t = 0; t < NUMBER_OF_PHYS; t++)
		{
		  ChannelOK[t] = 1;
			for (i = 0; i < number_of_lanes[t] ; i++)
		  {   
		  Channel_Reg[t][i]      =  Read_Channel_Reg(t,i);
		  Locked[t][i]  				= 0x0001 & (Channel_Reg[t][i] >> 15);	
		  //rx_am_lock[Selectedphy][i]        = 0x0001 & (Channel_Reg[Selectedphy][i] >> 3);	  
		  ErrorCount_Reg_L[t][i] =  Read_ErrorCount_L_Reg(t,i);
		  ErrorCount_Reg_H[t][i] =  Read_ErrorCount_H_Reg(t,i);
		  ErrorCount[t][i] =  ((double)(ErrorCount_Reg_H[t][i]) *  MULTIPLIER * MULTIPLIER) + (double) (ErrorCount_Reg_L[t][i]);	  
		  //if ((Locked[Selectedphy][i] == 0) || (ErrorCount[Selectedphy][i] != 0.0) ||  (rx_am_lock[Selectedphy][i] == 0))
		  if (pma_direct_pam4_mode[Selectedphy] == 0)
		  {			  
			if ((Locked[t][i] == 0) || (ErrorCount[t][i] != 0.0))	  
				ChannelOK[t] = 0;  
		  }
		  else //Biterrors are expected in PAM4 raw PRBS mode
		  {			  
			if ((Locked[t][i] == 0) )	  
				ChannelOK[t] = 0;  
		  }			  
		  //printf("\nTest:%4d phy:%1d rx_am_lock:%1d Channel:%1d Locked:%1d  ErrorCount:%f ChannelOK: %d",j, Selectedphy,rx_am_lock[Selectedphy][i], i, Locked[Selectedphy][i],ErrorCount[Selectedphy][i],ChannelOK); 
		  printf("\nTest:%4d phy:%1d Channel:%1d Locked:%1d  ErrorCount:%f ChannelOK: %d",loop, t, i, Locked[t][i],ErrorCount[t][i],ChannelOK[t]);   
		  }
			 
		  
			if (ChannelOK[t] == 0) 
				{
				NOK = NOK + 1;
					if (STOP_DURING_LOOPTEST)
					{
					printf("\nLink NOK  press any key to continue, s to stop %d :\n",NOK);
					rx_char = input_char(); 
					//break;
					if (rx_char == 's')
						{
						printf("\nStop selected");
						stop = 1;
						break;
						}
					}
					else
					 printf("\nLink NOK %d", NOK);
				}
		}
		if (stop == 1)
			break;
				 
	}
  printf("\n\nTotal NOK : %d", NOK);
  printf("\nStress test 2 ended");  
  if (SHOW_ADAPT_TIME)
  {  
  printf("\nMinimum adaptation time observed : %d ms",min_adapt_time);
  printf("\nMaximum adaptation time observed : %d ms",max_adapt_time);  
  histogram();  
  printf("\n\nPress any key to continue");
  rx_char = input_char();  
  }

}

void loop_reset_rx (int loopcount)
{
	int stop;
	int loop;
	int min_adapt_time;
	int max_adapt_time;	
	
       NOK = 0;
		 stop = 0;
		 min_adapt_time = 20000;
		 max_adapt_time = 0;		 
		 
       for (loop = 1; loop <= loopcount; loop++)
       {


				//Assert Rx Reset on all lanes
				Control_Reg[Selectedphy] = Control_Reg[Selectedphy] | (0x00F0);	
				write_control_reg(Selectedphy,Control_Reg[Selectedphy]);	
		
				if (DEBUG_RESET) printf("\nPhy %1d reset_rx asserted on all lanes",Selectedphy);
		
				do 
				{
					rx_reset_ack_combined = 1;
					for (i=0; i < number_of_lanes[Selectedphy]; i++)
					{
						Channel_Reg[Selectedphy][i]      =  Read_Channel_Reg(Selectedphy,i);
						rx_reset_ack[Selectedphy][i] = 0x0001 & (Channel_Reg[Selectedphy][i] >> 2);				
						if (rx_reset_ack[Selectedphy][i] == 0)
							rx_reset_ack_combined  = 0;
					}
				} while ((rx_reset_ack_combined == 0));
				
			   usleep(100);

				//de-assert Reset_Rx
				Control_Reg[Selectedphy] = Control_Reg[Selectedphy] & (0xFF0F);	
				write_control_reg(Selectedphy,Control_Reg[Selectedphy]);		
	
				if (DEBUG_RESET) printf("\nPhy %1d reset_rx de-asserted on all lanes",Selectedphy);	
					
			
		  timestamp1 = clock();
		  
		  do
		  {
			  	rx_ready_combined = 1;
				for (i = 0; i < number_of_lanes[Selectedphy] ; i++)
				{   
					Channel_Reg[Selectedphy][i]      =  Read_Channel_Reg(Selectedphy,i);	
					rx_ready[Selectedphy][i]  			= 0x0001 & (Channel_Reg[Selectedphy][i] >> 13);
					if (rx_ready[Selectedphy][i] == 0)
							rx_ready_combined  = 0;						
				}	
				timestamp2 = clock();
				time_taken[loop] = ((double) timestamp2 - (double) timestamp1)/(CLOCKS_PER_SEC/1000); // in milliseconds		 
		 } while ((rx_ready_combined == 0) && (time_taken[loop] < TIMEOUT_ADAPTATION_MS)); 

			if (time_taken[loop] < min_adapt_time)
				min_adapt_time = time_taken[loop];
			if (time_taken[loop] > max_adapt_time)
				max_adapt_time = time_taken[loop];
			
			// if (rx_ready_combined == 1)
				// printf("\nrx_ready asserted on all lanes");
			

						
		  usleep(100); //wait for prbslock
		  clear_counters(Selectedphy);
		  usleep(100000); //wait 100ms after clearing counters.


		  ChannelOK[Selectedphy] = 1;
		  if (SHOW_ADAPT_TIME) 
		  {
			  if (time_taken[loop] == TIMEOUT_ADAPTATION_MS)
					printf("\nTest:%4d phy:%1d Adaptation Timeout after %d milliseconds", loop,Selectedphy,(int) time_taken[loop]);	
			  else 
				   printf("\nTest:%4d phy:%1d Total Adaptation time :%d milliseconds", loop,Selectedphy,(int) time_taken[loop]);	
		  }		  
			for (i = 0; i < number_of_lanes[Selectedphy] ; i++)
		  {   
		  Channel_Reg[Selectedphy][i]      =  Read_Channel_Reg(Selectedphy,i);
		  Locked[Selectedphy][i]  				= 0x0001 & (Channel_Reg[Selectedphy][i] >> 15);	
		  //rx_am_lock[Selectedphy][i]        = 0x0001 & (Channel_Reg[Selectedphy][i] >> 3);	  
		  ErrorCount_Reg_L[Selectedphy][i] =  Read_ErrorCount_L_Reg(Selectedphy,i);
		  ErrorCount_Reg_H[Selectedphy][i] =  Read_ErrorCount_H_Reg(Selectedphy,i);
		  ErrorCount[Selectedphy][i] =  ((double)(ErrorCount_Reg_H[Selectedphy][i]) *  MULTIPLIER * MULTIPLIER) + (double) (ErrorCount_Reg_L[Selectedphy][i]);	
		  if (pma_direct_pam4_mode[Selectedphy] == 0)
		  {
		  //if ((Locked[Selectedphy][i] == 0) || (ErrorCount[Selectedphy][i] != 0.0) ||  (rx_am_lock[Selectedphy][i] == 0))
			if ((Locked[Selectedphy][i] == 0) || (ErrorCount[Selectedphy][i] != 0.0))	  
				ChannelOK[Selectedphy] = 0;  
		  }
		  else
		  {
		  //if ((Locked[Selectedphy][i] == 0) || (ErrorCount[Selectedphy][i] != 0.0) ||  (rx_am_lock[Selectedphy][i] == 0))
			if ((Locked[Selectedphy][i] == 0))	  //Biterrors are expected in PAM4 raw PRBS mode
				ChannelOK[Selectedphy] = 0;  
		  }			  
		  //printf("\nTest:%4d phy:%1d rx_am_lock:%1d Channel:%1d Locked:%1d  ErrorCount:%f ChannelOK: %d",j, Selectedphy,rx_am_lock[Selectedphy][i], i, Locked[Selectedphy][i],ErrorCount[Selectedphy][i],ChannelOK); 
		  printf("\nTest:%4d phy:%1d Channel:%1d Locked:%1d  ErrorCount:%f ChannelOK: %d",loop, Selectedphy, i, Locked[Selectedphy][i],ErrorCount[Selectedphy][i],ChannelOK[Selectedphy]);   
		  
		  }
			 
		  
			if (ChannelOK[Selectedphy] == 0) 
				{
				NOK = NOK + 1;
					if (STOP_DURING_LOOPTEST)
					{
					printf("\nLink NOK  press any key to continue, s to stop %d :\n",NOK);
					rx_char = input_char(); 
					//break;
					if (rx_char == 's')
						{
						printf("\nStop selected");
						stop = 1;
						break;
						}
					}
					else
					 printf("\nLink NOK %d", NOK);
				}
		if (stop == 1)
			break;				
				 
		}
  printf("\n\nTotal NOK : %d", NOK);
  printf("\nStress test 3 ended");  
  if (SHOW_ADAPT_TIME)
  {  
  printf("\nMinimum adaptation time observed : %d ms",min_adapt_time);
  printf("\nMaximum adaptation time observed : %d ms",max_adapt_time);  
  histogram();  
  printf("\n\nPress any key to continue");
  rx_char = input_char();  
  }  

}

void loop_reset_rx_until_all_rx_good (int loopcount)
{
	//int stop;
	int loop;
		
	
       NOK = 0;
		 //stop = 0;
		 
       for (loop = 1; loop <= loopcount; loop++)
       {


				//Assert Rx Reset on all lanes
				Control_Reg[Selectedphy] = Control_Reg[Selectedphy] | (0x00F0);	
				write_control_reg(Selectedphy,Control_Reg[Selectedphy]);	
		
				if (DEBUG_RESET) printf("\nPhy %1d reset_rx asserted on all lanes",Selectedphy);
		
				do 
				{
					rx_reset_ack_combined = 1;
					for (i=0; i < number_of_lanes[Selectedphy]; i++)
					{
						Channel_Reg[Selectedphy][i]      =  Read_Channel_Reg(Selectedphy,i);
						rx_reset_ack[Selectedphy][i] = 0x0001 & (Channel_Reg[Selectedphy][i] >> 2);				
						if (rx_reset_ack[Selectedphy][i] == 0)
							rx_reset_ack_combined  = 0;
					}
				} while ((rx_reset_ack_combined == 0));
				
			   usleep(100);

				//de-assert Reset_Rx
				Control_Reg[Selectedphy] = Control_Reg[Selectedphy] & (0xFF0F);	
				write_control_reg(Selectedphy,Control_Reg[Selectedphy]);		
	
				if (DEBUG_RESET) printf("\nPhy %1d reset_rx de-asserted on all lanes",Selectedphy);	
					
				
		  timestamp1 = clock();
		  
		  do
		  {
			  	rx_ready_combined = 1;
				for (i = 0; i < number_of_lanes[Selectedphy] ; i++)
				{   
					Channel_Reg[Selectedphy][i]      =  Read_Channel_Reg(Selectedphy,i);	
					rx_ready[Selectedphy][i]  			= 0x0001 & (Channel_Reg[Selectedphy][i] >> 13);
					if (rx_ready[Selectedphy][i] == 0)
							rx_ready_combined  = 0;						
				}	
				timestamp2 = clock();
				time_taken[loop] = ((double) timestamp2 - (double) timestamp1)/(CLOCKS_PER_SEC/1000); // in milliseconds

		  } while ((rx_ready_combined == 0) && (time_taken[loop] < TIMEOUT_ADAPTATION_MS)); 
		  
		  usleep(100); //wait for prbslock		  
		  clear_counters(Selectedphy);
		  usleep(100000); //wait 100ms after clearing counters.


		  ChannelOK[Selectedphy] = 1;
		  if (SHOW_ADAPT_TIME) 
		  {
			  if (time_taken[loop] == TIMEOUT_ADAPTATION_MS)
					printf("\nTest:%4d phy:%1d Adaptation Timeout after %d milliseconds", loop,Selectedphy,(int) time_taken[loop]);	
			  else 
				   printf("\nTest:%4d phy:%1d Total Adaptation time :%d milliseconds", loop,Selectedphy,(int) time_taken[loop]);	
		  }		  
			for (i = 0; i < number_of_lanes[Selectedphy] ; i++)
		  {   
		  Channel_Reg[Selectedphy][i]      =  Read_Channel_Reg(Selectedphy,i);
		  Locked[Selectedphy][i]  				= 0x0001 & (Channel_Reg[Selectedphy][i] >> 15);	
		  //rx_am_lock[Selectedphy][i]        = 0x0001 & (Channel_Reg[Selectedphy][i] >> 3);	  
		  ErrorCount_Reg_L[Selectedphy][i] =  Read_ErrorCount_L_Reg(Selectedphy,i);
		  ErrorCount_Reg_H[Selectedphy][i] =  Read_ErrorCount_H_Reg(Selectedphy,i);
		  ErrorCount[Selectedphy][i] =  ((double)(ErrorCount_Reg_H[Selectedphy][i]) *  MULTIPLIER * MULTIPLIER) + (double) (ErrorCount_Reg_L[Selectedphy][i]);	
		  if (pma_direct_pam4_mode[Selectedphy] == 0)
		  {
		  //if ((Locked[Selectedphy][i] == 0) || (ErrorCount[Selectedphy][i] != 0.0) ||  (rx_am_lock[Selectedphy][i] == 0))
			if ((Locked[Selectedphy][i] == 0) || (ErrorCount[Selectedphy][i] != 0.0))	  
				ChannelOK[Selectedphy] = 0;  
		  }
		  else
		  {
		  //if ((Locked[Selectedphy][i] == 0) || (ErrorCount[Selectedphy][i] != 0.0) ||  (rx_am_lock[Selectedphy][i] == 0))
			if ((Locked[Selectedphy][i] == 0))	  //Biterrors are expected in PAM4 raw PRBS mode
				ChannelOK[Selectedphy] = 0;  
		  }			  
		  //printf("\nTest:%4d phy:%1d rx_am_lock:%1d Channel:%1d Locked:%1d  ErrorCount:%f ChannelOK: %d",j, Selectedphy,rx_am_lock[Selectedphy][i], i, Locked[Selectedphy][i],ErrorCount[Selectedphy][i],ChannelOK); 
		  printf("\nTest:%4d phy:%1d Channel:%1d Locked:%1d  ErrorCount:%f ChannelOK: %d",loop, Selectedphy, i, Locked[Selectedphy][i],ErrorCount[Selectedphy][i],ChannelOK[Selectedphy]);   
		  }
			 
		  
			if (ChannelOK[Selectedphy] == 1) 
			{
				//stop = 1;
				break;
			}				
				 
		}

}


void loop_reset_rx_until_rx_good (int loopcount)
{
	//int stop;
	int loop;
		
	
       NOK = 0;
		 //stop = 0;
		 
      for (loop = 1; loop <= loopcount; loop++)
      {


			reset_rx_channel(Selectedphy,SelectedChannel[Selectedphy]);
		
		  timestamp1 = clock();
		  
			do
			{
 
				Channel_Reg[Selectedphy][SelectedChannel[Selectedphy]]      =  Read_Channel_Reg(Selectedphy,SelectedChannel[Selectedphy]);	
				rx_ready[Selectedphy][SelectedChannel[Selectedphy]]  			= 0x0001 & (Channel_Reg[Selectedphy][SelectedChannel[Selectedphy]]  >> 13);				
				
				timestamp2 = clock();
				time_taken[loop] = ((double) timestamp2 - (double) timestamp1)/(CLOCKS_PER_SEC/1000); // in milliseconds

		  } while ((rx_ready[Selectedphy][SelectedChannel[Selectedphy]]  == 0) && (time_taken[loop] < TIMEOUT_ADAPTATION_MS)); 					
				
		  usleep(100); //wait for prbslock	
		  clear_counters(Selectedphy);
		  usleep(100000); //wait 100ms after clearing counters.


		  ChannelOK[Selectedphy] = 1;  
		  
		  if (SHOW_ADAPT_TIME) 
		  {
			  if (time_taken[loop] == TIMEOUT_ADAPTATION_MS)
					printf("\nTest:%4d phy:%1d Adaptation Timeout after %d milliseconds", loop,Selectedphy,(int) time_taken[loop]);	
			  else 
				   printf("\nTest:%4d phy:%1d Total Adaptation time :%d milliseconds", loop,Selectedphy,(int) time_taken[loop]);	
		  }
		  
		  Channel_Reg[Selectedphy][SelectedChannel[Selectedphy]]      =  Read_Channel_Reg(Selectedphy,SelectedChannel[Selectedphy]);
		  Locked[Selectedphy][SelectedChannel[Selectedphy]]  				= 0x0001 & (Channel_Reg[Selectedphy][SelectedChannel[Selectedphy]] >> 15);	
		  //rx_am_lock[Selectedphy][i]        = 0x0001 & (Channel_Reg[Selectedphy][i] >> 3);	  
		  ErrorCount_Reg_L[Selectedphy][SelectedChannel[Selectedphy]] =  Read_ErrorCount_L_Reg(Selectedphy,SelectedChannel[Selectedphy]);
		  ErrorCount_Reg_H[Selectedphy][SelectedChannel[Selectedphy]] =  Read_ErrorCount_H_Reg(Selectedphy,SelectedChannel[Selectedphy]);
		  ErrorCount[Selectedphy][SelectedChannel[Selectedphy]] =  ((double)(ErrorCount_Reg_H[Selectedphy][SelectedChannel[Selectedphy]]) *  MULTIPLIER * MULTIPLIER) + (double) (ErrorCount_Reg_L[Selectedphy][SelectedChannel[Selectedphy]]);	
		  if (pma_direct_pam4_mode[Selectedphy] == 0)
		  {
		  //if ((Locked[Selectedphy][i] == 0) || (ErrorCount[Selectedphy][i] != 0.0) ||  (rx_am_lock[Selectedphy][i] == 0))
			if ((Locked[Selectedphy][SelectedChannel[Selectedphy]] == 0) || (ErrorCount[Selectedphy][SelectedChannel[Selectedphy]] != 0.0))	  
				ChannelOK[Selectedphy] = 0;  
		  }
		  else
		  {
		  //if ((Locked[Selectedphy][i] == 0) || (ErrorCount[Selectedphy][i] != 0.0) ||  (rx_am_lock[Selectedphy][i] == 0))
			if ((Locked[Selectedphy][SelectedChannel[Selectedphy]] == 0))	  //Biterrors are expected in PAM4 raw PRBS mode
				ChannelOK[Selectedphy] = 0;  
		  }			  
		  //printf("\nTest:%4d phy:%1d rx_am_lock:%1d Channel:%1d Locked:%1d  ErrorCount:%f ChannelOK: %d",j, Selectedphy,rx_am_lock[Selectedphy][i], i, Locked[Selectedphy][i],ErrorCount[Selectedphy][i],ChannelOK); 
		  printf("\nTest:%4d phy:%1d Channel:%1d Locked:%1d  ErrorCount:%f ChannelOK: %d",loop, Selectedphy, SelectedChannel[Selectedphy], Locked[Selectedphy][SelectedChannel[Selectedphy]],ErrorCount[Selectedphy][SelectedChannel[Selectedphy]],ChannelOK[Selectedphy]);   

			 
		  
			if (ChannelOK[Selectedphy] == 1) 
			{
				//stop = 1;
				break;
			}				
				 
		}

}



void loop_mute_tx (int loopcount)
{
	int stop;
	int i;
	int loop;
	int local_phy;
	int remote_phy;
	int min_adapt_time;
	int max_adapt_time;
	
       NOK = 0;
		 stop = 0;
		 min_adapt_time = 20000;
		 max_adapt_time = 0;
		 
		 printf("\nSelect index for local phy (DUT) (0-%1d) : ",NUMBER_OF_PHYS-1);
		 local_phy = input_byte();

		 printf("\nSelect index for remote phy (the one where Tx output will be muted) (0-%1d) : ",NUMBER_OF_PHYS-1);
		 remote_phy = input_byte();
		 
		 
       for (loop = 1; loop <= loopcount; loop++)
       {

		  
		   printf("\nMute transmitters on remote phy %1d",remote_phy);
			
			 
			for (i = 0; i < number_of_lanes[remote_phy] ; i++)
			{ 					
					rmw_channel_ftile(remote_phy,i,offset[remote_phy], 0x41750,0x03000000,0x03000000); //Mute tx driver
			}

			//wait until rx_ready is deasserted on all lanes of the local_phy
			
			timestamp1 = clock();
			
		   do
		   { 
			  	rx_ready_combined = 0;
				for (i = 0; i < number_of_lanes[local_phy] ; i++)
				{   
					Channel_Reg[local_phy][i]      =  Read_Channel_Reg(local_phy,i);	
					rx_ready[local_phy][i]  			= 0x0001 & (Channel_Reg[local_phy][i] >> 13);
					if (rx_ready[local_phy][i] == 1)
							rx_ready_combined  = 1;						
				}	
				timestamp2 = clock();
				time_taken[loop] = ((double) timestamp2 - (double) timestamp1)/(CLOCKS_PER_SEC/1000); // in milliseconds
				
		   } while ((rx_ready_combined == 1) && (time_taken[loop] < TIMEOUT_ADAPTATION_MS)); 
			
			if (time_taken[loop] >= TIMEOUT_ADAPTATION_MS)
			{
				printf("\nTest failed, rx_ready not deasserted, test will stop");
				printf("\nPress any key to continue ");
				rx_char = input_char();
				break;
			}
			else
			{
				printf("\nAll rx_ready de-asserted on local phy %d",local_phy);
			}
		  
		  usleep(500000);
		  

		  random_factor = (double) (rand ())/ (double) (RAND_MAX); // value between 0 and 1.
		  random_number = (int) (random_factor * 200000.0); // value between 0 and 200000
		  //printf("\nrandom_number = %d",random_number);
        usleep(100000+random_number); //use random times of wait (100 + 0-200 ms) before turning on the transmitter again
 
		   //unmute transmitters on remote phy_global
		   printf("\nUnmute transmitters on remote phy %1d",remote_phy);			

			for (i = 0; i < number_of_lanes[remote_phy] ; i++)
			{ 					
					rmw_channel_ftile(remote_phy,i,offset[remote_phy], 0x41750,0x03000000,0x00000000); //Unmute tx driver
			}
			
			//start checking rx_ready on local phy

		  timestamp1 = clock();

		  do
		  {
			  	rx_ready_combined = 1;
				for (i = 0; i < number_of_lanes[local_phy] ; i++)
				{   
					Channel_Reg[local_phy][i]      =  Read_Channel_Reg(local_phy,i);	
					rx_ready[local_phy][i]  			= 0x0001 & (Channel_Reg[local_phy][i] >> 13);
					if (rx_ready[local_phy][i] == 0)
							rx_ready_combined  = 0;						
				}	
				timestamp2 = clock();
				time_taken[loop] = ((double) timestamp2 - (double) timestamp1)/(CLOCKS_PER_SEC/1000); // in milliseconds
				
		  } while ((rx_ready_combined == 0) && (time_taken[loop] < TIMEOUT_ADAPTATION_MS)); 
		  
			if (time_taken[loop] < min_adapt_time)
				min_adapt_time = time_taken[loop];
			if (time_taken[loop] > max_adapt_time)
				max_adapt_time = time_taken[loop];
		  
		  usleep(100); //wait for prbslock
		  clear_counters(local_phy);
		  usleep(100000); //wait 100ms after clearing counters.


		  ChannelOK[local_phy] = 1;
		  if (SHOW_ADAPT_TIME) 
		  {
			  if (time_taken[loop] == TIMEOUT_ADAPTATION_MS)
					printf("\nTest:%4d phy:%1d Adaptation Timeout after %d milliseconds", loop,local_phy,(int) time_taken[loop]);	
			  else 
				   printf("\nTest:%4d phy:%1d Total Adaptation time :%d milliseconds", loop,local_phy,(int) time_taken[loop]);	
		  }

		  
		for (i = 0; i < number_of_lanes[local_phy] ; i++)
		  {   
		  Channel_Reg[local_phy][i]      =  Read_Channel_Reg(local_phy,i);
		  Locked[local_phy][i]  				= 0x0001 & (Channel_Reg[local_phy][i] >> 15);	
		  //rx_am_lock[local_phy][i]        = 0x0001 & (Channel_Reg[local_phy][i] >> 3);	  
		  ErrorCount_Reg_L[local_phy][i] =  Read_ErrorCount_L_Reg(local_phy,i);
		  ErrorCount_Reg_H[local_phy][i] =  Read_ErrorCount_H_Reg(local_phy,i);
		  ErrorCount[local_phy][i] =  ((double)(ErrorCount_Reg_H[local_phy][i]) *  MULTIPLIER * MULTIPLIER) + (double) (ErrorCount_Reg_L[local_phy][i]);	
		  if (pma_direct_pam4_mode[local_phy] == 0)
		  {
		  //if ((Locked[local_phy][i] == 0) || (ErrorCount[local_phy][i] != 0.0) ||  (rx_am_lock[local_phy][i] == 0))
			if ((Locked[local_phy][i] == 0) || (ErrorCount[local_phy][i] != 0.0))	  
				ChannelOK[local_phy] = 0;  
		  }
		  else
		  {
		  //if ((Locked[local_phy][i] == 0) || (ErrorCount[local_phy][i] != 0.0) ||  (rx_am_lock[local_phy][i] == 0))
			if ((Locked[local_phy][i] == 0))	  //Biterrors are expected in PAM4 raw PRBS mode
				ChannelOK[local_phy] = 0;  
		  }			  
		  //printf("\nTest:%4d phy:%1d rx_am_lock:%1d Channel:%1d Locked:%1d  ErrorCount:%f ChannelOK: %d",j, local_phy,rx_am_lock[local_phy][i], i, Locked[local_phy][i],ErrorCount[local_phy][i],ChannelOK); 
		  printf("\nTest:%4d phy:%1d Channel:%1d Locked:%1d  ErrorCount:%f ChannelOK: %d",loop, local_phy, i, Locked[local_phy][i],ErrorCount[local_phy][i],ChannelOK[local_phy]);   
		  }
			 
		  
			if (ChannelOK[local_phy] == 0) 
				{
				NOK = NOK + 1;
					if (STOP_DURING_LOOPTEST)
					{
					printf("\nLink NOK  press any key to continue, s to stop %d :\n",NOK);
					rx_char = input_char(); 
					//break;
					if (rx_char == 's')
						{
						printf("\nStop selected");
						stop = 1;
						break;
						}
					}
					else
					 printf("\nLink NOK %d", NOK);
				}
		if (stop == 1)
			break;				
				 
		}
  printf("\n\nTotal NOK : %d", NOK);
  printf("\nStress test 7 ended");
  if (SHOW_ADAPT_TIME)
  {
  printf("\nMinimum adaptation time observed : %d ms",min_adapt_time);
  printf("\nMaximum adaptation time observed : %d ms",max_adapt_time);  
  histogram();
  printf("\n\nPress any key to continue");
  rx_char = input_char();
  }

}


void loop_avmm(int loopcount)
{
int l;

	for (l = 0; l < loopcount; l++)
	{

	printf("\n====================== TEST %d",l);

	 for (t = 0; t < NUMBER_OF_PHYS ; t++)
	 { 


			
	  for (j = 0; j < number_of_lanes[t] ; j++)
	  { 
		  
		  

		  
		  // for (i=0x101c1;i<0x10722;i++)
		  // {
			// temp = rd_channel(t,(j << offset[t]) + i);
			// printf("\n===> Phy %1d xcvr_reconfiguration_interface Ch %1d Address 0x%x Read = 0x%x",t,j,i, temp);		  
		  // }

			// temp = rd_channel(t,(j << offset[t]) + 0x101c1);
			// printf("\n===> Phy %1d xcvr_reconfiguration_interface Ch %1d Address 0x%x Read = 0x%x",t,j,(j << offset[t]) + 0x101c1, temp);		
			
			temp = rd_channel(t,(j << offset[t]) + 0x44000);
			printf("\nPhy %1d xcvr_reconfiguration_interface Ch %1d Address 0x44000 Read = 0x%x",t,j, temp);	

			temp = rd_channel(t,(j << offset[t]) + 0x41BB8);
			printf("\nPhy %1d xcvr_reconfiguration_interface Ch %1d Address 0x41BB8 Read = 0x%x",t,j, temp);	
			
			
			temp = rd_channel(t,(j << offset[t]) + 0xFFFFC);
			printf("\nPhy %1d xcvr_reconfiguration_interface Ch %1d Address 0xFFFFC Read = 0x%x",t, j, temp);	
			
			temp = rd_channel(t,(j << offset[t]) + 0x7001C);
			printf("\nPhy %1d xcvr_reconfiguration_interface Ch %1d Address 0x%x Read = 0x%x",t,j,(j << offset[t]) + 0x7001C, temp);			
			
			printf("\n");
			


		  for (i=0x60C0;i<=0x617C;i+=4)
		  {
			temp = rd_pdp_channel(t,(j << offset_pdp[t]) + i);
			printf("\n===> Phy %1d pdp_reconfiguration_interface Ch %1d Address 0x%x Read = 0x%x",t,j,i, temp);		  
		  }
		  

			
	  }
	 }
	}
}

#ifdef SUPERLITE_ENABLED
void loop_latency(int loopcount)
{

int Latency_Minimum;
int Latency_Maximum;

	  printf("\n\nMeasuring Latency across %d cycles, this takes some time ....",loopcount);
	  
      NOK = 0;
	   Latency_Minimum = 1000;
		Latency_Maximum = 0;
	   
	  for (j = 0; j < 256; j++)
       {
				hist[j] = 0;
		 }
	  
		
//	   usleep(2000000); // wait 2 seconds to make sure the dataclock is correctly measured.
//	   DataClock_Reg = IORD_ALTERA_AVALON_PIO_DATA(DATACLOCK_REG_BASE);
	  
       for (j = 0; j < loopcount; j++)
       {

			reset_phy(Selectedphy,USE_RESET);
		 
		  usleep(10000);
		  
        do
        {
					Channel_Reg[Selectedphy][0]      =  Read_Channel_Reg(Selectedphy,0);	
					ChannelOK[Selectedphy]  = 0x0001 & (Channel_Reg[Selectedphy][0]  >> 9);     
        } while (ChannelOK[Selectedphy]  == 0);
		  // Problem with the loop above is that it will hang if the channel is not ok.
		  
		  usleep(1000);       

		  
			Latency_Max_Reg[Selectedphy] 			= read_latency_reg(Selectedphy);

			Latency_Memory[j] = Latency_Max_Reg[Selectedphy];

		  
		  
		if (ChannelOK[Selectedphy] == 0) 
			{
			NOK = NOK + 1;
 
			if (Latency_Memory[j]  < Latency_Minimum )
				Latency_Minimum = Latency_Memory[j] ;
			if (Latency_Memory[j]  > Latency_Maximum )
				Latency_Maximum = Latency_Memory[j] ;
						
		  
						printf("\n");
					   printf("%4d:Latency:%3d clock cycles ",j,Latency_Memory[j]);	
			if (STOP == 1)
			{
				printf("\nLink NOK  press any key: %d :\n",NOK);
				rx_char = input_char();
			}
			}
		else
		{
			
			
			if (Latency_Memory[j] == 0)
			{
				printf("\nError : Latency measurement is zero");
				break;
			}
			else
			{
				if (Latency_Memory[j]  < Latency_Minimum )
					Latency_Minimum = Latency_Memory[j] ;
				if (Latency_Memory[j]  > Latency_Maximum )
					Latency_Maximum = Latency_Memory[j] ;
				
				 
				hist[Latency_Memory[j]] = hist[Latency_Memory[j]] + 1;
			}
						printf("\n");
						printf("%4d:Latency:%3d clock cycles ",j,Latency_Memory[j]);
		
        }//  if-else
		  
	  } // for j loop

	 printf("\n");

	 for (i = Latency_Minimum; i <= Latency_Maximum; i++)
       {  

		  printf("\nNumber of cases Maximum Latency is equal to %2d parallel clocks is : %4d",i,hist[i]);
		 }
		 
}
#endif

void readback_loopbacks(int phy)
{
	int i;
	unsigned int readout;
	unsigned int loopback_address;
	
	if (FHT_USED)
		loopback_address = LOOPBACK_ADDR_FHT;
	else
		loopback_address = LOOPBACK_ADDR_FGT;

	for (i = 0; i < number_of_physical_lanes[phy] ; i++)
	{ 		


		readout = rd_channel_ftile (phy,i, offset[phy],loopback_address);
	
		if (FHT_USED)
		{
			Serial_Loop[phy][i] = 0x0001 & (readout >> 14);	
			Rev_Parallel[phy][i] = 0x0001 & (readout >> 0);
		}
		else
		{
		Serial_Loop[phy][i] = 0x0001 & (readout >> 1);	
		Rev_Parallel[phy][i] = 0x0001 & (readout >> 2);			
		}
		
		if (DEBUG_SERIAL_LOOP) printf("\nPhy %1d xcvr_reconfiguration_interface Ch %1d Address 0x%x Read = 0x%x",phy,i, address, readout);						
		if (DEBUG_SERIAL_LOOP) printf("\nSerial_Loop : %d",Serial_Loop[phy][i]);		
	}

	
}

void readback_polarity(int phy)
{
	int i;
	unsigned int readout;
	unsigned int polarity_address;
	
	// if (FHT_USED)
		// loopback_address = LOOPBACK_ADDR_FHT;
	// else
		polarity_address = 0x41428;

	for (i = 0; i < number_of_physical_lanes[phy] ; i++)
	{ 		


		readout = rd_channel_ftile (phy,i, offset[phy],polarity_address);
	
		// if (FHT_USED)
		// {
			// Serial_Loop[phy][i] = 0x0001 & (readout >> 14);	
			// Rev_Parallel[phy][i] = 0x0001 & (readout >> 0);
		// }
		// else
		// {
		invert_tx_polarity[phy][i] = 0x0001 & (readout >> 7);	
		invert_rx_polarity[phy][i] = 0x0001 & (readout >> 6);			
		// }
		
	
	}

	
}

void histogram(void)
{
	int i;
	int hist[10];
	float temp;
	
	//initialize histogram

	for (i=0;i<10;i++)
	{
		hist[i] = 0;
	}
	
	//build histogram
	for (i=0;i<LOOPCOUNT;i++)
	{
		if (time_taken[i] < 100.0)
			hist[0] = hist[0] + 1;
		else  if ((time_taken[i] >= 100.0) && (time_taken[i] < 200.0))
			hist[1] = hist[1] + 1;
		else  if ((time_taken[i] >= 200.0) && (time_taken[i] < 400.0))
			hist[2] = hist[2] + 1;
		else  if ((time_taken[i] >= 400.0) && (time_taken[i] < 600.0))
			hist[3] = hist[3] + 1;	
		else  if ((time_taken[i] >= 600.0) && (time_taken[i] < 1000.0))
			hist[4] = hist[4] + 1;	
		else  if ((time_taken[i] >= 1000.0) && (time_taken[i] < 2000.0))
			hist[5] = hist[5] + 1;		
		else  if ((time_taken[i] >= 2000.0) && (time_taken[i] < 4000.0))
			hist[6] = hist[6] + 1;	
		else  if ((time_taken[i] >= 4000.0) && (time_taken[i] < 6000.0))
			hist[7] = hist[7] + 1;	
		else  if ((time_taken[i] >= 6000.0) && (time_taken[i] < 8000.0))
			hist[8] = hist[8] + 1;	
		else if (time_taken[i] >= 10000.0) 
			hist[9] = hist[9] + 1;	
	}
	
	printf("\n\nHistogram adaptation times across %d tests",LOOPCOUNT);
	printf("\n===================================================");
	

		printf("\nAdaptation time smaller than         100 ms : %4d  ",hist[0]);
		temp = (((float) hist[0])/LOOPCOUNT)*100; 
		print_bar_noise((int) temp);
		printf("\nAdaptation time between  100 ms and  200 ms : %4d  ",hist[1]);
		temp = (((float) hist[1])/LOOPCOUNT)*100; 
		print_bar_noise((int) temp);		
		printf("\nAdaptation time between  200 ms and  400 ms : %4d  ",hist[2]);	
		temp = (((float) hist[2])/LOOPCOUNT)*100; 
		print_bar_noise((int) temp);		
		printf("\nAdaptation time between  400 ms and  600 ms : %4d  ",hist[3]);
		temp = (((float) hist[3])/LOOPCOUNT)*100; 
		print_bar_noise((int) temp);		
		printf("\nAdaptation time between  600 ms and 1000 ms : %4d  ",hist[4]);	
		temp = (((float) hist[4])/LOOPCOUNT)*100; 
		print_bar_noise((int) temp);		
		printf("\nAdaptation time between 1000 ms and 2000 ms : %4d  ",hist[5]);
		temp = (((float) hist[5])/LOOPCOUNT)*100; 
		print_bar_noise((int) temp);		
		printf("\nAdaptation time between 2000 ms and 4000 ms : %4d  ",hist[6]);
		temp = (((float) hist[6])/LOOPCOUNT)*100; 
		print_bar_noise((int) temp);		
		printf("\nAdaptation time between 4000 ms and 6000 ms : %4d  ",hist[7]);
		temp = (((float) hist[7])/LOOPCOUNT)*100; 
		print_bar_noise((int) temp);		
		printf("\nAdaptation time between 6000 ms and 8000 ms : %4d  ",hist[8]);	
		temp = (((float) hist[8])/LOOPCOUNT)*100; 
		print_bar_noise((int) temp);		
		printf("\nAdaptation time greater than        8000 ms : %4d  ",hist[9]);
		temp = (((float) hist[9])/LOOPCOUNT)*100; 
		print_bar_noise((int) temp);		
}

#ifdef RSFEC_USED

void collect_fec_statistics(void)
{
for (t = 0; t < NUMBER_OF_PHYS ; t++)
{ 
	if ((fec_mode[t] == AGGREGATE_200GBE) || (fec_mode[t] == AGGREGATE_400GBE) || (fec_mode[t] == AGGREGATE_100GBE) )
		number_of_fecs[t] = NUMBER_OF_FECS_PHY;
	else
		number_of_fecs[t] = number_of_lanes[t];
	
   for (z = 0; z < number_of_fecs[t] ; z++)
   {	

		i = determine_channel(z); // for 2x200GbE i will return 4 when z = 1
		
		
	  //Issue a FEC shadow request	
	  for (j = 0; j < number_of_segments[t] ; j++)
		{
			fec_shadow_request(t,i,ethernet_mode[t],j);	
		}
	  
	  for (j = 0; j < number_of_segments[t] ; j++)
		{
		
		  //define virtual lane
		  
			vl = z * number_of_segments[t]  + j ; // lane 0 : vl= 0,1 lane 1 : vl = 2,3 ... 	
			if ((vl >= 0) && (vl < NUMBER_OF_VIRTUAL_LANES))
			{			
	  
			  FEC_Correctable_Symbols_Reg_L[t][vl] 		= Read_FEC_corr_symbols_Reg_L(t,i,ethernet_mode[t],j);
			  FEC_Correctable_Symbols_Reg_H[t][vl] 		= Read_FEC_corr_symbols_Reg_H(t,i,ethernet_mode[t],j);
			  FEC_Correctable_Bits_0_1_Reg_L[t][vl] 		= Read_FEC_corr_bits_0_1_Reg_L(t,i,ethernet_mode[t],j);
			  FEC_Correctable_Bits_0_1_Reg_H[t][vl] 		= Read_FEC_corr_bits_0_1_Reg_H(t,i,ethernet_mode[t],j);
			  FEC_Correctable_Bits_1_0_Reg_L[t][vl] 		= Read_FEC_corr_bits_1_0_Reg_L(t,i,ethernet_mode[t],j);
			  FEC_Correctable_Bits_1_0_Reg_H[t][vl] 		= Read_FEC_corr_bits_1_0_Reg_H(t,i,ethernet_mode[t],j);
			  FEC_Lane_Mapping[t][vl]							= Read_FEC_rx_lane_mapping(t,i,ethernet_mode[t],j);
			  FEC_Rx_Lane_Skew[t][vl]							= Read_FEC_rx_lane_skew(t,i,ethernet_mode[t],j);

			}
		   //printf("\nFEC_Correctable_Symbols_Reg_L[%d][%d] = %d",t,vl,FEC_Correctable_Symbols_Reg_L[t][vl]);
		   //printf("\nFEC_Correctable_Bits_0_1_Reg_L[%d][%d] = %d",t,vl,FEC_Correctable_Bits_0_1_Reg_L[t][vl]);	  
		  
  //Clear shadow request
  //fec_clear_shadow_request(t,i);
		}
		
		  //These are statistics per fec (not per segment)
		  if (number_of_segments[t] <= 2)
		  {
		  FEC_Correctable_Codeword_Reg_L[t][z] 		= Read_FEC_corr_codeword_Reg_L(t,i,ethernet_mode[t],0);
		  FEC_Correctable_Codeword_Reg_H[t][z] 		= Read_FEC_corr_codeword_Reg_H(t,i,ethernet_mode[t],0);
		  FEC_UnCorrectable_Codeword_Reg_L[t][z] 		= Read_FEC_uncorr_codeword_Reg_L(t,i,ethernet_mode[t],0);	
		  FEC_UnCorrectable_Codeword_Reg_H[t][z] 		= Read_FEC_uncorr_codeword_Reg_H(t,i,ethernet_mode[t],0);		  
		  rsfec_corr_cwbin_cnt_0_3_A[t][z]				= Read_FEC_rsfec_corr_cwbin_cnt_0_3(t,i,ethernet_mode[t],0);	
		  rsfec_corr_cwbin_cnt_4_7_A[t][z]				= Read_FEC_rsfec_corr_cwbin_cnt_4_7(t,i,ethernet_mode[t],0);	
		  rsfec_corr_cwbin_cnt_8_11_A[t][z]				= Read_FEC_rsfec_corr_cwbin_cnt_8_11(t,i,ethernet_mode[t],0);	
		  rsfec_corr_cwbin_cnt_12_15_A[t][z]			= Read_FEC_rsfec_corr_cwbin_cnt_12_15(t,i,ethernet_mode[t],0);
		  }
		  else
		  {
		  FEC_Correctable_Codeword_Reg_L[t][z] 		= Read_FEC_corr_codeword_Reg_L(t,i,ethernet_mode[t],0) + Read_FEC_corr_codeword_Reg_L(t,i,ethernet_mode[t],ethernet_mode_segment[t]);
		  FEC_Correctable_Codeword_Reg_H[t][z] 		= Read_FEC_corr_codeword_Reg_H(t,i,ethernet_mode[t],0) + Read_FEC_corr_codeword_Reg_H(t,i,ethernet_mode[t],ethernet_mode_segment[t]);
		  FEC_UnCorrectable_Codeword_Reg_L[t][z] 		= Read_FEC_uncorr_codeword_Reg_L(t,i,ethernet_mode[t],0) + Read_FEC_uncorr_codeword_Reg_L(t,i,ethernet_mode[t],ethernet_mode_segment[t]);	
		  FEC_UnCorrectable_Codeword_Reg_H[t][z] 		= Read_FEC_uncorr_codeword_Reg_H(t,i,ethernet_mode[t],0) + Read_FEC_uncorr_codeword_Reg_H(t,i,ethernet_mode[t],ethernet_mode_segment[t]);		  
		  rsfec_corr_cwbin_cnt_0_3_A[t][z]				= Read_FEC_rsfec_corr_cwbin_cnt_0_3(t,i,ethernet_mode[t],0);
		  //printf("\nrsfec_corr_cwbin_cnt_0_3_A[%d][%d] = %d",t,z,rsfec_corr_cwbin_cnt_0_3_A[t][z]);		  
		  rsfec_corr_cwbin_cnt_4_7_A[t][z]				= Read_FEC_rsfec_corr_cwbin_cnt_4_7(t,i,ethernet_mode[t],0);	
		  rsfec_corr_cwbin_cnt_8_11_A[t][z]				= Read_FEC_rsfec_corr_cwbin_cnt_8_11(t,i,ethernet_mode[t],0);	
		  rsfec_corr_cwbin_cnt_12_15_A[t][z]			= Read_FEC_rsfec_corr_cwbin_cnt_12_15(t,i,ethernet_mode[t],0);
		  rsfec_corr_cwbin_cnt_0_3_B[t][z]				= Read_FEC_rsfec_corr_cwbin_cnt_0_3(t,i,ethernet_mode[t],ethernet_mode_segment[t]);	
		  //printf("\nrsfec_corr_cwbin_cnt_0_3_B[%d][%d] = %d",t,z,rsfec_corr_cwbin_cnt_0_3_B[t][z]);
		  rsfec_corr_cwbin_cnt_4_7_B[t][z]				= Read_FEC_rsfec_corr_cwbin_cnt_4_7(t,i,ethernet_mode[t],ethernet_mode_segment[t]);	
		  rsfec_corr_cwbin_cnt_8_11_B[t][z]				= Read_FEC_rsfec_corr_cwbin_cnt_8_11(t,i,ethernet_mode[t],ethernet_mode_segment[t]);	
		  rsfec_corr_cwbin_cnt_12_15_B[t][z]			= Read_FEC_rsfec_corr_cwbin_cnt_12_15(t,i,ethernet_mode[t],ethernet_mode_segment[t]);	  
		  }			  

 
  
  //Clear shadow request	  
	  for (j = 0; j < number_of_segments[t] ; j++)
		{
			fec_clear_shadow_request(t,i,ethernet_mode[t],j);	
		}
	}

   for (i = 0; i < number_of_fecs[t] ; i++)
   {	

		  //store previous counters
		  
		  for (k = 0; k < 16; k++)
		  {
			previous_FEC_corr_cwbin_cnt_A[t][i][k] =  FEC_corr_cwbin_cnt_A[t][i][k];
		  }

		  FEC_corr_cwbin_cnt_A[t][i][0]		= rsfec_corr_cwbin_cnt_0_3_A[t][i] & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[t][i][1]		= (rsfec_corr_cwbin_cnt_0_3_A[t][i] >> 8) & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[t][i][2]		= (rsfec_corr_cwbin_cnt_0_3_A[t][i] >> 16) & (0x0000000FF);		  
		  FEC_corr_cwbin_cnt_A[t][i][3]		= (rsfec_corr_cwbin_cnt_0_3_A[t][i] >> 24) & (0x0000000FF);		
		  FEC_corr_cwbin_cnt_A[t][i][4]		= rsfec_corr_cwbin_cnt_4_7_A[t][i] & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[t][i][5]		= (rsfec_corr_cwbin_cnt_4_7_A[t][i] >> 8) & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[t][i][6]		= (rsfec_corr_cwbin_cnt_4_7_A[t][i] >> 16) & (0x0000000FF);		  
		  FEC_corr_cwbin_cnt_A[t][i][7]		= (rsfec_corr_cwbin_cnt_4_7_A[t][i] >> 24) & (0x0000000FF);		
		  FEC_corr_cwbin_cnt_A[t][i][8]		= rsfec_corr_cwbin_cnt_8_11_A[t][i] & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[t][i][9]		= (rsfec_corr_cwbin_cnt_8_11_A[t][i] >> 8) & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[t][i][10]		= (rsfec_corr_cwbin_cnt_8_11_A[t][i] >> 16) & (0x0000000FF);		  
		  FEC_corr_cwbin_cnt_A[t][i][11]		= (rsfec_corr_cwbin_cnt_8_11_A[t][i] >> 24) & (0x0000000FF);	
		  FEC_corr_cwbin_cnt_A[t][i][12]		= rsfec_corr_cwbin_cnt_12_15_A[t][i] & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[t][i][13]		= (rsfec_corr_cwbin_cnt_12_15_A[t][i] >> 8) & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[t][i][14]		= (rsfec_corr_cwbin_cnt_12_15_A[t][i] >> 16) & (0x0000000FF);		  
		  FEC_corr_cwbin_cnt_A[t][i][15]		= (rsfec_corr_cwbin_cnt_12_15_A[t][i] >> 24) & (0x0000000FF);	
		  
		  for (k = 0; k < 16; k++)
		  {
			//printf("\nFEC_corr_cwbin_cnt_A[%d][%d][%d] = %d",t,i,k,FEC_corr_cwbin_cnt_A[t][i][k]);
			
			if (FEC_corr_cwbin_cnt_A[t][i][k] < previous_FEC_corr_cwbin_cnt_A[t][i][k]) // detect overrun
				FEC_corr_cwbin_cnt_A_overrun[t][i][k] = 1;
				
		  }		  

		  value_found = 0;
		  rsfec_highest_bin_count_A[t][i] = 0;	//initialize
		  
			for (k = 15; k > 0 ; k--)
			{
				if ((FEC_corr_cwbin_cnt_A[t][i][k] > 0) && (value_found == 0))
				{
					rsfec_highest_bin_count_A[t][i] = (unsigned int) k;
					value_found = 1;
				}
			}
				
			if (number_of_segments[t] > 2)
			{

			  for (k = 0; k < 16; k++)
			  {
				previous_FEC_corr_cwbin_cnt_B[t][i][k] =  FEC_corr_cwbin_cnt_B[t][i][k];
			  }
		  
			  FEC_corr_cwbin_cnt_B[t][i][0]		= rsfec_corr_cwbin_cnt_0_3_B[t][i] & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[t][i][1]		= (rsfec_corr_cwbin_cnt_0_3_B[t][i] >> 8) & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[t][i][2]		= (rsfec_corr_cwbin_cnt_0_3_B[t][i] >> 16) & (0x0000000FF);		  
			  FEC_corr_cwbin_cnt_B[t][i][3]		= (rsfec_corr_cwbin_cnt_0_3_B[t][i] >> 24) & (0x0000000FF);		
			  FEC_corr_cwbin_cnt_B[t][i][4]		= rsfec_corr_cwbin_cnt_4_7_B[t][i] & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[t][i][5]		= (rsfec_corr_cwbin_cnt_4_7_B[t][i] >> 8) & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[t][i][6]		= (rsfec_corr_cwbin_cnt_4_7_B[t][i] >> 16) & (0x0000000FF);		  
			  FEC_corr_cwbin_cnt_B[t][i][7]		= (rsfec_corr_cwbin_cnt_4_7_B[t][i] >> 24) & (0x0000000FF);		
			  FEC_corr_cwbin_cnt_B[t][i][8]		= rsfec_corr_cwbin_cnt_8_11_B[t][i] & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[t][i][9]		= (rsfec_corr_cwbin_cnt_8_11_B[t][i] >> 8) & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[t][i][10]		= (rsfec_corr_cwbin_cnt_8_11_B[t][i] >> 16) & (0x0000000FF);		  
			  FEC_corr_cwbin_cnt_B[t][i][11]		= (rsfec_corr_cwbin_cnt_8_11_B[t][i] >> 24) & (0x0000000FF);	
			  FEC_corr_cwbin_cnt_B[t][i][12]		= rsfec_corr_cwbin_cnt_12_15_B[t][i] & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[t][i][13]		= (rsfec_corr_cwbin_cnt_12_15_B[t][i] >> 8) & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[t][i][14]		= (rsfec_corr_cwbin_cnt_12_15_B[t][i] >> 16) & (0x0000000FF);		  
			  FEC_corr_cwbin_cnt_B[t][i][15]		= (rsfec_corr_cwbin_cnt_12_15_B[t][i] >> 24) & (0x0000000FF);	
			  
			  for (k = 0; k < 16; k++)
			  {
				//printf("\nFEC_corr_cwbin_cnt_B[%d][%d][%d] = %d",t,i,k,FEC_corr_cwbin_cnt_B[t][i][k]);				  
				if (FEC_corr_cwbin_cnt_B[t][i][k] < previous_FEC_corr_cwbin_cnt_B[t][i][k]) // detect overrun
					FEC_corr_cwbin_cnt_B_overrun[t][i][k] = 1;
					
			  }	

			  value_found = 0;
			  rsfec_highest_bin_count_B[t][i] = 0;	//initialize
			  
				for (k = 15; k > 0 ; k--)
				{
					if ((FEC_corr_cwbin_cnt_B[t][i][k] > 0) && (value_found == 0))
					{
						rsfec_highest_bin_count_B[t][i] = (unsigned int) k;
						value_found = 1;
					}
				}
			
				
			}
			

	}
}//t
	
	
}

void calculate_fec_statistics(void)
{

for (t = 0; t < NUMBER_OF_PHYS ; t++)
{ 
	// per virtual lane
  for (i = 0; i < number_of_virtual_lanes[t]  ; i++)
  {	 
  FEC_Correctable_Symbols[t][i] = ((double)(FEC_Correctable_Symbols_Reg_H[t][i]) *  MULTIPLIER * MULTIPLIER) + (double) (FEC_Correctable_Symbols_Reg_L[t][i]);	
  FEC_Correctable_Bits_0_1[t][i] = ((double)(FEC_Correctable_Bits_0_1_Reg_H[t][i]) *  MULTIPLIER * MULTIPLIER) + (double) (FEC_Correctable_Bits_0_1_Reg_L[t][i]);	
  FEC_Correctable_Bits_1_0[t][i] = ((double)(FEC_Correctable_Bits_1_0_Reg_H[t][i]) *  MULTIPLIER * MULTIPLIER) + (double) (FEC_Correctable_Bits_1_0_Reg_L[t][i]);		  

  //When in aggregate mode the correctable codeword and uncorrectable codeword from all the lanes are combined in the readout of lane 0
  //In fractured mode this is a seperate number.

  	  
  }

  //per FEC
  for (i = 0; i < number_of_fecs[t]  ; i++)
  {	
  FEC_Correctable_Codeword[t][i] = ((double)(FEC_Correctable_Codeword_Reg_H[t][i]) *  MULTIPLIER * MULTIPLIER) + (double) (FEC_Correctable_Codeword_Reg_L[t][i]);	
  FEC_UnCorrectable_Codeword[t][i] = ((double)(FEC_UnCorrectable_Codeword_Reg_H[t][i]) *  MULTIPLIER * MULTIPLIER) + (double) (FEC_UnCorrectable_Codeword_Reg_L[t][i]);	
  }
  

  //per fec statistic (across all segments)
  for (i = 0; i < number_of_fecs[t]  ; i++)
  {	
		FEC_Correctable_Bits_Total[t][i] = 0.0;  //per FEC
		ErrorCount_Total[t][i] = 0.0;
		Total_Correctable_Symbols[t][i] = 0.0;		
  
	  for (j = 0; j < number_of_segments[t]; j++)
	  {	 
			vl = i * number_of_segments[t]  + j ;
			
			FEC_Correctable_Bits_Total[t][i] += FEC_Correctable_Bits_0_1[t][vl] + FEC_Correctable_Bits_1_0[t][vl]; 
			ErrorCount_Total[t][i] += ErrorCount[t][vl];
			Total_Correctable_Symbols[t][i] += FEC_Correctable_Symbols[t][vl]; 			
	  }

		//printf("\nFEC_Correctable_Bits_Total[%1d][%1d] = %e",t,i,FEC_Correctable_Bits_Total[t][i]);
		//printf("\n  = %e",(double) (Totalbits[t]));
		
		if (fec_mode[t] == FRACTURED)	
			Totalbits_per_fec[t] = (double) (Totalbits[t]);
		else
		{
			if ((FHT_USED == 1) && (FHT_HIGHEST_RATE == 1))
				Totalbits_per_fec[t] = (double) (Totalbits[t]*(number_of_segments[t]/4)); //100G-1 = *1, 200G = *2, 400G =  *4
			else
				Totalbits_per_fec[t] = (double) (Totalbits[t]*(number_of_segments[t]/2)); //50G-1 = *1, 200G = * 4, 400G-8 = *8				
		}
		
		Precorrected_BER[t][i] = (double) (FEC_Correctable_Bits_Total[t][i] + ErrorCount_Total[t][i]) /(double) (Totalbits_per_fec[t]); 
		Corrected_symbols_rate[t][i] =  (double) Total_Correctable_Symbols[t][i]/(Totalbits_per_fec[t]/(10)); 
	  
	}
  

	if (AGGREGATE_FECS == 1)
	{
		Total_Correctable_Symbols_Aggr[t] = 0.0;
		FEC_Correctable_Bits_Total_Aggr[t] = 0.0;
		ErrorCount_Total_Aggr[t]  = 0.0;
	   Totalbits_Aggr[t] = 0.0;
		
		for (i = 0; i < number_of_fecs[t]  ; i++)
		{
			Total_Correctable_Symbols_Aggr[t] += Total_Correctable_Symbols[t][i];
			FEC_Correctable_Bits_Total_Aggr[t] += FEC_Correctable_Bits_Total[t][i];
			ErrorCount_Total_Aggr[t] +=  ErrorCount_Total[t][i];	 
			Totalbits_Aggr[t] += Totalbits_per_fec[t];
		}

			// printf("\nTotal_Correctable_Symbols_Aggr[%d] = %e",t,Total_Correctable_Symbols_Aggr[t]);
			// printf("\nFEC_Correctable_Bits_Total_Aggr[%d] = %e",t,FEC_Correctable_Bits_Total_Aggr[t] );
			// printf("\nErrorCount_Total_Aggr[%d] = %e",t,ErrorCount_Total_Aggr[t]);	 
			// printf("\nTotalbits_Aggr[%d] = %e",t,Totalbits_Aggr[t]);
			
		
		Precorrected_BER_Aggr[t] = (double) (FEC_Correctable_Bits_Total_Aggr[t] + ErrorCount_Total_Aggr[t]) /(Totalbits_Aggr[t]); 	
		Corrected_symbols_rate_Aggr[t] =  (double) Total_Correctable_Symbols_Aggr[t]/((Totalbits_Aggr[t])/(10));
	}
	else
	{
		Totalbits_Aggr[t] = (double) Totalbits_per_fec[t];
	}
	
}

}

void print_fec_statistics(int t)
{
	

     printf("--------------------|");
     for (i = 0; i < number_of_virtual_lanes[t]  ; i++)
     { 
     printf("--------|");
     }
     printf("\n");	  

     printf("RSFEC Locked       :|");

     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     {   
  
  		  if (fec_mode[t] == FRACTURED)
		  {
				print_alarm(rx_am_lock[t][i],1);
		  }
		  else
		  {
				if ( (i % number_of_segments[t]) == 0) 
					print_alarm(rx_am_lock[t][i/number_of_segments[t]],1);
				else
					printf("        |");
		  }	
		  
     }
     printf("\n");
	  
#ifdef SUPERLITE_ENABLED
if (SUPERLITEIV_USED)
{
     printf("Skew Between FECs  :|");  

     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     {   
  
  		  if (fec_mode[t] == FRACTURED)
		  {
			  if (rx_am_lock[t][i] == 1)
					printf("%8d|",Skew[t][i]);  
			  else
					printf("        |");				  
		  }
		  else
		  {
			  	if (rx_am_lock[t][i/number_of_segments[t]] == 1)
				{
					if ( (i % number_of_segments[t]) == 0) 
						printf("%8d|",Skew[t][i/number_of_segments[t]]);
					else
						printf("        |");					
				}
				else
					printf("        |");
		  }	
		  
     }
     printf("\n");
}	  
#endif	  
	  
	  
if (fec_mode[t] != FRACTURED)
{	
	  
     printf("Fec Lane Mapping   :|");


     for (i = 0; i < number_of_virtual_lanes[t]  ; i++)
     { 

		if (rx_am_lock[t][i/number_of_segments[t]] == 1)
		 {
       printf("%8d|",FEC_Lane_Mapping[t][i]);     
		}
     else
       printf("        |");
	  }	  

     printf("\n");	 
 
     printf("Fec Lane Skew      :|");


     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 

		if (rx_am_lock[t][i/number_of_segments[t]] == 1)
		 {
       printf("%8d|",FEC_Rx_Lane_Skew[t][i]);   
		}
     else
       printf("        |");
	  }	  

     printf("\n");
  }	  	  
	  


	  
     printf("Fec corr symbols   :|");
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
		if (rx_am_lock[t][i/number_of_segments[t]] == 1)
		 {
		  if (FEC_Correctable_Symbols[t][i] == 0)
		     print_alarm(FEC_Correctable_Symbols_Reg_L[t][i],0);
		  else if (FEC_Correctable_Symbols[t][i] > 99999999)
	       printf(COLOR_CORRECTABLE "%.2e" COLOR_RESET "|" , FEC_Correctable_Symbols[t][i]);		  
		  else 
	       printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" ,FEC_Correctable_Symbols_Reg_L[t][i]);			   
		}

     else
       printf("        |");
	  }	  
     printf("\n");
	  
     printf("Fec corr bits 0/1  :|");
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
		if (rx_am_lock[t][i/number_of_segments[t]] == 1)
		 {		  

		  if (FEC_Correctable_Bits_0_1[t][i] == 0)
		     print_alarm(FEC_Correctable_Bits_0_1_Reg_L[t][i],0);
		  else if (FEC_Correctable_Bits_0_1[t][i] > 99999999)
	       printf(COLOR_CORRECTABLE "%.2e" COLOR_RESET "|" , FEC_Correctable_Bits_0_1[t][i]);		  
		  else 
	       printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" ,FEC_Correctable_Bits_0_1_Reg_L[t][i]);	
		  
			}
     else
       printf("        |");
		}

     printf("\n");

     printf("Fec corr bits 1/0  :|");
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
		if (rx_am_lock[t][i/number_of_segments[t]] == 1)
		{		 		  
		  if (FEC_Correctable_Bits_1_0[t][i] == 0)
		     print_alarm(FEC_Correctable_Bits_1_0_Reg_L[t][i],0);
		  else if (FEC_Correctable_Bits_1_0[t][i] > 99999999)
	       printf(COLOR_CORRECTABLE "%.2e" COLOR_RESET "|" , FEC_Correctable_Bits_1_0[t][i]);		  
		  else 
	       printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" ,FEC_Correctable_Bits_1_0_Reg_L[t][i]);	   
		  }

     else
       printf("        |");
	  }  
     printf("\n");
   
		
	  printf("Precorrected BER   :|");
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
			if (fec_mode[t] == FRACTURED)
			{		
				if (rx_am_lock[t][i] == 1) 
				{		 		  
				  if (Precorrected_BER[t][i] == 0)	
					  print_alarm(Precorrected_BER[t][i],0);
				  else
					  printf(COLOR_CORRECTABLE "%.2e" COLOR_RESET "|" , Precorrected_BER[t][i]);		
				 } 				 
				else
					printf("        |");
			}
			else
			{
				if ( (i % number_of_segments[t]) == 0) 
				{
					if ((rx_am_lock[t][i/number_of_segments[t]] == 1))
						{		 		  
						if (Precorrected_BER[t][i/number_of_segments[t]] == 0)	
							print_alarm(Precorrected_BER[t][i/number_of_segments[t]],0);  
						else 
							printf(COLOR_CORRECTABLE "%.2e" COLOR_RESET "|" , Precorrected_BER[t][i/number_of_segments[t]]);		      
						}
						else
							printf("        |");
				}	
				else
					printf("        |");
			}							
	   }  
	   printf("\n");

     printf("SER (RSFEC)        :|");	
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
			if (fec_mode[t] == FRACTURED)
			{		
				if (rx_am_lock[t][i] == 1) 
				{		 		  
				  if (Corrected_symbols_rate[t][i] == 0)	
					  print_alarm(Corrected_symbols_rate[t][i],0);
				  else
					  printf(COLOR_CORRECTABLE "%.2e" COLOR_RESET "|" , Corrected_symbols_rate[t][i]);		
				 } 				 
				else
					printf("        |");
			}
			else
			{
				if ( (i % number_of_segments[t]) == 0) 
				{
					if ((rx_am_lock[t][i/number_of_segments[t]] == 1))
						{		 		  
						if (Corrected_symbols_rate[t][i/number_of_segments[t]] == 0)	
							print_alarm(Corrected_symbols_rate[t][i/number_of_segments[t]],0);  
						else 
							printf(COLOR_CORRECTABLE "%.2e" COLOR_RESET "|" , Corrected_symbols_rate[t][i/number_of_segments[t]]);		      
						}
						else
							printf("        |");
				}	
				else
					printf("        |");
			}							
	   }  
	   printf("\n");
		
	  
if (fec_mode[t] != FRACTURED)
{	
	  printf("FEC corr tot. symb.:|");
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
			if (fec_mode[t] == FRACTURED)
			{		
				if (rx_am_lock[t][i] == 1) 
				{		 		  
	 
		
				  if (Total_Correctable_Symbols[t][i] == 0.0)
					  print_alarm(Total_Correctable_Symbols[t][i] ,0);
				  else if (Total_Correctable_Symbols[t][i]  > 99999999)
					 printf(COLOR_CORRECTABLE "%.2e" COLOR_RESET "|" , Total_Correctable_Symbols[t][i] );		  
				  else 
					 printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" ,(int) Total_Correctable_Symbols[t][i] );	
			  
				} 
				else
					printf("        |");
			}
			else
			{
				if ( (i % number_of_segments[t]) == 0) 
				{
					if ((rx_am_lock[t][i/number_of_segments[t]] == 1))
						{		 		  
						if (Total_Correctable_Symbols[t][i/number_of_segments[t]] == 0)	
							print_alarm(Total_Correctable_Symbols[t][i/number_of_segments[t]],0);  
						else if (Total_Correctable_Symbols[t][i/number_of_segments[t]] > 99999999)
							printf(COLOR_CORRECTABLE "%.2e" COLOR_RESET "|" , Total_Correctable_Symbols[t][i/number_of_segments[t]]);		
						else	
							printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" ,(int) Total_Correctable_Symbols[t][i/number_of_segments[t]]);	      
						}
						else
							printf("        |");
				}	
				else
					printf("        |");
			}			
		  
				
	   } 
	  if (EXTRA_FEC_COMMENTS)
			printf(" Total amount of corrected symbols\n");
	  else
		 printf("\n");		
}

   
     printf("FEC corr codeword  :|");
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
			if (fec_mode[t] == FRACTURED)
			{		
			if (rx_am_lock[t][i] == 1) 
					{		 		  
 
	
			  if (FEC_Correctable_Codeword_Reg_L[t][i] == 0)
				  print_alarm(FEC_Correctable_Codeword_Reg_L[t][i],0);
			  else if (FEC_Correctable_Codeword_Reg_L[t][i] > 99999999)
				 printf(COLOR_CORRECTABLE "%.2e" COLOR_RESET "|" , FEC_Correctable_Codeword[t][i]);		  
			  else 
				 printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" ,FEC_Correctable_Codeword_Reg_L[t][i]);	
		  
			  } 
		
			else
			 printf("        |");
			}
			else
			{
				if ( (i % number_of_segments[t]) == 0) 
				{
					if ((rx_am_lock[t][i/number_of_segments[t]] == 1))
						{		 		  
						if (FEC_Correctable_Codeword_Reg_L[t][i/number_of_segments[t]] == 0)	
							print_alarm(FEC_Correctable_Codeword_Reg_L[t][i/number_of_segments[t]],0);  
						else if (FEC_Correctable_Codeword_Reg_L[t][i/number_of_segments[t]] > 99999999)
							printf(COLOR_CORRECTABLE "%.2e" COLOR_RESET "|" , FEC_Correctable_Codeword[t][i/number_of_segments[t]]);		
						else	
							printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" ,FEC_Correctable_Codeword_Reg_L[t][i/number_of_segments[t]]);	      
						}
						else
							printf("        |");
				}	
				else
					printf("        |");
			}			
		  
				
	   }  
	   printf("\n");
		
	  printf("Max #CS per CW     :|"); //if you have FEC_corr_cwbin_cnt[0][2][10] = 1 it means worst case situation was a CW with 10 err’d symbols
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
			if (fec_mode[t] == FRACTURED)
			{	  
				if (rx_am_lock[t][i] == 1)
				{	
		
		  //printf("\nrsfec_highest_bin_count[%d][%d] = %d",t,i,rsfec_highest_bin_count[t][i]);	
		  if (rsfec_highest_bin_count_A[t][i] == 0)
		     print_alarm(rsfec_highest_bin_count_A[t][i],0);
		     //print_bar_histogram(rsfec_highest_bin_count[t][i]);
		  else
			  //print_bar_histogram(rsfec_highest_bin_count[t][i]);
	       printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" , rsfec_highest_bin_count_A[t][i]);		  
  
				}	

			else
				printf("        |");
			}
			else
			{	 
				if (number_of_segments[t] == 2)
				{
					if ( (i % number_of_segments[t]) == 0) 
					{		
						if (rx_am_lock[t][i/number_of_segments[t]] == 1)
						{	
				
							//printf("\nrsfec_highest_bin_count[%d][%d] = %d",t,i,rsfec_highest_bin_count[t][i]);	
						if (rsfec_highest_bin_count_A[t][i/number_of_segments[t]] == 0)
							print_alarm(rsfec_highest_bin_count_A[t][i/number_of_segments[t]],0);
							//print_bar_histogram(rsfec_highest_bin_count[t][i/number_of_segments[t]]);
						else
							printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" , rsfec_highest_bin_count_A[t][i/number_of_segments[t]]);	
							//print_bar_histogram(rsfec_highest_bin_count[t][i/number_of_segments[t]]);
		  
						}
						else
							printf("        |");					
					}
					else
					{
						if (rx_am_lock[t][i/number_of_segments[t]] == 1)
						{						
							print_bar_histogram((rsfec_highest_bin_count_A[t][i/number_of_segments[t]])/2);

						}
						else
							printf("        |");						
					}
				}
				else // number_of_segments = 4 or 8 
				{	
					if ( (i % number_of_segments[t]) == 0) 
					{		
						if (rx_am_lock[t][i/number_of_segments[t]] == 1)
						{	
				
							//printf("\nrsfec_highest_bin_count[%d][%d] = %d",t,i,rsfec_highest_bin_count[t][i]);	
						if (rsfec_highest_bin_count_A[t][i/number_of_segments[t]] == 0)
							print_alarm(rsfec_highest_bin_count_A[t][i/number_of_segments[t]],0);
							//print_bar_histogram(rsfec_highest_bin_count[t][i/number_of_segments[t]]);
						else
							printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" , rsfec_highest_bin_count_A[t][i/number_of_segments[t]]);	
							//print_bar_histogram(rsfec_highest_bin_count[t][i/number_of_segments[t]]);
		  
						}
						else
							printf("        |");					
					}
					else if ( (i % number_of_segments[t]) == 1) 
					{
						if (rx_am_lock[t][i/number_of_segments[t]] == 1)
						{						
							print_bar_histogram((rsfec_highest_bin_count_A[t][i/number_of_segments[t]])/2);

						}
						else
							printf("        |");						
					}
					else if  ((i % number_of_segments[t]) == number_of_segments[t]/2)						
					{	
						if (use_dual_rsfec_codeword[t] == 1)
						{
							if (rx_am_lock[t][i/number_of_segments[t]] == 1)
							{	
					
								//printf("\nrsfec_highest_bin_count[%d][%d] = %d",t,i,rsfec_highest_bin_count[t][i]);	
							if (rsfec_highest_bin_count_B[t][i/number_of_segments[t]] == 0)
								print_alarm(rsfec_highest_bin_count_B[t][i/number_of_segments[t]],0);
								//print_bar_histogram(rsfec_highest_bin_count[t][i/number_of_segments[t]]);
							else
								printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" , rsfec_highest_bin_count_B[t][i/number_of_segments[t]]);	
								//print_bar_histogram(rsfec_highest_bin_count[t][i/number_of_segments[t]]);
			  
							}
							else
								printf("        |");										
						}
						else
							printf("        |");					
					}
					else if  ((i % number_of_segments[t]) == ((number_of_segments[t]/2)+1))
					{
						if (use_dual_rsfec_codeword[t] == 1)
						{						
							if (rx_am_lock[t][i/number_of_segments[t]] == 1)
							{						
								print_bar_histogram((rsfec_highest_bin_count_B[t][i/number_of_segments[t]])/2);

							}
							else
								printf("        |");						
						}
						else
								printf("        |");										
					}
					else
						printf("        |");	

				}				
			}				
				
	  }  
	  if (EXTRA_FEC_COMMENTS)	  
		printf(" Maximum Amount of corrected Symbols in one Codeword\n");	  
	  else
		 printf("\n");
	 
	  printf("#CW in w.c. bin    :|"); //if you have FEC_corr_cwbin_cnt[0][2][10] = 1 it means worst case situation was a CW with 10 err’d symbols
      for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
  
			if (fec_mode[t] == FRACTURED)
			{	  
				if (rx_am_lock[t][i] == 1)
					{		 		  
				if (FEC_Correctable_Codeword_Reg_L[t][i] == 0)	
							printf("       -|");	//when there are no corrected codewords this value is meaningless
						else	
						{
							if (FEC_corr_cwbin_cnt_A_overrun[t][i][rsfec_highest_bin_count_A[t][i]] == 0)
							printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" , FEC_corr_cwbin_cnt_A[t][i][rsfec_highest_bin_count_A[t][i]]);		  		  
							else
								printf(COLOR_CORRECTABLE "    >256" COLOR_RESET "|");
						}
				}	
				else
					printf("        |");				
			}
			else
			{
				if (number_of_segments[t] == 2)
				{				
					if ( (i % number_of_segments[t]) == 0) 
					{		
						if (rx_am_lock[t][i/number_of_segments[t]] == 1)
						{	
							if (FEC_Correctable_Codeword_Reg_L[t][i/number_of_segments[t]] == 0)
								printf("       -|");	//when there are no corrected codewords this value is meaningless
							else					
								{
									if (FEC_corr_cwbin_cnt_A_overrun[t][i/number_of_segments[t]][rsfec_highest_bin_count_A[t][i/number_of_segments[t]]  ] == 0)
								printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" , FEC_corr_cwbin_cnt_A[t][i/number_of_segments[t]][rsfec_highest_bin_count_A[t][i/number_of_segments[t]]  ]);		  		  	  
									else
										printf(COLOR_CORRECTABLE "    >256" COLOR_RESET "|");	
								}
						}
						else	
							printf("        |");						
					} 
					else
						printf("        |");					
				}			
				else  // number_of_segments = 4 or 8 
				{	
					if ( (i % number_of_segments[t]) == 0) 
					{		
						if (rx_am_lock[t][i/number_of_segments[t]] == 1)
						{	
				
						if (FEC_Correctable_Codeword_Reg_L[t][i/number_of_segments[t]] == 0)
							printf("       -|");
						else
							{
								if (FEC_corr_cwbin_cnt_A_overrun[t][i/number_of_segments[t]][rsfec_highest_bin_count_A[t][i/number_of_segments[t]]  ] == 0)
								printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" , FEC_corr_cwbin_cnt_A[t][i/number_of_segments[t]][rsfec_highest_bin_count_A[t][i/number_of_segments[t]]  ]);		  		  	  
								else
									printf(COLOR_CORRECTABLE "    >256" COLOR_RESET "|");										
							}	
		  
						}
						else
							printf("        |");					
					}
					else if ( (i % number_of_segments[t]) == number_of_segments[t]/2) 
					{	
						if (use_dual_rsfec_codeword[t] == 1)
						{						
							if (rx_am_lock[t][i/number_of_segments[t]] == 1)
							{	
					
							if (FEC_Correctable_Codeword_Reg_L[t][i/number_of_segments[t]] == 0)
								printf("       -|");
							else
								{
									if (FEC_corr_cwbin_cnt_B_overrun[t][i/number_of_segments[t]][rsfec_highest_bin_count_B[t][i/number_of_segments[t]]  ] == 0)
									printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" , FEC_corr_cwbin_cnt_B[t][i/number_of_segments[t]][rsfec_highest_bin_count_B[t][i/number_of_segments[t]]  ]);		  		  	  
									else
										printf(COLOR_CORRECTABLE "    >256" COLOR_RESET "|");											
								}
			  
							}
							else
								printf("        |");		
						}
						else
							printf("        |");								
					}
					else
						printf("        |");	

				}					

								
			}	
	   } 
	  if (EXTRA_FEC_COMMENTS)		
		printf(" Amount of corrected Codewords in worst case bin\n");	  
	  else
		 printf("\n");	  

	  printf("#CW in 2nd w.c. bin:|"); //if you have FEC_corr_cwbin_cnt[0][2][10] = 1 it means worst case situation was a CW with 10 err’d symbols
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 
  
			if (fec_mode[t] == FRACTURED)
			{	  
				if (rx_am_lock[t][i] == 1)
					{		 		  
						if ( (FEC_Correctable_Codeword_Reg_L[t][i] == 0)	|| ((rsfec_highest_bin_count_A[t][i]-1) == 0) ) // if 2nd w.c. bin is bin 0 don't show it because this doesn't make sense
							printf("       -|");	//when there are no corrected codewords this value is meaningless
						else	
						{
							if (FEC_corr_cwbin_cnt_A_overrun[t][i][rsfec_highest_bin_count_A[t][i]-1] == 0)
							printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" , FEC_corr_cwbin_cnt_A[t][i][rsfec_highest_bin_count_A[t][i]-1]);		  		  
							else
								printf(COLOR_CORRECTABLE "    >256" COLOR_RESET "|");										
						}
				}	
				else
					printf("        |");				
			}
			else
			{
				if (number_of_segments[t] == 2)
				{				
					if ( (i % number_of_segments[t]) == 0) 
					{		
						if (rx_am_lock[t][i/number_of_segments[t]] == 1)
						{	
							if ((FEC_Correctable_Codeword_Reg_L[t][i/number_of_segments[t]] == 0) || ((rsfec_highest_bin_count_A[t][i/number_of_segments[t]] -1) == 0) ) // if 2nd w.c. bin is bin 0 don't show it because this doesn't make sense
								printf("       -|");	//when there are no corrected codewords this value is meaningless
							else					
							{
								if (FEC_corr_cwbin_cnt_A_overrun[t][i/number_of_segments[t]][rsfec_highest_bin_count_A[t][i/number_of_segments[t]] -1 ] == 0)
								printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" , FEC_corr_cwbin_cnt_A[t][i/number_of_segments[t]][rsfec_highest_bin_count_A[t][i/number_of_segments[t]] -1 ]);		  		  	  
								else
									printf(COLOR_CORRECTABLE "    >256" COLOR_RESET "|");											
							}
						}
						else	
							printf("        |");						
					} 
					else
						printf("        |");					
				}			
				else // number_of_segments = 4 or 8 
				{	
					if ( (i % number_of_segments[t]) == 0) 
					{		
						if (rx_am_lock[t][i/number_of_segments[t]] == 1)
						{	
				
						if ((FEC_Correctable_Codeword_Reg_L[t][i/number_of_segments[t]] == 0) || ((rsfec_highest_bin_count_A[t][i/number_of_segments[t]] -1) == 0) ) // if 2nd w.c. bin is bin 0 don't show it because this doesn't make sense
							printf("       -|");
						else
							{
								if (FEC_corr_cwbin_cnt_A_overrun[t][i/number_of_segments[t]][rsfec_highest_bin_count_A[t][i/number_of_segments[t]] -1 ] == 0)
								printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" , FEC_corr_cwbin_cnt_A[t][i/number_of_segments[t]][rsfec_highest_bin_count_A[t][i/number_of_segments[t]] -1 ]);		  		  	  
								else
									printf(COLOR_CORRECTABLE "    >256" COLOR_RESET "|");											
							}
		  
						}
						else
							printf("        |");					
					}
					else if ( (i % number_of_segments[t]) == number_of_segments[t]/2) 
					{	
						if (use_dual_rsfec_codeword[t] == 1)
						{				
							if (rx_am_lock[t][i/number_of_segments[t]] == 1)
							{	
					
							if ((FEC_Correctable_Codeword_Reg_L[t][i/number_of_segments[t]] == 0) || ((rsfec_highest_bin_count_A[t][i/number_of_segments[t]] -1) == 0) ) // if 2nd w.c. bin is bin 0 don't show it because this doesn't make sense
								printf("       -|");
							else
								{
									if (FEC_corr_cwbin_cnt_B_overrun[t][i/number_of_segments[t]][rsfec_highest_bin_count_B[t][i/number_of_segments[t]] -1 ] == 0)
									printf(COLOR_CORRECTABLE "%8d" COLOR_RESET "|" , FEC_corr_cwbin_cnt_B[t][i/number_of_segments[t]][rsfec_highest_bin_count_B[t][i/number_of_segments[t]] -1 ]);		  		  	  
									else
										printf(COLOR_CORRECTABLE "    >256" COLOR_RESET "|");	
								}
			  
							}
							else
								printf("        |");	
						}
						else
							printf("        |");								
					}
					else
						printf("        |");		

				}				

								
			}	
	   } 
	  if (EXTRA_FEC_COMMENTS)		
		printf(" Amount of corrected Codewords in second worst case bin\n");	
	  else
		 printf("\n");
	  

	  
	
     printf("FEC uncorr codeword:|");
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 	
			if (fec_mode[t] == FRACTURED)
			{		  
				if (rx_am_lock[t][i] == 1)
					{		 		  			
				  if (FEC_UnCorrectable_Codeword_Reg_L[t][i] == 0)
					  print_alarm(FEC_UnCorrectable_Codeword_Reg_L[t][i],0);
				  else if (FEC_UnCorrectable_Codeword_Reg_L[t][i] > 99999999)
					 printf(COLOR_ALARM "%.2e" COLOR_RESET "|" , FEC_UnCorrectable_Codeword[t][i]);		  
				  else 
					 printf(COLOR_ALARM "%8d" COLOR_RESET "|" ,FEC_UnCorrectable_Codeword_Reg_L[t][i]);	
				  } 
		  
				 else
					printf("        |");
			 }
			 else
			{		  
				if ( (i % number_of_segments[t]) == 0) 
					{		 		  
					if ((rx_am_lock[t][i/number_of_segments[t]] == 1))
					{		 		  
						  if (FEC_UnCorrectable_Codeword_Reg_L[t][i/number_of_segments[t]] == 0)
							  print_alarm(FEC_UnCorrectable_Codeword_Reg_L[t][i/number_of_segments[t]],0);
						  else if (FEC_UnCorrectable_Codeword_Reg_L[t][i/number_of_segments[t]] > 99999999)
							 printf(COLOR_ALARM "%.2e" COLOR_RESET "|" , FEC_UnCorrectable_Codeword[t][i/number_of_segments[t]]);		  
						  else 
							 printf(COLOR_ALARM "%8d" COLOR_RESET "|" ,FEC_UnCorrectable_Codeword_Reg_L[t][i/number_of_segments[t]]);	   
					} 
				  else 
						printf("        |");
				  } 
		  
				 else
						printf("        |");				
			 }				 
				 
		}	  
     printf("\n");	

     printf("Total Bits         :|");
     for (i = 0; i < number_of_virtual_lanes[t] ; i++)
     { 	
			if (fec_mode[t] == FRACTURED)
			{		  
				if (rx_am_lock[t][i] == 1)
				{		 		  			
					 printf("%.2e|", Totalbits_per_fec[t]);		  
				} 
		  
				 else
					printf("        |");
			 }
			 else
			{		  
				if ( (i % number_of_segments[t]) == 0) 
					{		 		  
					if ((rx_am_lock[t][i/number_of_segments[t]] == 1))
					{		 		  
							printf("%.2e|", Totalbits_per_fec[t]);	  
					} 
				  else 
						printf("        |");
				  } 
		  
				 else
						printf("        |");				
			 }				 
				 
		}	  
     printf("\n");
	  
		
	if (AGGREGATE_FECS == 1)
	{	

     printf("--------------------|");
     for (i = 0; i < number_of_virtual_lanes[t]  ; i++)
     { 
     printf("---------");
     }
     printf("\n");	  
	  
	  
	  printf("Pre corr BER Aggr  :|");		  
		if (rx_am_lock[t][0] == 1)
				{		 		  
			if (Precorrected_BER_Aggr[t] == 0.0)	 
				print_alarm(Precorrected_BER_Aggr[t],0);			
		  else 
			 printf(COLOR_CORRECTABLE "%e" COLOR_RESET  "  (Pre-Corrected Aggregrate BER)",Precorrected_BER_Aggr[t]);   
		  } 
     else
       printf("     ");
	  
     printf("\n");
		
	  printf("SER Aggregate      :|");	
 			
		if (rx_am_lock[t][0] == 1)
				{		 		  	 
			if (Corrected_symbols_rate_Aggr[t] == 0.0)	
				print_alarm(Corrected_symbols_rate_Aggr[t],0);				
		  else
				printf(COLOR_CORRECTABLE "%e" COLOR_RESET "  (Symbol Error Rate Aggregate)",Corrected_symbols_rate_Aggr[t]);         
		  
		  } 			
     else
       printf("     ");

     printf("\n");
	  
	  printf("Total Bits Aggr    :|");	
 			
		if (rx_am_lock[t][0] == 1)
				{		 		  	 
				printf("%e", Totalbits_Aggr[t]);	       
		  
		  } 			
     else
       printf("     ");	 
	  
	  
     printf("\n");	  
	}
	  	
	
}


int determine_channel(int z)
{
int i;
	if (AGGREGATE_FECS == 1)
		i = z*(NUMBER_OF_SEGMENTS/2); //for 2*200GbE this will be 4 when z = 1
	else
		i = z;
return i;
}
	
	
void fec_tree (int phy)
{
  //int m;
  //int store_counter[1000];
  unsigned int FEC_corr_cwbin_cnt_A_total[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX][16];
  unsigned int FEC_corr_cwbin_cnt_B_total[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX][16];  
 

	

printf("\033[2J"); //erase screen 

	if ((fec_mode[phy] == AGGREGATE_200GBE) || (fec_mode[phy] == AGGREGATE_400GBE))
		number_of_fecs[phy] = NUMBER_OF_FECS_PHY;
	else
		number_of_fecs[phy] = number_of_lanes[phy];


			
			
	int fd = fileno(stdin);
	
	//set stdin non-blocking
	
	int flags = fcntl(fd, F_GETFL, 0);
	//printf("\nflags : 0x%x\n",flags);
	fcntl(fd, F_SETFL, flags | O_NONBLOCK);	

	clear_counters(phy);

//Initialize FEC_corr_cwbin_cnt_A_total and FEC_corr_cwbin_cnt_B_total
	
   for (i = 0; i < number_of_fecs[phy] ; i++)
   {	

		  for (k = 0; k < 16; k++)
		  {
			FEC_corr_cwbin_cnt_A[phy][i][k]		 = 0;
			FEC_corr_cwbin_cnt_B[phy][i][k]		 = 0;					
			FEC_corr_cwbin_cnt_A_total[phy][i][k] =  0;
			FEC_corr_cwbin_cnt_B_total[phy][i][k] =  0;
			FEC_corr_cwbin_cnt_A_overrun[phy][i][k] = 0;
			FEC_corr_cwbin_cnt_B_overrun[phy][i][k] = 0;	
		  }
	}	
	
	//start loop
	do
	{		


	printf("\033[H");	

	TimeInterval = 1 * 100000;
  
	usleep(TimeInterval);
			
   for (z = 0; z < number_of_fecs[phy] ; z++)
   {	

		i = determine_channel(z); // for 2x200GbE i will return 4 when z = 1
	
	  //Issue a FEC shadow request	
	  for (j = 0; j < number_of_segments[phy] ; j++)
		{
			fec_shadow_request(phy,i,ethernet_mode[phy],j);	
		}
	  
		
		  //These are statistics per fec (not per segment)
		  if (number_of_segments[phy] <= 2)
		  {
		  FEC_UnCorrectable_Codeword_Reg_L[phy][z] 		= Read_FEC_uncorr_codeword_Reg_L(phy,i,ethernet_mode[phy],0);	
		  FEC_UnCorrectable_Codeword_Reg_H[phy][z] 		= Read_FEC_uncorr_codeword_Reg_H(phy,i,ethernet_mode[phy],0);		  
			  
		  rsfec_corr_cwbin_cnt_0_3_A[phy][z]				= Read_FEC_rsfec_corr_cwbin_cnt_0_3(phy,i,ethernet_mode[phy],0);	
		  rsfec_corr_cwbin_cnt_4_7_A[phy][z]				= Read_FEC_rsfec_corr_cwbin_cnt_4_7(phy,i,ethernet_mode[phy],0);	
		  rsfec_corr_cwbin_cnt_8_11_A[phy][z]				= Read_FEC_rsfec_corr_cwbin_cnt_8_11(phy,i,ethernet_mode[phy],0);	
		  rsfec_corr_cwbin_cnt_12_15_A[phy][z]				= Read_FEC_rsfec_corr_cwbin_cnt_12_15(phy,i,ethernet_mode[phy],0);
		  }
		  else
		  {
		  FEC_UnCorrectable_Codeword_Reg_L[phy][z] 		= Read_FEC_uncorr_codeword_Reg_L(phy,i,ethernet_mode[phy],0) + Read_FEC_uncorr_codeword_Reg_L(phy,i,ethernet_mode[phy],ethernet_mode_segment[phy]);	
		  FEC_UnCorrectable_Codeword_Reg_H[phy][z] 		= Read_FEC_uncorr_codeword_Reg_H(phy,i,ethernet_mode[phy],0) + Read_FEC_uncorr_codeword_Reg_H(phy,i,ethernet_mode[phy],ethernet_mode_segment[phy]);	
		  
/* Code to measure bin1 acquisition time

		  printf("\033[2J"); //erase screen
		  printf("\033[H");	
		  printf("\nSet trigger");
		  //rx_char = input_char();
		  FEC_corr_cwbin_cnt_A_overrun[phy][i][1] = 0;				  
		  timestamp1 = clock();		
  
			for (m = 0;m<1000;m++)
			{
				fec_shadow_request(phy,i,ethernet_mode[phy],0);					
				rsfec_corr_cwbin_cnt_0_3_A[phy][z]				= Read_FEC_rsfec_corr_cwbin_cnt_0_3(phy,i,ethernet_mode[phy],0);	
				fec_clear_shadow_request(phy,i,ethernet_mode[phy],0);		
				
				previous_FEC_corr_cwbin_cnt_A[phy][i][1] =  FEC_corr_cwbin_cnt_A[phy][i][1];
				FEC_corr_cwbin_cnt_A[phy][i][1]		= (rsfec_corr_cwbin_cnt_0_3_A[phy][i] >> 8) & (0x0000000FF);
				store_counter[m] = FEC_corr_cwbin_cnt_A[phy][i][1];
				if (FEC_corr_cwbin_cnt_A[phy][i][1] < previous_FEC_corr_cwbin_cnt_A[phy][i][1]) // detect overrun
				{
					FEC_corr_cwbin_cnt_A_overrun[phy][i][1] = 1; // if overrun highlight in red
					//printf("\n!!!!! OVERRUN ");
					FEC_corr_cwbin_cnt_A_total[phy][i][1] += ((256 + FEC_corr_cwbin_cnt_A[phy][i][1]) - previous_FEC_corr_cwbin_cnt_A[phy][i][1]);										
				}
				else if (FEC_corr_cwbin_cnt_A[phy][i][1] > previous_FEC_corr_cwbin_cnt_A[phy][i][1])			
					FEC_corr_cwbin_cnt_A_total[phy][i][1] += (FEC_corr_cwbin_cnt_A[phy][i][1] - previous_FEC_corr_cwbin_cnt_A[phy][i][1]);		
					
			}
						timestamp2 = clock();
						time_taken[0] = ((double) timestamp2 - (double) timestamp1)/(CLOCKS_PER_SEC/1000); // in milliseconds
						//time_taken[0] = ((double) timestamp2 - (double) timestamp1); 

		 printf("\nRead time for 100000 accesses :%d milliseconds",(int)time_taken[0]);
		 printf("\nOverrun : %d",FEC_corr_cwbin_cnt_A_overrun[phy][i][1]);
		 printf("\nFEC_corr_cwbin_cnt_A_total[phy][i][1] %d",FEC_corr_cwbin_cnt_A_total[phy][i][1]);
			for (m = 0;m<1000;m++)
			{
					printf("\nFEC_corr_cwbin_cnt_A[phy][i][1] : %d", store_counter[m]);
			}
		  
		  rx_char = input_char();
		  
		  */
		  
		  rsfec_corr_cwbin_cnt_0_3_A[phy][z]				= Read_FEC_rsfec_corr_cwbin_cnt_0_3(phy,i,ethernet_mode[phy],0);	
		  rsfec_corr_cwbin_cnt_0_3_B[phy][z]				= Read_FEC_rsfec_corr_cwbin_cnt_0_3(phy,i,ethernet_mode[phy],ethernet_mode_segment[phy]);		  
		  rsfec_corr_cwbin_cnt_4_7_A[phy][z]				= Read_FEC_rsfec_corr_cwbin_cnt_4_7(phy,i,ethernet_mode[phy],0);	
		  rsfec_corr_cwbin_cnt_4_7_B[phy][z]				= Read_FEC_rsfec_corr_cwbin_cnt_4_7(phy,i,ethernet_mode[phy],ethernet_mode_segment[phy]);			  
		  rsfec_corr_cwbin_cnt_8_11_A[phy][z]				= Read_FEC_rsfec_corr_cwbin_cnt_8_11(phy,i,ethernet_mode[phy],0);	
		  rsfec_corr_cwbin_cnt_8_11_B[phy][z]				= Read_FEC_rsfec_corr_cwbin_cnt_8_11(phy,i,ethernet_mode[phy],ethernet_mode_segment[phy]);			  
		  rsfec_corr_cwbin_cnt_12_15_A[phy][z]				= Read_FEC_rsfec_corr_cwbin_cnt_12_15(phy,i,ethernet_mode[phy],0);
		  rsfec_corr_cwbin_cnt_12_15_B[phy][z]				= Read_FEC_rsfec_corr_cwbin_cnt_12_15(phy,i,ethernet_mode[phy],ethernet_mode_segment[phy]);	  
		  }			  

 
  
  //Clear shadow request	  
	  for (j = 0; j < number_of_segments[phy] ; j++)
		{
			fec_clear_shadow_request(phy,i,ethernet_mode[phy],j);	
		}
	}

	//read out registers	
	for (i = 0; i < number_of_lanes[phy] ; i++)
	{  

   Channel_Reg[phy][i]      =  Read_Channel_Reg(phy,i);	
	rx_am_lock_alarm[phy][i]   = 0x0001 & (Channel_Reg[phy][i] >> 4);	
	
	#ifdef RX_AM_LOCK_ALARM_COUNTER_ENABLED
			rx_am_lock_alarm_count[phy][i] = (Read_PrbsLock_Alarm_Reg(phy,i) >> 16) & (0xFFFF);	
	#endif	
	}

   for (i = 0; i < number_of_fecs[phy] ; i++)
   {

		FEC_UnCorrectable_Codeword[phy][i] = ((double)(FEC_UnCorrectable_Codeword_Reg_H[phy][i]) *  MULTIPLIER * MULTIPLIER) + (double) (FEC_UnCorrectable_Codeword_Reg_L[phy][i]);	
		
		  //store previous counters
		  
		  for (k = 0; k < 16; k++)
		  {
			previous_FEC_corr_cwbin_cnt_A[phy][i][k] =  FEC_corr_cwbin_cnt_A[phy][i][k];
		  }

		  FEC_corr_cwbin_cnt_A[phy][i][0]	= rsfec_corr_cwbin_cnt_0_3_A[phy][i] & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[phy][i][1]	= (rsfec_corr_cwbin_cnt_0_3_A[phy][i] >> 8) & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[phy][i][2]	= (rsfec_corr_cwbin_cnt_0_3_A[phy][i] >> 16) & (0x0000000FF);		  
		  FEC_corr_cwbin_cnt_A[phy][i][3]	= (rsfec_corr_cwbin_cnt_0_3_A[phy][i] >> 24) & (0x0000000FF);		
		  FEC_corr_cwbin_cnt_A[phy][i][4]	= rsfec_corr_cwbin_cnt_4_7_A[phy][i] & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[phy][i][5]	= (rsfec_corr_cwbin_cnt_4_7_A[phy][i] >> 8) & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[phy][i][6]	= (rsfec_corr_cwbin_cnt_4_7_A[phy][i] >> 16) & (0x0000000FF);		  
		  FEC_corr_cwbin_cnt_A[phy][i][7]	= (rsfec_corr_cwbin_cnt_4_7_A[phy][i] >> 24) & (0x0000000FF);		
		  FEC_corr_cwbin_cnt_A[phy][i][8]	= rsfec_corr_cwbin_cnt_8_11_A[phy][i] & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[phy][i][9]	= (rsfec_corr_cwbin_cnt_8_11_A[phy][i] >> 8) & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[phy][i][10]	= (rsfec_corr_cwbin_cnt_8_11_A[phy][i] >> 16) & (0x0000000FF);		  
		  FEC_corr_cwbin_cnt_A[phy][i][11]	= (rsfec_corr_cwbin_cnt_8_11_A[phy][i] >> 24) & (0x0000000FF);	
		  FEC_corr_cwbin_cnt_A[phy][i][12]	= rsfec_corr_cwbin_cnt_12_15_A[phy][i] & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[phy][i][13]	= (rsfec_corr_cwbin_cnt_12_15_A[phy][i] >> 8) & (0x0000000FF);
		  FEC_corr_cwbin_cnt_A[phy][i][14]	= (rsfec_corr_cwbin_cnt_12_15_A[phy][i] >> 16) & (0x0000000FF);		  
		  FEC_corr_cwbin_cnt_A[phy][i][15]	= (rsfec_corr_cwbin_cnt_12_15_A[phy][i] >> 24) & (0x0000000FF);	
		  
		  for (k = 0; k < 16; k++)
		  {
			if (FEC_corr_cwbin_cnt_A[phy][i][k] < previous_FEC_corr_cwbin_cnt_A[phy][i][k]) // detect overrun
			{
				FEC_corr_cwbin_cnt_A_overrun[phy][i][k] = 1; // if overrun highlight in red
				//printf("\n!!!!! OVERRUN ");
				FEC_corr_cwbin_cnt_A_total[phy][i][k] += ((256 + FEC_corr_cwbin_cnt_A[phy][i][k]) - previous_FEC_corr_cwbin_cnt_A[phy][i][k]);										
			}
			else if (FEC_corr_cwbin_cnt_A[phy][i][k] > previous_FEC_corr_cwbin_cnt_A[phy][i][k])			
				FEC_corr_cwbin_cnt_A_total[phy][i][k] += (FEC_corr_cwbin_cnt_A[phy][i][k] - previous_FEC_corr_cwbin_cnt_A[phy][i][k]);						
		  }		  

				
			if (number_of_segments[phy] > 2)
			{

			  for (k = 0; k < 16; k++)
			  {
				previous_FEC_corr_cwbin_cnt_B[phy][i][k] =  FEC_corr_cwbin_cnt_B[phy][i][k];
			  }
		  
			  FEC_corr_cwbin_cnt_B[phy][i][0]	= rsfec_corr_cwbin_cnt_0_3_B[phy][i] & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[phy][i][1]	= (rsfec_corr_cwbin_cnt_0_3_B[phy][i] >> 8) & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[phy][i][2]	= (rsfec_corr_cwbin_cnt_0_3_B[phy][i] >> 16) & (0x0000000FF);		  
			  FEC_corr_cwbin_cnt_B[phy][i][3]	= (rsfec_corr_cwbin_cnt_0_3_B[phy][i] >> 24) & (0x0000000FF);		
			  FEC_corr_cwbin_cnt_B[phy][i][4]	= rsfec_corr_cwbin_cnt_4_7_B[phy][i] & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[phy][i][5]	= (rsfec_corr_cwbin_cnt_4_7_B[phy][i] >> 8) & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[phy][i][6]	= (rsfec_corr_cwbin_cnt_4_7_B[phy][i] >> 16) & (0x0000000FF);		  
			  FEC_corr_cwbin_cnt_B[phy][i][7]	= (rsfec_corr_cwbin_cnt_4_7_B[phy][i] >> 24) & (0x0000000FF);		
			  FEC_corr_cwbin_cnt_B[phy][i][8]	= rsfec_corr_cwbin_cnt_8_11_B[phy][i] & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[phy][i][9]	= (rsfec_corr_cwbin_cnt_8_11_B[phy][i] >> 8) & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[phy][i][10]	= (rsfec_corr_cwbin_cnt_8_11_B[phy][i] >> 16) & (0x0000000FF);		  
			  FEC_corr_cwbin_cnt_B[phy][i][11]	= (rsfec_corr_cwbin_cnt_8_11_B[phy][i] >> 24) & (0x0000000FF);	
			  FEC_corr_cwbin_cnt_B[phy][i][12]	= rsfec_corr_cwbin_cnt_12_15_B[phy][i] & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[phy][i][13]	= (rsfec_corr_cwbin_cnt_12_15_B[phy][i] >> 8) & (0x0000000FF);
			  FEC_corr_cwbin_cnt_B[phy][i][14]	= (rsfec_corr_cwbin_cnt_12_15_B[phy][i] >> 16) & (0x0000000FF);		  
			  FEC_corr_cwbin_cnt_B[phy][i][15]	= (rsfec_corr_cwbin_cnt_12_15_B[phy][i] >> 24) & (0x0000000FF);	
			  
			  for (k = 0; k < 16; k++)
			  {
				if (FEC_corr_cwbin_cnt_B[phy][i][k] < previous_FEC_corr_cwbin_cnt_B[phy][i][k]) // detect overrun
				{
					FEC_corr_cwbin_cnt_B_overrun[phy][i][k] = 1; // if overrun highlight in red
					FEC_corr_cwbin_cnt_B_total[phy][i][k] += ((256 + FEC_corr_cwbin_cnt_B[phy][i][k]) - previous_FEC_corr_cwbin_cnt_B[phy][i][k]);										
					//printf("\n!!!!! OVERRUN");
				}
				else if (FEC_corr_cwbin_cnt_B[phy][i][k] > previous_FEC_corr_cwbin_cnt_B[phy][i][k])
					FEC_corr_cwbin_cnt_B_total[phy][i][k] += (FEC_corr_cwbin_cnt_B[phy][i][k] - previous_FEC_corr_cwbin_cnt_B[phy][i][k]);						
					
			  }				
				
			}
	} //i	
			//printout fec tree
			
		Counter_1ms_Reg[phy] = read_counter_1ms_reg(phy); 
		Hours[phy] =  Counter_1ms_Reg[phy] / NUMBER_OF_MS_PER_HOUR ;
		Minutes[phy] = (Counter_1ms_Reg[phy] - (Hours[phy] * NUMBER_OF_MS_PER_HOUR))/NUMBER_OF_MS_PER_MINUTE;
		Seconds[phy] = (Counter_1ms_Reg[phy] - (Hours[phy] * NUMBER_OF_MS_PER_HOUR) - (Minutes[phy] * NUMBER_OF_MS_PER_MINUTE)) / NUMBER_OF_MS_PER_SECOND;		 

		  printf("\nFec Error Tree Phy %1d",phy);
		  printf("\nPress 's' + enter to stop");
		  printf("\n==========================");
        printf("\nTime               :|%2dh:%2dm:%2ds",Hours[phy],Minutes[phy],Seconds[phy]);                 
		  printf("\n\n");
		  
		if (AGGREGATE_FECS == 1)
		{
		  printf("FEC identifier     :|");					  
		  for (i = 0; i < number_of_virtual_lanes[phy] ; i++)
		  { 
			  		
				if ( (i % number_of_segments[phy]) == ((number_of_segments[phy]/2)-1)) 
				{			 
					switch (i/number_of_segments[phy])
					{
						case 0 : printf(COLOR_LIGHT_BLUE COLOR_INVERSE "       0 " COLOR_RESET);break;
						case 1 : printf(COLOR_LIGHT_CYAN COLOR_INVERSE "       1 " COLOR_RESET);break;
						case 2 : printf(COLOR_BLUE COLOR_INVERSE "       2 " COLOR_RESET);break;
						case 3 : printf(COLOR_LIGHT_RED COLOR_INVERSE "       3 " COLOR_RESET);break;						
						default : break;
					}			
				}
				else
					switch (i/number_of_segments[phy])
					{
						case 0 : printf(COLOR_LIGHT_BLUE COLOR_INVERSE "         " COLOR_RESET);break;
						case 1 : printf(COLOR_LIGHT_CYAN COLOR_INVERSE "         " COLOR_RESET);break;
						case 2 : printf(COLOR_BLUE COLOR_INVERSE "         " COLOR_RESET);break;
						case 3 : printf(COLOR_LIGHT_RED COLOR_INVERSE "         " COLOR_RESET);break;						
						default : break;
					}

		  }
		}
		
		  printf("\nChannel            :|");		  
		  for (i = 0; i < number_of_virtual_lanes[phy] ; i++)
		  { 
			  
			if (fec_mode[phy] == FRACTURED)	
				 printf("%8d|",i);		
			else
			{
				
				if ( (i % number_of_segments_lane[phy]) == 0) 
				{			 
						printf("%8d|",i/number_of_segments_lane[phy]);
				}
				else
						printf("        |");	
			}

		  }
		  printf("\n");		  
		  
		  if (pma_direct_mode[phy] == 0)
		  {

			  printf("Segment            :|");
			  
			  for (i = 0; i < number_of_virtual_lanes[phy] ; i++)
			  { 
				// if ((fec_mode[phy] == AGGREGATE_200GBE) || (fec_mode[phy] == AGGREGATE_400GBE))
					// printf("%8d|",i);
				// else
					printf("%8d|",(i % number_of_segments[phy]));		  

			  }
			  printf("\n");
		  }

    printf("                    |");
     for (i = 0; i < number_of_virtual_lanes[phy] ; i++)
     { 
     printf("--------|");
     }
     printf("\n");
		  printf("Transceiver Type   :|");
		  for (i = 0; i < number_of_virtual_lanes[phy] ; i++)
		  { 
			  
			if (fec_mode[phy] == FRACTURED)	
			{
				if (FHT_USED)
					printf("     FHT|");
				else
					printf("     FGT|");
			}
			else
			{
				
				if ( (i % number_of_segments_lane[phy]) == 0) 
				{			 
					if (FHT_USED)
						printf("     FHT|");
					else
						printf("     FGT|");
				}
				else
						printf("        |");	
			}

		  }
		  printf("\n");
		  
		  if (FHT_USED == 0)				
			{			
			  printf("FGT Quad           :|");		  
			  for (i = 0; i < number_of_virtual_lanes[phy] ; i++)
			  { 
				  
				if (fec_mode[phy] == FRACTURED)	
				{
						printf("%8d|",FGT_Quad[phy][i]);
				}
				else
				{
					
					if ( (i % number_of_segments_lane[phy]) == 0) 
					{			 
						printf("%8d|",FGT_Quad[phy][i/number_of_segments_lane[phy]]);
					}
					else
							printf("        |");	
				}

			  }
			  printf("\n");
			}
			
		


			

		if (FHT_USED == 1)
			printf("FHT Lane           :|");		
		else
		   printf("FGT Lane           :|");	
		
	  
		  for (i = 0; i < number_of_virtual_lanes[phy] ; i++)
		  { 
			  
			if (fec_mode[phy] == FRACTURED)	
			{
					printf("%8d|",Quad_Channel[phy][i]);
			}
			else
			{
				
				if ( (i % number_of_segments_lane[phy]) == 0) 
				{			 
					printf("%8d|",Quad_Channel[phy][i/number_of_segments_lane[phy]]);
				}
				else
						printf("        |");	
			}

		  }
		  printf("\n");		  
		 
			  

     printf("Native Phy Mode    :|");   	  
     for (i = 0; i < number_of_virtual_lanes[phy] ; i++)
     { 
 	if (pma_direct_mode[phy] == 0)
	{
		  if (fec_mode[phy] == FRACTURED)
		  {		  
       	printf("FEC-FRAC|");
		  }
		  else if (fec_mode[phy] == FRACTURED_50GBE)
		   {
				if ( (i % number_of_segments[phy]) == 0) 
				{			 
					printf("FEC-50GE|");
				}
				else
					printf("        |");
			}
		  else if (fec_mode[phy] == FRACTURED_100GBE)
		   {
				if ( (i % number_of_segments_lane[phy]) == 0) 
				{			 
					printf("FEC100GE|");
				}
				else				
					printf("        |");
			}		
		  else if (fec_mode[phy] == AGGREGATE_200GBE)
		   {
				if ( (i % number_of_segments_lane[phy]) == 0) 
				{			 
					printf("AGG200GE|");
				}
				else
					printf("        |");
			}	
		  else if (fec_mode[phy] == AGGREGATE_400GBE)
		   {
				if ( (i % number_of_segments_lane[phy]) == 0) 
				{			 
					printf("AGG400GE|");
				}
				else
					printf("        |");
			}				
			else
					printf("        |");				
	}
	else
	{
		  if (pam4_mode[phy] == 0)
				printf(" PMA-DIR|");
		  else
				printf("PAM4-DIR|");			   
	}
					  
     }
     printf("\n");		  
 	if (pma_direct_mode[phy] == 0)
	{
     printf("FEC configuration  :|");	   	  
     for (i = 0; i < number_of_virtual_lanes[phy] ; i++)
     { 
		  if (fec_mode[phy] == FRACTURED)
		  {		
			if (kpfec[phy] == 0)  
				printf(" 528,514|"); 
			else
				printf(" 544,514|"); 				 

		  }
		  else
		  {
				if ( (i % number_of_segments_lane[phy]) == 0) 
				{			 
						printf(" 544,514|");  
				}
				else
						printf("        |");
			}
					  
     }
     printf("\n");
  }		  

     printf("RSFEC Locked       :|");

     for (i = 0; i < number_of_virtual_lanes[phy] ; i++)
     {   
  
  		  if (fec_mode[phy] == FRACTURED)
		  {
				print_alarm(rx_am_lock[phy][i],1);
		  }
		  else
		  {
				if ( (i % number_of_segments[phy]) == 0) 
					print_alarm(rx_am_lock[phy][i/number_of_segments[phy]],1);
				else
					printf("        |");
		  }	
		  
     }
     printf("\n");

	  if (RX_AM_LOCK_ALARM_COUNTER_USED == 1)
	  {	  
     printf("Rx AM Lock Alarm   :|");	  

     for (i = 0; i < number_of_virtual_lanes[phy] ; i++)
     {		  		  

  		  if (fec_mode[phy] == FRACTURED)
     {		  		  

				 if (rx_am_lock_alarm[phy][i] == 1)
					printf(COLOR_RED COLOR_INVERSE "     SET" COLOR_RESET "|");
				 else
					printf("        |");					
				}
		  else
		  {
				if ( (i % number_of_segments_lane[phy]) == 0) 
				{
					if (rx_am_lock_alarm[phy][i/number_of_segments_lane[phy]] == 1)
						printf(COLOR_RED COLOR_INVERSE "     SET" COLOR_RESET "|");
					else
						printf("        |");	 	
				}
				else
					printf("        |");
		  }
		  
	
		}

     printf("\n");
	  }

	  if (RX_AM_LOCK_ALARM_COUNTER_USED == 1)
	  {
      printf("AM Lock Alarm Count:|");		  
     for (i = 0; i < number_of_virtual_lanes[phy] ; i++)
     {		  		  

  		  if (fec_mode[phy] == FRACTURED)
     {		  		  

				 if (rx_am_lock_alarm[phy][i] == 1)
					printf( COLOR_ALARM "%8d" COLOR_RESET "|" ,rx_am_lock_alarm_count[phy][i]);  
				 else
					printf("        |");					
				}
		  else
		  {
				if ( (i % number_of_segments_lane[phy]) == 0) 
				{
					if (rx_am_lock_alarm[phy][i/number_of_segments_lane[phy]] == 1)
						printf( COLOR_ALARM "%8d" COLOR_RESET "|" ,rx_am_lock_alarm_count[phy][i/number_of_segments_lane[phy]]); 
					else
						printf("        |");	 	
				}
				else
					printf("        |");
		  }
		  
	
		}

     printf("\n");
	  }

     printf("FEC uncorr codeword:|");
     for (i = 0; i < number_of_virtual_lanes[phy] ; i++)
     { 	
			if (fec_mode[phy] == FRACTURED)
			{		  
				if (rx_am_lock[phy][i] == 1)
					{		 		  			
				  if (FEC_UnCorrectable_Codeword_Reg_L[phy][i] == 0)
					  print_alarm(FEC_UnCorrectable_Codeword_Reg_L[phy][i],0);
				  else if (FEC_UnCorrectable_Codeword_Reg_L[phy][i] > 99999999)
					 printf(COLOR_ALARM "%.2e" COLOR_RESET "|" , FEC_UnCorrectable_Codeword[phy][i]);		  
				  else 
					 printf(COLOR_ALARM "%8d" COLOR_RESET "|" ,FEC_UnCorrectable_Codeword_Reg_L[phy][i]);	
				  } 
		  
				 else
					printf("        |");
			 }
			 else
			{		  
				if ( (i % number_of_segments[phy]) == 0) 
					{		 		  
					if ((rx_am_lock[phy][i/number_of_segments[phy]] == 1))
					{		 		  
						  if (FEC_UnCorrectable_Codeword_Reg_L[phy][i/number_of_segments[phy]] == 0)
							  print_alarm(FEC_UnCorrectable_Codeword_Reg_L[phy][i/number_of_segments[phy]],0);
						  else if (FEC_UnCorrectable_Codeword_Reg_L[phy][i/number_of_segments[phy]] > 99999999)
							 printf(COLOR_ALARM "%.2e" COLOR_RESET "|" , FEC_UnCorrectable_Codeword[phy][i/number_of_segments[phy]]);		  
						  else 
							 printf(COLOR_ALARM "%8d" COLOR_RESET "|" ,FEC_UnCorrectable_Codeword_Reg_L[phy][i/number_of_segments[phy]]);	   
					} 
				  else 
						printf("        |");
				  } 
		  
				 else
						printf("        |");				
			 }				 
				 
		}	  
     printf("\n");	
	  
	  

     printf("                    |");
     for (i = 0; i < number_of_virtual_lanes[phy] ; i++)
     { 
     printf("--------|");
     }
	  
	for (k = 0; k < 16; k++)
	{
		if (k == 0)
			printf("\n#CW without errors :|");	
		else
			printf("\n#CW with %2d CS     :|",k);		
	
		for (i = 0; i < number_of_virtual_lanes[phy] ; i++)
		{ 

			if (fec_mode[phy] == FRACTURED)
			{	  
				if (rx_am_lock[phy][i] == 1)
				{	
		
			  //printf("\nrsfec_highest_bin_count[%d][%d] = %d",t,i,rsfec_highest_bin_count[phy][i]);	
				  if (FEC_corr_cwbin_cnt_A_total[phy][i][k] == 0)
					  print_alarm(FEC_corr_cwbin_cnt_A_total[phy][i][k],0);
				  else
				  {
						if (FEC_corr_cwbin_cnt_A_overrun[phy][i][k] == 0)
							print_stat_unsigned_correctable(FEC_corr_cwbin_cnt_A_total[phy][i][k]);
						else
							print_stat_unsigned_alarm(FEC_corr_cwbin_cnt_A_total[phy][i][k]);
					}	
				}

			else
				printf("        |");
			}
			else
			{	 
				if (number_of_segments[phy] == 2)
				{
					if ( (i % number_of_segments[phy]) == 0) 
					{		
						if (rx_am_lock[phy][i/number_of_segments[phy]] == 1)
						{	
				
							if (FEC_corr_cwbin_cnt_A_total[phy][i/number_of_segments[phy]][k] == 0)
								print_alarm(FEC_corr_cwbin_cnt_A_total[phy][i/number_of_segments[phy]][k],0);
							else
							{
								if (FEC_corr_cwbin_cnt_A_overrun[phy][i/number_of_segments[phy]][k] == 0)	
									print_stat_unsigned_correctable(FEC_corr_cwbin_cnt_A_total[phy][i/number_of_segments[phy]][k]);
								else
									print_stat_unsigned_alarm(FEC_corr_cwbin_cnt_A_total[phy][i/number_of_segments[phy]][k]);
							}
		  
						}
						else
							printf("        |");					
					}
					else
					{
						if (rx_am_lock[phy][i/number_of_segments[phy]] == 1)
						{	
							print_bar_tree((FEC_corr_cwbin_cnt_A_total[phy][i/number_of_segments[phy]][k]));

						}
						else
							printf("        |");						
					}
				}
				else // number_of_segments = 4 or 8 
				{	
					if ( (i % number_of_segments[phy]) == 0) 
					{		
						if (rx_am_lock[phy][i/number_of_segments[phy]] == 1)
						{	
					
							if (FEC_corr_cwbin_cnt_A_total[phy][i/number_of_segments[phy]][k] == 0)
								print_alarm(FEC_corr_cwbin_cnt_A_total[phy][i/number_of_segments[phy]][k],0);
							else
							{
								if (FEC_corr_cwbin_cnt_A_overrun[phy][i/number_of_segments[phy]][k] == 0)								
									print_stat_unsigned_correctable(FEC_corr_cwbin_cnt_A_total[phy][i/number_of_segments[phy]][k]);
								else
									print_stat_unsigned_alarm(FEC_corr_cwbin_cnt_A_total[phy][i/number_of_segments[phy]][k]);
							}
						}
						else
							printf("        |");					
					}
					else if ( (i % number_of_segments[phy]) == 1) 
					{
						if (rx_am_lock[phy][i/number_of_segments[phy]] == 1)
						{						
							print_bar_tree((FEC_corr_cwbin_cnt_A_total[phy][i/number_of_segments[phy]][k]));

						}
						else
							printf("        |");							
					}
					else if  ((i % number_of_segments[phy]) == number_of_segments[phy]/2)						
					{	
						if (use_dual_rsfec_codeword[phy] == 1)
						{
							if (rx_am_lock[phy][i/number_of_segments[phy]] == 1)
							{	
					
								if (FEC_corr_cwbin_cnt_B_total[phy][i/number_of_segments[phy]][k] == 0)
									print_alarm(FEC_corr_cwbin_cnt_B_total[phy][i/number_of_segments[phy]][k],0);
								else
								{
									if (FEC_corr_cwbin_cnt_B_overrun[phy][i/number_of_segments[phy]][k] == 0)
										print_stat_unsigned_correctable(FEC_corr_cwbin_cnt_B_total[phy][i/number_of_segments[phy]][k]);
									else
										print_stat_unsigned_alarm(FEC_corr_cwbin_cnt_B_total[phy][i/number_of_segments[phy]][k]);
								}
							}
							else
								printf("        |");										
						}
						else
							printf("        |");					
					}
					else if  ((i % number_of_segments[phy]) == ((number_of_segments[phy]/2)+1))
					{
						if (use_dual_rsfec_codeword[phy] == 1)
						{						
							if (rx_am_lock[phy][i/number_of_segments[phy]] == 1)
							{						
								print_bar_tree((FEC_corr_cwbin_cnt_B_total[phy][i/number_of_segments[phy]][k]));

							}
							else
							printf("        |");					
						}
						else
							printf("        |");										
					}
					else
							printf("        |");		

				}				
			}

			} //i
			
		if (k == 0)
		{
		if (EXTRA_FEC_COMMENTS)
			printf(" This is just to show activity as the read is too slow");
		}
		if (k == 15)
		{
			printf("\n\nNote that if a count is indicated in red it means that counter has experienced at least one overrun");
			printf("\nIf only one overrun has occurred the value is correct");
			printf("\nCW = CodeWord, CS = Corrected Symbols");
		}
	  } //k   printout

		

			//Check if enter is pressed	
                                                 
			char c;

				
			c = getchar();
		   d = (c);

			if (c == 's')
				{
					printf("\033[2J"); //erase screen

					// for (i = 0; i < number_of_fecs[phy] ; i++)
					// {					
					  // for (k = 0; k < 16; k++)
					  // {
						// printf("\nFEC_corr_cwbin_cnt_A[%d][%d][%d] = %d",phy,i,k,FEC_corr_cwbin_cnt_A[phy][i][k]);					
					  // }
					  // for (k = 0; k < 16; k++)
					  // {
						// printf("\nFEC_corr_cwbin_cnt_B[%d][%d][%d] = %d",phy,i,k,FEC_corr_cwbin_cnt_B[phy][i][k]);					
					  // }			  
					// }
					break;

				}

	  
 } while (1);
		  
		  //set stdin blocking again
		  fcntl(fd, F_SETFL, flags);
		  
        
        printf("\n Stopped\n");	
	
}
	


					
#endif

void program_tx_pma_settings_fht(int phy, int channel, int offsephy,int mute)
{

	if (mute == 0)
	{
		rmw_channel_ftile (phy, channel, offset[phy],0x45080, 0x00000001 , 0x0  	);	//set bit[0] to 1'b0 to change coefficients (works also without setting this ...)
		rmw_channel_ftile (phy, channel, offset[phy],0x45080, 0x000000FC , fht_tx_pretap_2[phy][channel] << 2  	);	
		rmw_channel_ftile (phy, channel, offset[phy],0x45080, 0x00003F00 , fht_tx_pretap_1[phy][channel] << 8  	);	
		//rmw_channel_ftile (phy, channel, offset[phy],0x45080, 0x00003F00 , (60+i) << 8  	);	//(useful for debug)
		rmw_channel_ftile (phy, channel, offset[phy],0x45080, 0x001FC000 , fht_tx_maintap[phy][channel] << 14  	);	
		//rmw_channel_ftile (phy, channel, offset[phy],0x45080, 0x001FC000 , (30+i) << 14  	);					 //(useful for debug to have every lane a different VOD)
		rmw_channel_ftile (phy, channel, offset[phy],0x45080, 0x07E00000 , fht_tx_posttap_1[phy][channel] << 21 	);
		
		rmw_channel_ftile (phy, channel, offset[phy],0x45084, 0x0000003F , fht_tx_posttap_2[phy][channel] << 0  	);
		//rmw_channel_ftile (phy, channel, offset[phy],0x45084, 0x0000003F , (60+i) << 0  	);	//(useful for debug)
		rmw_channel_ftile (phy, channel, offset[phy],0x45084, 0x00000FC0 , fht_tx_posttap_3[phy][channel] << 6  	);	
		rmw_channel_ftile (phy, channel, offset[phy],0x45084, 0x0003F000 , fht_tx_posttap_4[phy][channel] << 12  );	
		rmw_channel_ftile (phy, channel, offset[phy],0x45084, 0x00FC0000 , fht_tx_pretap_3[phy][channel] << 18  	);	
		rmw_channel_ftile (phy, channel, offset[phy],0x45080, 0x00000001 , 0x1  	);		//set bit[0] to 1'b1 to update coefficients		
	}
	else
	{
		rmw_channel_ftile (phy, channel, offset[phy],0x45080, 0x00000001 , 0x0  		);	//set bit[0] to 1'b0 to change coefficients (works also without setting this ...)
		rmw_channel_ftile (phy, channel, offset[phy],0x45080, 0x000000FC , 0x0 << 2  	);	
		rmw_channel_ftile (phy, channel, offset[phy],0x45080, 0x00003F00 , 0x0 << 8  	);	
		rmw_channel_ftile (phy, channel, offset[phy],0x45080, 0x001FC000 , 0x0 << 14  );	
		rmw_channel_ftile (phy, channel, offset[phy],0x45080, 0x07E00000 , 0x0 << 21 	);	
		rmw_channel_ftile (phy, channel, offset[phy],0x45084, 0x0000003F , 0x0 << 0  	);
		rmw_channel_ftile (phy, channel, offset[phy],0x45084, 0x00000FC0 , 0x0 << 6  	);	
		rmw_channel_ftile (phy, channel, offset[phy],0x45084, 0x0003F000 , 0x0 << 12  );	
		rmw_channel_ftile (phy, channel, offset[phy],0x45084, 0x00FC0000 , 0x0 << 18  );	
		rmw_channel_ftile (phy, channel, offset[phy],0x45080, 0x00000001 , 0x1  		);		//set bit[0] to 1'b1 to update coefficients		
	}	

}

unsigned int set_bit(unsigned int data, int bitpos)
{
unsigned int temp;

	temp = data | (0x1 << bitpos);	
	return(temp);
}

unsigned int clear_bit(unsigned int data, int bitpos)
{
unsigned int temp;

	temp = data & (~(0x1 << bitpos));
	return(temp);
}

void perform_ehm(int phy, int channel, int ber_target)
{

int basic_measure_config;

			//Top Eye
			
			if (fgt_pam4[phy][channel]  == 1)
			{
			
				//positive Core0, top eye, symbol 3
				basic_measure_config 			= CORE0_SYMBOL_3;	

				vertical_eye_fgt_top_pos[phy][channel] = get_ehm_fgt(phy,channel,offset[phy],
					basic_measure_config,ber_target,POS);
				
				//negative Core0, top eye, symbol 1
				basic_measure_config 			= CORE0_SYMBOL_1;
				
				vertical_eye_fgt_top_neg[phy][channel] = twos_complement_12bit(get_ehm_fgt(phy,channel,offset[phy],
					basic_measure_config,ber_target,NEG));		
			}

			//Middle Eye

			if (fgt_pam4[phy][channel]  == 1)
			{
			
				//positive Core0, middle eye, symbol 1
				basic_measure_config 			= CORE0_SYMBOL_1;
				
				vertical_eye_fgt_middle_pos[phy][channel] = get_ehm_fgt(phy,channel,offset[phy],
					basic_measure_config,ber_target,POS);
				
				//positive Core0, middle eye, symbol -1
				basic_measure_config 			= CORE0_SYMBOL_MIN_1;
				
				
				vertical_eye_fgt_middle_neg[phy][channel] = twos_complement_12bit(get_ehm_fgt(phy,channel,offset[phy],
					basic_measure_config,ber_target,NEG));	
					
			}
			else //nrz
			{
			
			
				//positive middle eye, symbol 3
				basic_measure_config 			= CORE0_SYMBOL_3;
				
				vertical_eye_fgt_middle_pos[phy][channel] = get_ehm_fgt(phy,channel,offset[phy],
					basic_measure_config,ber_target,POS);
				
				//negative middle eye, symbol -3
				basic_measure_config 			= CORE0_SYMBOL_MIN_3;
				
				
				vertical_eye_fgt_middle_neg[phy][channel] = twos_complement_12bit(get_ehm_fgt(phy,channel,offset[phy],
					basic_measure_config,ber_target,NEG));	
			
			}

			//Bottom Eye
			
			if (fgt_pam4[phy][channel]  == 1)
			{
			
				//positive Core0, bot eye, symbol -1
				basic_measure_config 			= CORE0_SYMBOL_MIN_1;	

				vertical_eye_fgt_bot_pos[phy][channel] = twos_complement_12bit(get_ehm_fgt(phy,channel,offset[phy],
					basic_measure_config,ber_target,POS));
				
				//negative Core0, bot eye symbol -3
				basic_measure_config 			= CORE0_SYMBOL_MIN_3;
				
				vertical_eye_fgt_bot_neg[phy][channel] = twos_complement_12bit(get_ehm_fgt(phy,channel,offset[phy],
					basic_measure_config,ber_target,NEG));		
			}	
			
	
}

void show_time_estimate_ehm(int ber_target)
{
int ehm_time_estimate_in_ms;

		switch (ber_target)
			{
			case 3 : 
						if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
							ehm_time_estimate_in_ms		= 130;	
						else
							ehm_time_estimate_in_ms		= 50;											
						break;
			case 4 :	
						if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
							ehm_time_estimate_in_ms		= 130;	
						else
							ehm_time_estimate_in_ms		= 50;															
						break;
			case 5 : 	
						if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
							ehm_time_estimate_in_ms		= 160;	
						else
							ehm_time_estimate_in_ms		= 50;												
						break;
			case 6 : 	
						if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
							ehm_time_estimate_in_ms		= 600;	
						else
							ehm_time_estimate_in_ms		= 120;							
						break;	
			case 7 : 
						if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
							ehm_time_estimate_in_ms		= 3700;	
						else
							ehm_time_estimate_in_ms		= 950;											
						break;	
			case 8 : 						
						if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
							ehm_time_estimate_in_ms		= 60000;	
						else
							ehm_time_estimate_in_ms		= 7000;											
						break;						
			case 9 : 		
						if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
							ehm_time_estimate_in_ms		= 250000;	
						else
							ehm_time_estimate_in_ms		= 125000;																
						break;
			case 10 : 	
						if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
							ehm_time_estimate_in_ms		= 0;	
						else
							ehm_time_estimate_in_ms		= 0;																		
						break;			
						
			default : 
						if (fgt_pam4[Selectedphy][SelectedChannel[Selectedphy]]  == 1)
							ehm_time_estimate_in_ms		= 600;	
						else
							ehm_time_estimate_in_ms		= 120;																
						break;						
			
			}
			
			if (ehm_time_estimate_in_ms > 0)
			{
				if (ehm_time_estimate_in_ms < 1000)
					printf(" measurement time estimate < %d ms", ehm_time_estimate_in_ms);
				else
					printf(" measurement time estimate < %3.0f seconds", (float) ehm_time_estimate_in_ms/1000);
			}
			else
				printf(" note that this measurement could take a very long time to complete!");
			
}

void set_serial_loopback_fgt(int phy)
{
int i;

	if ((phy >= 0) && (phy < NUMBER_OF_PHYS))
	{

		//Assert Rx Reset on all lanes
		reset_rx_assert_phy(phy);
		
		usleep(100);
		
			
			for (i = 0; i < number_of_physical_lanes[phy] ; i++)
			{ 	
			
		
				if (Serial_Loop[phy][i] == 1)
				{
				//enable SILB CPI command 
				
				//void cpi_request(int phy, int offset, int data, int lane, int opcode, int assert)
				//Issue CPI request for serial loopback
				//Data : 0x0006 : PMA Tx to Rx buffered serial loopback, loops back the Tx serializer output into Rx Eq.
				//Opcode : 0x40
				
				//Lane : this is the physical lane (can be determined by reading out 0xFFFFC (only supported in production silicon)
				
					readout = cpi_request_fgt(phy, i, offset[phy], 0x0006, 0x40,1,1);
					readout = cpi_request_fgt(phy, i, offset[phy], 0x0006, 0x40,0,1);
				}
				else //serial loopback not set
				{
					readout = cpi_request_fgt(phy, i, offset[phy], 0x0000, 0x40,1,1);
					readout = cpi_request_fgt(phy, i, offset[phy], 0x0000, 0x40,0,1);							
				}
						

			} // for i
			
			//de-assert Rx reset on all lanes	
			reset_rx_deassert_phy(phy);
			
			// readback serial loopback 
			// this takes time before this bit is set.
			// also adaptation takes time before the link is up so this why a wait time of 100 ms is used.
			
			usleep(100000);
	}
}


