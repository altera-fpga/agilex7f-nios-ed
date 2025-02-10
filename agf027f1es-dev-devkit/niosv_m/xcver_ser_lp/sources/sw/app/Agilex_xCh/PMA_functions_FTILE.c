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


//Author 	: Peter Schepers
//Version 	: 3.0
//Date		: 19/05/2022
 

#include <stdio.h>
#include "system.h"
#include "string.h"
#include "altera_avalon_pio_regs.h"
#include <unistd.h>
#include "io.h"
#include "altera_avalon_jtag_uart_regs.h"
#include <time.h>
#include <ctype.h>
#include "sys/alt_timestamp.h"
#include "alt_types.h"
#include <math.h>

#include "parameters.h"

#include "ehm_parameters.h"


#include "nphy_functions.h"
#include "channel_functions.h"


#define DEBUG_CPI 0
#define DEBUG_CPI_L2 0
#define DEBUG_EHM 0 


#define TIMEOUT 200

#define DUMMY 0 //to suppress warnings



#define FOM_THRESHOLD_LOW 20 //This is set arbitrary right now.
#define FOM_THRESHOLD_HIGH 45 //This is set arbitrary right now (PAM4 only)

#define SHOW_BER_ESTIMATE 0


int get_cpidata(int phy, int channel, int offset, int data, int opcode);
void print_alarm_6ch(int value, int ok_value);
int get_snr_fht(int phy, int channel, int offset);
int get_vertical_eye_fht(int phy, int channel, int offset,int bin_threshold, int test_length);
int check_cpi_test_status(int phy, int channel, int offset, int opcode);
int get_ehm_fgt(int phy, int channel, int offset, int basic_measure_config, int ber_target, int pos);

///////////////////////////////////////////////////////////////////////////////////////////////
// 2 complement functions
///////////////////////////////////////////////////////////////////////////////////////////////

int decode_tap_6bits (int tap_encoded) 
  {
    int decoded_tap;

	 if (tap_encoded > 0x20 )
		 decoded_tap = -(tap_encoded - 0x20); 
	 else
		 decoded_tap = tap_encoded;
   return(decoded_tap);
} 


int decode_tap_7bits (int tap_encoded) 
  {
    int decoded_tap;

	 if (tap_encoded > 0x40 )
		 decoded_tap = -(tap_encoded - 0x40); 
	 else
		 decoded_tap = tap_encoded;
   return(decoded_tap);
} 

int twos_complement(int value) 
  {
    int temp;

	if (value > 0xF000)
		temp = -((65535 - value) + 1);
	else
		temp = value;
	
   return(temp);
} 

int twos_complement_6bit(int value) 
  {
    int temp;

	if (value > 0x20)
		temp = -((0x3F - value) + 1);
	else
		temp = value;
	
   return(temp);
} 

int twos_complement_8bit(int value) 
  {
    int temp;

	if (value > 0x80)
		temp = -((0xFF - value) + 1);
	else
		temp = value;
	
   return(temp);
} 

int twos_complement_12bit(int value) 
  {
    int temp;

	if (value > 0x800)
		temp = -((0xFFF - value) + 1);
	else
		temp = value;
	
   return(temp);
} 




// This function converts a reflected binary Gray code number to a binary number.
unsigned int GrayToBinary(unsigned int num)
{
    unsigned int mask = num;
    while (mask) {           // Each Gray code bit is exclusive-ored with all more significant bits.
        mask >>= 1;
        num   ^= mask;
    }
    return num;
}


///////////////////////////////////////////////////////////////////////////////////////////////
// F-Tile PMA Functions
///////////////////////////////////////////////////////////////////////////////////////////////

unsigned int cpi_request(int phy, int offset, int data, int lane, int opcode,int assert, int set_getn)
{
	unsigned int cpi_command;
	unsigned int readout;
	int cpi_service_requested;
	int cpi_in_reset;

	readout = rd_channel(phy,offset + 0x90044);
	if ((readout & 0xFFFF) == 0xF)
	{
	if (DEBUG_CPI_L2) printf("\n==============>DEBUG_CPI : Owner is NONE. Session ownership can be requested.");
	
	cpi_command = (data << 16) + (assert << 15) + (set_getn << 13) +  (lane << 8) + (opcode); //bit 15 determines if it is a CPI request assertion ('1') or CPI request de-assertion ('0')
	
	// CPI service request assert 
	rmw_channel(phy,offset + 0x9003c,0xFFFFFFFF,cpi_command);
	if (DEBUG_CPI) printf("\n==============>DEBUG_CPI : phy %d offset 0x%x cpi_command 0x%x",phy,offset + 0x9003c,cpi_command);
	
	//usleep(1000);
	//readout = rd_channel(phy,offset + 0x9003c);
	//if (DEBUG_CPI) printf("\n==============>DEBUG_CPI : readback of register 0x9003c phy %1d lane %d = 0x%x",phy,lane,readout);

	// read returns [15] should be 1 (CPI service requested), [14] should be 0 (CPI not in reset) to confirm CPI service request acknowledged. If [15] != 0x1 && [14] != 0x0 read again. User needs to add timer for example 1ms.
	do 
	{				
		readout = rd_channel(phy,offset + 0x90040);

		if (DEBUG_CPI) printf("\n==============>DEBUG_CPI : readback of register 0x90040 phy %1d lane %d = 0x%x",phy,lane,readout);
		cpi_service_requested 	= 0x0001 & (readout >> 15);	
		cpi_in_reset				= 0x0001 & (readout >> 14);
	}
	//while ((cpi_service_requested == 0) || (cpi_in_reset == 1));	
	while ((cpi_service_requested == !assert) || (cpi_in_reset == 1));
	}
	else
	{
		printf("\nCPI currently in use, CPI request ignored");
	}
	
	return (readout);
		
}


unsigned int cpi_request_fgt(int phy, int channel, int offset, int data, int opcode,int assert,int set_getn)
{
	unsigned int readout;
	int lane;
	
	readout = rd_channel(phy,(channel << offset) + 0xFFFFC);
	lane = readout & (0x00000003); 
	
   readout = cpi_request(phy,(channel << offset),data,lane,opcode,assert,set_getn);

return (readout);
		
}


int check_cpi_test_status(int phy, int channel, int offset, int opcode)
{
	unsigned int cpi_command;
	int cpi_service_requested;
	int test_status;
	unsigned int readout;
	int lane;
	int success;
	
	success = 0;
	
	readout = rd_channel(phy,(channel << offset) + 0xFFFFC);
	lane = readout & (0x00000003); 
	
	   cpi_command = (0x0 << 16) + (1 << 15) + (0 <<13) + (lane << 8) + opcode; 
					 
		rmw_channel(phy,(channel << offset) + 0x9003C           ,0xFFFFFFFF,cpi_command );	
		if (DEBUG_CPI) printf("\n==============>DEBUG_CPI : phy %d offset 0x%x cpi_command 0x%x",phy,(channel << offset) + 0x9003c,cpi_command);

		usleep(1000); 

	//do 
	//{				
		readout = rd_channel(phy,(channel << offset) + 0x90040);
		cpi_service_requested 	= 0x0001 & (readout >> 15);
		test_status 	= 0x0003 & (readout >> 24);
		if (DEBUG_CPI) printf("\n==============>DEBUG_CPI : readback of register 0x90040 phy %1d lane %d = 0x%x test_status = %d",phy,lane,readout,test_status);
		
	//}	
	//while ((cpi_service_requested != 1) || (test_status != 3));
	

	   cpi_command = (0x0 << 16) + (0 << 15) + (0 <<13) + (lane << 8) + opcode; 
					 
		rmw_channel(phy,(channel << offset) + 0x9003C           ,0xFFFFFFFF,cpi_command );	
		if (DEBUG_CPI) printf("\n==============>DEBUG_CPI : phy %d offset 0x%x cpi_command 0x%x",phy,(channel << offset) + 0x9003c,cpi_command);

	// read returns [15] should be 0 
	do 
	{				
		readout = rd_channel(phy,(channel << offset) + 0x90040);

		if (DEBUG_CPI) printf("\n==============>DEBUG_CPI : readback of register 0x90040 phy %1d lane %d = 0x%x",phy,lane,readout);
		cpi_service_requested 	= 0x0001 & (readout >> 15);	
	}	
	while ((cpi_service_requested != 0));	
	
	if (test_status == 3)
		success = 1;		
	else
		success = 0;
	

	
return (success);
	
}

void show_pma_settings_ftile (int phy, int offset, int number_of_lanes, int line_encoding[NUMBER_OF_PHYS][NUMBER_OF_LANES_MAX])
{

//tx parameters
	
  int tx_vodctrl[NUMBER_OF_LANES_MAX];
  int tx_pretap_1[NUMBER_OF_LANES_MAX];
  int tx_pretap_2[NUMBER_OF_LANES_MAX];
  int tx_posttap_1[NUMBER_OF_LANES_MAX];
  float fht_tx_maintap[NUMBER_OF_LANES_MAX];
  float fht_tx_posttap_1[NUMBER_OF_LANES_MAX];
  float fht_tx_posttap_2[NUMBER_OF_LANES_MAX];
  float fht_tx_posttap_3[NUMBER_OF_LANES_MAX];
  float fht_tx_posttap_4[NUMBER_OF_LANES_MAX];
  float fht_tx_pretap_1[NUMBER_OF_LANES_MAX];
  float fht_tx_pretap_2[NUMBER_OF_LANES_MAX];
  float fht_tx_pretap_3[NUMBER_OF_LANES_MAX];
  double fht_tx_sum1[NUMBER_OF_LANES_MAX];
  double fht_tx_sum2[NUMBER_OF_LANES_MAX];
  int fht_tx_setting_valid[NUMBER_OF_LANES_MAX];  
  int fht_snr[NUMBER_OF_LANES_MAX];
  int fht_ehm[NUMBER_OF_LANES_MAX];
  //float fht_ehm_bot[NUMBER_OF_LANES_MAX];
  float fht_ehm_center[NUMBER_OF_LANES_MAX];
  //float fht_ehm_top[NUMBER_OF_LANES_MAX];
  unsigned int fht_ctle_boost_st1[NUMBER_OF_LANES_MAX];
  unsigned int fht_ctle_boost_st2[NUMBER_OF_LANES_MAX]; 
  unsigned int fht_ctle_boost[NUMBER_OF_LANES_MAX];  
  unsigned int fht_vga_gain_1_n[NUMBER_OF_LANES_MAX]; 
  unsigned int fht_vga_gain_1_p[NUMBER_OF_LANES_MAX]; 
  unsigned int fht_vga_gain_2_n[NUMBER_OF_LANES_MAX]; 
  unsigned int fht_vga_gain_2_p[NUMBER_OF_LANES_MAX]; 
  unsigned int fht_vga_gain_3_n[NUMBER_OF_LANES_MAX]; 
  unsigned int fht_vga_gain_3_p[NUMBER_OF_LANES_MAX]; 
  unsigned int fht_vga_gain_1[NUMBER_OF_LANES_MAX]; 
  unsigned int fht_vga_gain_2[NUMBER_OF_LANES_MAX];
  unsigned int fht_vga_gain_3[NUMBER_OF_LANES_MAX];
  int fht_ffe_tap_post[14][NUMBER_OF_LANES_MAX];
  int fht_ffe_tap_pre[4][NUMBER_OF_LANES_MAX];  
  double x;
  double Q;  
  double fht_snr_db[NUMBER_OF_LANES_MAX];  
  double BER_estimate[NUMBER_OF_LANES_MAX];  
  
  int i,j;




   
  int serial_loop_rdback[NUMBER_OF_LANES_MAX];
  int rev_parallel_rdback[NUMBER_OF_LANES_MAX];  
  int RXEQ_DFE_TAP[17][NUMBER_OF_LANES_MAX];
  int RXEQ_HF_BOOST[NUMBER_OF_LANES_MAX];	
  int RXEQ_VGA_GAIN[NUMBER_OF_LANES_MAX];
  int FOM[NUMBER_OF_LANES_MAX];
  int vga[NUMBER_OF_LANES_MAX];  
  int ctle[NUMBER_OF_LANES_MAX];  
  int FGT_Quad[NUMBER_OF_LANES_MAX];
  int Quad_Channel[NUMBER_OF_LANES_MAX];
  //int media_mode[NUMBER_OF_LANES_MAX];
  int convergence_time_lsb[NUMBER_OF_LANES_MAX];
  //int convergence_time_msb[NUMBER_OF_LANES_MAX];
  //float convergence_time[NUMBER_OF_LANES_MAX];
  int Rx_Flow_state[NUMBER_OF_LANES_MAX];
  int Channel_Reg[NUMBER_OF_LANES_MAX];
  int rx_freqlocked_1ms[NUMBER_OF_LANES_MAX];
  int tx_ready[NUMBER_OF_LANES_MAX];
  int rx_ready[NUMBER_OF_LANES_MAX];
  int fgt_pam4[NUMBER_OF_LANES_MAX];
  //int vertical_eye_fgt[NUMBER_OF_LANES_MAX];
  
	int vertical_eye_fgt_middle[NUMBER_OF_LANES_MAX];
	int vertical_eye_fgt_middle_pos[NUMBER_OF_LANES_MAX];
	int vertical_eye_fgt_middle_neg[NUMBER_OF_LANES_MAX];

	int vertical_eye_fgt_top[NUMBER_OF_LANES_MAX];
	int vertical_eye_fgt_top_pos[NUMBER_OF_LANES_MAX];
	int vertical_eye_fgt_top_neg[NUMBER_OF_LANES_MAX];

	int vertical_eye_fgt_bot[NUMBER_OF_LANES_MAX];
	int vertical_eye_fgt_bot_pos[NUMBER_OF_LANES_MAX];
	int vertical_eye_fgt_bot_neg[NUMBER_OF_LANES_MAX];	

	int basic_measure_config;




  unsigned int readout;  
  unsigned int loopback_address;

	

			  

				if (FHT_USED)
					loopback_address = LOOPBACK_ADDR_FHT;
				else
					loopback_address = LOOPBACK_ADDR_FGT;	

					

    	      for (i = 0; i < number_of_lanes ; i++)
    	      { 
			
					Channel_Reg[i]      =  Read_Channel_Reg(phy,i);
					rx_freqlocked_1ms[i]  = 0x0001 & (Channel_Reg[i] >> 1);	  
					tx_ready[i] = 0x0001 & (Channel_Reg[i] >> 14);
					rx_ready[i] = 0x0001 & (Channel_Reg[i] >> 13);
	
  

  
					readout = rd_channel(phy,(i << offset) + 0xFFFFC);
					FGT_Quad[i] = (readout & (0x0000000C)) >> 2;
					Quad_Channel[i] = readout & (0x00000003); 
			  
			
					//readback loopbacks
					readout = rd_channel_ftile (phy,i,offset,loopback_address);
				
					if (FHT_USED)
					{
						serial_loop_rdback[i] = 0x0001 & (readout >> 14);	
						rev_parallel_rdback[i] = 0x0001 & (readout >> 0);
					}
					else
					{
					serial_loop_rdback[i] = 0x0001 & (readout >> 1);	
					rev_parallel_rdback[i] = 0x0001 & (readout >> 2);			
					}
			


					 //  Read out PMA values
					 //============================
		
					 //FGT Tx PMA parameters		
					 
					 if (FHT_USED)
					 {
					 fht_tx_pretap_2[i]			= (float)(twos_complement_6bit((rd_channel_ftile (phy, i, offset, 0x45080) & 0x000000FC) >> 2))/4;		
					 fht_tx_pretap_1[i]			= (float)(twos_complement_6bit((rd_channel_ftile (phy, i, offset, 0x45080) & 0x00003F00) >> 8))/2;							 
					 fht_tx_maintap[i]			= (float)((rd_channel_ftile (phy, i, offset, 0x45080) & 0x001FC000) >> 14)/2;		
					 fht_tx_posttap_1[i]			= (float)(twos_complement_6bit((rd_channel_ftile (phy, i, offset, 0x45080) & 0x07E00000) >> 21))/2;		

					 fht_tx_posttap_2[i]			= (float)(twos_complement_6bit((rd_channel_ftile (phy, i, offset, 0x45084) & 0x0000003F) >> 0))/4;	
					 fht_tx_posttap_3[i]			= (float)(twos_complement_6bit((rd_channel_ftile (phy, i, offset, 0x45084) & 0x00000FC0) >> 6))/4;
					 fht_tx_posttap_4[i]			= (float)(twos_complement_6bit((rd_channel_ftile (phy, i, offset, 0x45084) & 0x0003F000) >> 12))/4;
					 fht_tx_pretap_3[i]			= (float)(twos_complement_6bit((rd_channel_ftile (phy, i, offset, 0x45084) & 0x00FC0000) >> 18))/4;	
					 
					 fht_tx_sum1[i] = fabs(fht_tx_pretap_3[i]) + fabs(fht_tx_pretap_2[i]) + fabs(fht_tx_pretap_1[i]) + fabs(fht_tx_maintap[i]) + fabs(fht_tx_posttap_1[i]) + fabs(fht_tx_posttap_2[i]) + fabs(fht_tx_posttap_3[i]) + fabs(fht_tx_posttap_4[i]);
					 fht_tx_sum2[i] = fabs(fht_tx_pretap_3[i]) + fabs(fht_tx_pretap_2[i]) + fabs(fht_tx_pretap_1[i]) + fabs(fht_tx_posttap_1[i]) + fabs(fht_tx_posttap_2[i]) + fabs(fht_tx_posttap_3[i]) + fabs(fht_tx_posttap_4[i]);
					 
					 if ((fht_tx_sum1[i] <= 41.5) && (fht_tx_sum2[i] <= fht_tx_maintap[i]))
						 fht_tx_setting_valid[i] = 1;
					 else
						 fht_tx_setting_valid[i] = 0;						 
					 //printf("\nfht_tx_sum[i] = %6.2f",fht_tx_sum1[i]);
					 
					  // Get CTLE Boost Stage 1
					  readout = rd_channel_ftile (phy, i, offset, 0x4382C);
					  //st1_grload = serdes_lane_ana_rx1.afe_st1_config_1.cfg_st1_grload.read()
					  fht_ctle_boost_st1[i] = GrayToBinary(( readout & 0x0007E000) >> 13);		

					  // Get CTLE Boost Stage 2					  
					  readout = rd_channel_ftile (phy, i, offset, 0x43830);			
					  //st2_grload = serdes_lane_ana_rx1.afe_st2_config.cfg_st2_grload.read()					  
					  fht_ctle_boost_st2[i] = GrayToBinary(( readout & 0x0007E000) >> 13);	

					  fht_ctle_boost[i] = fht_ctle_boost_st1[i] + fht_ctle_boost_st1[i] ;
					  
					  // Get VGA Gain Stages
					  readout = rd_channel_ftile (phy, i, offset, 0x4382C);
					  //g1n = serdes_lane_ana_rx1.afe_st1_config_1.cfg_st1_ggain_n.read())
					  fht_vga_gain_1_n[i] = GrayToBinary(( readout & 0x0000003F) >> 0);	
					  //g1p = serdes_lane_ana_rx1.afe_st1_config_1.cfg_st1_ggain_p.read())					  
					  fht_vga_gain_1_p[i] = GrayToBinary(( readout & 0x00000FC0) >> 6);					  

					  // Get VGA Gain Stage 2
					  readout = rd_channel_ftile (phy, i, offset, 0x43830);
					  fht_vga_gain_2_n[i] = GrayToBinary(( readout & 0x0000003F) >> 0);							  
					  fht_vga_gain_2_p[i] = GrayToBinary(( readout & 0x00000FC0) >> 6);

					  // Get VGA Gain Stage 3
					  readout = rd_channel_ftile (phy, i, offset, 0x43834);
					  fht_vga_gain_3_n[i] = GrayToBinary(( readout & 0x0000003F) >> 0);							  
					  fht_vga_gain_3_p[i] = GrayToBinary(( readout & 0x00000FC0) >> 6);
					  
					  fht_vga_gain_1[i] = fht_vga_gain_1_n[i] + fht_vga_gain_1_p[i];
					  fht_vga_gain_2[i] = fht_vga_gain_2_n[i] + fht_vga_gain_2_p[i];
					  fht_vga_gain_3[i] = fht_vga_gain_3_n[i] + fht_vga_gain_3_p[i];	

					 //Readout FFE taps
					 
					
					 //ffe_coeff_set{}_group_1
					 readout = rd_channel_ftile (phy, i, offset, 0x41814);

					 fht_ffe_tap_post[1][i] 		= twos_complement_8bit( (readout & 0x000000FF) >> 0);
					 fht_ffe_tap_post[2][i] 		= twos_complement_8bit( (readout & 0x0000FF00) >> 8);	
					 fht_ffe_tap_post[3][i] 		= twos_complement_8bit( (readout & 0x00FF0000) >> 16);	
					 fht_ffe_tap_post[4][i] 		= twos_complement_8bit( (readout & 0xFF000000) >> 24);		

					 //ffe_coeff_set{}_group_2
					 readout = rd_channel_ftile (phy, i, offset, 0x41818);
					 fht_ffe_tap_post[5][i] 		= twos_complement_8bit( (readout & 0x000000FF) >> 0);
					 fht_ffe_tap_post[6][i] 		= twos_complement_8bit( (readout & 0x0000FF00) >> 8);	
					 fht_ffe_tap_post[7][i] 		= twos_complement_8bit( (readout & 0x00FF0000) >> 16);	
					 fht_ffe_tap_post[8][i] 		= twos_complement_8bit( (readout & 0xFF000000) >> 24);		

					 //ffe_coeff_set{}_group_3
					 readout = rd_channel_ftile (phy, i, offset, 0x4181C);
					 fht_ffe_tap_post[9][i] 		= twos_complement_8bit( (readout & 0x000000FF) >> 0);
					 fht_ffe_tap_post[10][i] 		= twos_complement_8bit( (readout & 0x0000FF00) >> 8);	
					 fht_ffe_tap_post[11][i] 		= twos_complement_8bit( (readout & 0x00FF0000) >> 16);	
					 fht_ffe_tap_post[12][i] 		= twos_complement_8bit( (readout & 0xFF000000) >> 24);		
					 
					 //ffe_coeff_set{}_group_4
					 readout = rd_channel_ftile (phy, i, offset, 0x41820);
					 fht_ffe_tap_post[13][i] 		= twos_complement_8bit( (readout & 0x000000FF) >> 0);
					 fht_ffe_tap_pre[3][i] 			= twos_complement_8bit( (readout & 0x0000FF00) >> 8);	
					 fht_ffe_tap_pre[2][i] 			= twos_complement_8bit( (readout & 0x00FF0000) >> 16);	
					 fht_ffe_tap_pre[1][i] 			= twos_complement_8bit( (readout & 0xFF000000) >> 24);	
					 

					 
					 
					if (rx_ready[i] == 1)
					{
						fht_snr[i] = get_snr_fht(phy,i,offset); // only measure when rx_ready is asserted otherwise it might hang.
						fht_snr_db[i] = 10*log10((double)fht_snr[i]);
						
						//Calculate SER (System Error), this is assuming only AWGN is present in the system which is not the case here.
						x = sqrt( ( 3.0 * fht_snr[i])/15.0);
						//printf("\nx = %e",x);
						Q = 0.5 - 0.5 * erf(x * M_SQRT1_2);
						//printf("\nQ = %e",Q);
						BER_estimate[i] = 0.5 * (1.5 * Q); // BER estimate is SER/2
					}
					else
						fht_snr[i] = 0.0;

					 if (rx_ready[i] == 1)
						fht_ehm[i] = get_vertical_eye_fht(phy,i,offset,2,10); // only measure when rx_ready is asserted (only supported for NRZ)
					 else
						fht_ehm[i] = 0.0;		
					
					//printf("\nfht_ehm[%d] = 0x%x",i,fht_ehm[i]);

					 //fht_ehm_bot[i] 		= (float) (twos_complement((fht_ehm[i] >> 0) & 0xff))/4;
					 fht_ehm_center[i] 	= (float)(twos_complement((fht_ehm[i] >> 8) & 0xff))/4;
					 //fht_ehm_top[i] 		= (float) (twos_complement((fht_ehm[i] >> 16) & 0xff))/4;					 
					



					
					 }
					 else //FGT
					 {
					 tx_vodctrl[i]				= (rd_channel_ftile (phy, i, offset, 0x47830) & 0x0000FC00) >> 10;
					 tx_pretap_2[i]			= (rd_channel_ftile (phy, i, offset, 0x47830) & 0x00070000) >> 16;		
					 tx_pretap_1[i]			= (rd_channel_ftile (phy, i, offset, 0x47830) & 0x000003E0) >> 5;		
					 tx_posttap_1[i]			= (rd_channel_ftile (phy, i, offset, 0x47830) & 0x0000001F);
					 
					 //Manual Rx PMA parameters		
					 

					 RXEQ_HF_BOOST[i]					= (rd_channel_ftile (phy, i, offset, 0x41BB8) & 0x01F80000) >> 19;	
					 RXEQ_VGA_GAIN[i]					= (rd_channel_ftile (phy, i, offset, 0x41BB8) & 0xFE000000) >> 25;	
					 RXEQ_DFE_TAP[1][i]				= decode_tap_6bits((rd_channel_ftile (phy, i, offset, 0x41914) & 0x0000003F));						 
					 RXEQ_DFE_TAP[2][i]				= decode_tap_7bits((rd_channel_ftile (phy, i, offset, 0x41914) & 0x00007F00) >> 8);	
					 RXEQ_DFE_TAP[3][i]				= decode_tap_7bits((rd_channel_ftile (phy, i, offset, 0x41914) & 0x007F0000) >> 16);
					 RXEQ_DFE_TAP[4][i]				= decode_tap_6bits((rd_channel_ftile (phy, i, offset, 0x41914) & 0x3F000000) >> 24);
					 RXEQ_DFE_TAP[5][i]				= decode_tap_6bits((rd_channel_ftile (phy, i, offset, 0x41918) & 0x0000003F));
					 RXEQ_DFE_TAP[6][i]				= decode_tap_6bits((rd_channel_ftile (phy, i, offset, 0x41918) & 0x00003F00) >> 8);	
					 RXEQ_DFE_TAP[7][i]				= decode_tap_6bits((rd_channel_ftile (phy, i, offset, 0x41918) & 0x003F0000) >> 16);	
					 RXEQ_DFE_TAP[8][i]				= decode_tap_6bits((rd_channel_ftile (phy, i, offset, 0x41918) & 0x3F000000) >> 24);					 
					 RXEQ_DFE_TAP[9][i]				= decode_tap_6bits((rd_channel_ftile (phy, i, offset, 0x4191C) & 0x0000003F));
					 RXEQ_DFE_TAP[10][i]				= decode_tap_6bits((rd_channel_ftile (phy, i, offset, 0x4191C) & 0x00003F00) >> 8);	
					 RXEQ_DFE_TAP[11][i]				= decode_tap_6bits((rd_channel_ftile (phy, i, offset, 0x4191C) & 0x003F0000) >> 16);	
					 RXEQ_DFE_TAP[12][i]				= decode_tap_6bits((rd_channel_ftile (phy, i, offset, 0x4191C) & 0x3F000000) >> 24);	
					 RXEQ_DFE_TAP[13][i]				= decode_tap_6bits((rd_channel_ftile (phy, i, offset, 0x41920) & 0x0000003F));
					 RXEQ_DFE_TAP[14][i]				= decode_tap_6bits((rd_channel_ftile (phy, i, offset, 0x41920) & 0x00003F00) >> 8);	
					 RXEQ_DFE_TAP[15][i]				= decode_tap_6bits((rd_channel_ftile (phy, i, offset, 0x41920) & 0x003F0000) >> 16);	
					 RXEQ_DFE_TAP[16][i]				= decode_tap_6bits((rd_channel_ftile (phy, i, offset, 0x41920) & 0x3F000000) >> 24);		
					 
					 FOM[i] = twos_complement(get_cpidata(phy,i,offset,(3<<13),0x94));	//ConvData			
					 vga[i] = get_cpidata(phy,i,offset,(2<<13),0x94); //ConvData
					 ctle[i] = get_cpidata(phy,i,offset,((2<<13)| 1),0x94); //ConvData
					 
					 convergence_time_lsb[i] = get_cpidata(phy,i,offset,0x0,0x90); //Getdata
					 //convergence_time_msb[i] = get_cpidata(phy,i,offset,0x1,0x90); //Getdata
					 //convergence_time[i] = ((float)(convergence_time_msb[i] << 16) + (float) convergence_time_lsb[i]);
					 Rx_Flow_state[i] = get_cpidata(phy,i,offset,0x3,0x90); //Getdata		
	
					 fgt_pam4[i] = (rd_channel_ftile (phy, i, offset, 0x47800) & 0x00000004) >> 2;
					
					/* 
					if (USE_FW196)
					{		
						// This only works if it has been set to 0x14 previously, any other value will result in CPI error (Bit 14), this is expected behaviour with FW196
						readout = cpi_request_fgt(phy, i, offset, 0x0000, 0x64,1,0);
						media_mode[i] = readout >> 16;
						readout = cpi_request_fgt(phy, i, offset, 0x0000 ,0x64,0,0);
					}
					*/
					

					if (rx_ready[i] == 1) // only measure when rx_ready is asserted
					{
						if (fgt_pam4[i]  == 1)
						{
						
							//positive Core0, top eye, symbol 3
							basic_measure_config 			= CORE0_SYMBOL_3;	

							vertical_eye_fgt_top_pos[i] = get_ehm_fgt(phy,i,offset,basic_measure_config,BER_TARGET_EHM_DEFAULT_PAM4,POS); 
							
							//negative Core0, top eye, symbol 1
							basic_measure_config 			= CORE0_SYMBOL_1;
							
							vertical_eye_fgt_top_neg[i] = get_ehm_fgt(phy,i,offset,basic_measure_config,BER_TARGET_EHM_DEFAULT_PAM4,NEG); 		
						}

						//Middle Eye

						if (fgt_pam4[i]  == 1)
						{
						
							//positive Core0, middle eye, symbol 1
							basic_measure_config 			= CORE0_SYMBOL_1;
							
							vertical_eye_fgt_middle_pos[i] = get_ehm_fgt(phy,i,offset,basic_measure_config,BER_TARGET_EHM_DEFAULT_PAM4,POS); 
							
							//positive Core0, middle eye, symbol -1
							basic_measure_config 			= CORE0_SYMBOL_MIN_1;
							
							
							vertical_eye_fgt_middle_neg[i] = twos_complement_12bit(get_ehm_fgt(phy,i,offset,basic_measure_config,BER_TARGET_EHM_DEFAULT_PAM4,NEG));	
								
						}
						else //nrz
						{
						
						
							//positive middle eye, symbol 3
							basic_measure_config 			= CORE0_SYMBOL_3;
							
							vertical_eye_fgt_middle_pos[i] = get_ehm_fgt(phy,i,offset,basic_measure_config,BER_TARGET_EHM_DEFAULT_NRZ,POS); 
							
							//negative middle eye, symbol -3
							basic_measure_config 			= CORE0_SYMBOL_MIN_3;
							
							
							vertical_eye_fgt_middle_neg[i] = twos_complement_12bit(get_ehm_fgt(phy,i,offset,basic_measure_config,BER_TARGET_EHM_DEFAULT_NRZ,NEG));	
						
						}

						//Bottom Eye
						
						if (fgt_pam4[i]  == 1)
						{
						
							//positive Core0, bot eye, symbol -1
							basic_measure_config 			= CORE0_SYMBOL_MIN_1;	

							vertical_eye_fgt_bot_pos[i] = twos_complement_12bit(get_ehm_fgt(phy,i,offset,basic_measure_config,BER_TARGET_EHM_DEFAULT_PAM4,POS));	
							
							//negative Core0, bot eye symbol -3
							basic_measure_config 			= CORE0_SYMBOL_MIN_3;
							
							vertical_eye_fgt_bot_neg[i] = twos_complement_12bit(get_ehm_fgt(phy,i,offset,basic_measure_config,BER_TARGET_EHM_DEFAULT_PAM4,NEG));			
						}	


						vertical_eye_fgt_top[i] = vertical_eye_fgt_top_pos[i] - vertical_eye_fgt_top_neg[i];
						vertical_eye_fgt_middle[i] = vertical_eye_fgt_middle_pos[i] - vertical_eye_fgt_middle_neg[i];
						vertical_eye_fgt_bot[i] = -(vertical_eye_fgt_bot_neg[i]) - (- vertical_eye_fgt_bot_pos[i]);			
					}
				}

			}
				
   	  printf("\n\n");

    	      printf("Channel            :|");
    	      for (i = 0; i < number_of_lanes ; i++)
    	      { 
    	        printf("%6d|",i);
    	      }
    	      printf("\n");
    	      printf("                    |");
    	      for (i = 0; i < number_of_lanes ; i++)
    	      { 
    	      printf("------|");
    	      }
    	      printf("\n");
				
				if (FHT_USED == 0)
				{
					printf("FGT Quad           :|"); 				
					for (i = 0; i < number_of_lanes ; i++)
					{ 
						 printf("%6d|",FGT_Quad[i]);
					}
					printf("\n");
				}
				if (FHT_USED)
				{
					printf("FHT Lane           :|"); 				
					for (i = 0; i < number_of_lanes ; i++)
					{ 
						 printf("%6d|",Quad_Channel[i]);
					}
					printf("\n");
				}	
				else
				{
					printf("FGT Lane           :|"); 				
					for (i = 0; i < number_of_lanes ; i++)
					{ 
						 printf("%6d|",Quad_Channel[i]);
					}
					printf("\n");
				}							

    	      printf("Transceiver Type   :|"); 
    	      for (i = 0; i < number_of_lanes ; i++)
    	      { 
					 if (FHT_USED)
						printf("   FHT|");
					 else
						printf("   FGT|");
    	      }
    	      printf("\n");
				
    	      printf("Line Encoding      :|"); 
    	      for (i = 0; i < number_of_lanes ; i++)
    	      { 
					if (FHT_USED)
					{
					if (line_encoding[phy][i] == NRZ)
						printf("   NRZ|");
					else
						printf("  PAM4|");
					}
					else //Based on readout of register 
					{
					if (fgt_pam4[i] == 1)
						printf("  PAM4|");
					else
						printf("   NRZ|");						
					}
					  
					
				}
    	      printf("\n");
				
    	      printf("tx_ready           :|");				
    	      for (i = 0; i < number_of_lanes ; i++)
    	      { 
					print_alarm_6ch(tx_ready[i],1); 
    	      }
    	      printf("\n");
				
    	      printf("rx_ready           :|");				
    	      for (i = 0; i < number_of_lanes ; i++)
    	      { 
					 print_alarm_6ch(rx_ready[i],1); 
    	      }
    	      printf("\n");
				
    	      printf("rx_freqlocked_1ms  :|");				
    	      for (i = 0; i < number_of_lanes ; i++)
    	      { 
					 print_alarm_6ch(rx_freqlocked_1ms[i],1); 
    	      }
    	      printf("\n");				
				
    	      printf("Serial Loop        :|"); 
    	      for (i = 0; i < number_of_lanes ; i++)
    	      { 
					if (serial_loop_rdback[i] == 0)
						printf("%6d|",serial_loop_rdback[i]);
					else
						printf(COLOR_YELLOW COLOR_INVERSE "     1" COLOR_RESET "|");			
    	      }
    	      printf("\n");
				
				printf("Reverse Parallel   :|"); 
    	      for (i = 0; i < number_of_lanes ; i++)
    	      { 
					if (rev_parallel_rdback[i] == 0)
						printf("%6d|",rev_parallel_rdback[i]);
					else
						printf(COLOR_YELLOW COLOR_INVERSE "     1" COLOR_RESET "|");							 
    	      }
    	      printf("\n");
							
				
				if (FHT_USED)
				{						
	 
					printf("Pre Tap 3 Level    :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 
						if (fht_tx_setting_valid[i] == 1)
							printf("%6.2f|",fht_tx_pretap_3[i]); 	
						else
							printf(COLOR_ALARM "%6.2f" COLOR_RESET "|",fht_tx_pretap_3[i]);							
					}
					printf("\n");
					
					printf("Pre Tap 2 Level    :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 
						if (fht_tx_setting_valid[i] == 1)				
						  printf("%6.2f|",fht_tx_pretap_2[i]); 	
						else
							printf(COLOR_ALARM "%6.2f" COLOR_RESET "|",fht_tx_pretap_2[i]);						  
					}
					printf("\n");

					printf("Pre Tap 1 Level    :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 
						if (fht_tx_setting_valid[i] == 1)				
						  printf("%6.2f|",fht_tx_pretap_1[i]); 
						else
							printf(COLOR_ALARM "%6.2f" COLOR_RESET "|",fht_tx_pretap_1[i]);						  
					}
					printf("\n");				
					
					printf("Main Tap           :|"); 				
					for (i = 0; i < number_of_lanes ; i++)
					{ 
						if (fht_tx_setting_valid[i] == 1)				
						 printf("%6.2f|",fht_tx_maintap[i]); 
						else
							printf(COLOR_ALARM "%6.2f" COLOR_RESET "|",fht_tx_maintap[i]);						 
					}
					printf("\n");
					
					
					printf("Post Tap 1 Level   :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 
						if (fht_tx_setting_valid[i] == 1)				
							printf("%6.2f|",fht_tx_posttap_1[i]);
						else
							printf(COLOR_ALARM "%6.2f" COLOR_RESET "|",fht_tx_posttap_1[i]);							
					}
					printf("\n");
					
					printf("Post Tap 2 Level   :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 
						if (fht_tx_setting_valid[i] == 1)				
							printf("%6.2f|",fht_tx_posttap_2[i]);
						else
							printf(COLOR_ALARM "%6.2f" COLOR_RESET "|",fht_tx_posttap_2[i]);							
					}
					printf("\n");

					printf("Post Tap 3 Level   :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 
						if (fht_tx_setting_valid[i] == 1)				
							printf("%6.2f|",fht_tx_posttap_3[i]);
						else
							printf(COLOR_ALARM "%6.2f" COLOR_RESET "|",fht_tx_posttap_3[i]);							
					}
					printf("\n");

					printf("Post Tap 4 Level   :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 
						if (fht_tx_setting_valid[i] == 1)				
							printf("%6.2f|",fht_tx_posttap_4[i]);
						else
							printf(COLOR_ALARM "%6.2f" COLOR_RESET "|",fht_tx_posttap_4[i]);							
					}
					printf("\n");	

					printf("VGA Gain Stage1    :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 		
							printf("%6d|",fht_vga_gain_1[i]);						
					}
					printf("\n");			

					printf("VGA Gain Stage2    :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 		
							printf("%6d|",fht_vga_gain_2[i]);						
					}
					printf("\n");	

					printf("VGA Gain Stage3    :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 		
							printf("%6d|",fht_vga_gain_3[i]);						
					}
					printf("\n");	
					

					printf("CTLE Boost Stage1  :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 		
							printf("%6d|",fht_ctle_boost_st1[i]);						
					}
					printf("\n");	
					
					printf("CTLE Boost Stage2  :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 		
							printf("%6d|",fht_ctle_boost_st2[i]);						
					}
					printf("\n");						

					printf("CTLE Boost         :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 		
							printf("%6d|",fht_ctle_boost[i]);						
					}
					printf("\n");	
					
					for (j = 3; j > 0; j--)
					{
						printf("FFE_PRE_TAP  %2d    :|",j); 	
						for (i = 0; i < number_of_lanes ; i++)
						{ 
								printf("%6d|",fht_ffe_tap_pre[j][i]); 
						}
					printf("\n");						
					}
					
					for (j = 1; j < 14; j++)
					{
						printf("FFE_POST_TAP %2d    :|",j); 	
						for (i = 0; i < number_of_lanes ; i++)
						{ 
								printf("%6d|",fht_ffe_tap_post[j][i]); 
						}
					printf("\n");						
					}
					
					
					printf("SNR (db)           :|");
					for (i = 0; i < number_of_lanes ; i++)
					{ 
							if (rx_ready[i] == 1)
								printf("%6.2f|",fht_snr_db[i]);				
							else
								printf(COLOR_ALARM "------" COLOR_RESET "|");
					}
					printf("\n");		
					
					if (SHOW_BER_ESTIMATE)
					{

						for (i = 0; i < number_of_lanes ; i++)
						{ 
						printf("\nBER Estimate Ch %d  :|",i);							
								if (rx_ready[i] == 1)
									printf("%e",BER_estimate[i]);				
								else
									printf(COLOR_ALARM "------" COLOR_RESET "|");
						}
						printf("\n");		
					}
					

					// printf("Veye Top           :|");
					// for (i = 0; i < number_of_lanes ; i++)
					// { 
							// if (rx_ready[i] == 1)
								// printf("%6.2f|",fht_ehm_top[i]);					
							// else
								// printf(COLOR_ALARM "------" COLOR_RESET "|");
					// }
					// printf("\n");	

					if (FHT_NRZ)
					{
						printf("Veye               :|");					
						for (i = 0; i < number_of_lanes ; i++)
						{ 
								if (rx_ready[i] == 1)
									printf("%6.2f|",fht_ehm_center[i]);					
								else
									printf(COLOR_ALARM "------" COLOR_RESET "|");
						}
						printf("\n");	
					}
					// printf("Veye Bottom        :|");
					// for (i = 0; i < number_of_lanes ; i++)
					// { 
							// if (rx_ready[i] == 1)
								// printf("%6.2f|",fht_ehm_bot[i]);					
							// else
								// printf(COLOR_ALARM "------" COLOR_RESET "|");
					// }
					// printf("\n");							
					
					
				}
				else
				{

							
	 
					printf("Pre Tap 2 Level    :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 
						  printf("%6d|",tx_pretap_2[i]); 
					}
					printf("\n");
					
					printf("Pre Tap 1 Level    :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 
						  printf("%6d|",tx_pretap_1[i]);
					}
					printf("\n");
					
					printf("Main Tap           :|"); 				
					for (i = 0; i < number_of_lanes ; i++)
					{ 
						 printf("%6d|",tx_vodctrl[i]); 	    	  
					}
					printf("\n");					
	 
					printf("Post Tap 1 Level   :|"); 
					for (i = 0; i < number_of_lanes ; i++)
					{ 
							printf("%6d|",tx_posttap_1[i]); 
					}
					printf("\n");
								
					printf("RXEQ_HF_BOOST      :|"); 					
					for (i = 0; i < number_of_lanes ; i++)
					{ 
							printf("%6d|",RXEQ_HF_BOOST[i]); 
					}
					printf("\n");
					
					printf("RXEQ_VGA_GAIN      :|"); 					
					for (i = 0; i < number_of_lanes ; i++)
					{ 
							printf("%6d|",RXEQ_VGA_GAIN[i]); 
					}
					printf("\n");
					
					
					for (j = 1; j < 17; j++)
					{
						printf("RXEQ_DFE_TAP%2d     :|",j); 					
						for (i = 0; i < number_of_lanes ; i++)
						{ 
								printf("%6d|",RXEQ_DFE_TAP[j][i]); 
						}
					printf("\n");						
					}
					
					if (SHOW_ADVANCED_EQUALIZATION_PARAMETERS)
					{
						printf("FOM                :|"); 				
						for (i = 0; i < number_of_lanes ; i++)
						{ 
								 if (FOM[i] == -1) //means measurement is not valid0
									 printf(COLOR_ALARM "------" COLOR_RESET "|");
								 else if (FOM[i] <= FOM_THRESHOLD_LOW)
									printf(COLOR_ALARM "%6d" COLOR_RESET "|",FOM[i]); 								 
								 else if (FOM[i] >= FOM_THRESHOLD_HIGH)
									printf(COLOR_OK "%6d" COLOR_RESET "|",FOM[i]); 										 
								 else
									printf("%6d|",FOM[i]); 
						}
						printf("\n");	

						printf("VGA                :|"); 				
						for (i = 0; i < number_of_lanes ; i++)
						{ 
							printf("%6d|",vga[i]); 
						}
						printf("\n");	
						
						printf("CTLE               :|"); 				
						for (i = 0; i < number_of_lanes ; i++)
						{ 
							printf("%6d|",ctle[i]); 
						}
						printf("\n");	
						
						if (fgt_pam4[0]  == 1)
						{	
							printf("Top Eye Height     :|");						
							for (i = 0; i < number_of_lanes ; i++)
							{ 
									if (rx_ready[i] == 1)
										printf("%6.2f|",CONVERT_TO_MV * vertical_eye_fgt_top[i]); 
									else
										printf("------|");
							}
							printf("  mV (at 1E-6) \n");
						}							
						
						if (fgt_pam4[0]  == 1)
						{	
							printf("Middle Eye Height  :|");	
							for (i = 0; i < number_of_lanes ; i++)
							{ 
									if (rx_ready[i] == 1)						
										printf("%6.2f|",CONVERT_TO_MV * vertical_eye_fgt_middle[i]); 
									else
										printf("------|");									
							}
							printf("  mV (at 1E-6) \n");									
						}
						else
						{	
							printf("Eye Height         :|");								
							for (i = 0; i < number_of_lanes ; i++)
							{ 
									if (rx_ready[i] == 1)								
										printf("%6.2f|",CONVERT_TO_MV * vertical_eye_fgt_middle[i]); 
									else
										printf("------|");										
							}
							printf("  mV (at 1E-6) \n");									
						}								

						if (fgt_pam4[0]  == 1)
						{	
							printf("Bottom Eye Height  :|");								
							for (i = 0; i < number_of_lanes ; i++)
							{ 
									if (rx_ready[i] == 1)								
										printf("%6.2f|",CONVERT_TO_MV * vertical_eye_fgt_bot[i]); 
									else
										printf("------|");											
							}
							printf("  mV (at 1E-6) \n");									
						}
							

							if (SHOW_ADVANCED_DEBUG_EQUALIZATION_PARAMETERS)
							{
								printf("Convergence time   :|"); 				
								for (i = 0; i < number_of_lanes ; i++)
								{ 
									printf("%6d|",convergence_time_lsb[i]); 
								}
								printf("  (ms) (only LSB portion) \n");	
								
								// printf("Convergence timeMSB:|"); 				
								// for (i = 0; i < number_of_lanes ; i++)
								// { 
									// printf("%6d|",convergence_time_msb[i]); 
								// }
								// printf("\n");					
								

								// printf("Convergence time   :|"); 				
								// for (i = 0; i < number_of_lanes ; i++)
								// { 
									// printf("%.2e|",convergence_time[i]); 
								// }
								// printf("\n");	
								
								
								printf("Rx Flow State      :|"); 				
								for (i = 0; i < number_of_lanes ; i++)
								{ 
									if (Rx_Flow_state[i] == 2)
										printf("SigDet|"); 
									else
										printf("%6d|",(signed) Rx_Flow_state[i]); 
								}
								printf("\n");	


								
							
							/*
							if (USE_FW196)
							{
								printf("media mode         :|"); 				
								for (i = 0; i < number_of_lanes ; i++)
								{ 
									printf("0x%x|",media_mode[i]); //can only be read out if it has been set to 0x14 before using FW196
								}
								printf("\n");					
							}
						*/
						
						
							}
					}
				}
    	      printf("\n");


									
}

int get_cpidata(int phy, int channel, int offset, int data, int opcode)
{
	unsigned int readout;
	unsigned int cpi_read_data;
	
	readout = cpi_request_fgt(phy, channel, offset, data, opcode,1,0);
	cpi_read_data = readout >> 16;
	readout = cpi_request_fgt(phy, channel, offset, data , opcode,0,0);
	
	return((int) cpi_read_data);
}

//The below requires FW196 and beyond
void set_media_mode(int phy, int offset, int number_of_lanes, int media_mode) 
{
	int i;
	unsigned int readout; 	
	
	for (i = 0; i < number_of_lanes ; i++)
	{ 		
	//Opcode 0x64

		readout = cpi_request_fgt(phy, i, offset, media_mode, 0x64,1,1);
		readout = cpi_request_fgt(phy, i, offset, media_mode, 0x64,0,1);
	}		
	if (DUMMY)
		printf("%d",readout);
}

void print_alarm_6ch(int value, int ok_value)
{
		if (value == ok_value)
			printf("%5s" COLOR_OK "%1d" COLOR_RESET "|" ," ",ok_value);
		else
			printf("%5s" COLOR_ALARM "%1d" COLOR_RESET  "|"," ",!(ok_value));	
  
}		

int get_snr_fht(int phy, int channel, int offset)
{
int temp;

		//read out SNR FHT
	
		//measure SNR on lane 0 bitprog register 0x619A8
		//0xa | (lane & 0x3 ) << 6 | 0x5 << 28
		//e.g. 0x5000000A (lane 0)
					 
		rmw_channel(phy,(channel << offset) + 0x619A8           ,0xFFFFFFFF,(0xA + (channel << 6) + (0x5<<28)));	

		usleep(1000); // wait time seems to be mandatory

		
		// temp = rd_channel(Selectedphy,(j << offset[Selectedphy]) + 0x619B0); 
		// printf("\ntemp : 0x%x",temp);
		
		
		do 
		{
			//readout status
			//temp = rd_channel_ftile(Selectedphy, j, offset[Selectedphy],0x619B0); NOK
			temp = rd_channel(phy,(channel << offset) + 0x619B0); 
			//printf("\ntemp : 0x%x",temp);
		}
		while ((temp & 0x00000001) == 0); // bit 0 is busy (wait till busy is 1)					
		
		do 
		{
			//readout status
			//temp = rd_channel_ftile(Selectedphy, j, offset[Selectedphy],0x619B0); 
			temp = rd_channel(phy,(channel << offset) + 0x619B0); 
			//printf("\ntemp : 0x%x",temp);
		}
		while ((temp & 0x00000002) == 0); // bit 1 is done (wait till test is done)
		//readout bitprog result 0x619AC
		//temp = rd_channel_ftile(Selectedphy, j, offset[Selectedphy],0x619AC);
		temp = rd_channel(phy,(channel << offset) + 0x619AC); 		

		//printf("\nbitprog result : 0x%x",temp);
		//printf("\nSNR phy %d Channel %d = %2.2f dB",Selectedphy,j,10*log10((double)temp));		
		return (temp);
}

int get_vertical_eye_fht(int phy, int channel, int offset,int bin_threshold, int test_length)
{
int temp;

		//for EHM – write this to bitprog command register: self.opcode_dict['BP_EHM_TEST'] | (lane & 0x3 ) << 6 | (bin_threshold & 0xf) << 12 | (test_length & 0xF) << 28
		//'BP_EHM_TEST' opcode is 0x2.   bin_threshold =2 , test_length=10

					 
		rmw_channel(phy,(channel << offset) + 0x619A8           ,0xFFFFFFFF,(0x2 + (channel << 6) + ((bin_threshold & 0xf) << 12) + ((test_length & 0xF) << 28)) );	

		usleep(1000); // wait time seems to be mandatory

		
		// temp = rd_channel(Selectedphy,(j << offset[Selectedphy]) + 0x619B0); 
		// printf("\ntemp : 0x%x",temp);
		
		
		do 
		{
			//readout status
			//temp = rd_channel_ftile(Selectedphy, j, offset[Selectedphy],0x619B0); NOK
			temp = rd_channel(phy,(channel << offset) + 0x619B0); 
			//printf("\ntemp : 0x%x",temp);
		}
		while ((temp & 0x00000001) == 0); // bit 0 is busy (wait till busy is 1)					
		
		do 
		{
			//readout status
			//temp = rd_channel_ftile(Selectedphy, j, offset[Selectedphy],0x619B0); 
			temp = rd_channel(phy,(channel << offset) + 0x619B0); 
			//printf("\ntemp : 0x%x",temp);
		}
		while ((temp & 0x00000002) == 0); // bit 1 is done (wait till test is done)
		//readout bitprog result 0x619AC
		//temp = rd_channel_ftile(Selectedphy, j, offset[Selectedphy],0x619AC);
		temp = rd_channel(phy,(channel << offset) + 0x619AC); 		

		//printf("\nbitprog result : 0x%x",temp);
		return (temp);
}



int get_ehm_fgt(int phy, int channel, int offset, int basic_measure_config, int ber_target, int pos)
{

unsigned int readout; 
int event_rate_lsb1_int_pos;
int event_rate_lsb2_int_pos;
int event_rate_msb_and_sign_int_pos;
int event_rate_lsb1_int_neg;
int event_rate_lsb2_int_neg;
int event_rate_msb_and_sign_int_neg;

int success;

switch (ber_target)
	{
	case 3 : event_rate_lsb1_int_pos 			= EVENT_RATE_1E3_POS_LSB1; 
				event_rate_lsb2_int_pos	 			= EVENT_RATE_1E3_POS_LSB2;
				event_rate_msb_and_sign_int_pos	= EVENT_RATE_1E3_POS_MSB;
				event_rate_lsb1_int_neg 			= EVENT_RATE_1E3_NEG_LSB1; 
				event_rate_lsb2_int_neg	 			= EVENT_RATE_1E3_NEG_LSB2;
				event_rate_msb_and_sign_int_neg	= EVENT_RATE_1E3_NEG_MSB;										
				break;
	case 4 : event_rate_lsb1_int_pos 			= EVENT_RATE_1E4_POS_LSB1; 
				event_rate_lsb2_int_pos	 			= EVENT_RATE_1E4_POS_LSB2;
				event_rate_msb_and_sign_int_pos	= EVENT_RATE_1E4_POS_MSB;
				event_rate_lsb1_int_neg 			= EVENT_RATE_1E4_NEG_LSB1; 
				event_rate_lsb2_int_neg	 			= EVENT_RATE_1E4_NEG_LSB2;
				event_rate_msb_and_sign_int_neg	= EVENT_RATE_1E4_NEG_MSB;															
				break;
	case 5 : event_rate_lsb1_int_pos 			= EVENT_RATE_1E5_POS_LSB1; 
				event_rate_lsb2_int_pos	 			= EVENT_RATE_1E5_POS_LSB2;
				event_rate_msb_and_sign_int_pos	= EVENT_RATE_1E5_POS_MSB;
				event_rate_lsb1_int_neg 			= EVENT_RATE_1E5_NEG_LSB1; 
				event_rate_lsb2_int_neg	 			= EVENT_RATE_1E5_NEG_LSB2;
				event_rate_msb_and_sign_int_neg	= EVENT_RATE_1E5_NEG_MSB;												
				break;
	case 6 : event_rate_lsb1_int_pos 			= EVENT_RATE_1E6_POS_LSB1; 
				event_rate_lsb2_int_pos	 			= EVENT_RATE_1E6_POS_LSB2;
				event_rate_msb_and_sign_int_pos	= EVENT_RATE_1E6_POS_MSB;
				event_rate_lsb1_int_neg 			= EVENT_RATE_1E6_NEG_LSB1; 
				event_rate_lsb2_int_neg	 			= EVENT_RATE_1E6_NEG_LSB2;
				event_rate_msb_and_sign_int_neg	= EVENT_RATE_1E6_NEG_MSB;							
				break;	
	case 7 : event_rate_lsb1_int_pos 			= EVENT_RATE_1E7_POS_LSB1; 
				event_rate_lsb2_int_pos	 			= EVENT_RATE_1E7_POS_LSB2;
				event_rate_msb_and_sign_int_pos	= EVENT_RATE_1E7_POS_MSB;
				event_rate_lsb1_int_neg 			= EVENT_RATE_1E7_NEG_LSB1; 
				event_rate_lsb2_int_neg	 			= EVENT_RATE_1E7_NEG_LSB2;
				event_rate_msb_and_sign_int_neg	= EVENT_RATE_1E7_NEG_MSB;											
				break;	
	case 8 : event_rate_lsb1_int_pos 			= EVENT_RATE_1E8_POS_LSB1; 
				event_rate_lsb2_int_pos	 			= EVENT_RATE_1E8_POS_LSB2;
				event_rate_msb_and_sign_int_pos	= EVENT_RATE_1E8_POS_MSB;
				event_rate_lsb1_int_neg 			= EVENT_RATE_1E8_NEG_LSB1; 
				event_rate_lsb2_int_neg	 			= EVENT_RATE_1E8_NEG_LSB2;
				event_rate_msb_and_sign_int_neg	= EVENT_RATE_1E8_NEG_MSB;															
				break;						
	case 9 : event_rate_lsb1_int_pos 			= EVENT_RATE_1E9_POS_LSB1; 
				event_rate_lsb2_int_pos	 			= EVENT_RATE_1E9_POS_LSB2;
				event_rate_msb_and_sign_int_pos	= EVENT_RATE_1E9_POS_MSB;
				event_rate_lsb1_int_neg 			= EVENT_RATE_1E9_NEG_LSB1; 
				event_rate_lsb2_int_neg	 			= EVENT_RATE_1E9_NEG_LSB2;
				event_rate_msb_and_sign_int_neg	= EVENT_RATE_1E9_NEG_MSB;																	
				break;
	case 10 : event_rate_lsb1_int_pos 			= EVENT_RATE_1E10_POS_LSB1; 
				event_rate_lsb2_int_pos	 			= EVENT_RATE_1E10_POS_LSB2;
				event_rate_msb_and_sign_int_pos	= EVENT_RATE_1E10_POS_MSB;
				event_rate_lsb1_int_neg 			= EVENT_RATE_1E10_NEG_LSB1; 
				event_rate_lsb2_int_neg	 			= EVENT_RATE_1E10_NEG_LSB2;
				event_rate_msb_and_sign_int_neg	= EVENT_RATE_1E10_NEG_MSB;																		
				break;			
				
	default : event_rate_lsb1_int_pos 			= EVENT_RATE_1E6_POS_LSB1; 
				event_rate_lsb2_int_pos	 			= EVENT_RATE_1E6_POS_LSB2;
				event_rate_msb_and_sign_int_pos	= EVENT_RATE_1E6_POS_MSB;
				event_rate_lsb1_int_neg 			= EVENT_RATE_1E6_NEG_LSB1; 
				event_rate_lsb2_int_neg	 			= EVENT_RATE_1E6_NEG_LSB2;
				event_rate_msb_and_sign_int_neg	= EVENT_RATE_1E6_NEG_MSB;															
				break;						
	
	}

		
	///////////////////////////////////////////////////////////////////////////
	//Setup test for Eye Height 
	///////////////////////////////////////////////////////////////////////////

	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM: Setup Test for Eye Height");
	
		readout = cpi_request_fgt(phy, channel, offset, 0x07, 0x45,1,1);
		readout = cpi_request_fgt(phy, channel, offset, 0x07, 0x45,0,1);		
			
	///////////////////////////////////////////////////////////////////////////
	//Clear and Reset previous parameters
	///////////////////////////////////////////////////////////////////////////

	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM: Clear and Reset previous parameters");

		readout = cpi_request_fgt(phy, channel, offset, 0x05, 0x91,1,1);
		readout = cpi_request_fgt(phy, channel, offset, 0x05, 0x91,0,1);	
		

	///////////////////////////////////////////////////////////////////////////
	//config :  Set Cursor ID, slicer ID, interfering symbol and victim
	///////////////////////////////////////////////////////////////////////////

	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM: config :  Set basic_measure_config to 0x%x",basic_measure_config);

		readout = cpi_request_fgt(phy, channel, offset, basic_measure_config, 0x48,1,1);
		readout = cpi_request_fgt(phy, channel, offset, basic_measure_config, 0x48,0,1);	
	
	///////////////////////////////////////////////////////////////////////////
	//config :  Set event_rate_lsb1_int
	///////////////////////////////////////////////////////////////////////////
	
	if (pos)
	{
	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM: config :  Set event_rate_lsb1_int to 0x%x",event_rate_lsb1_int_pos);

		readout = cpi_request_fgt(phy, channel, offset, event_rate_lsb1_int_pos, 0x48,1,1);
		readout = cpi_request_fgt(phy, channel, offset, event_rate_lsb1_int_pos, 0x48,0,1);
	}
	else
	{
	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM: config :  Set event_rate_lsb1_int to 0x%x",event_rate_lsb1_int_neg);

		readout = cpi_request_fgt(phy, channel, offset, event_rate_lsb1_int_neg, 0x48,1,1);
		readout = cpi_request_fgt(phy, channel, offset, event_rate_lsb1_int_neg, 0x48,0,1);
	}		
	
	///////////////////////////////////////////////////////////////////////////
	//config :  Set event_rate_lsb2_int
	///////////////////////////////////////////////////////////////////////////

	if (pos)
	{
	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM: config :  Set event_rate_lsb2_int to 0x%x",event_rate_lsb2_int_pos);

		readout = cpi_request_fgt(phy, channel, offset, event_rate_lsb2_int_pos, 0x48,1,1);
		readout = cpi_request_fgt(phy, channel, offset, event_rate_lsb2_int_pos, 0x48,0,1);
	}
	else
	{
	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM: config :  Set event_rate_lsb2_int to 0x%x",event_rate_lsb2_int_neg);

		readout = cpi_request_fgt(phy, channel, offset, event_rate_lsb2_int_neg, 0x48,1,1);
		readout = cpi_request_fgt(phy, channel, offset, event_rate_lsb2_int_neg, 0x48,0,1);		
	}

	///////////////////////////////////////////////////////////////////////////
	//config :  Set event_rate_msb_and_sign_int 
	///////////////////////////////////////////////////////////////////////////
	if (pos)
	{
	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM: config :  Set event_rate_msb_and_sign_int to 0x%x",event_rate_msb_and_sign_int_pos );

		readout = cpi_request_fgt(phy, channel, offset, event_rate_msb_and_sign_int_pos, 0x48,1,1);
		readout = cpi_request_fgt(phy, channel, offset, event_rate_msb_and_sign_int_pos, 0x48,0,1);
	}
	else
	{
	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM: config :  Set event_rate_msb_and_sign_int to 0x%x",event_rate_msb_and_sign_int_neg );

		readout = cpi_request_fgt(phy, channel, offset, event_rate_msb_and_sign_int_neg, 0x48,1,1);
		readout = cpi_request_fgt(phy, channel, offset, event_rate_msb_and_sign_int_neg, 0x48,0,1);
	}		
		
	
	///////////////////////////////////////////////////////////////////////////
	//Start test
	///////////////////////////////////////////////////////////////////////////	


	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM: Start Test");
	
		readout = cpi_request_fgt(phy, channel, offset, 0x20, 0x0F,1,1);
		readout = cpi_request_fgt(phy, channel, offset, 0x20, 0x0F,0,1);
	
	usleep(1000);
	//if (DEBUG_EHM) printf("\n==============>DEBUG_EHM : Wait for %d ms",wait_time_ms_after_ehm_start);	
	//usleep(wait_time_ms_after_ehm_start*1000);
	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM : Wait for 10 ms");		
   usleep(10000);

	///////////////////////////////////////////////////////////////////////////
	//Check test status
	///////////////////////////////////////////////////////////////////////////		

	do
	{
	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM : Check Test Status");	
	
		success = check_cpi_test_status(phy,channel,offset,0x49);
		usleep(10000);
	} while (success == 0);


	if (success)
		if (DEBUG_EHM) printf("\n==============>DEBUG_EHM : measurement done");	

	///////////////////////////////////////////////////////////////////////////
	//Stop Test
	///////////////////////////////////////////////////////////////////////////	

	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM: Stop Test");
	
		readout = cpi_request_fgt(phy, channel, offset, 0x21, 0x0F,1,1);
		readout = cpi_request_fgt(phy, channel, offset, 0x21, 0x0F,0,1);	
	

	
	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM : Test stopped");		


	///////////////////////////////////////////////////////////////////////////
	//Readout result
	///////////////////////////////////////////////////////////////////////////	

	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM : Read Result");		
	
	readout = get_cpidata(phy,channel,offset,0x0,0x4A);
	if (DEBUG_EHM) printf("\n==============>DEBUG_EHM : Readout 0x4A : 0x%x", readout);	
	// readout = get_cpidata(phy,channel,offset,0x0,0x4B);
	// if (DEBUG_EHM) printf("\n==============>DEBUG_EHM : Readout 0x4B : 0x%x", readout);	
	// readout = get_cpidata(phy,channel,offset,0x0,0x4C);
	// if (DEBUG_EHM) printf("\n==============>DEBUG_EHM : Readout 0x4C : 0x%x", readout);	
	// readout = get_cpidata(phy,channel,offset,0x0,0x4D);
	// if (DEBUG_EHM) printf("\n==============>DEBUG_EHM : Readout 0x4D : 0x%x", readout);	

	readout = get_cpidata(phy,channel,offset,0x0,0x4A);
		
	
		return (readout);
}
				 

