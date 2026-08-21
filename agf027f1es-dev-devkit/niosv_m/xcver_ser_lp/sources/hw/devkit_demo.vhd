-- (C) 2001-2025 Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions and other 
-- software and tools, and its AMPP partner logic functions, and any output 
-- files from any of the foregoing (including device programming or simulation 
-- files), and any associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License Subscription 
-- Agreement, Altera IP License Agreement, or other applicable 
-- license agreement, including, without limitation, that your use is for the 
-- sole purpose of programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the applicable 
-- agreement for further details.


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

-- Agilex F-Series FM86 Development Kit with 2 F-tiles (B0 Silicon) (AGFB027R24C2E2VR2)
-- Demo Design Multi Prbs PAM4 with RSFEC in fractured mode (544,514) 53.125 Gbps (QII 22.3)  (B104)
-- 4 Channels routed to QSFP56 (PHY0) and 4 channels routed to bottom of QSFPDD-56 (PHY1)  PRBS-7, PRBS-13, PRBS-23 or PRBS-31 at 53.125 Gpbs RSFEC encoded.
-- This version is using 2 instances where each instance is instantianting a single channel 4 times (fractured)
-- One referenceclock is shared between the 2 instances
-- Datarate is referenceclock x 170 x 2 for PAM4 
-- E.g. Referenceclock : 156.25 Mhz => Datarate : 53.125 Gbps (50 GbE rate) PAM4


-- Using PHY direct IP for F-tile.
-- Author : Peter Schepers (peter.schepers@intel.com)
-- Added core noise logic (courtesy of Gregg Baeckler)

-- Version with updated .qsys and _hw.tcl using altera_clock_bridge and altera_reset_bridge iso clock_source IP (deprecated)

-- Version with Nios V/m (slower than Nios II)


LIBRARY ieee;
LIBRARY work;
USE ieee.std_logic_1164.all;
use work.package_registertype.all; --package that defines Registertypes

-- Subvariant 01 : Using System PLL at exact same rate as transceiver clock (required as FEC is used)

ENTITY devkit_demo IS 
GENERIC
	(
		VERSION						   :  std_logic_vector(31 downto 0) := X"13012301"; -- Day(2 digits)/Month(2 digits)/Year(2 digits)/Variant(2 digits)
		NUMBER_OF_PHYS					: 	integer := 2;
		NUMBER_OF_LANES_PER_PHY		:  integer := 1; -- Number of lanes of each PHY direct instance
		NUMBER_OF_COPIES				:  integer := 4; -- Number of copies of each PHY direct instances per phy.
		NUMBER_OF_LANES				:  integer := 4; -- NUMBER_OF_LANES_PER_PHY * NUMBER_OF_COPIES
		INVERT_POLARITY_PRBS			:  boolean := false;  -- For L/H tile set to true, For E/F-tile set to false (allows compatibility with Hard PRBS generators/checkers)				
		GENERATE_INTERNAL_NOISE		:  boolean := false;
		NUMBER_OF_WABS					:  integer := 8  -- noise logic instances, each around 82K ALMs	(only when GENERATE_INTERNAL_NOISE is true)
	
	);
	PORT
	(

		clk_sys_100m	:  IN  STD_LOGIC; -- 100 Mhz  -- used to clock the IOPLL to generate the internal noise
		

		gt_refclk 		:  IN  STD_LOGIC; -- Refclock PHY 0 and 1  (Already at 156.25 Mhz)  

		--PHY 0 : QSFP-56 (connected to Quad 1)
		--PHY 1 : QSFPDD-56 (bottom lanes) (connected to Quad 2 and Quad 3)
		
		qsfpdd_rxp : IN STD_LOGIC_VECTOR((NUMBER_OF_LANES*NUMBER_OF_PHYS - 1) DOWNTO 0); 
		qsfpdd_rxn : IN STD_LOGIC_VECTOR((NUMBER_OF_LANES*NUMBER_OF_PHYS - 1) DOWNTO 0);
		 
	
		qsfpdd_txp :	 OUT STD_LOGIC_VECTOR((NUMBER_OF_LANES*NUMBER_OF_PHYS - 1) DOWNTO 0);  
		qsfpdd_txn :	 OUT STD_LOGIC_VECTOR((NUMBER_OF_LANES*NUMBER_OF_PHYS - 1) DOWNTO 0);   

		
      --QSFP56 control signals (not connected to the FPGA, these are controlled through PCA9534PW)
      
--    qsfpdd0_modsel_L     : out std_logic;
--    qsfpdd0_reset_L      : out std_logic;
--    qsfpdd0_Initmode     : out std_logic;
--    qsfpdd0_modprs_L     : in std_logic;
--    qsfpdd0_int_L        : in std_logic;
   
      --QSFPDD56 control signals (not connected to the FPGA, these are controlled through PCA9534PW)
      
--    qsfpdd1_modsel_L     : out std_logic;
--    qsfpdd1_reset_L      : out std_logic;
--    qsfpdd1_Initmode     : out std_logic;
--    qsfpdd1_modprs_L     : in std_logic;
--    qsfpdd1_int_L        : in std_logic;
	
		
		-----------------------------------------------------------------------------------------------------------------
		-- I2C interface to the modules
		-------------------------------------------------------------------------------------------------------------------	
		

      qsfpdd_fpga_i2c_scl    : INOUT STD_LOGIC;  	-- SCL: For both QSFP56 and QSFPDD56
      qsfpdd_fpga_i2c_sda    : INOUT STD_LOGIC   	-- SDA: For both QSFP56 and QSFPDD56
		
		--noise_out :  OUT  STD_LOGIC_VECTOR((NUMBER_OF_WABS -1) DOWNTO 0)		-- Virtual IO
		
	);
END devkit_demo;

ARCHITECTURE devkit_demo_rtl OF devkit_demo IS 


component reset_release is
	port (
		ninit_done : out std_logic   -- ninit_done
	);
end component reset_release;

component prbstest_rsfec is
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
		INVERT_POLARITY_PRBS			:  boolean := false;  -- For L/H tile set to true, For E/F-tile set to false (allows compatibility with Hard PRBS generators/checkers)		
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
	Counter_1ms_Reg				: out std_logic_vector(31 DOWNTO 0);
	ErrorCount_Reg 				: out Register_Array_64bit;
   PrbsLock_Alarm_Reg			: out Register_Array_32bit;	
    
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
end component;



	component refclk is
		port (
			out_systempll_synthlock_0 : out std_logic;        -- out_systempll_synthlock
			out_systempll_clk_0       : out std_logic;        -- clk
			out_refclk_fgt_0          : out std_logic;        -- clk
			in_refclk_fgt_0           : in  std_logic := 'X'  -- in_refclk_fgt_0
		);
	end component refclk;


	
	component controller is
		port (
			clk_in_clk                            : in  std_logic                     := 'X';             -- clk
			i2c_0_i2c_serial_sda_in               : in  std_logic                     := 'X';             -- sda_in
			i2c_0_i2c_serial_scl_in               : in  std_logic                     := 'X';             -- scl_in
			i2c_0_i2c_serial_sda_oe               : out std_logic;                                        -- sda_oe
			i2c_0_i2c_serial_scl_oe               : out std_logic;                                        -- scl_oe
			internal_noise_control_export         : out std_logic_vector(31 downto 0);                    -- export
			module_input_reg_export               : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			module_output_reg_export              : out std_logic_vector(31 downto 0);                    -- export
			reconfig_xcvr_0_s0_address            : out std_logic_vector(20 downto 0);                    -- address
			reconfig_xcvr_0_s0_byteenable         : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_xcvr_0_s0_read               : out std_logic;                                        -- read
			reconfig_xcvr_0_s0_readdata           : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_xcvr_0_s0_write              : out std_logic;                                        -- write
			reconfig_xcvr_0_s0_writedata          : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_xcvr_0_s0_waitrequest        : in  std_logic                     := 'X';             -- waitrequest
			reconfig_xcvr_0_reset_reset           : out std_logic;                                        -- reset
			reconfig_pdp_0_s0_address             : out std_logic_vector(20 downto 0);                    -- address
			reconfig_pdp_0_s0_byteenable          : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_pdp_0_s0_read                : out std_logic;                                        -- read
			reconfig_pdp_0_s0_readdata            : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_pdp_0_s0_write               : out std_logic;                                        -- write
			reconfig_pdp_0_s0_writedata           : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_pdp_0_s0_waitrequest         : in  std_logic                     := 'X';             -- waitrequest
			reconfig_pdp_0_reset_reset            : out std_logic;                                        -- reset
			reconfig_xcvr_1_s0_address            : out std_logic_vector(20 downto 0);                    -- address
			reconfig_xcvr_1_s0_byteenable         : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_xcvr_1_s0_read               : out std_logic;                                        -- read
			reconfig_xcvr_1_s0_readdata           : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_xcvr_1_s0_write              : out std_logic;                                        -- write
			reconfig_xcvr_1_s0_writedata          : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_xcvr_1_s0_waitrequest        : in  std_logic                     := 'X';             -- waitrequest
			reconfig_xcvr_1_reset_reset           : out std_logic;                                        -- reset
			reconfig_pdp_1_s0_address             : out std_logic_vector(20 downto 0);                    -- address
			reconfig_pdp_1_s0_byteenable          : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_pdp_1_s0_read                : out std_logic;                                        -- read
			reconfig_pdp_1_s0_readdata            : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_pdp_1_s0_write               : out std_logic;                                        -- write
			reconfig_pdp_1_s0_writedata           : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_pdp_1_s0_waitrequest         : in  std_logic                     := 'X';             -- waitrequest
			reconfig_pdp_1_reset_reset            : out std_logic;                                        -- reset
			reconfig_xcvr_2_s0_address            : out std_logic_vector(20 downto 0);                    -- address
			reconfig_xcvr_2_s0_byteenable         : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_xcvr_2_s0_read               : out std_logic;                                        -- read
			reconfig_xcvr_2_s0_readdata           : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_xcvr_2_s0_write              : out std_logic;                                        -- write
			reconfig_xcvr_2_s0_writedata          : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_xcvr_2_s0_waitrequest        : in  std_logic                     := 'X';             -- waitrequest
			reconfig_xcvr_2_reset_reset           : out std_logic;                                        -- reset
			reconfig_pdp_2_s0_address             : out std_logic_vector(20 downto 0);                    -- address
			reconfig_pdp_2_s0_byteenable          : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_pdp_2_s0_read                : out std_logic;                                        -- read
			reconfig_pdp_2_s0_readdata            : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_pdp_2_s0_write               : out std_logic;                                        -- write
			reconfig_pdp_2_s0_writedata           : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_pdp_2_s0_waitrequest         : in  std_logic                     := 'X';             -- waitrequest
			reconfig_pdp_2_reset_reset            : out std_logic;                                        -- reset
			reconfig_xcvr_3_s0_address            : out std_logic_vector(20 downto 0);                    -- address
			reconfig_xcvr_3_s0_byteenable         : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_xcvr_3_s0_read               : out std_logic;                                        -- read
			reconfig_xcvr_3_s0_readdata           : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_xcvr_3_s0_write              : out std_logic;                                        -- write
			reconfig_xcvr_3_s0_writedata          : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_xcvr_3_s0_waitrequest        : in  std_logic                     := 'X';             -- waitrequest
			reconfig_xcvr_3_reset_reset           : out std_logic;                                        -- reset
			reconfig_pdp_3_s0_address             : out std_logic_vector(20 downto 0);                    -- address
			reconfig_pdp_3_s0_byteenable          : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_pdp_3_s0_read                : out std_logic;                                        -- read
			reconfig_pdp_3_s0_readdata            : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_pdp_3_s0_write               : out std_logic;                                        -- write
			reconfig_pdp_3_s0_writedata           : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_pdp_3_s0_waitrequest         : in  std_logic                     := 'X';             -- waitrequest
			reconfig_pdp_3_reset_reset            : out std_logic;                                        -- reset
			phy_reg_set_control_reg_0_export      : out std_logic_vector(15 downto 0);                    -- export
			phy_reg_set_control2_reg_0_export     : out std_logic_vector(15 downto 0);                    -- export
			phy_reg_set_bitrate_0_export          : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			phy_reg_set_rxclock_0_export          : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			phy_reg_set_counter_1ms_reg_0_export  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reconfig_xcvr_4_s0_address            : out std_logic_vector(20 downto 0);                    -- address
			reconfig_xcvr_4_s0_byteenable         : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_xcvr_4_s0_read               : out std_logic;                                        -- read
			reconfig_xcvr_4_s0_readdata           : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_xcvr_4_s0_write              : out std_logic;                                        -- write
			reconfig_xcvr_4_s0_writedata          : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_xcvr_4_s0_waitrequest        : in  std_logic                     := 'X';             -- waitrequest
			reconfig_xcvr_4_reset_reset           : out std_logic;                                        -- reset
			reconfig_pdp_4_s0_address             : out std_logic_vector(20 downto 0);                    -- address
			reconfig_pdp_4_s0_byteenable          : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_pdp_4_s0_read                : out std_logic;                                        -- read
			reconfig_pdp_4_s0_readdata            : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_pdp_4_s0_write               : out std_logic;                                        -- write
			reconfig_pdp_4_s0_writedata           : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_pdp_4_s0_waitrequest         : in  std_logic                     := 'X';             -- waitrequest
			reconfig_pdp_4_reset_reset            : out std_logic;                                        -- reset
			reconfig_xcvr_5_s0_address            : out std_logic_vector(20 downto 0);                    -- address
			reconfig_xcvr_5_s0_byteenable         : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_xcvr_5_s0_read               : out std_logic;                                        -- read
			reconfig_xcvr_5_s0_readdata           : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_xcvr_5_s0_write              : out std_logic;                                        -- write
			reconfig_xcvr_5_s0_writedata          : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_xcvr_5_s0_waitrequest        : in  std_logic                     := 'X';             -- waitrequest
			reconfig_xcvr_5_reset_reset           : out std_logic;                                        -- reset
			reconfig_pdp_5_s0_address             : out std_logic_vector(20 downto 0);                    -- address
			reconfig_pdp_5_s0_byteenable          : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_pdp_5_s0_read                : out std_logic;                                        -- read
			reconfig_pdp_5_s0_readdata            : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_pdp_5_s0_write               : out std_logic;                                        -- write
			reconfig_pdp_5_s0_writedata           : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_pdp_5_s0_waitrequest         : in  std_logic                     := 'X';             -- waitrequest
			reconfig_pdp_5_reset_reset            : out std_logic;                                        -- reset
			reconfig_xcvr_6_s0_address            : out std_logic_vector(20 downto 0);                    -- address
			reconfig_xcvr_6_s0_byteenable         : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_xcvr_6_s0_read               : out std_logic;                                        -- read
			reconfig_xcvr_6_s0_readdata           : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_xcvr_6_s0_write              : out std_logic;                                        -- write
			reconfig_xcvr_6_s0_writedata          : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_xcvr_6_s0_waitrequest        : in  std_logic                     := 'X';             -- waitrequest
			reconfig_xcvr_6_reset_reset           : out std_logic;                                        -- reset
			reconfig_pdp_6_s0_address             : out std_logic_vector(20 downto 0);                    -- address
			reconfig_pdp_6_s0_byteenable          : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_pdp_6_s0_read                : out std_logic;                                        -- read
			reconfig_pdp_6_s0_readdata            : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_pdp_6_s0_write               : out std_logic;                                        -- write
			reconfig_pdp_6_s0_writedata           : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_pdp_6_s0_waitrequest         : in  std_logic                     := 'X';             -- waitrequest
			reconfig_pdp_6_reset_reset            : out std_logic;                                        -- reset
			reconfig_xcvr_7_s0_address            : out std_logic_vector(20 downto 0);                    -- address
			reconfig_xcvr_7_s0_byteenable         : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_xcvr_7_s0_read               : out std_logic;                                        -- read
			reconfig_xcvr_7_s0_readdata           : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_xcvr_7_s0_write              : out std_logic;                                        -- write
			reconfig_xcvr_7_s0_writedata          : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_xcvr_7_s0_waitrequest        : in  std_logic                     := 'X';             -- waitrequest
			reconfig_xcvr_7_reset_reset           : out std_logic;                                        -- reset
			reconfig_pdp_7_s0_address             : out std_logic_vector(20 downto 0);                    -- address
			reconfig_pdp_7_s0_byteenable          : out std_logic_vector(3 downto 0);                     -- byteenable
			reconfig_pdp_7_s0_read                : out std_logic;                                        -- read
			reconfig_pdp_7_s0_readdata            : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			reconfig_pdp_7_s0_write               : out std_logic;                                        -- write
			reconfig_pdp_7_s0_writedata           : out std_logic_vector(31 downto 0);                    -- writedata
			reconfig_pdp_7_s0_waitrequest         : in  std_logic                     := 'X';             -- waitrequest
			reconfig_pdp_7_reset_reset            : out std_logic;                                        -- reset
			phy_reg_set_control_reg_1_export      : out std_logic_vector(15 downto 0);                    -- export
			phy_reg_set_control2_reg_1_export     : out std_logic_vector(15 downto 0);                    -- export
			phy_reg_set_bitrate_1_export          : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			phy_reg_set_rxclock_1_export          : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			phy_reg_set_counter_1ms_reg_1_export  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_channel_0_export              : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			reg_set_error_count_h_0_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_error_count_l_0_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_prbslock_alarm_count_0_export : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_channel_1_export              : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			reg_set_error_count_h_1_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_error_count_l_1_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_prbslock_alarm_count_1_export : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_channel_2_export              : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			reg_set_error_count_h_2_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_error_count_l_2_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_prbslock_alarm_count_2_export : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_channel_3_export              : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			reg_set_error_count_h_3_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_error_count_l_3_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_prbslock_alarm_count_3_export : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_channel_4_export              : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			reg_set_error_count_h_4_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_error_count_l_4_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_prbslock_alarm_count_4_export : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_channel_5_export              : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			reg_set_error_count_h_5_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_error_count_l_5_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_prbslock_alarm_count_5_export : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_channel_6_export              : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			reg_set_error_count_h_6_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_error_count_l_6_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_prbslock_alarm_count_6_export : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_channel_7_export              : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			reg_set_error_count_h_7_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_error_count_l_7_export        : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg_set_prbslock_alarm_count_7_export : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reset_in_n_reset_n                    : in  std_logic                     := 'X';             -- reset_n
			version_export                        : in  std_logic_vector(31 downto 0) := (others => 'X')  -- export
		);
	end component controller;















	component clock_configuration is
		port (
			clkout : out std_logic   -- clk
		);
	end component clock_configuration;

	component clock_divider is
		port (
			inclk       : in  std_logic := 'X'; -- inclk
			clock_div1x : out std_logic;        -- clock_div1x
			clock_div2x : out std_logic         -- clock_div2x
		);
	end component clock_divider;

--// Generated by one of Gregg's toys.   Share And Enjoy.
--// Executable compiled Jan  5 2017 08:02:14
--// This file was generated 06/15/2017 10:39:14
--
--// "Wabbit" series 32 bit pseudo random number generator.
--// combine the essence of our nation	
--  wab_america_west_55 should produce around 80K ALMs
	


component wab_america_west_1f is
		port (
			clk               : in  std_logic;    
			sclr        		: in  std_logic;   
			debug_mute			: in std_logic_vector(8 downto 0);         
			din         		: in std_logic;                                        -- ready
			dout		         : out  std_logic_vector(31 downto 0)
		);
end component ;

	component iopll_core_noise is
		port (
			rst      : in  std_logic := 'X'; -- reset
			refclk   : in  std_logic := 'X'; -- clk
			locked   : out std_logic;        -- export
			outclk_0 : out std_logic         -- clk
		);
	end component iopll_core_noise;
	
	
component prbsgenerate_10bit is
PORT(
	coreclk  	: in std_logic;
	Reset	 	: in std_logic;
	Prbsout 	: out std_logic_vector(9 downto 0)
	);
end component ;
	


	component clk_buffer is
		port (
			ena    : in  std_logic := 'X'; -- ena
			inclk  : in  std_logic := 'X'; -- inclk
			outclk : out std_logic         -- outclk
		);
	end component clk_buffer;
	
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

component synchronizer is
GENERIC
	(
		BUS_WIDTH	: integer := 32  	
);
port
	(
		clk		 	: IN STD_LOGIC ;
		data_in	 	: IN STD_LOGIC_VECTOR((BUS_WIDTH - 1) DOWNTO 0);
		data_out	 	: OUT STD_LOGIC_VECTOR((BUS_WIDTH - 1) DOWNTO 0)
	);
end component;

	
CONSTANT CLK125M				: std_logic_vector(19 downto 0) := X"1E848" ; --
CONSTANT SAMPLES_125MHZ		: std_logic_vector(31 downto 0) :=	X"07735940"; -- (125 Mhz clock is 125E6 samples in one second)
CONSTANT CLK100M				: std_logic_vector(19 downto 0) := X"186A0" ; --
CONSTANT SAMPLES_100MHZ		: std_logic_vector(31 downto 0) :=	X"05F5E100"; -- (100 Mhz clock is 100E6 samples in one second)
	

type 	Bit32_ArrayType	is array (0 to (NUMBER_OF_PHYS - 1)) of std_logic_vector (31 downto 0);
type 	Bit32_ArrayType_wab	is array (0 to (NUMBER_OF_WABS - 1)) of std_logic_vector (31 downto 0);
type 	Bit10_ArrayType_wab	is array (0 to (NUMBER_OF_WABS - 1)) of std_logic_vector (9 downto 0);
type 	Bit4_ArrayType	is array (0 to (NUMBER_OF_PHYS - 1)) of std_logic_vector (3 downto 0);
type 	Bit16_ArrayType	is array (0 to (NUMBER_OF_PHYS - 1)) of std_logic_vector (15 downto 0);
type 	Bit21_ArrayType	is array (0 to (NUMBER_OF_PHYS - 1)) of std_logic_vector (20 downto 0);
type  BitLane_ArrayType is array (0 to (NUMBER_OF_PHYS - 1)) of std_logic_vector ((NUMBER_OF_LANES - 1) downto 0);
type 	Channel_ArrayType	is array (0 to 15) of std_logic_vector (31 downto 0);



SIGNAL	Bitrate_Reg :  Bit32_ArrayType;


SIGNAL	ClkMgmt :  STD_LOGIC;
SIGNAL	Control_Reg :  Bit16_ArrayType;
SIGNAL	Control2_Reg :  Bit16_ArrayType;
SIGNAL	Counter_1ms_Reg :  Bit32_ArrayType;



type  Channel_Reg_ArrayType is array (0 to (NUMBER_OF_PHYS - 1)) of Register_Array_16bit;
type 	ErrorCount_Reg_ArrayType is array (0 to (NUMBER_OF_PHYS - 1)) of Register_Array_64bit;

type AVMM_Register_Array_4bit 	is array (0 TO (NUMBER_OF_PHYS - 1)) of Register_Array_4bit;
type AVMM_Register_Array_21bit 	is array (0 TO (NUMBER_OF_PHYS - 1)) of Register_Array_21bit;
type AVMM_Register_Array_32bit 	is array (0 TO (NUMBER_OF_PHYS - 1)) of Register_Array_32bit;
type AVMM_Array 				is array (0 TO (NUMBER_OF_PHYS - 1)) of std_logic_vector((NUMBER_OF_COPIES - 1) downto 0); 


SIGNAL 	Channel_Reg : Channel_Reg_ArrayType;
SIGNAL 	ErrorCount_Reg :ErrorCount_Reg_ArrayType;
SIGNAL   PrbsLock_Alarm_Reg : AVMM_Register_Array_32bit;


SIGNAL	reconfig_xcvr_address 		:  AVMM_Register_Array_21bit; 
SIGNAL  reconfig_xcvr_byteenable 	:  AVMM_Register_Array_4bit;
SIGNAL	reconfig_xcvr_read 			:  AVMM_Array; 
SIGNAL	reconfig_xcvr_readdata 		:  AVMM_Register_Array_32bit;
SIGNAL	reconfig_xcvr_reset			:  AVMM_Array; 
SIGNAL	reconfig_xcvr_waitrequest 	:  AVMM_Array; 
SIGNAL	reconfig_xcvr_write 		:  AVMM_Array; 
SIGNAL	reconfig_xcvr_writedata 	:  AVMM_Register_Array_32bit;

SIGNAL	reconfig_pdp_address 		:  AVMM_Register_Array_21bit; 
SIGNAL  reconfig_pdp_byteenable 		:  AVMM_Register_Array_4bit;
SIGNAL	reconfig_pdp_read 			:  AVMM_Array; 
SIGNAL	reconfig_pdp_readdata 		:  AVMM_Register_Array_32bit;
SIGNAL	reconfig_pdp_reset			:  AVMM_Array; 
SIGNAL	reconfig_pdp_waitrequest 	:  AVMM_Array; 
SIGNAL	reconfig_pdp_write 			:  AVMM_Array; 
SIGNAL	reconfig_pdp_writedata 		:  AVMM_Register_Array_32bit;


SIGNAL	RefClock :  STD_LOGIC_VECTOR((NUMBER_OF_PHYS - 1) downto 0);
SIGNAL	RefClock_Rx :  STD_LOGIC_VECTOR((NUMBER_OF_PHYS - 1) downto 0);

SIGNAL	RX :  BitLane_ArrayType;
SIGNAL	RX_n :  BitLane_ArrayType;
SIGNAL	TX :  BitLane_ArrayType;
SIGNAL	TX_n :  BitLane_ArrayType;

SIGNAL   RxClock_Reg :  Bit32_ArrayType;








SIGNAL	oif_scl0_in		: std_logic;
SIGNAL	oif_sda0_in		: std_logic;
SIGNAL	oif_scl0_oe		: std_logic;
SIGNAL	oif_sda0_oe		: std_logic;

SIGNAL 	module_input_reg : std_logic_vector(31 downto 0);
SIGNAL 	module_output_reg : std_logic_vector(31 downto 0);


SIGNAL Clk250Mhz	: std_logic;





SIGNAL	init_done_n      	  : std_logic;

SIGNAL	refclk_fgt_0 				: std_logic;

SIGNAL	systempll_clk				: std_logic;
SIGNAL   out_systempll_synthlock	: std_logic;
-- Noise logic signals

signal enable_noise_chunks : std_logic_vector(31 downto 0);
signal wab_dout  : Bit32_ArrayType_wab;
signal wab_dout_i  : Bit32_ArrayType_wab;
signal prbsout 	: Bit10_ArrayType_wab;

SIGNAL 	clk_core_noise 								: std_logic;
signal 	clk_wab											: std_logic_vector((NUMBER_OF_WABS-1) downto 0);
signal   wab_sclr											: std_logic_vector((NUMBER_OF_WABS-1) downto 0);
signal   wab_sclr_i										: std_logic_vector((NUMBER_OF_WABS-1) downto 0);
signal   reset_in_wab									: std_logic_vector((NUMBER_OF_WABS-1) downto 0);
SIGNAL 	pll_locked_core_noise						: std_logic;
signal 	reset_n											: std_logic;

-- xor function for wab output

 function wab_xor(wab_dout_word:std_logic_vector(31 downto 0)) return std_logic is
	  variable temp:  std_logic := '0';
 begin
			for i in 0 to 31 loop
					 temp:=temp xor wab_dout_word(i);
			end loop;
	 return temp;
 end wab_xor;


		


BEGIN 

-----------------------------------------------------------------------------------------------------------
-- Instantiate reset release IP
-----------------------------------------------------------------------------------------------------------

reset_release_inst : reset_release
		port map (
			ninit_done => init_done_n  
		);

-----------------------------------------------------------------------------------------------------------
-- Instantiate clock configuration IP and clock divider IP to generate 125 Mhz MgmtClk
----------------------------------------------------------------------------------------------------------- 

clock_configuration_inst : clock_configuration
		port map (
			clkout => Clk250Mhz 
		);

clock_divider_inst : clock_divider 
		port map (
			inclk       	=> Clk250Mhz,
			clock_div1x 	=> open,
			clock_div2x 	=> ClkMgmt	
		);
		
-----------------------------------------------------------------------------------------------------------
--	Refclk and syspll instance 
-----------------------------------------------------------------------------------------------------------	

	refclk_inst : refclk
		port map (
			out_systempll_synthlock_0 => out_systempll_synthlock, 
			out_systempll_clk_0       => systempll_clk,      
			out_refclk_fgt_0 				 => refclk_fgt_0, 
			in_refclk_fgt_0  				 => gt_refclk  
		);		
		
-----------------------------------------------------------------------------------------------------------

-- Map board dependent signal onto internal signals.
-----------------------------------------------------------------------------------------------------------

RefClock(0) 		<= refclk_fgt_0;
RefClock(1)			<= refclk_fgt_0;


RX(0) 	<= qsfpdd_rxp(3 downto 0);
RX_n(0) 	<= qsfpdd_rxn(3 downto 0);



qsfpdd_txp(3 downto 0) 	<= TX(0);
qsfpdd_txn(3 downto 0) 	<= TX_n(0);

RX(1)  		<= qsfpdd_rxp(7 downto 4);
RX_n(1)  	<= qsfpdd_rxn(7 downto 4);



qsfpdd_txp(7 downto 4)  <= TX(1);
qsfpdd_txn(7 downto 4) 	<= TX_n(1);	






-----------------------------------------------------------------------------------------------------------
-- Generate Transceiver blocks each consisting of NUMBER_OF_LANES 
-----------------------------------------------------------------------------------------------------------
		
Generate_transceiver_block:
FOR i IN 0 to (NUMBER_OF_PHYS-1) GENERATE





instx : prbstest_rsfec
GENERIC MAP
	(
		NUMBER_OF_LANES			=> NUMBER_OF_LANES,
		NUMBER_OF_COPIES			=> NUMBER_OF_COPIES,
		INVERT_POLARITY_PRBS		=> INVERT_POLARITY_PRBS,
		SIMULATION_MODE			=> false		
	)
PORT MAP(
		 init_done_n			=> init_done_n,
		 RefClock  				=> RefClock(I),
		 ClkMgmt 				=> ClkMgmt,
		 Systempll_clk			=> systempll_clk,
		 XCVR_TX 				=> TX(I),
		 XCVR_TX_n 				=> TX_n(I),		 
		 XCVR_RX 				=> RX(I),
		 XCVR_RX_n 				=> RX_n(I),		 
		 Enable_Core 			=> out_systempll_synthlock,

		 Control_Reg 			=> Control_Reg(I),
		 Control2_Reg 			=> Control2_Reg(I),		 
		 
		 reconfig_xcvr_reset 				=> reconfig_xcvr_reset(I), 
		 reconfig_xcvr_write 				=> reconfig_xcvr_write(I),
		 reconfig_xcvr_read 					=> reconfig_xcvr_read(I),
		 reconfig_xcvr_address 				=> reconfig_xcvr_address(I),
		 reconfig_xcvr_byteenable 			=> reconfig_xcvr_byteenable(I),		 
		 reconfig_xcvr_writedata 			=> reconfig_xcvr_writedata(I),		 
		 reconfig_xcvr_waitrequest 		=> reconfig_xcvr_waitrequest(I),
		 reconfig_xcvr_readdata 			=> reconfig_xcvr_readdata(I),	
		 
		 reconfig_pdp_reset			=> reconfig_pdp_reset(I),
		 reconfig_pdp_write 			=> reconfig_pdp_write(I),
		 reconfig_pdp_read 			=> reconfig_pdp_read(I),
		 reconfig_pdp_address 		=> reconfig_pdp_address(I),
		 reconfig_pdp_byteenable 	=> reconfig_pdp_byteenable(I),			 
		 reconfig_pdp_writedata 	=> reconfig_pdp_writedata(I),		 
		 reconfig_pdp_waitrequest 	=> reconfig_pdp_waitrequest(I),
		 reconfig_pdp_readdata 		=> reconfig_pdp_readdata(I),			 
		 	 

		 
		 Bitrate_Reg 					=> Bitrate_Reg(I),
		 RxClock_Reg 					=> RxClock_Reg(I),
		 Counter_1ms_Reg 				=> Counter_1ms_Reg(I),
		 Channel_Reg 					=> Channel_Reg(I),
		 ErrorCount_Reg 				=> ErrorCount_Reg(I),
		 PrbsLock_Alarm_Reg			=> PrbsLock_Alarm_Reg(I),
		 Led								=> open
		 );

END generate;
		 

		 
reset_n <= not (init_done_n);


inst3 : controller
PORT MAP(
		 reset_in_n_reset_n => reset_n,
		 clk_in_clk => ClkMgmt,		 
		 
			i2c_0_i2c_serial_sda_in            => oif_sda0_in,
			i2c_0_i2c_serial_scl_in            => oif_scl0_in,
			i2c_0_i2c_serial_sda_oe            => oif_sda0_oe,   
			i2c_0_i2c_serial_scl_oe            => oif_scl0_oe, 
--			i2c_1_i2c_serial_sda_in            => oif_sda1_in,
--			i2c_1_i2c_serial_scl_in            => oif_scl1_in,
--			i2c_1_i2c_serial_sda_oe            => oif_sda1_oe,   
--			i2c_1_i2c_serial_scl_oe            => oif_scl1_oe, 			
		  
			module_input_reg_export            => module_input_reg,
			module_output_reg_export           => module_output_reg,		 
		 
		 phy_reg_set_control_reg_0_export 				=> Control_Reg(0),
		 phy_reg_set_control2_reg_0_export				=> Control2_Reg(0),	
		 phy_reg_set_counter_1ms_reg_0_export 			=> Counter_1ms_Reg(0),
		 phy_reg_set_bitrate_0_export 					=> Bitrate_Reg(0),	 
		 phy_reg_set_rxclock_0_export 					=> RxClock_Reg(0),

		 
		 phy_reg_set_control_reg_1_export 				=> Control_Reg(1),
		 phy_reg_set_control2_reg_1_export				=> Control2_Reg(1),	
		 phy_reg_set_counter_1ms_reg_1_export 			=> Counter_1ms_Reg(1),
		 phy_reg_set_bitrate_1_export 					=> Bitrate_Reg(1),	 
		 phy_reg_set_rxclock_1_export 					=> RxClock_Reg(1),
		 	
		 	
		 
		 reg_set_channel_0_export => Channel_Reg(0)(0),
		 reg_set_channel_1_export => Channel_Reg(0)(1),
		 reg_set_channel_2_export => Channel_Reg(0)(2),
		 reg_set_channel_3_export => Channel_Reg(0)(3),

		 reg_set_channel_4_export => Channel_Reg(1)(0),
		 reg_set_channel_5_export => Channel_Reg(1)(1),
		 reg_set_channel_6_export => Channel_Reg(1)(2),
		 reg_set_channel_7_export => Channel_Reg(1)(3),



		 
		 reg_set_error_count_l_0_export => ErrorCount_Reg(0)(0)(31 DOWNTO 0),
		 reg_set_error_count_l_1_export => ErrorCount_Reg(0)(1)(31 DOWNTO 0),
		 reg_set_error_count_l_2_export => ErrorCount_Reg(0)(2)(31 DOWNTO 0),
		 reg_set_error_count_l_3_export => ErrorCount_Reg(0)(3)(31 DOWNTO 0),

		 reg_set_error_count_l_4_export => ErrorCount_Reg(1)(0)(31 DOWNTO 0),
		 reg_set_error_count_l_5_export => ErrorCount_Reg(1)(1)(31 DOWNTO 0),
		 reg_set_error_count_l_6_export => ErrorCount_Reg(1)(2)(31 DOWNTO 0),
		 reg_set_error_count_l_7_export => ErrorCount_Reg(1)(3)(31 DOWNTO 0),


	
	
	 
		 
		 reg_set_error_count_h_0_export => ErrorCount_Reg(0)(0)(63 DOWNTO 32),
		 reg_set_error_count_h_1_export => ErrorCount_Reg(0)(1)(63 DOWNTO 32),
		 reg_set_error_count_h_2_export => ErrorCount_Reg(0)(2)(63 DOWNTO 32),
		 reg_set_error_count_h_3_export => ErrorCount_Reg(0)(3)(63 DOWNTO 32),	


		 reg_set_error_count_h_4_export => ErrorCount_Reg(1)(0)(63 DOWNTO 32),
		 reg_set_error_count_h_5_export => ErrorCount_Reg(1)(1)(63 DOWNTO 32),
		 reg_set_error_count_h_6_export => ErrorCount_Reg(1)(2)(63 DOWNTO 32),
		 reg_set_error_count_h_7_export => ErrorCount_Reg(1)(3)(63 DOWNTO 32),		 

		 reg_set_prbslock_alarm_count_0_export => PrbsLock_Alarm_Reg(0)(0),
		 reg_set_prbslock_alarm_count_1_export => PrbsLock_Alarm_Reg(0)(1),
		 reg_set_prbslock_alarm_count_2_export => PrbsLock_Alarm_Reg(0)(2),
		 reg_set_prbslock_alarm_count_3_export => PrbsLock_Alarm_Reg(0)(3),

		 reg_set_prbslock_alarm_count_4_export => PrbsLock_Alarm_Reg(1)(0),
		 reg_set_prbslock_alarm_count_5_export => PrbsLock_Alarm_Reg(1)(1),
		 reg_set_prbslock_alarm_count_6_export => PrbsLock_Alarm_Reg(1)(2),
		 reg_set_prbslock_alarm_count_7_export => PrbsLock_Alarm_Reg(1)(3),		 
		 
		 		 

		 reconfig_xcvr_0_reset_reset		=> reconfig_xcvr_reset(0)(0),		 
		 reconfig_xcvr_0_s0_address		=> reconfig_xcvr_address(0)(0),
		 reconfig_xcvr_0_s0_byteenable	=> reconfig_xcvr_byteenable(0)(0), 
		 reconfig_xcvr_0_s0_read 			=> reconfig_xcvr_read(0)(0),
		 reconfig_xcvr_0_s0_readdata 		=> reconfig_xcvr_readdata(0)(0),
		 reconfig_xcvr_0_s0_write 			=> reconfig_xcvr_write(0)(0),
		 reconfig_xcvr_0_s0_writedata 	=> reconfig_xcvr_writedata(0)(0),		 
		 reconfig_xcvr_0_s0_waitrequest 	=> reconfig_xcvr_waitrequest(0)(0),	
		 
		 reconfig_xcvr_1_reset_reset 		=> reconfig_xcvr_reset(0)(1),		 
		 reconfig_xcvr_1_s0_address 		=> reconfig_xcvr_address(0)(1),
		 reconfig_xcvr_1_s0_byteenable	=> reconfig_xcvr_byteenable(0)(1), 		 
		 reconfig_xcvr_1_s0_read 			=> reconfig_xcvr_read(0)(1),
		 reconfig_xcvr_1_s0_readdata 		=> reconfig_xcvr_readdata(0)(1),
		 reconfig_xcvr_1_s0_write 			=> reconfig_xcvr_write(0)(1),
		 reconfig_xcvr_1_s0_writedata 	=> reconfig_xcvr_writedata(0)(1),		 
		 reconfig_xcvr_1_s0_waitrequest 	=> reconfig_xcvr_waitrequest(0)(1),
		 
		 reconfig_xcvr_2_reset_reset 		=> reconfig_xcvr_reset(0)(2),		 
		 reconfig_xcvr_2_s0_address 		=> reconfig_xcvr_address(0)(2),
		 reconfig_xcvr_2_s0_byteenable	=> reconfig_xcvr_byteenable(0)(2), 		 
		 reconfig_xcvr_2_s0_read 			=> reconfig_xcvr_read(0)(2),
		 reconfig_xcvr_2_s0_readdata 		=> reconfig_xcvr_readdata(0)(2),
		 reconfig_xcvr_2_s0_write 			=> reconfig_xcvr_write(0)(2),
		 reconfig_xcvr_2_s0_writedata 	=> reconfig_xcvr_writedata(0)(2),		 
		 reconfig_xcvr_2_s0_waitrequest 	=> reconfig_xcvr_waitrequest(0)(2),		 

		 reconfig_xcvr_3_reset_reset 		=> reconfig_xcvr_reset(0)(3),		 
		 reconfig_xcvr_3_s0_address 		=> reconfig_xcvr_address(0)(3),
		 reconfig_xcvr_3_s0_byteenable	=> reconfig_xcvr_byteenable(0)(3), 		 
		 reconfig_xcvr_3_s0_read 			=> reconfig_xcvr_read(0)(3),
		 reconfig_xcvr_3_s0_readdata 		=> reconfig_xcvr_readdata(0)(3),
		 reconfig_xcvr_3_s0_write 			=> reconfig_xcvr_write(0)(3),
		 reconfig_xcvr_3_s0_writedata 	=> reconfig_xcvr_writedata(0)(3),		 
		 reconfig_xcvr_3_s0_waitrequest 	=> reconfig_xcvr_waitrequest(0)(3),

		 reconfig_xcvr_4_reset_reset 		=> reconfig_xcvr_reset(1)(0),		 
		 reconfig_xcvr_4_s0_address 		=> reconfig_xcvr_address(1)(0),
		 reconfig_xcvr_4_s0_byteenable	=> reconfig_xcvr_byteenable(1)(0), 		 
		 reconfig_xcvr_4_s0_read 			=> reconfig_xcvr_read(1)(0),
		 reconfig_xcvr_4_s0_readdata 		=> reconfig_xcvr_readdata(1)(0),
		 reconfig_xcvr_4_s0_write 			=> reconfig_xcvr_write(1)(0),
		 reconfig_xcvr_4_s0_writedata 	=> reconfig_xcvr_writedata(1)(0),		 
		 reconfig_xcvr_4_s0_waitrequest 	=> reconfig_xcvr_waitrequest(1)(0),

		 reconfig_xcvr_5_reset_reset 		=> reconfig_xcvr_reset(1)(1),		 
		 reconfig_xcvr_5_s0_address 		=> reconfig_xcvr_address(1)(1),
		 reconfig_xcvr_5_s0_byteenable	=> reconfig_xcvr_byteenable(1)(1), 		 
		 reconfig_xcvr_5_s0_read 			=> reconfig_xcvr_read(1)(1),
		 reconfig_xcvr_5_s0_readdata 		=> reconfig_xcvr_readdata(1)(1),
		 reconfig_xcvr_5_s0_write 			=> reconfig_xcvr_write(1)(1),
		 reconfig_xcvr_5_s0_writedata 	=> reconfig_xcvr_writedata(1)(1),		 
		 reconfig_xcvr_5_s0_waitrequest 	=> reconfig_xcvr_waitrequest(1)(1),

		 reconfig_xcvr_6_reset_reset 		=> reconfig_xcvr_reset(1)(2),		 
		 reconfig_xcvr_6_s0_address 		=> reconfig_xcvr_address(1)(2),
		 reconfig_xcvr_6_s0_byteenable	=> reconfig_xcvr_byteenable(1)(2), 		 
		 reconfig_xcvr_6_s0_read 			=> reconfig_xcvr_read(1)(2),
		 reconfig_xcvr_6_s0_readdata 		=> reconfig_xcvr_readdata(1)(2),
		 reconfig_xcvr_6_s0_write 			=> reconfig_xcvr_write(1)(2),
		 reconfig_xcvr_6_s0_writedata 	=> reconfig_xcvr_writedata(1)(2),		 
		 reconfig_xcvr_6_s0_waitrequest 	=> reconfig_xcvr_waitrequest(1)(2),
		 
		 reconfig_xcvr_7_reset_reset 		=> reconfig_xcvr_reset(1)(3),		 
		 reconfig_xcvr_7_s0_address 		=> reconfig_xcvr_address(1)(3),
		 reconfig_xcvr_7_s0_byteenable	=> reconfig_xcvr_byteenable(1)(3), 		 
		 reconfig_xcvr_7_s0_read 			=> reconfig_xcvr_read(1)(3),
		 reconfig_xcvr_7_s0_readdata 		=> reconfig_xcvr_readdata(1)(3),
		 reconfig_xcvr_7_s0_write 			=> reconfig_xcvr_write(1)(3),
		 reconfig_xcvr_7_s0_writedata 	=> reconfig_xcvr_writedata(1)(3),		 
		 reconfig_xcvr_7_s0_waitrequest 	=> reconfig_xcvr_waitrequest(1)(3),		 
		 
		 
		 reconfig_pdp_0_reset_reset		=> reconfig_pdp_reset(0)(0),		 
		 reconfig_pdp_0_s0_address		=> reconfig_pdp_address(0)(0),
		 reconfig_pdp_0_s0_byteenable	=> reconfig_pdp_byteenable(0)(0), 
		 reconfig_pdp_0_s0_read 			=> reconfig_pdp_read(0)(0),
		 reconfig_pdp_0_s0_readdata 		=> reconfig_pdp_readdata(0)(0),
		 reconfig_pdp_0_s0_write 			=> reconfig_pdp_write(0)(0),
		 reconfig_pdp_0_s0_writedata 	=> reconfig_pdp_writedata(0)(0),		 
		 reconfig_pdp_0_s0_waitrequest 	=> reconfig_pdp_waitrequest(0)(0),	
		 
		 reconfig_pdp_1_reset_reset 		=> reconfig_pdp_reset(0)(1),		 
		 reconfig_pdp_1_s0_address 		=> reconfig_pdp_address(0)(1),
		 reconfig_pdp_1_s0_byteenable	=> reconfig_pdp_byteenable(0)(1), 		 
		 reconfig_pdp_1_s0_read 			=> reconfig_pdp_read(0)(1),
		 reconfig_pdp_1_s0_readdata 		=> reconfig_pdp_readdata(0)(1),
		 reconfig_pdp_1_s0_write 			=> reconfig_pdp_write(0)(1),
		 reconfig_pdp_1_s0_writedata 	=> reconfig_pdp_writedata(0)(1),		 
		 reconfig_pdp_1_s0_waitrequest 	=> reconfig_pdp_waitrequest(0)(1),
		 
		 reconfig_pdp_2_reset_reset 		=> reconfig_pdp_reset(0)(2),		 
		 reconfig_pdp_2_s0_address 		=> reconfig_pdp_address(0)(2),
		 reconfig_pdp_2_s0_byteenable	=> reconfig_pdp_byteenable(0)(2), 		 
		 reconfig_pdp_2_s0_read 			=> reconfig_pdp_read(0)(2),
		 reconfig_pdp_2_s0_readdata 		=> reconfig_pdp_readdata(0)(2),
		 reconfig_pdp_2_s0_write 			=> reconfig_pdp_write(0)(2),
		 reconfig_pdp_2_s0_writedata 	=> reconfig_pdp_writedata(0)(2),		 
		 reconfig_pdp_2_s0_waitrequest 	=> reconfig_pdp_waitrequest(0)(2),		 

		 reconfig_pdp_3_reset_reset 		=> reconfig_pdp_reset(0)(3),		 
		 reconfig_pdp_3_s0_address 		=> reconfig_pdp_address(0)(3),
		 reconfig_pdp_3_s0_byteenable	=> reconfig_pdp_byteenable(0)(3), 		 
		 reconfig_pdp_3_s0_read 			=> reconfig_pdp_read(0)(3),
		 reconfig_pdp_3_s0_readdata 		=> reconfig_pdp_readdata(0)(3),
		 reconfig_pdp_3_s0_write 			=> reconfig_pdp_write(0)(3),
		 reconfig_pdp_3_s0_writedata 	=> reconfig_pdp_writedata(0)(3),		 
		 reconfig_pdp_3_s0_waitrequest 	=> reconfig_pdp_waitrequest(0)(3),

		 reconfig_pdp_4_reset_reset 		=> reconfig_pdp_reset(1)(0),		 
		 reconfig_pdp_4_s0_address 		=> reconfig_pdp_address(1)(0),
		 reconfig_pdp_4_s0_byteenable	=> reconfig_pdp_byteenable(1)(0), 		 
		 reconfig_pdp_4_s0_read 			=> reconfig_pdp_read(1)(0),
		 reconfig_pdp_4_s0_readdata 		=> reconfig_pdp_readdata(1)(0),
		 reconfig_pdp_4_s0_write 			=> reconfig_pdp_write(1)(0),
		 reconfig_pdp_4_s0_writedata 	=> reconfig_pdp_writedata(1)(0),		 
		 reconfig_pdp_4_s0_waitrequest 	=> reconfig_pdp_waitrequest(1)(0),

		 reconfig_pdp_5_reset_reset 		=> reconfig_pdp_reset(1)(1),		 
		 reconfig_pdp_5_s0_address 		=> reconfig_pdp_address(1)(1),
		 reconfig_pdp_5_s0_byteenable	=> reconfig_pdp_byteenable(1)(1), 		 
		 reconfig_pdp_5_s0_read 			=> reconfig_pdp_read(1)(1),
		 reconfig_pdp_5_s0_readdata 		=> reconfig_pdp_readdata(1)(1),
		 reconfig_pdp_5_s0_write 			=> reconfig_pdp_write(1)(1),
		 reconfig_pdp_5_s0_writedata 	=> reconfig_pdp_writedata(1)(1),		 
		 reconfig_pdp_5_s0_waitrequest 	=> reconfig_pdp_waitrequest(1)(1),

		 reconfig_pdp_6_reset_reset 		=> reconfig_pdp_reset(1)(2),		 
		 reconfig_pdp_6_s0_address 		=> reconfig_pdp_address(1)(2),
		 reconfig_pdp_6_s0_byteenable	=> reconfig_pdp_byteenable(1)(2), 		 
		 reconfig_pdp_6_s0_read 			=> reconfig_pdp_read(1)(2),
		 reconfig_pdp_6_s0_readdata 		=> reconfig_pdp_readdata(1)(2),
		 reconfig_pdp_6_s0_write 			=> reconfig_pdp_write(1)(2),
		 reconfig_pdp_6_s0_writedata 	=> reconfig_pdp_writedata(1)(2),		 
		 reconfig_pdp_6_s0_waitrequest 	=> reconfig_pdp_waitrequest(1)(2),
		 
		 reconfig_pdp_7_reset_reset 		=> reconfig_pdp_reset(1)(3),		 
		 reconfig_pdp_7_s0_address 		=> reconfig_pdp_address(1)(3),
		 reconfig_pdp_7_s0_byteenable	=> reconfig_pdp_byteenable(1)(3), 		 
		 reconfig_pdp_7_s0_read 			=> reconfig_pdp_read(1)(3),
		 reconfig_pdp_7_s0_readdata 		=> reconfig_pdp_readdata(1)(3),
		 reconfig_pdp_7_s0_write 			=> reconfig_pdp_write(1)(3),
		 reconfig_pdp_7_s0_writedata 	=> reconfig_pdp_writedata(1)(3),		 
		 reconfig_pdp_7_s0_waitrequest 	=> reconfig_pdp_waitrequest(1)(3),		
		 

		 internal_noise_control_export  => enable_noise_chunks,
		 
		 version_export							=> VERSION
			
	 	 
		 );

----------------------------------------------------------------------------------------
-- Instantiate Noise logic
----------------------------------------------------------------------------------------


Generate_noise_logic:
if GENERATE_INTERNAL_NOISE generate


iopll_core_noise_inst: iopll_core_noise -- 414.0625 Mhz
		port map (
			rst      	=> init_done_n,      
			refclk 		=> clk_sys_100m,
			locked   	=> pll_locked_core_noise,  
			outclk_0 	=> clk_core_noise  
		);
		
		

	generate_wabs:
	FOR i IN 0 to NUMBER_OF_WABS-1 GENERATE
	
	-- Add Stratix 10 clock control to enable or switch off a clock completely.
	-- Use root level clk_buffer instead of sector level.
	
	clk_buffer_inst : clk_buffer
		port map (
			ena    => enable_noise_chunks(i),
			inclk  => clk_core_noise,
			outclk => clk_wab(i)
		);
		
	reset_in_wab(i) <= not(enable_noise_chunks(i));
		
	reset_synchro_inst : reset_synchro
		port map (
			clk			=> clk_wab(i),
			reset_in		=> reset_in_wab(i) ,
			reset_out	=> wab_sclr_i(i)
			);
			
	synchro_sclr : synchro
		port map(
			clk => clk_wab(i),
			data_in => wab_sclr_i(i),
			data_out => wab_sclr(i)
		);
		
	prbsgenerate_10bit_inst: prbsgenerate_10bit
	port map (
		coreclk  	=> clk_wab(i),
		Reset	 		=> wab_sclr(i),
		Prbsout 		=> prbsout(i)
		);

		
	
	wab_america_west_1f_inst : wab_america_west_1f
		port map (
			clk               => clk_wab(i),
			debug_mute			=> (OTHERS => '0'),
			sclr					=> wab_sclr(i),
			din					=> prbsout(i)(i),
			dout					=> wab_dout_i(i)
		);
		
	synchro_dout : synchronizer		
		port map(
			clk => clk_wab(i),
			data_in => wab_dout_i(i),
			data_out => wab_dout(i)
		);
		
		
	--noise_out(i) <= wab_xor(wab_dout(i));
	
	end generate generate_wabs;
				  
end generate Generate_noise_logic;

Generate_no_noise_logic:
if not(GENERATE_INTERNAL_NOISE) generate
	--noise_out 										<= (OTHERS => '0');
	pll_locked_core_noise						<= '0';
end generate Generate_no_noise_logic;

-- On this board the control signals are controlled by external component (PCA9534PW) connected through I2C
-- not through FPGA.		


-- From QSFP28 point of view (as a reference)

-- modselL :(LVTTL-I signal) is an input pin. When held low by the host, the module responds to 2-wire serial communication commands, otherwise it does not. The ModSelL signal has weak pull-up on module connected to Vcc.
-- ResetL  :(LVTTL-I signal) is an input pin A low level on the ResetL pin for longer than the minimum pulse length (t_Reset_init > 2s) initiates a complete module reset and returns all user module settings to their default state.
-- LPMode  :(LVTTL-I signal) is an input signal. When LPMode is set <Low>, the module will boot into its standard default state. When LPMode is set <High>, the module will boot into ?low power mode? and only the management interface is active (high-speed TX and RX are shut down). The LPMode signal has a weak pull-up on the module connected to Vcc.
-- ModPrsL :(LVTTL-O signal) is pulled up to Vcc on the host board and grounded in the module. The ModPrsL pin is asserted <Low> when inserted and de-asserted <High> when the module is physically absent from the host connector
-- IntL 	  :(LVTTL-O signal) is an output signal. When IntL is asserted <Low>, it indicates a possible module operational fault, LOS condition or a status critical to the host system. The host identifies the source of the interrupt using the 2-wire serial interface.

----------------------------------------------------------------------------------------
-- Bank 12A QSFPDD0 and QSFPD1 Static control
----------------------------------------------------------------------------------------
		module_input_reg(11 downto 0) <= (OTHERS => '0');
		
--    qsfpdd0_modsel_L     <= module_output_reg(12); 
--    qsfpdd0_reset_L      <= module_output_reg(13);
--    qsfpdd0_Initmode     <= module_output_reg(14);
      
      
--    module_input_reg(12) <= qsfpdd0_modprs_L; 
--    module_input_reg(13) <= qsfpdd0_int_L;
      
      module_input_reg(12) <= '0'; 
      module_input_reg(13) <= '0';
      
      
--    qsfpdd1_modsel_L     <= module_output_reg(16); 
--    qsfpdd1_reset_L      <= module_output_reg(17);
--    qsfpdd1_Initmode     <= module_output_reg(18);

		module_input_reg(15 downto 14) <= (OTHERS => '0');
      
--    module_input_reg(16) <= qsfpdd1_modprs_L; 
--    module_input_reg(17) <= qsfpdd1_int_L;
      
      module_input_reg(16) <= '0';  
      module_input_reg(17) <= '0';     
 
		module_input_reg(30 downto 18) <= (OTHERS => '0'); 
	
		module_input_reg(31) <= '1' when GENERATE_INTERNAL_NOISE else '0';	
		
----------------------------------------------------------------------------------------		
-- I2C Interfaces
----------------------------------------------------------------------------------------	

oif_scl0_in <= qsfpdd_fpga_i2c_scl;
oif_sda0_in <= qsfpdd_fpga_i2c_sda;

qsfpdd_fpga_i2c_scl	<= '0' when oif_scl0_oe = '1' else 'Z';
qsfpdd_fpga_i2c_sda 	<= '0' when oif_sda0_oe = '1' else 'Z';






END devkit_demo_rtl;