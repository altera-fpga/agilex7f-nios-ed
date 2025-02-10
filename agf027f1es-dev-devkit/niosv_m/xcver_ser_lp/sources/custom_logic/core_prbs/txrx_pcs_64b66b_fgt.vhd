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

-- Note : editing and tabs are done with Quartus editor/Notepad++ (tab size = 3)

-- Author 	: Peter Schepers (peter.schepers@intel.com)
-- Variant  : 4x50GbE Fractional
-- Version 	: 1.2
-- Date		: 11/08/2021
 
-- Originally created for version with RSFEC (544,514) (aggregate 200G mode, 4x53G PAM4), modified for fractured operation


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.package_registertype.all; --package that defines Registertypes



entity txrx_pcs_64b66b_fgt is
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
		EXTERNAL_LATENCY				:  integer := 2;  -- This is the external latency of the data generation (from tx_datin_ready to tx_data_in_valid)
		SIMULATION_MODE            :  boolean := true
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
END txrx_pcs_64b66b_fgt;	


architecture rtl of txrx_pcs_64b66b_fgt is

component scrambler is
GENERIC
(
	WIDTH  : integer range 0 to 1024 :=64
);
PORT
(
	use_scrambler			: in std_logic;
	clk						: in std_logic; 						
	srst						: in std_logic;	
	ena						: in std_logic;   						
	din						: in std_logic_vector(WIDTH-1 downto 0);	
	dout						: out std_logic_vector(WIDTH-1 downto 0)
 );
 end component;


component descrambler is
GENERIC
(
	WIDTH  : integer range 0 to 1024 :=64
);
PORT
(
	use_descrambler	: in std_logic;
	clk					: in std_logic; 						
	srst					: in std_logic;	
	ena					: in std_logic;   						
	din					: in std_logic_vector(WIDTH-1 downto 0);	
	dout					: out std_logic_vector(WIDTH-1 downto 0)
 );
 end component;	

-- Phy direct instance needs to match the parameters on top
-- This one is using 50GbE (1 lane at 53.125 Gbps)

component phy_direct is
	port (
		rx_cdr_refclk_link         : in  std_logic                      := 'X';             -- clk
		tx_pll_refclk_link         : in  std_logic                      := 'X';             -- clk
		system_pll_clk_link        : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- clk
		tx_reset                   : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- tx_reset
		rx_reset                   : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- rx_reset
		tx_reset_ack               : out std_logic_vector(0 downto 0);                      -- tx_reset_ack
		rx_reset_ack               : out std_logic_vector(0 downto 0);                      -- rx_reset_ack
		tx_am_gen_start            : out std_logic_vector(0 downto 0);                      -- tx_am_gen_start
		tx_am_gen_2x_ack           : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- tx_am_gen_2x_ack
		tx_ready                   : out std_logic_vector(0 downto 0);                      -- tx_ready
		rx_ready                   : out std_logic_vector(0 downto 0);                      -- rx_ready
		tx_coreclkin               : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- tx_coreclkin
		rx_coreclkin               : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rx_coreclkin
		tx_clkout                  : out std_logic_vector(1 downto 0);                      -- tx_clkout
		tx_clkout2                 : out std_logic_vector(1 downto 0);                      -- tx_clkout2
		rx_clkout                  : out std_logic_vector(1 downto 0);                      -- rx_clkout
		rx_clkout2                 : out std_logic_vector(1 downto 0);                      -- rx_clkout2
		tx_serial_data             : out std_logic_vector(0 downto 0);                      -- tx_serial_data
		tx_serial_data_n           : out std_logic_vector(0 downto 0);                      -- tx_serial_data_n
		rx_serial_data             : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- rx_serial_data
		rx_serial_data_n           : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- rx_serial_data_n
		tx_pll_locked              : out std_logic_vector(0 downto 0);                      -- tx_pll_locked
		rx_is_lockedtodata         : out std_logic_vector(0 downto 0);                      -- rx_is_lockedtodata
		rx_is_lockedtoref          : out std_logic_vector(0 downto 0);                      -- rx_is_lockedtoref
		rsfec_sf                   : out std_logic_vector(0 downto 0);                      -- rsfec_sf
		rsfec_status_rx_not_align  : out std_logic_vector(0 downto 0);                      -- rsfec_status_rx_not_align
		rsfec_status_rx_not_deskew : out std_logic_vector(0 downto 0);                      -- rsfec_status_rx_not_deskew
		rsfec_status_rx_not_locked : out std_logic_vector(0 downto 0);                      -- rsfec_status_rx_not_locked
		fec_snapshot               : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- fec_snapshot
		tx_parallel_data           : in  std_logic_vector(159 downto 0) := (others => 'X'); -- tx_parallel_data
		rx_parallel_data           : out std_logic_vector(159 downto 0);                    -- rx_parallel_data
		reconfig_xcvr_clk          : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- clk
		reconfig_xcvr_reset        : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- reset
		reconfig_xcvr_write        : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- write
		reconfig_xcvr_read         : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- read
		reconfig_xcvr_address      : in  std_logic_vector(17 downto 0)  := (others => 'X'); -- address
		reconfig_xcvr_byteenable   : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- byteenable
		reconfig_xcvr_writedata    : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- writedata
		reconfig_xcvr_readdata     : out std_logic_vector(31 downto 0);                     -- readdata
		reconfig_xcvr_waitrequest  : out std_logic_vector(0 downto 0);                      -- waitrequest
		reconfig_pdp_clk           : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- clk
		reconfig_pdp_reset         : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- reset
		reconfig_pdp_write         : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- write
		reconfig_pdp_read          : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- read
		reconfig_pdp_address       : in  std_logic_vector(13 downto 0)  := (others => 'X'); -- address
		reconfig_pdp_byteenable    : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- byteenable
		reconfig_pdp_writedata     : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- writedata
		reconfig_pdp_readdata      : out std_logic_vector(31 downto 0);                     -- readdata
		reconfig_pdp_waitrequest   : out std_logic_vector(0 downto 0)                       -- waitrequest
	);
end component phy_direct;



component reset_synchro 
port
	(
	clk			: in std_logic;
	reset_in	: in std_logic;
	reset_out	: out std_logic
	);
end component;


component synchro is
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


CONSTANT DATAWIDTH	 		: integer := 66;
CONSTANT PRBSWIDTH			: integer := NUMBER_OF_SEGMENTS*LANEWIDTH;


signal tx_parallel_data 	: std_logic_vector(((NUMBER_OF_STREAMS  * 80)-1) downto 0) := (OTHERS => '0');


--signal tx_clkout_i			: std_logic_vector((NUMBER_OF_STREAMS  - 1) downto 0);
signal rx_clkout				: std_logic_vector((NUMBER_OF_COPIES  - 1) downto 0);
signal rx_clkout2 			: std_logic_vector((NUMBER_OF_COPIES  - 1) downto 0);


signal rx_out 					: std_logic_vector(((NUMBER_OF_STREAMS  * DATAWIDTH)-1) downto 0);
signal rx_parallel_data		: std_logic_vector(((NUMBER_OF_STREAMS  * 80)-1) downto 0);

type	Bit3_Type 	is array (0 to (NUMBER_OF_COPIES - 1)) of std_logic_vector(2 downto 0);
type	Bit4_Type 	is array (0 to (NUMBER_OF_COPIES - 1)) of std_logic_vector(3 downto 0);
type	Bit6_Type 	is array (0 to (NUMBER_OF_COPIES - 1)) of std_logic_vector(5 downto 0);
type 	Bit20_Type 	is array (0 to (NUMBER_OF_COPIES - 1)) of std_logic_vector(19 downto 0);


signal tx_ready_i					 	: std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);
signal rx_ready_i					 	: std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);

signal tx_ready_sync				 	: std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);

signal tx_reset_ack					: std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);
signal rx_reset_ack					: std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);


signal tx_reset_sync					: std_logic_vector((NUMBER_OF_COPIES - 1) downto 0);

signal rx_is_lockedtoref			: std_logic_vector((NUMBER_OF_LANES- 1) downto 0);

signal tx_am_gen_start				: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal tx_am_gen_start_sync		: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal tx_am_gen_start_Q			: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal tx_am_gen_2x_ack				: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal am_pulse_count				: Bit3_Type;

signal pulse_pause_data				: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal count_pulse					: Bit20_Type;
signal count_tx_pcs_ready			: Bit6_Type;
signal start_counting				: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal tx_pcs_ready   				: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal tx_pcs_ready_lane			: std_logic_vector((NUMBER_OF_COPIES- 1) DOWNTO 0);
signal am_pulse_min1					: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal am_pulse_min2					: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal am_pulse						: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal am_pulse_lane					: std_logic_vector((NUMBER_OF_COPIES- 1) DOWNTO 0); 
signal tx_pcs66_am_lane       	: std_logic_vector((NUMBER_OF_COPIES -1) DOWNTO 0);


signal rsfec_sf                   : std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal rsfec_status_rx_not_align  : std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal rsfec_status_rx_not_deskew : std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal rsfec_status_rx_not_locked : std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);

signal tx_encoded						: std_logic_vector(((NUMBER_OF_STREAMS * DATAWIDTH)-1) downto 0);
signal valid_encoded_lane			: std_logic_vector((NUMBER_OF_COPIES -1) DOWNTO 0);

signal rx_valid_q						: std_logic_vector((NUMBER_OF_COPIES -1) DOWNTO 0);

signal rx_pcs66_valid            : std_logic_vector((NUMBER_OF_COPIES -1) DOWNTO 0);
attribute keep : boolean;
attribute keep of rx_pcs66_valid : signal is true;

signal rx_pcs66_am_valid           	: std_logic_vector((NUMBER_OF_COPIES -1) DOWNTO 0);
attribute keep of rx_pcs66_am_valid : signal is true;


signal rx_pcs66_am_valid_min1_stream	: std_logic_vector((NUMBER_OF_STREAMS -1) DOWNTO 0);
signal rx_pcs66_am_valid_min1 			: std_logic_vector((NUMBER_OF_COPIES -1) DOWNTO 0);
signal rx_pcs66_am_valid_min1_Q     	: std_logic_vector((NUMBER_OF_COPIES -1) DOWNTO 0);
signal rx_pcs66_valid_min1_stream   	: std_logic_vector((NUMBER_OF_STREAMS -1) DOWNTO 0);
signal rx_pcs66_valid_min1		      	: std_logic_vector((NUMBER_OF_COPIES -1) DOWNTO 0);
signal rx_pcs66_valid_min1_Q        	: std_logic_vector((NUMBER_OF_COPIES -1) DOWNTO 0);

signal rx_valid_min1							: std_logic_vector((NUMBER_OF_COPIES-1) DOWNTO 0);
signal rx_am_lock_rx_coreclk				: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);
signal rx_am_lock_q							: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);
signal rx_am_lock_detected					: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);
signal rx_am_lock_async						: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);

signal pcs_scr_pld 							: std_logic_vector(NUMBER_OF_STREAMS*LANEWIDTH-1 downto 0);
signal rx_data_retimed						: std_logic_vector(NUMBER_OF_STREAMS*LANEWIDTH-1 downto 0);

signal pcs_descr_pld							: std_logic_vector(NUMBER_OF_STREAMS*LANEWIDTH-1 downto 0);
signal pcs_descr_pld_min1					: std_logic_vector(NUMBER_OF_STREAMS*LANEWIDTH-1 downto 0);

signal rx_ctrldetect_min1_stream			: std_logic_vector((NUMBER_OF_STREAMS  - 1) downto 0);
signal rx_ctrldetect_min1					: std_logic_vector((NUMBER_OF_COPIES  - 1) downto 0);
signal rx_ctrldetect_int					: std_logic_vector((NUMBER_OF_COPIES  - 1) downto 0);

signal dout_descr								: std_logic_vector(NUMBER_OF_STREAMS*LANEWIDTH-1 downto 0);
signal ena_scr									: std_logic_vector((NUMBER_OF_COPIES  - 1) downto 0);
signal ena_descr								: std_logic_vector((NUMBER_OF_COPIES  - 1) downto 0);
signal ena_descr_min1						: std_logic_vector((NUMBER_OF_COPIES  - 1) downto 0);

signal Reset_Rx_min1							: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);
signal Reset_Rx_A								: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);


signal enable_scrambler_sync_tx			: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);
signal enable_scrambler_sync_rx			: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);
signal Reset_in2								: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);
signal Reset_Tx								: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);

signal tx_ready_Q								: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);
signal rx_ready_Q								: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);

signal tx_ready_detected					: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);

signal Reset_sync								: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);
signal tx_deskew								: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);
signal tx_deskew_min1						: std_logic_vector((NUMBER_OF_COPIES-1) downto 0);
signal count_deskew							: Bit4_Type;


signal tx_ctrlenable_Q						: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal tx_clkout_not_used					: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal rx_clkout_not_used					: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);
signal rx_clkout2_not_used					: std_logic_vector((NUMBER_OF_COPIES- 1) downto 0);


begin


----------------------------------------------------------------------------------------
-- Important note on the clocking
-- There is only one reference clock in this design and one system PLL clock.
-- All tx_coreclk's and rx_coreclk's are originating from the same PLL clock.
-- When using fractured mode each of the tx_coreclk's has to be used independently as lanes can be kept in reset.
----------------------------------------------------------------------------------------

Generate_TxSignals:
FOR i IN 0 to NUMBER_OF_COPIES-1 GENERATE


----------------------------------------------------------------------------------------
-- Synchronize Reset to tx_coreclk(I)
----------------------------------------------------------------------------------------
	

reset_synchro_Resetx :  reset_synchro
port map
	(
	clk			=> tx_coreclk(I),
	reset_in		=> Reset,
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


Synchro_tx_ready: synchro
port map
	(
	Clk			=> ClkMgmt,
	data_in		=> tx_ready_i(I),
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
	

----------------------------------------------------------------------------------------
-- Synchronize enable_scrambler to the coreclk domains
----------------------------------------------------------------------------------------
	
Synchro_enable_scrambler_tx: synchro
port map
	(
	Clk			=> tx_coreclk(I),
	data_in		=> enable_scrambler,
	data_out		=> enable_scrambler_sync_tx(I)
	);
	
Synchro_enable_scrambler_rx: synchro
port map
	(
	Clk			=> rx_coreclk(I),
	data_in		=> enable_scrambler,
	data_out		=> enable_scrambler_sync_rx(I)
	);	
	
	
-----------------------------------------------------------------------------------------------------------
--	Generate Tx Deskew pulses 
-- 1 pulse every 16 parallel clock cycles for KPFEC or KP(544,514)
-----------------------------------------------------------------------------------------------------------	

	process(tx_coreclk(I))
	begin
		if rising_edge(tx_coreclk(I)) then	
		
		  if (tx_reset_sync(I) = '1') then 
		  
				count_deskew(I) 		<= (OTHERS => '0');
				tx_deskew_min1(I) 	<= '0';
				tx_deskew(I)			<= '0';
		  else
				
					if (count_deskew(I) = "1111") then -- Generate deskew pulse 
						tx_deskew_min1(I) <= '1';
						count_deskew(I) <= (OTHERS => '0');
					else
						tx_deskew_min1(I) <= '0';
						count_deskew(I) <= count_deskew(I) + 1;
					end if;
				
				tx_deskew(I) <= tx_deskew_min1(I); -- register for timing closure
		  end if;
		end if;
				
	end process;
	
	
-----------------------------------------------------------------------------------------------------------
--	Generate tx_pcs_ready :low every 17th clock cycle (32/34 ratio) (for KPFEC) 
--	Generate tx_pcs_ready :low every 33th clock cycle (32/33 ratio) (for RSFEC)
-----------------------------------------------------------------------------------------------------------		
	
	process(tx_coreclk(I))
	begin
		if rising_edge(tx_coreclk(I)) then	

		  if ((tx_reset_sync(I) = '1') or (start_counting(I) = '0')) then  		  
					count_tx_pcs_ready(I) <= (OTHERS => '0'); -- runs synchronously with count_pulse counter
					tx_pcs_ready(I) 	   <= '0';
			
				else
					if (KPFEC) then 
						-- Generate cadence (16/17) (RS(544,514) mode) KPFEC				
						if (count_tx_pcs_ready(I) = "10000") then 
							tx_pcs_ready(I) <= '0';
							count_tx_pcs_ready(I) <= (OTHERS => '0');
						else
							tx_pcs_ready(I) <= '1';
							count_tx_pcs_ready(I) <= count_tx_pcs_ready(I) + 1;
						end if;
					else -- Generate cadence 32/33 (RS(528,514 mode) RSFEC
						if (count_tx_pcs_ready(I) = "100000") then  
							tx_pcs_ready(I) <= '0';
							count_tx_pcs_ready(I) <= (OTHERS => '0');
						else
							tx_pcs_ready(I) <= '1';
							count_tx_pcs_ready(I) <= count_tx_pcs_ready(I) + 1;
						end if;	
					end if;
				end if;
		end if;	
	end process;	

	
-----------------------------------------------------------------------------------------------------------
--	Generate am_pulse
-----------------------------------------------------------------------------------------------------------			


Synchro_tx_am_gen_start: synchro
port map
	(
	Clk			=> tx_coreclk(I),
	data_in		=> tx_am_gen_start(I),
	data_out		=> tx_am_gen_start_sync(I)
	);
	
process (tx_coreclk(I))
begin
	if rising_edge(tx_coreclk(I)) then	
			
		if (tx_reset_sync(I) = '1') then			
		
		
			count_pulse(I) 				<= (OTHERS => '0');
			pulse_pause_data(I) 			<= '0';
			tx_datain_ready(I)	 		<= '0';
			start_counting(I)				<= '0';
			tx_am_gen_start_q(I)			<= '0';
			am_pulse_min2(I) 				<= '0';
			am_pulse_min1(I) 				<= '0';
			am_pulse(I) 					<= '0';	
			am_pulse_count(I)				<= (OTHERS => '0');
			tx_am_gen_2x_ack(I)			<= '0';
			
		else
				
			tx_am_gen_start_Q(I) <= tx_am_gen_start_sync(I); -- When this is asserted start the generation of AM pulses
		
			if (tx_am_gen_start_Q(I) /= tx_am_gen_start_sync(I)) and (tx_am_gen_start_sync(I) = '1') then -- Detect rising edge
				start_counting(I) <= '1';
			end if;

			-- Generate count_pulse counter
					
			if (SIMULATION_MODE) then	
				if ((tx_pcs_ready(I) = '1') and (start_counting(I) = '1')) then	
				   if (FEC_MODE = 0) then 
						if (count_pulse(I) = 1279) then	  -- needs to be this number otherwise it does not work (2**LOG2_MRK * 80 transfers per AM period for 100GE or 25GE)
						-- for simulation the LOG2_MRK is set to 4 apparently, 			
							count_pulse(I) <= (OTHERS => '0'); -- this will drive the last clock cycle of the am period
						else
							count_pulse(I) <= count_pulse(I) + 1;
						end if;
					elsif (FEC_MODE = 1) then
						if (count_pulse(I) = 639) then	  -- needs to be this number for 200GbE aggregate or 50G-1
						-- for simulation the LOG2_MRK is set to 4 apparently, 			
							count_pulse(I) <= (OTHERS => '0'); -- this will drive the last clock cycle of the am period
						else
							count_pulse(I) <= count_pulse(I) + 1;
						end if;
					end if;
				end if;
			else -- hw mode
				if ((tx_pcs_ready(I) = '1') and (start_counting(I) = '1')) then	
				   if (FEC_MODE = 0) then 				  
						if (count_pulse(I) = 81919) then -- LOG2_MRK is 10 in hardware mode (for 100GbE and 25GbE)
							count_pulse(I) <= (OTHERS => '0'); -- this will drive the last clock cycle of the am period
						else
							count_pulse(I) <= count_pulse(I) + 1;
						end if;
					elsif (FEC_MODE = 1) then
						if (count_pulse(I) = 40959) then -- LOG2_MRK is 9  (for 200GbE aggregate and 50G-1)
							count_pulse(I) <= (OTHERS => '0'); -- this will drive the last clock cycle of the am period
						else
							count_pulse(I) <= count_pulse(I) + 1;
						end if;
					end if;
				end if;	
			end if;
			

			if ((tx_pcs_ready(I) = '1') and (start_counting(I) = '1')) then					
				if ((count_pulse(I) >= 0) and (count_pulse(I) < AM_PULSE_WIDTH)) then 		
					am_pulse_min2(I) <= '1';
					pulse_pause_data(I) <= '0';	
				else
					am_pulse_min2(I) <= '0';
					pulse_pause_data(I) <= '1';
				end if;
			end if;				
			
			am_pulse_min1(I) 	<= am_pulse_min2(I);
			am_pulse(I)		<= am_pulse_min1(I);
			
			if (am_pulse_count(I) <= 3) then
				if ((am_pulse(I) /= am_pulse_min1(I)) and (am_pulse(I) = '1')) then -- rising edge
					am_pulse_count(I) <= am_pulse_count(I) + 1; -- when 4 it stops counting.
				end if;
			end if;
			
		

--          This is from the one lane implementation : test to see if this works.

			if (am_pulse_count(I) = 3) then  -- need 2 full AM periods before asserting tx_am_gen_2x_ack
				tx_am_gen_2x_ack(I) <= '1';
			elsif tx_am_gen_start_sync(I) = '0' then
				tx_am_gen_2x_ack(I) <= '0';					
			end if;
			
			
			tx_datain_ready(I) <= pulse_pause_data(I) and tx_pcs_ready(I);
			
		end if;
	end if;
end process;
	
end generate generate_TxSignals;


-----------------------------------------------------------------------------------------------------------
--	Instantiate scrambler (one for each FEC/for each COPY)
-----------------------------------------------------------------------------------------------------------	

-- AM data should not be scrambled.


generate_scramblers:
FOR I IN 0 to NUMBER_OF_COPIES-1 GENERATE
ena_scr(I)	<= tx_datain_valid(I);

scrambler_inst : scrambler
GENERIC MAP(
	WIDTH	=> (NUMBER_OF_SEGMENTS*LANEWIDTH) -- FRACTURED MODE = NUMBER_OF_SEGMENTS*LANEWIDTH  AGGREGATE MODE = NUMBER_OF_STREAMS*LANEWIDTH
)
PORT MAP
(
	use_scrambler	=> enable_scrambler_sync_tx(I),
	clk				=> tx_coreclk(I),						
	srst				=> Reset_Tx(I), -- TBD Change this to tx_reset_sync(I)?
	ena				=> ena_scr(I),		
	din				=> tx_datain((PRBSWIDTH*(I+1)-1) downto (PRBSWIDTH*I)),		
	dout				=> pcs_scr_pld((PRBSWIDTH*(I+1)-1) downto (PRBSWIDTH*I))
);		


-- delay header bit with one clock cycle to match the scrambler delay
-- When using control characters the scrambled must be used otherwise it doesn't match
	
retimer_header : hyper_pipe 
GENERIC MAP
	(
		DWIDTH	 	=>	1,
		NUM_PIPES 	=> 1  
	)
PORT MAP(
	clk				=> tx_coreclk(I),
	din(0)			=> tx_ctrlenable(I),
	dout(0)			=> tx_ctrlenable_Q(I)
	);
	
end generate generate_scramblers;



	




Generate_valid_encoded_lane:
FOR I IN 0 to NUMBER_OF_COPIES-1 GENERATE	

tx_pcs_ready_lane(I) <= tx_pcs_ready(I);

-- delay tx_pcs_ready with EXTERNAL_LATENCY+1 clock cycles to match the delays through the prbsgenerate 
-- (one clock from tx_pcs_ready to prbsgenerate_enable + 2 (EXTERNAL_LATENCY) clocks through the prbsgenerate)
-- (the delay through the scrambler is one clock cycle but it is not required to have a delay for this when used)
-- note that valid_encoded is only based on tx_pcs_ready not on the am pulse


retimer_valid : hyper_pipe 
GENERIC MAP
	(
		DWIDTH	 =>	1,
		NUM_PIPES => 	EXTERNAL_LATENCY+1  -- With PRBS this is 3
	)
PORT MAP(
	clk				=> tx_coreclk(I),
	din(0)			=> tx_pcs_ready_lane(I),
	dout(0)			=> valid_encoded_lane(I)
	);	
end generate Generate_valid_encoded_lane;
	


-- delay am_pulse with one clock cycle so that it ends up aligned with the am pulse present on tx_datain_valid
-- This assumes the external data generator has a latency of 2 from tx_datain_ready 

Generate_tx_pcs66_am_lane:
FOR I IN 0 to NUMBER_OF_COPIES-1 GENERATE	

am_pulse_lane(I) <= am_pulse(I);

retimer_am_pulse_in : hyper_pipe 
GENERIC MAP
	(
		DWIDTH	 =>	1,
		NUM_PIPES => EXTERNAL_LATENCY-1  -- With PRBS this is 1
	)
PORT MAP(
	clk				=> tx_coreclk(I),
	din(0)			=> am_pulse_lane(I),
	dout(0)			=> tx_pcs66_am_lane(I)
	);	
end generate Generate_tx_pcs66_am_lane;	




Generate_Encoded_data:
FOR I IN 0 to NUMBER_OF_STREAMS-1 GENERATE	

--	tx_encoded((65+ 66*I)  downto (2  + 66*I))  	<= Prbsout((63 + 64*I)  downto (  0 + 64*I));
	tx_encoded((65+ 66*I)  downto (2  + 66*I))  	<= pcs_scr_pld((63 + 64*I)  downto (  0 + 64*I));
	
	-- convert NUMBER_OF_COPIES to NUMBER_OF_STREAMS
	tx_encoded((1 + 66*I)) 								<= not(tx_ctrlenable_Q(I/NUMBER_OF_SEGMENTS));
	tx_encoded((0 + 66*I)) 								<= tx_ctrlenable_Q(I/NUMBER_OF_SEGMENTS);	
	
	-- tx_encoded((1 + 66*I)) 								<= '1' when (scrambled_idle_sync(0) = '0') else '0';
	-- tx_encoded((0 + 66*I)) 								<= '0' when (scrambled_idle_sync(0) = '0') else '1';
	
	
end generate Generate_Encoded_data;


-----------------------------------------------------------------------------------------------------------
--	Phy Direct Instantiation
-----------------------------------------------------------------------------------------------------------	



Generate_ALTGX_CLocks:
FOR i IN 0 to NUMBER_OF_COPIES-1 GENERATE

	--tx_coreclk(I) 	<= tx_clkout(I);  -- Systempll_clock/2	(overclocked at /64)	Make sure every channel is independent
	rx_coreclk(I)	<= rx_clkout(I);  -- Systempll_clock/2	(overclocked at /64)




END GENERATE;


Generate_map_data:
FOR i IN 0 to NUMBER_OF_STREAMS-1 GENERATE



	

	-- Mapping RSFEC txdata


	tx_parallel_data((32  + 80*I)  downto (   0 + 80*I)) 	<= tx_encoded((32  + 66*I)  downto (   0 + 66*I));
	
	tx_parallel_data((36  + 80*I)  downto (  33 + 80*I)) 	<= (OTHERS => '0');
	
	--Alignment Marker
	tx_parallel_data(37  + 80*I) 	<= tx_pcs66_am_lane(I/NUMBER_OF_SEGMENTS);	
	
	--Tx Data Valid
	tx_parallel_data(38  + 80*I)  <= valid_encoded_lane(I/NUMBER_OF_SEGMENTS);
	
	tx_parallel_data(39  + 80*I)	<= '0';	
	
	tx_parallel_data((72  + 80*I)  downto (  40 + 80*I)) 	<= tx_encoded((65  + 66*I)  downto (  33 + 66*I));	
	
	tx_parallel_data((76  + 80*I)  downto (  73 + 80*I)) 	<= (OTHERS => '0');	
	
	--2nd Alignment Marker
	tx_parallel_data(77  + 80*I) 	<= tx_pcs66_am_lane(I/NUMBER_OF_SEGMENTS);		
	
	tx_parallel_data(78 + 80*I)	<= tx_deskew(I/NUMBER_OF_SEGMENTS);	

	tx_parallel_data(79 + 80*I)	<= '0';	
	
	-- Mapping PMA direct Txdata (just as reference)
	
--	tx_parallel_data((31+ 80*I)  downto (0  + 80*I)) 	<= Prbsout((31 + 64*I)  downto ( 0 + 64*I));
--	tx_parallel_data(38+ 80*I)	<= '1'; -- Datavalid
--	tx_parallel_data((71+ 80*I)  downto (40 + 80*I)) 	<= Prbsout((63 + 64*I)  downto (32 + 64*I));	
--	tx_parallel_data(79+ 80*I)	<= '1'; -- Write enable for TX core interface FIFO in elastic mode.	


	-- Mapping RSFEC rxdata	

	

	rx_out((32  + 66*I)  downto (  0 + 66*I)) 		<= rx_parallel_data((32  + 80*I)  downto (  0 + 80*I));
	rx_out((65  + 66*I)  downto (  33 + 66*I)) 		<= rx_parallel_data((72  + 80*I)  downto ( 40 + 80*I));
	

	-- o_rx_valid
	rx_pcs66_valid_min1_stream(I)	<= rx_parallel_data(38  + 80*I);

	-- o_rx_am
	rx_pcs66_am_valid_min1_stream(I) <= rx_parallel_data(37  + 80*I);
	
	
	
	
	
END GENERATE;



	



-----------------------------------------------------------------------------------------------------------
--	Phy direct IP instance
-----------------------------------------------------------------------------------------------------------	
	
Generate_phy_direct:
FOR i IN 0 to NUMBER_OF_COPIES-1 GENERATE



phy_direct_inst : phy_direct
		port map (
			rx_cdr_refclk_link        		=> RefClock,        
			tx_pll_refclk_link        		=> RefClock, 
			system_pll_clk_link(0)			=> Systempll_clk,
			tx_reset(0)							=> tx_reset(I),
			rx_reset(0)							=> rx_reset(I),
			tx_reset_ack(0)              	=> tx_reset_ack(I),    
			rx_reset_ack(0)             	=> rx_reset_ack(I),  
			tx_am_gen_start(0)           	=> tx_am_gen_start(I), -- output (asynchronous)
			tx_am_gen_2x_ack(0)          	=> tx_am_gen_2x_ack(I), -- input
			tx_ready(0)		              	=> tx_ready_i(I),      
			rx_ready(0)		               => rx_ready_i(I),      
			tx_coreclkin(0)               => tx_coreclk(I),
			tx_coreclkin(1)               => tx_coreclk(I),
			rx_coreclkin(0)               => rx_coreclk(I),   
			rx_coreclkin(1)               => rx_coreclk(I),  	  
			tx_clkout(0)                  => tx_clkout(I),
			tx_clkout(1)						=> tx_clkout_not_used(I),
			tx_clkout2                    => open,
			rx_clkout(0)                  => rx_clkout(I),   
			rx_clkout(1)						=> rx_clkout_not_used(I),
			rx_clkout2(0)                 => rx_clkout2(I),  
			rx_clkout2(1)						=> rx_clkout2_not_used(I),
			tx_serial_data(0)             => tx_dataout(I),
			tx_serial_data_n(0)           => tx_dataout_n(I),
			rx_serial_data(0)             => rx_datain(I), 
			rx_serial_data_n(0)           => rx_datain_n(I), 

			tx_pll_locked(0)				   		=> tx_pll_locked(I),
			rx_is_lockedtodata(0)            	=> rx_freqlocked(I),            
			rx_is_lockedtoref(0)			   		=> rx_is_lockedtoref(I), -- not used

			rsfec_sf(0)                   		=> rsfec_sf(I),						 -- Signal fail, low means RSFEC is aligned( fec_ready is high and rsfec_status_not_aligned is low)
			rsfec_status_rx_not_align(0) 			=> rsfec_status_rx_not_align(I),  -- Incoming signal fail, Rx lanes not all locked, alignment markers not unique or skew too large. Only applicable in multi-lane.
			rsfec_status_rx_not_deskew(0)			=> rsfec_status_rx_not_deskew(I), -- All Rx lanes locked but the alignment markers were not unique or the skew was too large. Only applicable in multi-lane.
			rsfec_status_rx_not_locked(0) 		=> rsfec_status_rx_not_locked(I), -- Rx lane not locked. Not locked to alignment/codework markers or FEC codewords(when not using markers). Only applicable in multi-lane.
			fec_snapshot								=> (OTHERS => '0'),
			
			tx_parallel_data          		=> tx_parallel_data((159  + 160*I)  downto (   0 + 160*I)) ,
			rx_parallel_data          		=> rx_parallel_data((159  + 160*I)  downto (   0 + 160*I)) ,			
			
			reconfig_xcvr_clk(0)        	=> ClkMgmt,
			reconfig_xcvr_reset(0)       	=> reconfig_xcvr_reset(I),
			reconfig_xcvr_write(0)       	=> reconfig_xcvr_write(I),
			reconfig_xcvr_read(0)        	=> reconfig_xcvr_read(I),
			reconfig_xcvr_address        	=> reconfig_xcvr_address(I)(17 downto 0),
			reconfig_xcvr_byteenable		=> reconfig_xcvr_byteenable(I),
			reconfig_xcvr_writedata      	=> reconfig_xcvr_writedata(I),
			reconfig_xcvr_readdata       	=> reconfig_xcvr_readdata(I),
			reconfig_xcvr_waitrequest(0) 	=> reconfig_xcvr_waitrequest(I),	
			
			reconfig_pdp_clk(0)           => ClkMgmt,   
			reconfig_pdp_reset(0)         => reconfig_pdp_reset(I),
			reconfig_pdp_write(0)         => reconfig_pdp_write(I),
			reconfig_pdp_read(0)          => reconfig_pdp_read(I),
			reconfig_pdp_address         	=> reconfig_pdp_address(I)(13 downto 0),
			reconfig_pdp_byteenable		 	=> reconfig_pdp_byteenable(I),			
			reconfig_pdp_writedata       	=> reconfig_pdp_writedata(I),
			reconfig_pdp_readdata        	=> reconfig_pdp_readdata(I),
			reconfig_pdp_waitrequest(0)   => reconfig_pdp_waitrequest(I)
		);

end generate Generate_phy_direct;		

	

-- Keep downstream path in Reset until rx_am_lock is achieved (for each FEC)


Generate_RxSignals:
FOR I IN 0 to NUMBER_OF_COPIES-1 GENERATE

rx_am_lock_async(I)	 <= not (rsfec_sf(I)); 	-- note that all rsfec status signals are ASYNCHRONOUS wrt to the rx_coreclk, so they need to be synchronized first

Synchro_rx_am_lock: synchro
port map
	(
	Clk			=> rx_coreclk(I),
	data_in		=> rx_am_lock_async(I),
	data_out		=> rx_am_lock_rx_coreclk(I) -- Synchronized to rx_coreclk(I)
	);

rx_am_lock(I) <= rx_am_lock_rx_coreclk(I);

process(rx_coreclk(I),Reset)
begin
	if Reset = '1' then
		Reset_Rx_min1(I)		<= '1';
		rx_ready_Q(I) 			<=  '0';
	elsif rising_edge(rx_coreclk(I)) then	
		rx_ready_Q(I)	 	<= rx_am_lock_rx_coreclk(I)  ;						
		if (rx_ready_Q(I)= '1')  then
			Reset_Rx_min1(I)		 		<= '0';
		else
			Reset_Rx_min1(I)	 			<= '1';
		end if;
	end if;
end process;

 

Duplicate_Reset_Rx_A : hyper_pipe
GENERIC MAP
	(
		DWIDTH	 =>	1,
		NUM_PIPES =>   2  
	)
PORT MAP(
	clk				=> rx_coreclk(I),
	din(0)			=> Reset_Rx_min1(I),	
	dout(0)			=> Reset_Rx_A(I)
	);
	


end generate Generate_RxSignals;

----------------------------------------------------------------------------------------------------
-- Create assertions for simulation testbench (not used in the RTL)
----------------------------------------------------------------------------------------------------

Generate_create_assertions:
FOR I IN 0 to NUMBER_OF_COPIES-1 GENERATE

process (tx_coreclk(I),tx_ready_i(I))
begin
	if tx_ready_i(I) = '0' then
		tx_ready_q(I) <= '0';
		tx_ready_detected(I) <= '0';
	elsif rising_edge(tx_coreclk(I)) then
		tx_ready_q(I) <= tx_ready_i(I);

		if tx_ready_q(I) /= tx_ready_i(I) and tx_ready_i(I) = '1' then
			tx_ready_detected(I) <= '1';
				assert(tx_ready_detected(I) = '1')
				report "==========================================================================================================> tx_lanes_stable ..." 		severity note;							
		end if;
	 end if;
end process;
			



process (rx_coreclk(I),rx_ready_i(I))
begin
	if rx_ready_i(I) = '0' then
		rx_am_lock_q(I) <=  '0';
		rx_am_lock_detected(I) <= '0';
	elsif rising_edge(rx_coreclk(I)) then

-- This is for aggregate mode
			rx_am_lock_q(I) <= rx_am_lock_rx_coreclk(I);
			if rx_am_lock_q(I) /= rx_am_lock_rx_coreclk(I) and rx_am_lock_rx_coreclk(I) = '1' then
				rx_am_lock_detected(I) <= '1';
				assert(rx_am_lock_detected(I) = '1') 
					report "==========================================================================================================> rx_am_lock detected ..." 		severity note;							
			end if;

-- Fractured

			-- rx_am_lock_q(I) <= rx_pcs66_am_valid_min1(I);
			-- if rx_am_lock_q(I) /= rx_pcs66_am_valid_min1(I) and rx_pcs66_am_valid_min1(I) = '1' then
				-- rx_am_lock_detected(I) <= '1';
					-- assert(rx_am_lock_detected(I) = '1') 
					-- report "==========================================================================================================> rx_pcs66_am_valid detected ..." 		severity note;							
			-- end if;


   end if;
end process;
	
end generate Generate_create_assertions;

-------------------------------------------------------------------------------------------------------------
-- Instantiate Receive path logic
-------------------------------------------------------------------------------------------------------------	

Generate_demap_Rxdata:
FOR I IN 0 to NUMBER_OF_STREAMS-1 GENERATE

-- Use bit 1,0 as header bits
--rx_data((63  + 64*I)  downto (0 + 64*I))			<= rx_out((65 + 66*I)  downto (2 + 66*I));
pcs_descr_pld_min1((63  + 64*I)  downto (0 + 64*I))	<= rx_out((65 + 66*I)  downto (2 + 66*I));
rx_ctrldetect_min1_stream(I)										<= rx_out((0  + 66*I));



end generate Generate_demap_Rxdata;


-------------------------------------------------------------------------------------------------------------
--	Instantiate Descramblers
-------------------------------------------------------------------------------------------------------------


Generate_rx_control_signals:
FOR I IN 0 to (NUMBER_OF_COPIES-1) GENERATE

-- Convert streams  to NUMBER_OF_COPIES

	rx_pcs66_valid_min1(I)	<= rx_pcs66_valid_min1_stream(NUMBER_OF_SEGMENTS*I);

	-- o_rx_am
	rx_pcs66_am_valid_min1(I) <= rx_pcs66_am_valid_min1_stream(NUMBER_OF_SEGMENTS*I);

	rx_ctrldetect_min1(I)	 <= rx_ctrldetect_min1_stream(NUMBER_OF_SEGMENTS*I);

ena_descr_min1(I) <= '1' when ((rx_pcs66_valid_min1(I) = '1') and (rx_pcs66_am_valid_min1(I) = '0')) else '0';


retimer_ena_descr : hyper_pipe 
GENERIC MAP
	(
		DWIDTH	 => 1,
		NUM_PIPES => 1  
	)
PORT MAP(
	clk				=> rx_coreclk(I),
	din(0)			=> ena_descr_min1(I), 
	dout(0)			=> ena_descr(I)
	);

retimer_pcs_descr_pld : hyper_pipe 
GENERIC MAP
	(
		DWIDTH		=> (NUMBER_OF_SEGMENTS*LANEWIDTH), -- FRACTURED MODE = NUMBER_OF_SEGMENTS*LANEWIDTH  AGGREGATE MODE = NUMBER_OF_STREAMS*LANEWIDTH
		NUM_PIPES	=> 1  
	)
PORT MAP(
	clk				=> rx_coreclk(I),
	din				=> pcs_descr_pld_min1((PRBSWIDTH*(I+1)-1) downto (PRBSWIDTH*I)),
	dout				=> pcs_descr_pld((PRBSWIDTH*(I+1)-1) downto (PRBSWIDTH*I))
	);	
	
	
descrambler_inst : descrambler
GENERIC MAP(
	WIDTH	=> (NUMBER_OF_SEGMENTS*LANEWIDTH) -- FRACTURED MODE = NUMBER_OF_SEGMENTS*LANEWIDTH  AGGREGATE MODE = NUMBER_OF_STREAMS*LANEWIDTH
)
PORT MAP
(
	use_descrambler	=> enable_scrambler_sync_rx(I),
	clk					=> rx_coreclk(I),						
	srst					=> Reset_Rx_A(I), 		
	ena					=> ena_descr(I), 		
	din					=> pcs_descr_pld((PRBSWIDTH*(I+1)-1) downto (PRBSWIDTH*I)),	
	dout					=> dout_descr((PRBSWIDTH*(I+1)-1) downto (PRBSWIDTH*I))
);


retimer_rx_am_valid : hyper_pipe 
GENERIC MAP
	(
		DWIDTH	 => 1,
		NUM_PIPES => 2 
	)
PORT MAP(
	clk				=> rx_coreclk(I),
	din(0)			=> rx_pcs66_am_valid_min1(I), 
	dout(0)			=> rx_pcs66_am_valid_min1_Q(I)
	);
	
rx_pcs66_am_valid(I) <=  rx_pcs66_am_valid_min1_Q(I); 

retimer_rx_pcs66_valid : hyper_pipe 
GENERIC MAP
	(
		DWIDTH	 => 1,
		NUM_PIPES => 2  
	)
PORT MAP(
	clk				=> rx_coreclk(I),
	din(0)			=> rx_pcs66_valid_min1(I), 
	dout(0)			=> rx_pcs66_valid_min1_Q(I)
	);	
	
rx_pcs66_valid(I)		<=  rx_pcs66_valid_min1_Q(I); 
	
rx_valid_min1(I)		<= '1' when (rx_pcs66_valid(I) = '1' and rx_pcs66_am_valid(I) = '0') else '0';	


-- Retime rx_valid_min1(I) to ease timing closure;

retimer_rx_valid : hyper_pipe 
GENERIC MAP
	(
		DWIDTH	 =>	1,
		NUM_PIPES => 1  
	)
PORT MAP(
	clk				=> rx_coreclk(I),
	din(0)			=> rx_valid_min1(I), -- signals are the same within the same Native PHY
	dout(0)			=> rx_valid_q(I)
	);

rx_valid(I) 		<= rx_valid_q(I);


-- retime parallel data accordingly

retimer_rx_data : hyper_pipe 
GENERIC MAP
	(
		DWIDTH		=> (NUMBER_OF_SEGMENTS*LANEWIDTH), -- FRACTURED MODE = NUMBER_OF_SEGMENTS*LANEWIDTH  AGGREGATE MODE = NUMBER_OF_STREAMS*LANEWIDTH
		NUM_PIPES 	=> 2  
	)
PORT MAP(
	clk				=> rx_coreclk(I),
	din				=> dout_descr((PRBSWIDTH*(I+1)-1) downto (PRBSWIDTH*I)),  
	dout				=> rx_data_retimed((PRBSWIDTH*(I+1)-1) downto (PRBSWIDTH*I)) 
	);

rx_dataout <= rx_data_retimed;

-- Delay header bit to match the delay of the data 

retimer_rx_ctrldetect : hyper_pipe 
GENERIC MAP
	(
		DWIDTH	 => 1,
		NUM_PIPES => 2  
	)
PORT MAP(
	clk				=> rx_coreclk(I),
	din(0)			=> rx_ctrldetect_min1(I), 
	dout(0)			=> rx_ctrldetect_int(I)
	);	

rx_ctrldetect(I) <= rx_ctrldetect_int(I);
	

end generate Generate_rx_control_signals;


-----------------------------------------------------------------------------------------------------------
--	Generation of ready signals and ack signals
-----------------------------------------------------------------------------------------------------------	

Generate_ready:
FOR i IN 0 to NUMBER_OF_COPIES-1 GENERATE

rx_ready(I) <= rx_ready_i(I);
tx_ready(I) <= tx_ready_i(I);

	
END GENERATE;


Generate_reset_ack:
FOR i  IN 0 to NUMBER_OF_COPIES-1 Generate
    
Synchro_tx_reset_ack: synchro
port map
	(
	Clk			=> ClkMgmt,
	data_in		=> tx_reset_ack(I),
	data_out		=> tx_reset_ack_sync(I) -- Synchronized to ClkMgmt domain
	);

Synchro_rx_reset_ack: synchro
port map
	(
	Clk			=> ClkMgmt,
	data_in		=> rx_reset_ack(I),
	data_out		=> rx_reset_ack_sync(I) -- Synchronized to ClkMgmt domain
	);
	
Synchro_rx_am_lock: synchro
port map
	(
	Clk			=> ClkMgmt,
	data_in		=> rx_am_lock_rx_coreclk(I),
	data_out		=> rx_am_lock_sync(I) -- Synchronized to ClkMgmt domain
	);

rx_recovered_clk(I) <= rx_clkout2(0);
	
end generate;

			
end;



