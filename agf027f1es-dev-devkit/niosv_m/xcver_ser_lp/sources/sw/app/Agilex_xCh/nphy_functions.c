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

/* NPHY functions */
//2 PHY's with each PHY using 4 times a 1 channel instance (4 AVMM per PHY)

//Author 	: Peter Schepers
//Version 	: 2.0
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

#include "parameters.h"



unsigned int rd_channel (int phy, int offset)
 {

	 unsigned int value;
	 
	if (BYTE_ADDRESSING_USED == 1) offset = offset/4;


	switch(phy)
		{
			case 0	 		:
				if (offset < (1 << CHANNEL_OFFSET))
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_0_OFFSET,offset);
				else if ((offset >= (1 << CHANNEL_OFFSET)) && (offset < (2 << CHANNEL_OFFSET)) )
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_1_OFFSET,offset- (1 << CHANNEL_OFFSET));
				else if ((offset >= (2 << CHANNEL_OFFSET)) && (offset < (3 << CHANNEL_OFFSET)) )
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_2_OFFSET,offset- (2 << CHANNEL_OFFSET));
				else if (offset >= (3 << CHANNEL_OFFSET))
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_3_OFFSET,offset- (3 << CHANNEL_OFFSET));
				else
						printf("!!!!!!======>>>> ACCESS ERROR, address out of range");
				break;
			
			case 1		 : 
				if (offset < (1 << CHANNEL_OFFSET))
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_4_OFFSET,offset);
				else if ((offset >= (1 << CHANNEL_OFFSET)) && (offset < (2 << CHANNEL_OFFSET)) )
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_5_OFFSET,offset- (1 << CHANNEL_OFFSET));
				else if ((offset >= (2 << CHANNEL_OFFSET)) && (offset < (3 << CHANNEL_OFFSET)) )
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_6_OFFSET,offset- (2 << CHANNEL_OFFSET));
				else if (offset >= (3 << CHANNEL_OFFSET))
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_7_OFFSET,offset- (3 << CHANNEL_OFFSET));
				else
						printf("!!!!!!======>>>> ACCESS ERROR, address out of range");
				break;	

				
			default	 		: value = 0;break;				
		}
		
	 return(value);
} 

void wr_channel (int phy, int offset, unsigned int value)
 {
	  
	if (BYTE_ADDRESSING_USED == 1) offset = offset/4;
	
	switch(phy)
		{
			case 0	 		:
				if (offset < (1 << CHANNEL_OFFSET))
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_0_OFFSET,offset,value);
				else if ((offset >= (1 << CHANNEL_OFFSET)) && (offset < (2 << CHANNEL_OFFSET)) )
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_1_OFFSET,offset- (1 << CHANNEL_OFFSET),value);
				else if ((offset >= (2 << CHANNEL_OFFSET)) && (offset < (3 << CHANNEL_OFFSET)) )
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_2_OFFSET,offset- (2 << CHANNEL_OFFSET),value);
				else if (offset >= (3 << CHANNEL_OFFSET))
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_3_OFFSET,offset- (3 << CHANNEL_OFFSET),value);
				else
						printf("!!!!!!======>>>> ACCESS ERROR, address out of range");
				break;
			
			case 1		 : 
				if (offset < (1 << CHANNEL_OFFSET))
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_4_OFFSET,offset,value);
				else if ((offset >= (1 << CHANNEL_OFFSET)) && (offset < (2 << CHANNEL_OFFSET)) )
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_5_OFFSET,offset- (1 << CHANNEL_OFFSET),value);
				else if ((offset >= (2 << CHANNEL_OFFSET)) && (offset < (3 << CHANNEL_OFFSET)) )
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_6_OFFSET,offset- (2 << CHANNEL_OFFSET),value);
				else if (offset >= (3 << CHANNEL_OFFSET))
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_XCVR_7_OFFSET,offset- (3 << CHANNEL_OFFSET),value);
				else
						printf("!!!!!!======>>>> ACCESS ERROR, address out of range");
				break;

				
				
			default 			: break;
		}	  
} 

	  
void rmw_channel (int phy, int offset,unsigned int bitmask, unsigned int newval)
 {

	 
unsigned int value;	 
	  

	  //Read data from data register at offset (32-bit)
	  
	  value = rd_channel(phy, offset);

	   // bitwise-AND and clear out bitmask bits
	 
	  value = value & (0xffffffff & (~bitmask));
	 
	  value = value | newval;
	  
	  wr_channel(phy,offset,value);
} 

void rmw_channel_ftile (int phy, int channel, int offset,int address, unsigned int bitmask, unsigned int newval)
{

unsigned int readout;
int lane;

	readout = rd_channel(phy,(channel << offset) + 0xFFFFC);
	lane = readout & (0x00000003); 
	
	rmw_channel(phy,(channel << offset) + address + lane*0x8000,bitmask,newval); 

}						
						
unsigned int rd_channel_ftile (int phy, int channel, int offset,int address)
{
unsigned int readout;
int lane;

	readout = rd_channel(phy,(channel << offset) + 0xFFFFC);
	lane = readout & (0x00000003); 
	
	readout = rd_channel(phy,(channel << offset) + address + lane*0x8000);

return(readout);

}							
							
unsigned int rd_pdp_channel (int phy, int offset)
 {

	 unsigned int value;
	 
	if (BYTE_ADDRESSING_USED == 1) offset = offset/4;


	switch(phy)
		{
			case 0	 		:
				if (offset < (1 << CHANNEL_OFFSET_PDP))
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_0_OFFSET,offset);
				else if ((offset >= (1 << CHANNEL_OFFSET_PDP)) && (offset < (2 << CHANNEL_OFFSET_PDP)) )
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_1_OFFSET,offset- (1 << CHANNEL_OFFSET_PDP));
				else if ((offset >= (2 << CHANNEL_OFFSET_PDP)) && (offset < (3 << CHANNEL_OFFSET_PDP)) )
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_2_OFFSET,offset- (2 << CHANNEL_OFFSET_PDP));
				else if (offset >= (3 << CHANNEL_OFFSET_PDP))
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_3_OFFSET,offset- (3 << CHANNEL_OFFSET_PDP));
				else
						printf("!!!!!!======>>>> ACCESS ERROR, address out of range");
				break;
			
			case 1		 : 
				if (offset < (1 << CHANNEL_OFFSET_PDP))
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_4_OFFSET,offset);
				else if ((offset >= (1 << CHANNEL_OFFSET_PDP)) && (offset < (2 << CHANNEL_OFFSET_PDP)) )
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_5_OFFSET,offset- (1 << CHANNEL_OFFSET_PDP));
				else if ((offset >= (2 << CHANNEL_OFFSET_PDP)) && (offset < (3 << CHANNEL_OFFSET_PDP)) )
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_6_OFFSET,offset- (2 << CHANNEL_OFFSET_PDP));
				else if (offset >= (3 << CHANNEL_OFFSET_PDP))
						value = IORD(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_7_OFFSET,offset- (3 << CHANNEL_OFFSET_PDP));
				else
						printf("!!!!!!======>>>> ACCESS ERROR, address out of range");
				break;

				
			default	 		: value = 0;break;					
		}
		
	 return(value);
} 

void wr_pdp_channel (int phy, int offset, unsigned int value)
 {  
 
	if (BYTE_ADDRESSING_USED == 1) offset = offset/4;
	
	switch(phy)
		{
			case 0	 		:
				if (offset < (1 << CHANNEL_OFFSET_PDP))
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_0_OFFSET,offset,value);
				else if ((offset >= (1 << CHANNEL_OFFSET_PDP)) && (offset < (2 << CHANNEL_OFFSET_PDP)) )
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_1_OFFSET,offset- (1 << CHANNEL_OFFSET_PDP),value);
				else if ((offset >= (2 << CHANNEL_OFFSET_PDP)) && (offset < (3 << CHANNEL_OFFSET_PDP)) )
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_2_OFFSET,offset- (2 << CHANNEL_OFFSET_PDP),value);
				else if (offset >= (3 << CHANNEL_OFFSET_PDP))
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_3_OFFSET,offset- (3 << CHANNEL_OFFSET_PDP),value);
				else
						printf("!!!!!!======>>>> ACCESS ERROR, address out of range");
				break;
			
			case 1		 : 
				if (offset < (1 << CHANNEL_OFFSET_PDP))
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_4_OFFSET,offset,value);
				else if ((offset >= (1 << CHANNEL_OFFSET_PDP)) && (offset < (2 << CHANNEL_OFFSET_PDP)) )
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_5_OFFSET,offset- (1 << CHANNEL_OFFSET_PDP),value);
				else if ((offset >= (2 << CHANNEL_OFFSET_PDP)) && (offset < (3 << CHANNEL_OFFSET_PDP)) )
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_6_OFFSET,offset- (2 << CHANNEL_OFFSET_PDP),value);
				else if (offset >= (3 << CHANNEL_OFFSET_PDP))
						IOWR(PHY_REG_SET_BASE + PHY_REG_SET_RECONFIG_PDP_7_OFFSET,offset- (3 << CHANNEL_OFFSET_PDP),value);
				else
						printf("!!!!!!======>>>> ACCESS ERROR, address out of range");
				break;
				
				
			default 			: break;
		}	    
} 

	  
void rmw_pdp_channel (int phy, int offset,unsigned int bitmask, unsigned int newval)
 {

	 
unsigned int value;	 

		  

	  //Read data from data register at offset (32-bit)
	  
	  value = rd_pdp_channel(phy, offset);

	   // bitwise-AND and clear out bitmask bits
	 
	  value = value & (0xffffffff & (~bitmask));
	 
	  value = value | newval;
	  
	  wr_pdp_channel(phy,offset,value);
} 





