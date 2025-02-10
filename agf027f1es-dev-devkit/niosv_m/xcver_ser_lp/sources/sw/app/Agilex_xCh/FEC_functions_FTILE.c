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


/* FEC functions */

//Author 	: Peter Schepers
//Version 	: 1.0
//Date		: 16/09/2021

#include <stdio.h>
#include "system.h"
#include "string.h"
#include "altera_avalon_pio_regs.h"
#include <unistd.h>
#include "io.h"
#include "altera_avalon_jtag_uart_regs.h"

#include "parameters.h"


#include "nphy_functions.h"


unsigned int Read_FEC_corr_codeword_Reg_L( int phy, int SelectedChannel, int ethernet_mode_base_address, int segment)
{  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	//rsfec_corr_cw_cnt_lo	
	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x184);

 return (result);      
}

unsigned int Read_FEC_corr_codeword_Reg_H( int phy, int SelectedChannel, int ethernet_mode_base_address, int segment)
 {  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	//rsfec_corr_cw_cnt_hi
	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp)  + base_address + 0x188);

 return (result);  
}

unsigned int Read_FEC_uncorr_codeword_Reg_L( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	//rsfec_uncorr_cw_cnt_lo	
	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x18C);

 return (result);  
}

unsigned int Read_FEC_uncorr_codeword_Reg_H( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	//rsfec_uncorr_cw_cnt_hi
	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x190);

 return (result);    
}


unsigned int Read_FEC_corr_symbols_Reg_L( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	//rsfec_corr_syms_cnt_lo	
	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x194);

 return (result);  
}

unsigned int Read_FEC_corr_symbols_Reg_H( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	//rsfec_corr_syms_cnt_hi
	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x198);

 return (result); 
}

unsigned int Read_FEC_corr_bits_0_1_Reg_L( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	//rsfec_corr_0s_cnt_lo
	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x19C);

 return (result); 
}

unsigned int Read_FEC_corr_bits_0_1_Reg_H( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	//rsfec_corr_0s_cnt_hi	
	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x1A0);

 return (result); 
}

unsigned int Read_FEC_corr_bits_1_0_Reg_L( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	//rsfec_corr_1s_cnt_lo	
	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x1A4);

 return (result);  
}

unsigned int Read_FEC_corr_bits_1_0_Reg_H( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	//rsfec_corr_1s_cnt_hi
	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x1A8);

 return (result);   
}

void Write_FEC_error_inject( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment,int pattern, int rate)
 {  
unsigned int temp;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	 
	 temp = ( ((pattern & (0x000000FF)) << 8) + (rate & (0x000000FF)) );
	 
	 wr_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x138,temp);


}

unsigned int Read_FEC_rx_lane_mapping( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x16C);

 return (result);    
}
	
unsigned int Read_FEC_rx_lane_skew( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	//rsfec_ln_skew_rx	
	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x170);

 return (result);    
}

unsigned int Read_FEC_rsfec_corr_cwbin_cnt_0_3( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;


	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x1D0);

 return (result);    
}

unsigned int Read_FEC_rsfec_corr_cwbin_cnt_4_7( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;


	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x1D4);

 return (result);    
}

unsigned int Read_FEC_rsfec_corr_cwbin_cnt_8_11( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;


	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x1D8);

 return (result);    
}

unsigned int Read_FEC_rsfec_corr_cwbin_cnt_12_15( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  
unsigned int result;
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;


	result = rd_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x1DC);

 return (result);    
}


void fec_shadow_request( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  

unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	 
	 wr_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x1E0,0x01);


}
	
void fec_clear_shadow_request( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  

unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	 
	 wr_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x1E0,0x00);


}	

void fec_clear_counters( int phy, int SelectedChannel,int ethernet_mode_base_address, int segment)
 {  
unsigned int offset_pdp;
unsigned int base_address;

		if (BYTE_ADDRESSING_USED == 1)
			offset_pdp = CHANNEL_OFFSET_PDP + 2;
		else
			offset_pdp = CHANNEL_OFFSET_PDP;
		
	
	base_address = ethernet_mode_base_address + segment*0x200;

	 
	 wr_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x1E0,0x10);
	 
	 usleep(100);
	 wr_pdp_channel(phy,(SelectedChannel << offset_pdp) + base_address + 0x1E0,0x00);	


}	


