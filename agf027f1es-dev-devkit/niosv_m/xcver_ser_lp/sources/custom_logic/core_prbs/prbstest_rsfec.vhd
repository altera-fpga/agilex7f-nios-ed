------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2021-2022 Intel Corporation
-- 
-- This code and the related documents are Intel copyrighted materials, and 
-- your use of them is governed by the express license under which they were 
-- provided to you ("License"). Unless the License provides otherwise, you may 
-- not use, modify, copy, publish, distribute, disclose or transmit this 
-- code or the related documents without Intel's prior written permission.
--
-- This code and the related documents are provided as is, with no express 
-- or implied warranties, other than those that are expressly stated in the 
-- License.
--
------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.package_registertype.all; --package that defines Registertypes

-- Note : editing and tabs are done with Quartus editor/Notepad++ (tab size = 3)

-- Author 	: Peter Schepers (peter.schepers@intel.com)
-- Variant  : 4x50GbE Fractional
-- Version 	: 1.1
-- Date		: 03/08/2021
 
-- Calls module txrx_pcs_64b66b_fgt which implements the fec functionality + phy direct ip
	
entity prbstest_rsfec is
GENERIC
	(
		KPFEC								:  boolean := true; -- true = RS(544,514) (KPFEC), false = RS(528,514) (RSFEC)
		FEC_MODE							:  integer := 1;  -- 0 = 100GbE or 25GbE, 1 = 400GbE, 200GbE and 50G-1
		AM_PULSE_WIDTH					:  integer := 2;  -- 2 for 400GbE, 200GbE aggregate and 50G-1, 4 for 25GbE fractured, 5 for 100GbE aggregate
		NUMBER_OF_LANES_PER_PHY		:  integer := 1;  -- Number of lanes of each PHY direct instance
		NUMBER_OF_COPIES				:  integer := 4; 	-- Number of copies of each PHY direct instances per phy (also the number of FECS)
		NUMBER_OF_LANES				:  integer := 4;  -- NUMBER_OF_LANES_PER_PHY * NUMBER_OF_COPIES
		NUMBER_OF_SEGMENTS			:  integer := 2;	-- 2 for 50GbE (not used in the RTL)
		NUMBER_OF_STREAMS				:  integer := 8;  -- NUMBER_OF_COPIES*NUMBER_OF_SEGMENTS
		LANEWIDTH						:  integer := 64; -- 64 bits per stream
		INVERT_POLARITY_PRBS			:  boolean := false;  -- For L/H tile set to true, For E/F-tile set to false (allows compatibility with Hard PRBS generators/checkers)		
		EXTERNAL_LATENCY				:  integer := 2;  -- This is the external latency of the data generation (from tx_datin_ready to tx_data_in_valid)
		SIMULATION_MODE            :  boolean := false
	);
PORT(
	init_done_n					: in std_logic;
	RefClock						: in std_logic; 	 			
	ClkMgmt						: in std_logic;
	Systempll_clk				: in std_logic;	
	Enable_Core					: in std_logic;
	XCVR_TX						: out STD_LOGIC_VECTOR ((NUMBER_OF_LANES - 1) DOWNTO 0);
	XCVR_TX_n					: out STD_LOGIC_VECTOR ((NUMBER_OF_LANES - 1) DOWNTO 0);		
	XCVR_RX						: in STD_LOGIC_VECTOR ((NUMBER_OF_LANES - 1) DOWNTO 0);  
	XCVR_RX_n					: in STD_LOGIC_VECTOR ((NUMBER_OF_LANES - 1) DOWNTO 0); 	
	Led							: out std_logic_vector(7 downto 0);
	Control_Reg					: in std_logic_vector(15 downto 0);
	Control2_Reg				: in std_logic_vector(15 downto 0);

	Bitrate_Reg					: out std_logic_vector(31 DOWNTO 0);
	RxClock_Reg					: out std_logic_vector(31 DOWNTO 0);
	Channel_Reg 				: out Register_Array_16bit;
	Counter_1ms_Reg			: out std_logic_vector(31 DOWNTO 0);
	ErrorCount_Reg 			: out Register_Array_64bit;	
   PrbsLock_Alarm_Reg		: out Register_Array_32bit;		-- combination of counting PrbsLockalarm and rx_am_lock de-asserted count
    
   --Reconfig_xcvr_interface 
	reconfig_xcvr_reset       : in  std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);   
	reconfig_xcvr_write       : in  std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);  
	reconfig_xcvr_read        : in  std_logic_vector((NUMBER_OF_COPIES - 1) downto 0); 
	reconfig_xcvr_address     : in  Register_Array_21bit;
	reconfig_xcvr_byteenable  : in  Register_Array_4bit;
	reconfig_xcvr_writedata   : in  Register_Array_32bit;
	reconfig_xcvr_readdata    : out Register_Array_32bit;
	reconfig_xcvr_waitrequest : out std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);                     
	
	-- RSFEC PDP interface			
	reconfig_pdp_reset        : in  std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);  
	reconfig_pdp_write        : in  std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);
	reconfig_pdp_read         : in  std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);
	reconfig_pdp_address      : in  Register_Array_21bit;
	reconfig_pdp_byteenable   : in  Register_Array_4bit;
	reconfig_pdp_writedata    : in  Register_Array_32bit;
	reconfig_pdp_readdata     : out Register_Array_32bit;
	reconfig_pdp_waitrequest  : out std_logic_vector((NUMBER_OF_COPIES - 1) downto 0)	
	
	);
END prbstest_rsfec;	


architecture rtl of prbstest_rsfec is


component txrx_pcs_64b66b_fgt is
GENERIC
	(
		KPFEC								:  boolean := true; -- true = RS(544,514), false = RS(528,514)
		FEC_MODE							:  integer := 1;  -- 0 = 100GbE or 25GbE, 1 = 200GbE and 50G-1
		AM_PULSE_WIDTH					:  integer := 2;  -- 2 for 200GbE aggregate and 50G-1, 4 for 25GbE fractured, 5 for 100GbE aggregate
		NUMBER_OF_LANES_PER_PHY		:  integer := 4;  -- Number of lanes of each PHY direct instance
		NUMBER_OF_COPIES				:  integer := 1; 	-- Number of copies of each PHY direct instances per phy (also the number of FECS)
		NUMBER_OF_LANES				:  integer := 4;  -- NUMBER_OF_LANES_PER_PHY * NUMBER_OF_COPIES
		NUMBER_OF_SEGMENTS			:  integer := 8;	-- 8 For 200GbE Aggregate (not used in the RTL)
		NUMBER_OF_STREAMS				:  integer := 8; 	-- NUMBER_OF_COPIES*NUMBER_OF_SEGMENTS
		LANEWIDTH						:  integer := 64; -- Always 64 bits for a single stream
		EXTERNAL_LATENCY				:  integer := 2;  -- This is the external latency of the data generation (from tx_datin_ready to tx_data_in_valid)
		SIMULATION_MODE             		:  boolean := true
	);
PORT(
	-- Global Reset
	Reset							: in std_logic;

	-- Clocks
	RefClock						: in std_logic; 	 			
	ClkMgmt						: in std_logic;
	Systempll_clk				: in std_logic;

	-- Control inputs
	enable_scrambler			: in std_logic;
	

	-- PHY direct IP related signals
	tx_reset						: in std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); -- ClkMgmt
	rx_reset   					: in std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); -- ClkMgmt
	tx_reset_ack_sync			: out std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); -- ClkMgmt
	rx_reset_ack_sync			: out std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); -- ClkMgmt
	
	tx_ready						: buffer std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); -- Asynchronous
	rx_ready						: buffer std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); -- Asynchronous

	tx_pll_locked				: out std_logic_vector((NUMBER_OF_LANES - 1) DOWNTO 0); -- Asynchronous
	
	tx_coreclk					: in std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); -- connect to tx_clkout externally
	tx_datain					: in std_logic_vector(((NUMBER_OF_STREAMS * LANEWIDTH)-1) downto 0); -- tx_coreclk
	tx_datain_valid			: in std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); -- tx_coreclk/based on tx_datain_ready
	tx_ctrlenable				: in std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); -- tx_coreclk

	tx_datain_ready			: buffer std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0);  -- tx_coreclk/ low during AM insertion and tx_pcs_ready low
	tx_clkout					: out std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0);
	tx_dataout					: out std_logic_vector((NUMBER_OF_LANES - 1) DOWNTO 0);
	tx_dataout_n				: out std_logic_vector((NUMBER_OF_LANES - 1) DOWNTO 0);

	rx_datain					: in std_logic_vector((NUMBER_OF_LANES - 1) DOWNTO 0);  
	rx_datain_n					: in std_logic_vector((NUMBER_OF_LANES - 1) DOWNTO 0); 	
	
	rx_coreclk					: buffer std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); -- is the same as rx_clkout(0) which is the same as tx_clkout(0)		
	rx_dataout					: out std_logic_vector (((NUMBER_OF_STREAMS * LANEWIDTH)-1) downto 0); -- rx_coreclk
	rx_ctrldetect				: out std_logic_vector ((NUMBER_OF_COPIES-1) DOWNTO 0); -- rx_coreclk
	rx_valid						: out std_logic_vector ((NUMBER_OF_COPIES-1) DOWNTO 0); -- rx_coreclk

	rx_am_lock					: out std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); -- rx_coreclk
	rx_am_lock_sync			: out std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); -- ClkMgmt

	rx_recovered_clk			: out std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); -- connected to rx_clkout2 which is the configured as div66 recovered clock	
	rx_freqlocked				: out std_logic_vector((NUMBER_OF_LANES - 1) DOWNTO 0); -- Asynchronous		
  
   --Reconfig_xcvr_interface 
	reconfig_xcvr_reset       : in  std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); 
	reconfig_xcvr_write       : in  std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0);
	reconfig_xcvr_read        : in  std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); 
	reconfig_xcvr_address     : in  Register_Array_21bit;
	reconfig_xcvr_byteenable  : in  Register_Array_4bit;
	reconfig_xcvr_writedata   : in  Register_Array_32bit;
	reconfig_xcvr_readdata    : out Register_Array_32bit;
	reconfig_xcvr_waitrequest : out std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0);                    
	
	-- RSFEC PDP interface	
	reconfig_pdp_reset        : in  std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0);
	reconfig_pdp_write        : in  std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0);
	reconfig_pdp_read         : in  std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0);
	reconfig_pdp_address      : in  Register_Array_21bit;
	reconfig_pdp_byteenable   : in  Register_Array_4bit;
	reconfig_pdp_writedata    : in  Register_Array_32bit;
	reconfig_pdp_readdata     : out Register_Array_32bit;
	reconfig_pdp_waitrequest  : out std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0)
	
	);
END component;	

component multi_prbsgenerate_128bit is
PORT(
	coreclk  		: in std_logic;
	Enable			: in std_logic;
	StartValue		: in std_logic_vector(127 downto 0);
	Reset	 			: in std_logic;
	PrbsSelect		: in std_logic_vector(1 downto 0);
	Inserterror 	: in std_logic;
	Prbsout 			: out std_logic_vector(127 downto 0);
	Valid				: out std_logic;
	deskew_pulse 	: out std_logic
	);
END component;	


component multi_prbsverify_128bit is
GENERIC
	(
		USE_ADDER_HW		:  boolean := true
	);
PORT(
	Clock  					: in std_logic;
	Enable					: in std_logic;	
	Reset	 					: in std_logic;
	Reset_PrbsLockAlarm 	: in std_logic;
	ResetErrorCount 		: in std_logic;
	PrbsSelect				: in std_logic_vector(1 downto 0);
	DataIn 					: in std_logic_vector(127 downto 0);
	PrbsLocked				: out std_logic;
	Errorcount_Q 			: out std_logic_vector(63 downto 0);
	PrbsLock_Alarm_Count	: out std_logic_vector(31 downto 0)
	);
END component;				

component reset_synchro 
port
	(
	clk			: in std_logic;
	reset_in		: in std_logic;
	reset_out	: out std_logic
	);
end component;


component Synchro is
port
	(
	Clk			: in std_logic;
	data_in		: in std_logic;
	data_out		: out std_logic
	);
end component;

component hyper_pipe is
GENERIC
	(
	DWIDTH 	: integer := 1;
	NUM_PIPES : integer := 1
	);
port	
(
	clk				: in std_logic;
	din				: in std_logic_vector((DWIDTH-1) downto 0);
	dout				: out std_logic_vector((DWIDTH-1) downto 0)
);
end component;



CONSTANT CLK125M				: std_logic_vector(19 downto 0) := X"1E848" ; --
CONSTANT SAMPLES_125MHZ		: std_logic_vector(31 downto 0) := X"07735940"; -- (125 Mhz clock is 125E6 samples in one second)
CONSTANT CLK100M				: std_logic_vector(19 downto 0) := X"186A0" ; --
CONSTANT SAMPLES_100MHZ		: std_logic_vector(31 downto 0) := X"05F5E100"; -- (100 Mhz clock is 100E6 samples in one second)


component measure_refclk 
GENERIC
	(
		CYC_MEASURE_CLK_IN_1_SEC	:  std_logic_vector(31 downto 0) := SAMPLES_125MHZ 
	);
port
	(
	RefClock				: in	std_logic;
	Measure_Clk				: in 	std_logic;
	reset					: in	std_logic;
	RefClock_Measure		: out  std_logic_vector(31 downto 0) 
	);
end component;

component counter_1ms 
GENERIC
	(
		BITRATE	: std_logic_vector(19 downto 0) :=	CLK125M
	);
port
	(
	RefClock		: in	std_logic;
	reset			: in	std_logic;
	count_1ms		: buffer std_logic_vector(31 downto 0)
	);
end component;


CONSTANT PRBSWIDTH 					: integer := 128;

signal Reset 					: std_logic;
signal ResetErrorCount		: std_logic;

signal PrbsLocked 			: std_logic_vector((NUMBER_OF_LANES - 1) downto 0);

signal tx_coreclk			: std_logic_vector((NUMBER_OF_COPIES  - 1) downto 0);
signal rx_coreclk			: std_logic_vector((NUMBER_OF_COPIES  - 1) downto 0);
signal tx_clkout			: std_logic_vector((NUMBER_OF_COPIES  - 1) downto 0);


type 	ErrorCountArrayType	is array (0 to (NUMBER_OF_LANES - 1)) of std_logic_vector (63 downto 0);
type 	next_prbs_ArrayType	is array (0 to (NUMBER_OF_LANES - 1)) of std_logic_vector(31 downto 0);
type 	RegisterType			is array (0 to (NUMBER_OF_LANES - 1)) of std_logic_vector(15 downto 0);

type	Bit2_Type 	is array (0 to (NUMBER_OF_LANES - 1)) of std_logic_vector(1 downto 0);
type	Bit20_Type 	is array (0 to (NUMBER_OF_LANES - 1)) of std_logic_vector(19 downto 0);


signal ErrorCountArray 			: ErrorCountArrayType;

signal ChannelSelect 			: integer range 0 to (NUMBER_OF_LANES);
signal Channel 					: integer range 0 to (NUMBER_OF_LANES-1);
signal ChannelReg					: RegisterType;
signal ChannelMask 				:  std_logic_vector ((NUMBER_OF_LANES - 1) downto 0);
signal InsertErrorChannel 		:  std_logic_vector ((NUMBER_OF_LANES - 1) downto 0);

signal Prbsout						: std_logic_vector(((NUMBER_OF_LANES * PRBSWIDTH)-1) downto 0);
signal prbsgenerate_valid		: std_logic_vector ((NUMBER_OF_LANES - 1) downto 0);

signal InsertError				: std_logic;
signal ResetErrorCountChannel	: std_logic_vector ((NUMBER_OF_LANES - 1) downto 0);
signal ResetErrorCountChannel_i	: std_logic_vector ((NUMBER_OF_LANES - 1) downto 0);


signal ChannelOk					: std_logic_vector ((NUMBER_OF_LANES - 1) downto 0);
signal ChannelOk_Q				: std_logic_vector ((NUMBER_OF_LANES - 1) downto 0);

signal rx_freqlocked				: std_logic_vector ((NUMBER_OF_LANES - 1) downto 0);
signal rx_freqlocked_Q3			: std_logic_vector ((NUMBER_OF_LANES - 1) downto 0);

signal Reset_I						: std_logic_vector ((NUMBER_OF_LANES - 1) downto 0);

signal Reset_Counter_1ms		: std_logic;
signal Reset_PrbsGenerate		: std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);


signal Reset_PrbsVerify			: std_logic_vector ((NUMBER_OF_COPIES - 1) downto 0);

signal PrbsSelect					: Bit2_Type;

signal RefClock_Measure			: std_logic_vector(31 downto 0);
signal RxClkout_Measure			: std_logic_vector(31 downto 0);


signal Select_PrbsSelect		: std_logic_vector (1 downto 0);
signal Latch_PrbsPattern		: std_logic;

signal tx_ready					 : std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);
signal rx_ready					 : std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);

signal tx_ready_sync				 : std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);
signal rx_ready_sync				 : std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);

signal reconfig_reset_poweron	: std_logic;
signal reconfig_reset_i			: std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);
signal rx_reset					: std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);
signal tx_reset					: std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);
signal tx_reset_sync				: std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);


signal rx_freqlocked_1ms	 	: std_logic_vector((NUMBER_OF_LANES - 1) downto 0);
signal count_words				: Bit20_Type;


signal PrbsLockAlarm					: std_logic_vector((NUMBER_OF_LANES- 1) downto 0);
signal PrbsLockAlarm_sync			: std_logic_vector((NUMBER_OF_LANES- 1) downto 0);
signal Reset_PrbsLockAlarm			: std_logic_vector((NUMBER_OF_LANES- 1) downto 0);
signal Reset_PrbsLockAlarm_sync	: std_logic_vector((NUMBER_OF_LANES- 1) downto 0);
signal PrbsLock_Alarm_Reset		: std_logic;

signal StartValue						: Register_Array_128bit;


signal tx_reset_ack_sync			: std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);
signal rx_reset_ack_sync			: std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);
signal tx_pll_locked					: std_logic_vector((NUMBER_OF_LANES- 1) downto 0);


signal Prbslocked_q					: std_logic_vector((NUMBER_OF_LANES- 1) downto 0);

signal rx_valid						: std_logic_vector((NUMBER_OF_COPIES -1) DOWNTO 0);

signal rx_am_lock						: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);
signal rx_am_lock_sync				: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);


signal Reset_Rx_min1							: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);

signal Reset_Rx_B								: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);
signal enable_scrambler						: std_logic;

signal Reset_in2								: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);
signal Reset_Tx								: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);


signal rx_ready_Q								: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);

signal tx_ready_detected					: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);
signal Reset_sync								: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);

signal rx_am_lock_alarm				: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal rx_am_lock_q					: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal rx_am_lock_alarm_sync		: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal rx_am_lock_alarm_count		: Register_Array_16bit;
signal PrbsLock_Alarm_Count		: Register_Array_32bit;

signal scrambled_idle				: std_logic;
signal scrambled_idle_sync			: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);

signal tx_datain_ready				: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal tx_datain						: std_logic_vector(((NUMBER_OF_STREAMS * LANEWIDTH)-1) downto 0); 
signal tx_ctrlenable					: std_logic_vector((NUMBER_OF_COPIES - 1) DOWNTO 0); 	
signal rx_dataout						: std_logic_vector(((NUMBER_OF_STREAMS * LANEWIDTH)-1) downto 0);
signal rx_ctrldetect					: std_logic_vector((NUMBER_OF_COPIES-1) DOWNTO 0); 
signal rx_recovered_clk				: std_logic_vector((NUMBER_OF_COPIES-1) DOWNTO 0); 
signal Counter_1ms_Reg_i			: std_logic_vector(31 DOWNTO 0);

begin

-- Reset : Control_Reg(15)
-- 1 : Reset
-- 0 : No Reset

-- InsertError : Control_Reg(14)
-- 1 : InsertError
-- 0 : NoError

-- ResetErrorCount : Control_Reg(13)
-- 1 : ResetErrorcount active
-- 0 : No Reset

-- Enable Scrambling/Descrambling : Control_Reg(12)
-- 1 : Enable Scrambling/Descrambling of the data
-- 0 : No Scrambling/Descrambling used (not required for PRBS data)

-- Select Scramble Idle pattern instead of PRBSdata : Control_Reg(10)
-- 1 : Sent continous scrambled idle pattern
-- 0 : Normal operation


-- rx_reset : Control_Reg(7..4)
-- 1 : rx_reset asserted
-- 0 : No Reset


-- tx_reset : Control_Reg(3..0)
-- 1 : tx_reset asserted
-- 0 : No Reset

-- PrbsLock_Alarm_Reset : Control2_Reg(15)
-- 1 : Reset PrbsLock_Alarm signal
-- 0 : no reset


-- Latch PrbsPattern on selected channel: Control2_Reg(12)
-- 0 : Nothing
-- 1 : Latch PrbsPattern on currently selected channel


-- Select PRBS Pattern on selected channel : Control2_Reg(10..8)
-- 00 : PRBS-13Q
-- 01 : PRBS-23Q
-- 10 : PRBS-31Q
-- 11 : PRBS-7

-- ChannelSelect : Control2_Reg(4 downto 0)
-- 00000 : Select Channel 0
-- 00001 : Select Channel 1
-- 00010 : Select Channel 2
-- 00011 : Select Channel 3
-- ...
-- 01001 : Select Channel 9
-- 10000 : Select All Channels





inserterror			<= Control_Reg(14);
ResetErrorCount 	<= Control_Reg(13);
enable_scrambler	<= Control_Reg(12);
scrambled_idle		<= Control_Reg(10);


PrbsLock_Alarm_Reset	<= Control2_Reg(15);
Latch_PrbsPattern		<= Control2_Reg(12);
Select_PrbsSelect		<= Control2_Reg(9 downto 8);


----------------------------------------------------------------------------------------
-- Create Reset
----------------------------------------------------------------------------------------

process(ClkMgmt,init_done_n)
begin
	if init_done_n = '1' then
		Reset 									<= '1';
		reconfig_reset_poweron 	<= '1';			
	elsif ClkMgmt'event and ClkMgmt = '1' then
		if  (Enable_Core = '1') and (Control_Reg(15) = '0')	then		
			Reset	 						<= '0';
			reconfig_reset_poweron	<= '0';				
		else
			Reset 						<= '1';
		end if;
	end if;
end process;

----------------------------------------------------------------------------------------
-- Create reconfig_reset_i such it is de-asserted at the same time at poweron as the Reset
----------------------------------------------------------------------------------------

Generate_reconfig_reset_i:
FOR i IN 0 to NUMBER_OF_COPIES-1 GENERATE
	reconfig_reset_i(i) 	<= reconfig_xcvr_reset(i) or reconfig_pdp_reset(i) or reconfig_reset_poweron;
END GENERATE;

-----------------------------------------------------------------------------------------------------------
--	ChannelSelectControl
-----------------------------------------------------------------------------------------------------------	

				
ChannelSelectControl:
WITH Control2_Reg(2 downto 0) SELECT
	Channelselect	<=  0	WHEN	"000",
						1	WHEN	"001",
						2	WHEN	"010",
						3	WHEN	"011",
						4	WHEN 	OTHERS;
										

ChannelMaskControl:
WITH ChannelSelect SELECT
	ChannelMask	<=		"0001" 	WHEN	0,
						"0010" 	WHEN	1,
						"0100" 	WHEN	2,
						"1000" 	WHEN	3,
						"1111" 	WHEN	OTHERS;	

ChannelControl:
WITH ChannelSelect SELECT
	Channel	<= 0 when 0,
			   1 when 1,
			   2 when 2,
			   3 when 3,
			   0 when OTHERS;

				

----------------------------------------------------------------------------------------
-- Latch PrbsSelect
----------------------------------------------------------------------------------------

process(ClkMgmt,init_done_n)
begin
	if init_done_n = '1' then
		FOR i IN 0 to (NUMBER_OF_LANES-1) LOOP
			PrbsSelect(i)  <= "10"; -- Default to PRBS-31
		end loop;
	elsif ClkMgmt'event and ClkMgmt = '1' then
			if Latch_PrbsPattern = '1' then 
				PrbsSelect(Channel) <= Select_PrbsSelect;
			else
				NULL;
			end if;
	end if;
end process;


Generate_TxSignals:
FOR i IN 0 to NUMBER_OF_COPIES-1 GENERATE

----------------------------------------------------------------------------------------
-- Synchronize scrambled_idle to the tx_coreclk domain
----------------------------------------------------------------------------------------
	
Synchro_scrambled_idle: Synchro
port map
	(
	Clk			=> tx_coreclk(I),
	data_in		=> scrambled_idle,
	data_out		=> scrambled_idle_sync(I)
	);
	
----------------------------------------------------------------------------------------
-- Synchronize Reset to tx_coreclk(I)
----------------------------------------------------------------------------------------
	

reset_synchro_Resetx :  reset_synchro
port map
	(
	clk			=> tx_coreclk(I),
	reset_in		=> Reset ,
	reset_out	=> Reset_sync(I)
	);
	
----------------------------------------------------------------------------------------
-- Synchronize tx_reset to tx_coreclk(I)
----------------------------------------------------------------------------------------


reset_synchro_tx_reset :  reset_synchro
port map
	(
	clk			=> tx_coreclk(I),
	reset_in		=> tx_reset(I),
	reset_out	=> tx_reset_sync(I) -- tx_coreclk(I) domain
	);
	
----------------------------------------------------------------------------------------
-- Synchronize tx_ready to ClkMgmt domain
----------------------------------------------------------------------------------------


Synchro_tx_ready: Synchro
port map
	(
	Clk			=> ClkMgmt,
	data_in		=> tx_ready(I),
	data_out		=> tx_ready_sync(I) -- Synchronized to ClkMgmt domain
	);
	
----------------------------------------------------------------------------------------
-- Generate Reset_Tx (for the PrbsGeneration)
----------------------------------------------------------------------------------------


Reset_in2(I) <= Reset OR not (tx_ready_sync(I));	-- ClkMgmt domain	


reset_synchro_Reset_Tx_x :  reset_synchro
port map
	(
	clk			=> tx_coreclk(I),
	reset_in		=> Reset_in2(I),
	reset_out	=> Reset_Tx(I) -- tx_coreclk(I) domain
	);

Reset_PrbsGenerate(I) <= Reset_Tx(I);

end generate generate_TxSignals;


-----------------------------------------------------------------------------------------------------------
--	InsertErrorControl
-----------------------------------------------------------------------------------------------------------	


Generate_InsertErrorChannel:
FOR i IN 0 to NUMBER_OF_LANES-1 GENERATE
	InsertErrorChannel(I) <= ChannelMask(I) AND InsertError;
	Reset_PrbsLockAlarm(I)	<= (ChannelMask(I) AND PrbsLock_Alarm_Reset) or Reset;	
END GENERATE;
	
-----------------------------------------------------------------------------------------------------------
--	Instantiate PRBS Generator Modules
-----------------------------------------------------------------------------------------------------------	

StartValue(0)		<= X"11111111111111111111111111111111";
StartValue(1)		<= X"22222222222222222222222222222222";
StartValue(2)		<= X"33333333333333333333333333333333";
StartValue(3)		<= X"44444444444444444444444444444444";


Generate_PrbsGenerate_Ch:
FOR i IN 0 to (NUMBER_OF_LANES-1) GENERATE
PrbsGenerateX_Ch:multi_prbsgenerate_128bit 
PORT MAP(
	coreclk  		=> tx_coreclk(I),
	Enable			=> tx_datain_ready(I), -- From txrx_pcs_64b66b_fgt
	Reset	 			=> Reset_PrbsGenerate(I),
	StartValue		=> StartValue(I),	
	PrbsSelect		=> PrbsSelect(I),
	Inserterror 	=> InsertErrorChannel(I),
	Prbsout 			=> Prbsout((PRBSWIDTH*(I+1)-1) downto (PRBSWIDTH*I)),
	Valid				=> prbsgenerate_valid(I)
	);	
END GENERATE Generate_PrbsGenerate_Ch;


-----------------------------------------------------------------------------------------------------------
--	Instantiate txrx_pcs_64b66b_fgt
-----------------------------------------------------------------------------------------------------------	

Generate_tx_rx_reset:
FOR i IN 0 to NUMBER_OF_COPIES-1 GENERATE
	tx_reset(I)		<=  Control_Reg(I); 
	rx_reset(I)		<=  Control_Reg(NUMBER_OF_LANES+I); 	
end generate;

generate_tx_datain:
FOR I IN 0 to NUMBER_OF_COPIES-1 GENERATE
-- Use either prbs or scrambled_idle
tx_datain((PRBSWIDTH*(I+1)-1) downto (PRBSWIDTH*I)) <= Prbsout((PRBSWIDTH*(I+1)-1) downto (PRBSWIDTH*I)) when (scrambled_idle_sync(I) = '0') else X"000000000000001E000000000000001E";

end generate;

Generate_txrx_pcs_64b66b_fgt:
FOR i IN 0 to (NUMBER_OF_COPIES-1) GENERATE

tx_ctrlenable(I) <= '0' when (scrambled_idle_sync(I) = '0') else '1';

tx_coreclk(I)	 <= tx_clkout(I);

end generate Generate_txrx_pcs_64b66b_fgt;

txrx_pcs_64b66b_fgt_x: txrx_pcs_64b66b_fgt
GENERIC MAP(
		KPFEC								=> KPFEC,
		FEC_MODE							=> FEC_MODE,
		AM_PULSE_WIDTH					=> AM_PULSE_WIDTH,
		NUMBER_OF_LANES_PER_PHY		=> NUMBER_OF_LANES_PER_PHY,
		NUMBER_OF_COPIES				=> NUMBER_OF_COPIES,
		NUMBER_OF_LANES				=> NUMBER_OF_LANES,
		NUMBER_OF_SEGMENTS			=> NUMBER_OF_SEGMENTS,
		NUMBER_OF_STREAMS				=> NUMBER_OF_STREAMS,
		LANEWIDTH						=> 64,
		EXTERNAL_LATENCY				=> 2, -- This is the external latency of the data generation (from tx_datin_ready to tx_data_in_valid)
		SIMULATION_MODE            => SIMULATION_MODE
	)
PORT MAP
(
	-- Global Reset
	Reset							=> Reset,

	-- Clocks
	RefClock						=> RefClock,	 			
	ClkMgmt						=> ClkMgmt,
	Systempll_clk				=> Systempll_clk,	

	-- Control inputs
	enable_scrambler			   => enable_scrambler,  -- ClkMgmt	
	
	-- PHY direct IP related signals
	tx_reset							=> tx_reset,
	rx_reset	   					=> rx_reset,
	tx_reset_ack_sync				=> tx_reset_ack_sync,
	rx_reset_ack_sync				=> rx_reset_ack_sync,
	
	tx_ready							=> tx_ready,
	rx_ready							=> rx_ready,
	
	tx_pll_locked					=> tx_pll_locked,
	
	tx_coreclk						=> tx_coreclk,
	tx_datain						=> tx_datain,
	tx_datain_valid		   	=> prbsgenerate_valid,
	tx_ctrlenable					=> tx_ctrlenable,	
	tx_datain_ready				=> tx_datain_ready,
	
	tx_clkout						=> tx_clkout,
	
	tx_dataout						=> XCVR_TX,
	tx_dataout_n					=> XCVR_TX_n,

	rx_datain						=> XCVR_RX,
	rx_datain_n						=> XCVR_RX_n,	

	
	rx_coreclk						=> rx_coreclk,

	rx_dataout						=> rx_dataout,
	rx_ctrldetect					=> rx_ctrldetect,
	rx_valid							=> rx_valid,
	rx_am_lock						=> rx_am_lock,
	rx_am_lock_sync				=> rx_am_lock_sync,

	rx_recovered_clk				=> rx_recovered_clk,	
	rx_freqlocked					=> rx_freqlocked,	

	reconfig_xcvr_reset		     	=> reconfig_reset_i,
	reconfig_xcvr_write		   	=> reconfig_xcvr_write,
	reconfig_xcvr_read		    	=> reconfig_xcvr_read,
	reconfig_xcvr_address      	=> reconfig_xcvr_address,
	reconfig_xcvr_byteenable 		=> reconfig_xcvr_byteenable,
	reconfig_xcvr_writedata    	=> reconfig_xcvr_writedata,
	reconfig_xcvr_readdata     	=> reconfig_xcvr_readdata,
	reconfig_xcvr_waitrequest	 	=> reconfig_xcvr_waitrequest,
	
	reconfig_pdp_reset		      => reconfig_reset_i,
	reconfig_pdp_write		      => reconfig_pdp_write,
	reconfig_pdp_read					=> reconfig_pdp_read,
	reconfig_pdp_address       	=> reconfig_pdp_address,
	reconfig_pdp_byteenable			=> reconfig_pdp_byteenable,			
	reconfig_pdp_writedata     	=> reconfig_pdp_writedata,
	reconfig_pdp_readdata      	=> reconfig_pdp_readdata,
	reconfig_pdp_waitrequest		=> reconfig_pdp_waitrequest
	
	);



-----------------------------------------------------------------------------------------------------------
--	Generate Rx resets
-----------------------------------------------------------------------------------------------------------	


Generate_RxReset:
FOR I IN 0 to NUMBER_OF_COPIES-1 GENERATE

process(rx_coreclk(I),Reset)
begin
	if Reset = '1' then
		Reset_Rx_min1(I)		<= '1';
		rx_ready_Q(I) 			<=  '0';
	elsif rising_edge(rx_coreclk(I)) then
		rx_ready_Q(I)	 	<= rx_am_lock(I)  ;						
		if (rx_ready_Q(I)= '1')  then
			Reset_Rx_min1(I)		 		<= '0';
		else
			Reset_Rx_min1(I)	 			<= '1';
		end if;
	end if;
end process;

 
	
Duplicate_Reset_Rx_B : hyper_pipe
GENERIC MAP
	(
		DWIDTH	 =>	1,
		NUM_PIPES =>   2  
	)
PORT MAP(
	clk				=> rx_coreclk(I),
	din(0)			=> Reset_Rx_min1(I),	
	dout(0)			=> Reset_Rx_B(I)
	);		


end generate Generate_RxReset;




-----------------------------------------------------------------------------------------------------------
--	ResetErrorCountControl
-----------------------------------------------------------------------------------------------------------	

Generate_Reset_I:
FOR i IN 0 to NUMBER_OF_COPIES-1 GENERATE

Synchro_rx_ready: Synchro
port map
	(
	Clk			=> ClkMgmt,
	data_in		=> rx_ready(I),
	data_out		=> rx_ready_sync(I) -- Synchronized to ClkMgmt domain
	);
	
	
Reset_I(I) <= Reset Or not rx_ready_sync(I);  -- ClkMgmt domain 
	
END GENERATE;

Generate_Reset_PrbsVerify:
FOR i IN 0 to NUMBER_OF_COPIES-1 GENERATE
   Reset_PrbsVerify(I) <= Reset_Rx_B(I);	
	

END GENERATE;

Generate_ResetErrorCountChannel:
FOR i IN 0 to NUMBER_OF_LANES-1 GENERATE
	ResetErrorCountChannel_i(I) <= (ChannelMask(I) AND ResetErrorCount) OR Reset_I(I); -- ClkMgtmt domain

reset_synchro_ResetErrorCountChannel :  reset_synchro
port map
	(
	clk			=> rx_coreclk(I),
	reset_in		=> ResetErrorCountChannel_i(I),
	reset_out	=> ResetErrorCountChannel(I)
	);	
	
END GENERATE;



-----------------------------------------------------------------------------------------------------------
--	Create status signal asserted after rx_freqlocked is asserted for 1 ms
-----------------------------------------------------------------------------------------------------------	


Generate_rxfreqlocked_1ms:
FOR i IN 0 to NUMBER_OF_LANES-1 GENERATE
Synchro_instx: Synchro
port map
	(
	Clk			=> ClkMgmt,
	data_in		=> rx_freqlocked(I),
	data_out		=> rx_freqlocked_Q3(I)
	);


	process(ClkMgmt)
	begin
	if rising_edge(ClkMgmt) then
		if rx_freqlocked_Q3(I) = '0' then
			rx_freqlocked_1ms(I) <= '0';
			count_words(I) <= (OTHERS => '0');		
		else
			if count_words(I) = (CLK125M-1) then 		
				rx_freqlocked_1ms(I) <= '1';
			else
				count_words(I) <= count_words(I) + 1;
			end if;
		end if;
	end if;
	end process;
	
END GENERATE;




-----------------------------------------------------------------------------------------------------------
--	PRBS Verification Instantiation and PrbsAlarm 
-----------------------------------------------------------------------------------------------------------	


Generate_PrbsVerify_Ch:
FOR i IN 0 to NUMBER_OF_LANES-1 GENERATE

reset_synchro_Reset_PrbsLockAlarm :  reset_synchro
port map
	(
	clk			=> rx_coreclk(I),
	reset_in		=> Reset_PrbsLockAlarm(I),
	reset_out	=> Reset_PrbsLockAlarm_sync(I)
	);
	
PrbsVerify_Ch:multi_prbsverify_128bit 
PORT MAP(
	Clock  					=> rx_coreclk(I),
	Enable					=> rx_valid(I),
	Reset	 					=> Reset_PrbsVerify(I),
	Reset_PrbsLockAlarm	=> Reset_PrbsLockAlarm_sync(I),
	ResetErrorCount 		=> ResetErrorCountChannel(I) ,
	PrbsSelect				=> PrbsSelect(I),
	DataIn					=> rx_dataout((PRBSWIDTH*(I+1)-1) downto (PRBSWIDTH*I)),
	PrbsLocked				=> PrbsLocked(I),
	ErrorCount_Q  			=> ErrorcountArray(I),
	PrbsLock_Alarm_Count => PrbsLock_Alarm_Count(I) -- only 16 lower bits are relevant
	);	
	
-----------------------------------------------------------------------------------------------------------
--	Generate PrbsLockAlarm
-----------------------------------------------------------------------------------------------------------	

process(rx_coreclk(I))
begin
	if rising_edge(rx_coreclk(I)) then
		if Reset_PrbsLockAlarm_sync(I) = '1' then
			PrbsLockAlarm(I) 	<= '0';
			PrbsLocked_q(I) 	<= '0';
		else
			PrbsLocked_q(I) <= PrbsLocked(I);
			
			if (PrbsLocked_q(I) /= PrbsLocked(I) ) and (PrbsLocked(I)  = '0') then -- detect Falling Edge on PRBSlocked
						PrbsLockAlarm(I) <= '1'; -- Latched (Alarm stays high even when the PRBSVerifier gets a reset)
			end if;
		end if;
	end if;
end process;

-----------------------------------------------------------------------------------------------------------
--	Generate rx_am_lock_alarm and rx_am_lock_alarm_count 	
-----------------------------------------------------------------------------------------------------------	

process(rx_coreclk(I))
begin
	if rising_edge(rx_coreclk(I)) then
		if Reset_PrbsLockAlarm_sync(I) = '1' then
			rx_am_lock_alarm_count(I) <= (OTHERS => '0');
			rx_am_lock_q(I) <= '0';
			rx_am_lock_alarm(I) <= '0';	
		else
			rx_am_lock_q(I) <= rx_am_lock(I);				
			if (rx_am_lock_q(I) /= rx_am_lock(I)) and (rx_am_lock(I) = '0') then -- detect falling edge rx_am_lock
				rx_am_lock_alarm(I) <= '1'; -- Latched (Alarm stays high even when the PRBSVerifier gets a reset)
				rx_am_lock_alarm_count(I) <= rx_am_lock_alarm_count(I) + 1;						
			end if;
		end if;
	end if;
end process;

END GENERATE Generate_PrbsVerify_Ch;
	




-----------------------------------------------------------------------------------------------------------
--	1ms Counter Instantiation
-----------------------------------------------------------------------------------------------------------	


Reset_Counter_1ms <= ResetErrorCount or Reset;

Counter_1ms_inst:counter_1ms 
GENERIC MAP
	(
		BITRATE	 =>	CLK125M  
	)
PORT MAP(
	RefClock 	=> ClkMgmt,
	Reset 		=> Reset_Counter_1ms,
	count_1ms	=> Counter_1ms_Reg_i -- every tick of the counter corresponds to 1ms/
	);

Counter_1ms_Reg <= Counter_1ms_Reg_i;

-----------------------------------------------------------------------------------------------------------
--	Measure tx_coreclk
-----------------------------------------------------------------------------------------------------------	


measure_refclk_inst : measure_refclk
GENERIC MAP
	(
		CYC_MEASURE_CLK_IN_1_SEC	=> SAMPLES_125MHZ 
	)
port MAP(

	RefClock				=> tx_coreclk(0),
	Measure_Clk			=> ClkMgmt,
	reset					=> init_done_n,
	RefClock_Measure	=> RefClock_Measure
	);	

	
-----------------------------------------------------------------------------------------------------------
--	Measure Recovered Clock
-----------------------------------------------------------------------------------------------------------	


measure_rx_clkout_inst : measure_refclk
GENERIC MAP
	(
		CYC_MEASURE_CLK_IN_1_SEC	=> SAMPLES_125MHZ 
	)
port MAP(
	--RefClock				=> rx_coreclk(0), -- in system pll clocking mode this is the same clock as the tx_coreclk (so no additional information)
	RefClock				=> rx_recovered_clk(0),	
	Measure_Clk			=> ClkMgmt,
	reset					=> init_done_n,
	RefClock_Measure	=> RxClkout_Measure
	);	
	
	
-----------------------------------------------------------------------------------------------------------
--	Generate status output signals for Channel_Reg (ClkMgt)
-----------------------------------------------------------------------------------------------------------	

Generate_rx_am_lock_alarm_sync:
FOR i  IN 0 to NUMBER_OF_COPIES-1 Generate

Synchro_rx_am_lock_alarm: Synchro
port map
	(
	Clk			=> ClkMgmt,
	data_in		=> rx_am_lock_alarm(I),
	data_out		=> rx_am_lock_alarm_sync(I) -- Synchronized to ClkMgmt domain
	);	
	
end generate;

Generate_ChannelReg:
FOR i  IN 0 to NUMBER_OF_LANES-1 Generate

Synchro_PrbsLockAlarm: Synchro
port map
	(
	Clk			=> ClkMgmt,
	data_in		=> PrbsLockAlarm(I),
	data_out		=> PrbsLockAlarm_sync(I) -- Synchronized to ClkMgmt domain
	);	
	
	Channel_Reg(i)(15) <= PrbsLocked(i);
	Channel_Reg(i)(14) <= tx_ready_sync(i);
	Channel_Reg(i)(13) <= rx_ready_sync(i);
	Channel_Reg(i)(12) <= rx_am_lock_sync(i);
	Channel_Reg(i)(11) <= '0';
	Channel_Reg(i)(10) <= '0';
	Channel_Reg(i)(9)  <= '0';
	Channel_Reg(i)(8)  <= '0';
	Channel_Reg(i)(7)  <= '0';
	Channel_Reg(i)(6)  <= '0';
	Channel_Reg(i)(5)  <= '0';
	Channel_Reg(i)(4)  <= rx_am_lock_alarm_sync(i);
	Channel_Reg(i)(3)  <= tx_reset_ack_sync(i);
	Channel_Reg(i)(2)  <= rx_reset_ack_sync(i);
	Channel_Reg(i)(1)  <= rx_freqlocked_1ms(i);
	Channel_Reg(i)(0)  <= PrbsLockAlarm_sync(i);

	ChannelOK(i) <= '1' WHEN ((PrbsLocked(i) = '1') AND (ErrorcountArray(i) = X"0000000000000000")) ELSE '0';
	
	ErrorCount_Reg(i) <= ErrorCountArray(i);

	PrbsLock_Alarm_Reg(I)(15 downto 0)  <= PrbsLock_Alarm_Count(I)(15 downto 0);
	PrbsLock_Alarm_Reg(I)(31 downto 16) <= rx_am_lock_alarm_count(I);	
	
END Generate Generate_ChannelReg;




process(ClkMgmt)
begin
	if rising_edge(ClkMgmt) then
					ChannelOK_Q <= ChannelOK;
		CASE ChannelSelect IS
					WHEN 0 => 	led(0) <= not(tx_pll_locked(0));
								led(1) <= not(rx_freqlocked_Q3(0));
								led(2) <= not(PrbsLocked(0));	
								led(3) <= not (ChannelOK_Q(0));															
					WHEN 1 => 	led(0) <= not(tx_pll_locked(1));
								led(1) <= not(rx_freqlocked_Q3(1));
								led(2) <= not(PrbsLocked(1));	
								led(3) <= not (ChannelOK_Q(1));									
					WHEN 2 => 	led(0) <= not(tx_pll_locked(0));
								led(1) <= not(rx_freqlocked_Q3(2));
								led(2) <= not(PrbsLocked(2));	
								led(3) <= not (ChannelOK_Q(2));								
					WHEN 3 => 	led(0) <= not(tx_pll_locked(3));
								led(1) <= not(rx_freqlocked_Q3(3));
								led(2) <= not(PrbsLocked(3));	
								led(3) <= not (ChannelOK_Q(3));																
--					WHEN 4 => led(0) <= not(tx_ready(4));
--								led(1) <= not(rx_ready(4));
--								led(2) <= not(PrbsLocked(4));	
--								led(3) <= not (ChannelOK_Q(4));						
--					WHEN 5 => led(0) <= not(tx_ready(5));
--								led(1) <= not(rx_ready(5));
--								led(2) <= not(PrbsLocked(5));	
--								led(3) <= not (ChannelOK_Q(5));	
--					WHEN 6 => led(0) <= not(tx_ready(6));
--								led(1) <= not(rx_ready(6));
--								led(2) <= not(PrbsLocked(6));	
--								led(3) <= not (ChannelOK_Q(6));
--					WHEN 7 => led(0) <= not(tx_ready(7));
--								led(1) <= not(rx_ready(7));
--								led(2) <= not(PrbsLocked(7));	
--								led(3) <= not (ChannelOK_Q(7));						
--					WHEN 8 => led(0) <= not(tx_pma_ready(8));
--								led(1) <= not(rx_freqlocked(8));
--								led(2) <= not(PrbsLocked(8));	
--								led(3) <= not (ChannelOK_Q(8));	
--					WHEN 9 => led(0) <= not(tx_pma_ready(9));
--								led(1) <= not(rx_freqlocked(9));
--								led(2) <= not(PrbsLocked(9));	
--								led(3) <= not (ChannelOK_Q(9));	

					WHEN OTHERS => led(0) <= not(tx_pll_locked(0));
								led(1) <= not(rx_freqlocked_Q3(0));
								led(2) <= not(PrbsLocked(0));	
								led(3) <= not (ChannelOK_Q(0));	
								
		END CASE;
		led(7 downto 4) <= not (Control2_Reg(3 downto 0));

	end if;
end process;

Bitrate_Reg <= RefClock_Measure ; 
RxClock_Reg	<= RxClkout_Measure;

			
end;



