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

//parameters.h
//Contains all defines

//Channel offset for reconfig_xcr 
#define CHANNEL_OFFSET 18 

//Channel offset for reconfig_pdp
#define CHANNEL_OFFSET_PDP 14 

//Addresses for loopbacks
#define LOOPBACK_ADDR_FGT 0x4781C
#define LOOPBACK_ADDR_FHT 0x45800

//Select if Byte addressing is being used.
#define BYTE_ADDRESSING_USED 1

#define NIOS_TERMINAL_19_1 0

#define NUMBER_OF_MS_PER_HOUR 3600000
#define NUMBER_OF_MS_PER_MINUTE 60000
#define NUMBER_OF_MS_PER_SECOND 1000


#define TIMEOUT_ADAPTATION_MS 6000.0 //Timeout for the adaption in ms
#define TIMEOUT_ADAPTATION_MS_OPTICS 12000.0 //Timeout for the adaption in ms when using optics
#define LOOPCOUNT 1000
#define SHOW_ADAPT_TIME 1

#define ENABLE_MUTE_LANES 1
#define MUTE_ALL_CHANNELS 1

#define SHOW_ADVANCED_EQUALIZATION_PARAMETERS 1
#define SHOW_ADVANCED_DEBUG_EQUALIZATION_PARAMETERS 1

#define SHOW_BITSLIP_COUNT 1

#define BITSLIP_START_BIT_POSITION 8 //use 4 for 8 lane PMA direct design with 8 instances, use 8 for design for 4 instances

///////////////////////////////////////////////////////////////////////				
// Superlite II/IV design?
///////////////////////////////////////////////////////////////////////	
//#define SUPERLITE_ENABLED 1 //uncomment if Superlite II or IV is used
#define SUPERLITE_USED 0
#define SUPERLITEIV_USED 0 // 1: Superlite IV, 0 : Superlite II

#define READ_LENGTH 40960 // This should match the RTL implementation
#define IDLE_LENGTH 7	  // This should match the RTL implementation

///////////////////////////////////////////////////////////////////////				
// XGMII Design?
///////////////////////////////////////////////////////////////////////	
//#define XGMII_ENABLED 1 //uncomment if XGMII is used
#define XGMII_USED 0


///////////////////////////////////////////////////////////////////////				
// Design Specific parameters
///////////////////////////////////////////////////////////////////////	

//Number of Tiles, PHYs and Lanes
#define PMA_BONDING 0 //Set to 1 if more than 1 PMA lane is used in the Phy Direct IP
#define NUMBER_OF_TILES 1
#define NUMBER_OF_PHYS 2
#define NUMBER_OF_PHYS_MAX 4
#define NUMBER_OF_LANES_PHY 4
#define NUMBER_OF_FECS_PHY 4 
#define NUMBER_OF_SEGMENTS 2			//Amount of segments per FEC (50G = 2, 100G = 4, 200G = 8, 400G = 16)
#define NUMBER_OF_SEGMENTS_LANE 2	//This is how many segments are used per PRBSVerifier : 128 bit = 2, 256 bit = 4, 64 bit = 1.
#define NUMBER_OF_VIRTUAL_LANES 8 //NUMBER_OF_SEGMENTS*NUMBER_OF_FECS_PHY
#define NUMBER_OF_LANES_MAX 4 // = NUMBER_OF_LANES_PHY : used to dimension Arrays.
#define AGGREGATE_FECS 0 				//Set to 1 if the designs uses multiple FECS as one aggregate block (e.g. 2x200GE aggregate to make 1 virtual 400G Datapipe)

#define EXTRA_FEC_COMMENTS 1			//Set to 0 if using 600G phy in order to not have too much on the display

#define FORCE_SERIAL_LOOPBACK_FGT 1 //Set to 1 to force all lanes to enable serial loopback at start

#define PASS_FAIL_MODE 1				//Set to 1 to disable user input.

//Internal noise
#define INTERNAL_NOISE_REGISTER_PRESENT //uncomment if QSYS system has internal noise register control
#define NUMBER_OF_WABS 8


//Design Specifics
		
#define PHY0_PAM4_DESIGN 1    //set to 1 if PAM4 is used on PHY0
#define PHY1_PAM4_DESIGN 1    //set to 1 if PAM4 is used on PHY1
#define PHY2_PAM4_DESIGN 0    //set to 1 if PAM4 is used on PHY2
#define PHY3_PAM4_DESIGN 0    //set to 1 if PAM4 is used on PHY3

//multiplier of the tx_coreclk frequency to reach the line rate
#define PHY0_CORECLK_MULTIPLIER 128
#define PHY1_CORECLK_MULTIPLIER 128
#define PHY2_CORECLK_MULTIPLIER 128
#define PHY3_CORECLK_MULTIPLIER 128

//multiplier for the reference clock to reach the line rate
//NRZ 26 Gbps 165 if using 156.25 Mhz
//PAM4 53 Gbps 2x170 if using 156.26 Mhz
//PAM4 106 Gbps 4x170 if using 156.25 Mhz
#define PHY0_TX_CLK_DIVIDER 340
#define PHY1_TX_CLK_DIVIDER 340
#define PHY2_TX_CLK_DIVIDER 340
#define PHY3_TX_CLK_DIVIDER 340


//#define RESET_CONTROL_REG_ENABLED //uncomment if Reset Control Register is used to reset the PHY's instead of Control_Reg
#define RESET_CONTROL_REG_USED 0
#define PMA_DIRECT_MODE 0 		//set to zero if RSFEC is used
#define RSFEC_USED 1   		//uncomment if RSFEC is used (used for #ifdef statements)
#define PRBSLOCK_ALARM_COUNTER_ENABLED //uncomment if the PRBS_Lock_Alarm_Counter is used in the design (used for #ifdef statements)
#define PRBSLOCK_ALARM_COUNTER_USED 1 
//#define PRBSLOCK_ALARM_COUNTER_ALT_ENABLED //uncomment if the 64-bit version of the PRBS lock alarm counter is used
//#define BER_CONTROL_ENABLED //uncomment if BER_Control register is enabled in the design
#define BER_CONTROL_USED 0
#define RX_AM_LOCK_ALARM_COUNTER_ENABLED //Uncomment For RSFEC designs that uses this feature
#define RX_AM_LOCK_ALARM_COUNTER_USED 1 //For RSFEC design that uses this feature
#define SCRAMBLED_IDLE_PATTERN_SUPPORTED 1 //Set to 1 if this feature is available in the design
#define USE_PAM4_CLOCK_PATTERN_INSTEAD_OF_PRBS7 0 //set to 1 if 128bit prbsgenerator is using clockpattern instead of PRBS-7
#define USE_PAM4_DUAL_CLOCK_PATTERN 0 // set to 1 if 128 bit prbsgenerator supports FF00 and FFFF0000 patterns
#define DUAL_RSFEC_CODEWORD 0 //This determines whether the FEC is using dual codewords or not (100G-1/400G-4 : not used)
#define PAM4_50GBE 1
#define PAM4_100GBE_FRACTURED 0 //FHT 1x100G
#define PAM4_100GBE_AGGREGATE 0 //2x53G or 4x26G
#define PAM4_200GBE 0
#define PAM4_400GBE 0
#define NRZ_GBE25 0
#define USE_KPFEC 1 
//FHT Settings
#define FHT_USED	0				//set to 1 if FHT is used
#define USE_128BIT_PRBS_NRZ 0			//set to 1 if FHT using NRZ at 53 Gbps using 128 bit PRBS
#define FHT_NRZ 0
#define FHT_HIGHEST_RATE 0 	//set to 1 if FHT with 106 Gbps or more is used
#define FHT_TX_SETTINGS_100G 0
#define FHT_TX_SETTINGS_50G 0
#define USE_SCRAMBLER 1
#define USE_REC_CLOCK_DIV66 1 //set to 1 if this is a system PLL clocked design where the recovered clock/66 is being measured as rx_clkout
#define REC_CLOCK_MEASURE_CHANNEL 0 //identify which Channel is used to bring out the recovered clock (by default channel 0)

#define AGILEX_PCIE_DEVKIT 0
#define AGILEX_HS_DEMO_KIT 0  
#define AGILEX_MUDV_BOARD 0 
#define AGILEX_SI_BOARD 0
#define AGILEX_MGM_BOARD 0
#define AGILEX_FM86_BOARD 1

#define ACCUMULATE_ERRORS 1	

#define WAIT_AFTER_CHANGING_TX_PMA_SETTING 1
#define WAIT_TIME_AFTER_CHANGING_TX_PMA_SETTING 10000 //10 seconds
#define CHANGE_TX_PMA_SETTINGS_ALL_LANES 1 // for sweep tests
//Strings for the mapping of the PHYS

//1 or 2 PHY designs
//#define PHY0_NAME "  QSFPDD0 bottom" //NRZ AGILEX PCIE DEVKIT
#define PHY0_NAME "  QSFPDD-56" //PAM4 AGILEX PCIE DEVKIT
//#define PHY0_NAME "  OSFP800" //FHT PAM4 AGILEX HS DEMO BOARD
//#define PHY0_NAME "  FMC+" //FGT AGILEX HS DEMO BOARD
#define PHY1_NAME "  QSFPDD-56"
//#define PHY1_NAME "        "
//#define PHY1_NAME "  FMC+" //FGT AGILEX HS DEMO BOARD
#define PHY2_NAME "        "
#define PHY3_NAME "        "


//3 PHY Designs
//#define PHY0_NAME "  QSFPDD1 top" //PAM4 AGILEX PCIE DEVKIT
//#define PHY1_NAME "  QSFPDD1 bottom" //PAM4 AGILEX PCIE DEVKIT
//#define PHY2_NAME "  QSFPDD0 top" //PAM4 AGILEX PCIE DEVKIT
//#define PHY3_NAME "        "  

// #define PHY0_NAME "  Quad2" //FGT AGILEX HS DEMO BOARD
// #define PHY1_NAME "  Quad1" //FGT AGILEX HS DEMO BOARD
// #define PHY2_NAME "       " //FGT AGILEX HS DEMO BOARD
// #define PHY3_NAME "       " //FGT AGILEX HS DEMO BOARD 
#define PHY0_TILE "12C"
#define PHY1_TILE "12C"
#define PHY2_TILE "12A"
#define PHY3_TILE "12C"

 



///////////////////////////////////////////////////////////////////////				
// I2C Parameters
///////////////////////////////////////////////////////////////////////	
#define I2CTEST 0
#define I2C_PRINT_PHY_INFO 0
#define ENABLE_I2C_ACCESS_QSFPDD0 0
#define ENABLE_I2C_ACCESS_QSFPDD1 0
#define ENABLE_I2C_ACCESS_QSFPDD800 0



#define RX_CLK_DIVIDER_KPFEC 170
#define TX_CLK_DIVIDER_KPFEC 170

#define RX_CLK_DIVIDER_RSFEC 165
#define TX_CLK_DIVIDER_RSFEC 165




#define AGGREGATE 0
#define FRACTURED 1



#define FRACTURED_50GBE 2
#define FRACTURED_100GBE 3 //this is 100GBE line rate when using FHT
#define AGGREGATE_200GBE 4
#define AGGREGATE_400GBE 5
#define AGGREGATE_100GBE 6 //this is using 2x53G or 4x25G


#define MEDIA_MODE_FW_DEFAULT		  		0x10
#define MEDIA_MODE_VSR_OPTICAL_MODULE	0x14


#define CHIP2CHIP 0
#define BACKPLANE 1
#define SHORT 2
#define DAC 3
#define OPTICAL 4
#define ELECTRICAL 5
#define FGT_DEFAULT 6
#define FHT_DEFAULT 7

#define NONE 0
#define FMC 1
#define QSFP28 2
#define BKP 3
#define SMA 4
#define LPBK 5
#define MXP 6
#define SFP 7
#define OSFP 8
#define QSFPDD 9
#define QSFPDD800 10

#define AGILEX_SI_BOARD_PHY_0_CONNECTION_TYPE 1 //FMC
#define AGILEX_SI_BOARD_PHY_1_CONNECTION_TYPE 1 //FMC
#define AGILEX_SI_BOARD_PHY_2_CONNECTION_TYPE 9 //QSFPDD
#define AGILEX_SI_BOARD_PHY_3_CONNECTION_TYPE 9 //QSFPDD


#define NO_REV_SERIAL 0
#define POSTCDR 1
#define PRECDR 2

#define REFCLOCKMULTIPLIER0 64
#define REFCLOCKMULTIPLIER1 64
#define REFCLOCKMULTIPLIER2 64
#define REFCLOCKMULTIPLIER3 64
#define MULTIPLIER 65536.0 // 2^16

//ethernet base address
#define GBE25 	0x6000
#define GBE50	0x6200
#define GBE100 0x6600
#define GBE200 0x6E00
#define GBE400 0x7E00

//ODI Related parameters start

#define DEBUG_ODI 0

#define DimA 130
#define DimB 130
#define VERTICAL_SIZE 64
#define VCCER_900MV 1
#define VCCER_1030MV 2
#define VCCER_1110MV 3


//OLD ODI Bandwidth settings (A10 and L-Tile ES1)
#define BELOW_2GBPS 0
#define BETWEEN_2GBPS_5GBPS 1
#define BETWEEN_5GBPS_10GBPS 2
#define ABOVE_10GBPS 3

//New ODI Bandwidth settings (H-Tile)

#define BELOW_6G5 	4
#define BETWEEN_6G5_12G5 3		
#define BETWEEN_12G5_20G 2
#define ABOVE_20G 1

//ODI Runtime parameters

#define ODI_2E16 0
#define ODI_1E6 1
#define ODI_1E7 2
#define ODI_1E8 3
#define ODI_3x1E8 4
#define ODI_1E9 5
#define ODI_2E32 6
#define ODI_NONSTOP 7 

// OTHER ODI
#define WAIT_TIME 10
#define ODI_ALL_INFO 1
#define CONSTANT 410
#define ERROR_TRESSHOLD 3
#define PAUSE_AFTER_ODI 1
#define FOM_BER 0
#define FOM_EYE 1
#define FOM_EYE_SYMMETRY 2
#define DO_CDR_PHASE_READOUT 0
#define TWO_DIMENSIONAL 1
#define ONE_DIMENSIONAL 0
				
//ODI Related parameters Stop


//PMA SWEEP PARAMETERS
#define PMA_SWEEP_TIME_MS 5000
#define MAX_SWEEP_RANGE 65
#define PRINT_EYE_DURING_SWEEP 0
#define DO_BER_MEASUREMENT 1
#define DO_ODI 1
#define UPDATE 1
#define SWEEP_AVERAGE 100
#define SWEEP_TIME 2 



#define DEBUG 0
#define ADVANCED 0
#define RESET_CYCLES 1000
#define STOP 1





//2's complement

#define PRE_TAP3_1N 0xFF
#define PRE_TAP3_0 0
#define PRE_TAP3_1 1


#define PRE_TAP2_15N 0xF1
#define PRE_TAP2_14N 0xF2
#define PRE_TAP2_13N 0xF3
#define PRE_TAP2_12N 0xF4
#define PRE_TAP2_11N 0xF5
#define PRE_TAP2_10N 0xF6
#define PRE_TAP2_9N 0xF7
#define PRE_TAP2_8N 0xF8
#define PRE_TAP2_7N 0xF9
#define PRE_TAP2_6N 0xFA
#define PRE_TAP2_5N 0xFB
#define PRE_TAP2_4N 0xFC
#define PRE_TAP2_3N 0xFD
#define PRE_TAP2_2N 0xFE
#define PRE_TAP2_1N 0xFF
#define PRE_TAP2_0 0
#define PRE_TAP2_1 1
#define PRE_TAP2_2 2
#define PRE_TAP2_3 3
#define PRE_TAP2_4 4
#define PRE_TAP2_5 5
#define PRE_TAP2_6 6
#define PRE_TAP2_7 7
#define PRE_TAP2_8 8
#define PRE_TAP2_9 9
#define PRE_TAP2_10 10
#define PRE_TAP2_11 11
#define PRE_TAP2_12 12
#define PRE_TAP2_13 13
#define PRE_TAP2_14 14
#define PRE_TAP2_15 15

// only even values allowed
#define PRE_TAP1_10N 0xF6
#define PRE_TAP1_8N 0xF8
#define PRE_TAP1_6N 0xFA
#define PRE_TAP1_4N 0xFC
#define PRE_TAP1_2N 0xFE
#define PRE_TAP1_0  0x0
#define PRE_TAP1_2  0x2
#define PRE_TAP1_4  0x4
#define PRE_TAP1_6  0x6
#define PRE_TAP1_8  0x8
#define PRE_TAP1_10  0xA



// only even values allowed
#define POST_TAP1_18N 0xEE
#define POST_TAP1_16N 0xF0
#define POST_TAP1_14N 0xF2
#define POST_TAP1_12N 0xF4
#define POST_TAP1_10N 0xF6
#define POST_TAP1_8N 0xF8
#define POST_TAP1_6N 0xFA
#define POST_TAP1_4N 0xFC
#define POST_TAP1_2N 0xFE
#define POST_TAP1_0 0
#define POST_TAP1_2 2
#define POST_TAP1_4 4
#define POST_TAP1_6 6
#define POST_TAP1_8 8
#define POST_TAP1_10 10
#define POST_TAP1_12 12
#define POST_TAP1_14 14
#define POST_TAP1_16 16
#define POST_TAP1_18 18




//Parameters for 64-bit PRBS generation/checking
#define PRBS_7 0
#define PRBS_23 1
#define PRBS_31 2
#define PRBS_15 3
#define HIGH_FREQUENCY 4
#define LOW_FREQUENCY 5
#define PRBS_9 6
#define FRAMED 7
#define PRBS_11 8

//Parameters for 128-bit PRBS generation/checking
#define PRBS_13_PAM4 0
#define PRBS_23_PAM4 1
#define PRBS_31_PAM4 2
#define PRBS_7_PAM4 3
#define PATTERN_FF00 4
#define PATTERN_FFFF0000 5




#define PAUSE_AFTER_SHOW_PMA_SETTINGS 1

#define PMA_SWEEP_WAIT_TIME_AFTER_RX_RESET 1000


#define NRZ 0
#define PAM4 1


#define MULTILANE 1
#define ML4062 2

#define QSFP_DD_LPBK_VOD 0
#define QSFP_DD_VOD 0
#define OSFP_VOD 0
#define ELECTRICAL_VOD 6
#define OPTICAL_VOD 0
#define MXP_VOD 6
#define BACKPLANE_VOD 6
#define SERIAL_LPBK_VOD 9





#define COLOR_INVERSE 		"\033[7m"
#define COLOR_RESET 			"\033[m"

#define COLOR_BLUE			"\033[22;34m"
#define COLOR_LIGHT_BLUE	"\033[01;34m"

#define COLOR_LIGHT_CYAN	"\033[01;36m"

#define COLOR_GREEN 			"\033[22;32m"
#define COLOR_LIGHT_GREEN	"\033[01;32m"

#define COLOR_YELLOW 		"\033[01;33m"

#define COLOR_RED 			"\033[22;31m"
#define COLOR_LIGHT_RED 	"\033[01;31m"


#define COLOR_ALARM_INVERT	"\033[7m\033[01;31m"
#define COLOR_ALARM			"\033[01;31m"
#define COLOR_OK				"\033[01;32m" 

#define COLOR_CORRECTABLE  "\033[01;33m"

#define DEGREES				"\xC2\xB0"
#define BLACKBOX			   "\xE2\x96\xA0"
#define BLACKBOX_FULL	   "\xE2\x96\x88"

#define BOX_LEFT_DOWN	   "\xE2\x94\x8C"
#define BOX_HORIZONTAL     "\xE2\x94\x80"

#define BOX_VERTICAL 		 "\xE2\x94\x82"
#define BOX_DOUBLE_VERTICAL "\xE2\x95\x91"
#define HALF_BLOCK_LEFT "\xE2\x96\x8C"



#define FANCY_GRAPHICS		1

