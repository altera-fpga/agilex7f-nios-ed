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

/* Channel functions */
//2 PHY's

//Author 	: Peter Schepers
//Version 	: 1.3
//Date		: 04/02/2022

#include <stdio.h>
#include "system.h"
#include "string.h"
#include "altera_avalon_pio_regs.h"
#include <unistd.h>
#include "io.h"
#include "altera_avalon_jtag_uart_regs.h"

#include "parameters.h"


#include "nphy_functions.h"

int Read_Channel_Reg( int phy,int SelectedChannel)
 {  
int temp;
	if (phy == 0)
	{
	switch(SelectedChannel)
	  {
	  case 0 :       
		  temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_CHANNEL_0_OFFSET);         		   
        break;     
      case 1:           		
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_CHANNEL_1_OFFSET);   
        break;       
      case 2:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_CHANNEL_2_OFFSET);   
        break;         
      case 3:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_CHANNEL_3_OFFSET);               
        break;    		
      default: 
			temp = 0;
      }  
	}
	else if (phy == 1)
	{
	switch(SelectedChannel)
	  {
	  case 0 :       
		  temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_CHANNEL_4_OFFSET);         		   
        break;     
      case 1:           		
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_CHANNEL_5_OFFSET);   
        break;       
      case 2:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_CHANNEL_6_OFFSET);   
        break;         
      case 3:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_CHANNEL_7_OFFSET);               
        break;     		
      default: 
			temp = 0;
      }  
	}	
	else
		printf("\n==================> Error : Acces undefined");			
	
 return (temp);      
}

unsigned int Read_ErrorCount_L_Reg( int phy, int SelectedChannel)
 {  
unsigned int temp;
	 
	if (phy == 0)
	{	 
	switch(SelectedChannel)
	  {
	  case 0 :       
		  temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_L_0_OFFSET);          		   
        break;     
      case 1:           		
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_L_1_OFFSET);   
        break;       
      case 2:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_L_2_OFFSET);    
        break;         
      case 3:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_L_3_OFFSET);        
        break;  

      default: 
		temp = 0;
      } 
	}
	else if (phy == 1)
	{	 
	switch(SelectedChannel)
	  {
	   case 0 :       
		  temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_L_4_OFFSET);           		   
        break;     
      case 1:           		
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_L_5_OFFSET);    
        break;       
      case 2:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_L_6_OFFSET);    
        break;         
      case 3:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_L_7_OFFSET);         
        break;	
      default: 
		temp = 0;
      } 
	}
	else
		printf("\n==================> Error : Acces undefined");			
	
 return (temp);      
}

unsigned int Read_ErrorCount_H_Reg( int phy, int SelectedChannel)
 {  
unsigned int temp;
	if (phy == 0)
	{	 
	switch(SelectedChannel)
	  {
	  case 0 :       
		  temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_H_0_OFFSET);          		   
        break;     
      case 1:           		
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_H_1_OFFSET);   
        break;       
      case 2:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_H_2_OFFSET);    
        break;         
      case 3:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_H_3_OFFSET);        
        break;  	
      default: 
		temp = 0;
      }   
	}	
	else if (phy == 1)
	{	 
	switch(SelectedChannel)
	  {
	   case 0 :       
		  temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_H_4_OFFSET);           		   
        break;     
      case 1:           		
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_H_5_OFFSET);    
        break;       
      case 2:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_H_6_OFFSET);    
        break;         
      case 3:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_ERROR_COUNT_H_7_OFFSET);         
        break;	
      default: 
		temp = 0;
      }   
	}
	else
		printf("\n==================> Error : Acces undefined");			
 return (temp);      
}

#ifdef PRBSLOCK_ALARM_COUNTER_ENABLED
unsigned int Read_PrbsLock_Alarm_Reg( int phy, int SelectedChannel)
 {  
unsigned int temp;
	if (phy == 0)
	{	 
	switch(SelectedChannel)
	  {
	  case 0 :       
		  temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_0_OFFSET);          		   
        break;     
      case 1:           		
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_1_OFFSET);   
        break;       
      case 2:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_2_OFFSET);    
        break;         
      case 3:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_3_OFFSET);        
        break;  	
      default: 
		temp = 0;
      }   
	}	
	else if (phy == 1)
	{	 
	switch(SelectedChannel)
	  {
	   case 0 :       
		  temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_4_OFFSET);           		   
        break;     
      case 1:           		
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_5_OFFSET);    
        break;       
      case 2:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_6_OFFSET);    
        break;         
      case 3:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_7_OFFSET);         
        break;	
      default: 
		temp = 0;
      }   
	}	
	else
		printf("\n==================> Error : Acces undefined");			
 return (temp);      
}
#ifdef PRBSLOCK_ALARM_COUNTER_ALT_ENABLED
unsigned int Read_PrbsLock_Alarm_Reg_Alt( int phy, int SelectedChannel)
 {  
unsigned int temp;
	if (phy == 0)
	{	 
	switch(SelectedChannel)
	  {
	  case 0 :       
		  temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_ALT_0_OFFSET);          		   
        break;     
      case 1:           		
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_ALT_1_OFFSET);   
        break;       
      case 2:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_ALT_2_OFFSET);    
        break;         
      case 3:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_ALT_3_OFFSET);        
        break;  	
      default: 
		temp = 0;
      }   
	}	
	else if (phy == 1)
	{	 
	switch(SelectedChannel)
	  {
	   case 0 :       
		  temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_ALT_4_OFFSET);           		   
        break;     
      case 1:           		
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_ALT_5_OFFSET);    
        break;       
      case 2:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_ALT_6_OFFSET);    
        break;         
      case 3:
        temp = IORD_ALTERA_AVALON_PIO_DATA(REG_SET_BASE + REG_SET_PRBSLOCK_ALARM_COUNT_ALT_7_OFFSET);         
        break;	
      default: 
		temp = 0;
      }   
	}	
	else
		printf("\n==================> Error : Acces undefined");			
 return (temp);      
}
#endif
#endif


unsigned int read_counter_1ms_reg (int phy)
{
unsigned int value;
	if (phy == 0)
	   value = IORD_ALTERA_AVALON_PIO_DATA(PHY_REG_SET_BASE + PHY_REG_SET_COUNTER_1MS_REG_0_OFFSET);
	else if (phy == 1)
		value = IORD_ALTERA_AVALON_PIO_DATA(PHY_REG_SET_BASE + PHY_REG_SET_COUNTER_1MS_REG_1_OFFSET);
	else
		printf("\n==================> Error : Acces undefined");
return (value);
}

unsigned int read_bitrate_reg (int phy)
{
unsigned int value;
	if (phy == 0)
	   value = IORD_ALTERA_AVALON_PIO_DATA(PHY_REG_SET_BASE + PHY_REG_SET_BITRATE_0_OFFSET);
	else if (phy == 1)
		value = IORD_ALTERA_AVALON_PIO_DATA(PHY_REG_SET_BASE + PHY_REG_SET_BITRATE_1_OFFSET);
	else
		printf("\n==================> Error : Acces undefined");	
return (value);
}

unsigned int read_rxclock_reg (int phy)
{
unsigned int value;
	if (phy == 0)
	   value = IORD_ALTERA_AVALON_PIO_DATA(PHY_REG_SET_BASE + PHY_REG_SET_RXCLOCK_0_OFFSET);
	else if (phy == 1)
		value = IORD_ALTERA_AVALON_PIO_DATA(PHY_REG_SET_BASE + PHY_REG_SET_RXCLOCK_1_OFFSET);
	else
		printf("\n==================> Error : Acces undefined");
return (value);
}
	
	
void write_control_reg(int phy,int Control_Reg)
{
	
	if (phy == 0)
     IOWR_ALTERA_AVALON_PIO_DATA(PHY_REG_SET_BASE + PHY_REG_SET_CONTROL_REG_0_OFFSET,Control_Reg);
	else if (phy == 1)
     IOWR_ALTERA_AVALON_PIO_DATA(PHY_REG_SET_BASE + PHY_REG_SET_CONTROL_REG_1_OFFSET,Control_Reg);
	else
		printf("\n==================> Error : Acces undefined");  
}

void write_control2_reg(int phy,int Control2_Reg)
{
	
	if (phy == 0)
     IOWR_ALTERA_AVALON_PIO_DATA(PHY_REG_SET_BASE + PHY_REG_SET_CONTROL2_REG_0_OFFSET,Control2_Reg);
	else if (phy == 1)
     IOWR_ALTERA_AVALON_PIO_DATA(PHY_REG_SET_BASE + PHY_REG_SET_CONTROL2_REG_1_OFFSET,Control2_Reg);
	else
		printf("\n==================> Error : Acces undefined");  
}

#ifdef BER_CONTROL_ENABLED
void write_ber_control_reg(int phy,int BER_Control)
{
	
	if (phy == 0)
     IOWR_ALTERA_AVALON_PIO_DATA(PHY_REG_SET_BASE + PHY_REG_SET_BER_CONTROL_0_OFFSET,BER_Control);
	else if (phy == 1)
     IOWR_ALTERA_AVALON_PIO_DATA(PHY_REG_SET_BASE + PHY_REG_SET_BER_CONTROL_1_OFFSET,BER_Control);
	else
		printf("\n==================> Error : Acces undefined");  
}
#endif

#ifdef RESET_CONTROL_REG_ENABLED
void write_reset_control_reg(int phy,int Reset_Control)
{
	
	if (phy == 0)
     IOWR_ALTERA_AVALON_PIO_DATA(PHY_REG_SET_BASE + PHY_REG_SET_RESET_CONTROL_0_OFFSET,Reset_Control);
	else if (phy == 1)
     IOWR_ALTERA_AVALON_PIO_DATA(PHY_REG_SET_BASE + PHY_REG_SET_RESET_CONTROL_1_OFFSET,Reset_Control);
	else
		printf("\n==================> Error : Acces undefined");  
}
#endif