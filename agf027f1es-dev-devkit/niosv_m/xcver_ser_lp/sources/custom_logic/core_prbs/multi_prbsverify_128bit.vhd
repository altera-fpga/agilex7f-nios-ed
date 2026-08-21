------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2018-2022 Intel Corporation
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

entity multi_prbsverify_128bit is
GENERIC
	(
		USE_ADDER_HW					:  boolean := true
	);
PORT(
	Clock  				: in std_logic;
	Enable			: in std_logic;
	Reset	 			: in std_logic;
	Reset_PrbsLockAlarm : in std_logic;
	ResetErrorCount 	: in std_logic;
	PrbsSelect			: in std_logic_vector(1 downto 0);
	DataIn 				: in std_logic_vector(127 downto 0);
	PrbsLocked			: out std_logic;
	Errorcount_Q 		: out std_logic_vector(63 downto 0);
	PrbsLock_Alarm_Count : out std_logic_vector(31 downto 0)
	);
END multi_prbsverify_128bit;		

architecture rtl of multi_prbsverify_128bit is



	component adder_hw is
		port (
		result      : out std_logic_vector(63 downto 0);                    -- result
			dataa_0     : in  std_logic_vector(26 downto 0) := (others => 'X'); -- dataa_0
			datab_0     : in  std_logic_vector(26 downto 0) := (others => 'X'); -- datab_0
		clock0      : in  std_logic                     := 'X';             -- clk
		ena0        : in  std_logic                     := 'X';             -- ena0
		aclr0       : in  std_logic                     := 'X';             -- reset
		accum_sload : in  std_logic                     := 'X'              -- accum_sload
		);
	end component adder_hw;
	
type   Array_16x8bit	 is array (0 to 15) of std_logic_vector(7 downto 0);
type   Array_4x8bit	 is array (0 to 3) of std_logic_vector(7 downto 0);
	
signal next_prbs					: std_logic_vector(127 downto 0);
signal next_prbs_pipe			: std_logic_vector(127 downto 0);
signal next_prbs_7				: std_logic_vector(127 downto 0);
signal next_prbs_13				: std_logic_vector(127 downto 0);
signal next_prbs_23				: std_logic_vector(127 downto 0);
signal next_prbs_31				: std_logic_vector(127 downto 0);

signal prbs2					: std_logic_vector(127 downto 0);
signal prbs2_7, prbs2_23, prbs2_31, prbs2_13					: std_logic_vector(127 downto 0);
signal rcv_data 				: std_logic_vector(127 downto 0);

signal count 					: unsigned(7 downto 0);
signal count_no_match 			: unsigned(7 downto 0);

signal lock						: std_logic;
signal no_match					: std_logic;
signal no_match_W	            : std_logic_vector(7 downto 0);
signal no_match_Z               : std_logic_vector(7 downto 0);

signal no_match_zero                : std_logic;
signal detect_selectchannel 	: std_logic;

signal LSBRcvData 				: std_logic_vector(127 downto 0);
signal LSBRcvData_pipe 			: std_logic_vector(127 downto 0);
signal LSBRcvData_pipe_min1 	: std_logic_vector(127 downto 0);

signal ErrorCount_adder_hw		: std_logic_vector(63 downto 0) := (OTHERS=> '0');
signal ErrorCount_sim			: std_logic_vector(63 downto 0) := (OTHERS=> '0');
signal ErrorCount_pipe			: std_logic_vector(63 downto 0);
signal Difference_tot         : std_logic_vector(7 downto 0);
signal Difference					: Array_16x8bit;
signal Difference_min         : Array_4x8bit;
signal Difference_pipe			: std_logic_vector(7 downto 0);
signal Difference_adder			: std_logic_vector(7 downto 0);
signal Resetadder					: std_logic;
signal Difference_adder_27b 	: std_logic_vector(26 downto 0); 


signal const_one : std_logic_vector(26 downto 0); 
attribute keep : boolean; 
attribute keep of const_one : signal is true; 
signal PrbsSelect_s1, PrbsSelect_s2, PrbsSelect_s3 : std_logic_vector(1 downto 0); 
signal Reset_dupA1, Reset_dupA2,  Reset_dupB1, Reset_dupB2	 			:  std_logic :='0';
attribute preserve_syn_only : boolean;
attribute preserve_syn_only of Reset_dupA1 : signal is true;
attribute preserve_syn_only of Reset_dupB1 : signal is true;

signal CheckZeroes				: std_logic_vector(127 downto 0);
signal count_prbslock_alarm  : std_logic_vector(15 downto 0);
--signal count_bitslip_check   : std_logic_vector(7 downto 0);
signal bitslip_counter			: std_logic_vector(15 downto 0);
signal lock_q						: std_logic;

--type   Check_State_type	 is (Check_State_Reset,Idle,Counting,Check_Lock);
--signal Check_State	: Check_State_type;
--signal start_counter_check_bitslip : std_logic;
signal bitslip_1								: std_logic;
signal bitslip_2								: std_logic;
signal bitslip									: std_logic;
signal bitslip_q								: std_logic;


begin


	process(Clock)
	begin
		if rising_edge(Clock) then	
				Reset_dupA1 <= Reset;
				Reset_dupA2 <= Reset_dupA1;
				Reset_dupB1 <= Reset;
				Reset_dupB2 <= Reset_dupB1;
			if (Reset_dupA2 = '1') then
				--prbs2 <= (OTHERS => '0');
				prbs2_13 <= (OTHERS => '0');
				prbs2_7 <= (OTHERS => '0');
				prbs2_23 <= (OTHERS => '0');
				prbs2_31 <= (OTHERS => '0');
				--prbs2_9 <= (OTHERS => '0');
				--rcv_data <= (OTHERS => '0');
				LSBRcvData 	<= (OTHERS => '0');
				PrbsSelect_s1 <= (OTHERS => '0'); 
				PrbsSelect_s2 <= (OTHERS => '0'); 
				PrbsSelect_s3 <= (OTHERS => '0'); 
			else
				PrbsSelect_s1 <= PrbsSelect; 
				PrbsSelect_s2 <= PrbsSelect_s1; 
				PrbsSelect_s3 <= PrbsSelect_s2;	

			if Enable = '1' then
				SwapMSB_With_LSB:
				FOR i IN 0 to 127 LOOP
					rcv_data(i) <= DataIn(127-i);
				END LOOP SwapMSB_With_LSB;		

	
					LSBRcvData_pipe_min1 	<= rcv_data;		-- reclock the data
					LSBRcvData		 			<= LSBRcvData_pipe_min1;	-- Retimer since next_prbs is also being retimed.		
		
				if lock = '1' then
                    --prbs2 <= next_prbs;
							prbs2_7 <= next_prbs_7;
							prbs2_13 <= next_prbs_13;
							prbs2_23 <= next_prbs_23;
							prbs2_31 <= next_prbs_31;
							--prbs2_9 <= next_prbs_9;
				else
                   -- prbs2 <= LSBRcvData;
							prbs2_7 <= LSBRcvData_pipe_min1;
							prbs2_13 <= LSBRcvData_pipe_min1;
							prbs2_23 <= LSBRcvData_pipe_min1;
							prbs2_31 <= LSBRcvData_pipe_min1;
							--prbs2_9 <= LSBRcvData_pipe_min1;
                end if;
				end if;
		end if;
		end if;
	end process;

				 


   process(Clock)
	begin
		if rising_edge(Clock) then
			if (Reset_dupA2 = '1') then
				lock <= '0';
				no_match <= '1';
				FOR J in 0 to 7	Loop		
					no_match_W(J) <= '1';
					no_match_Z(J) <= '1';					
				end loop;
                no_match_zero <= '1';

				count <= (OTHERS => '0');
				count_no_match <=(Others => '0');
				
				
        else
		
				if Enable = '1' then
				if no_match = '1' then
					count <= (Others => '0');
					count_no_match <= count_no_match + 1;
				else
					count <= count + 1;
					count_no_match <=(Others => '0');
				end if;
				if count(7) = '1' and count_no_match(0) = '0' then -- Receive 128 consecutive words without any errors before declaring lock
					lock <= '1';
					assert(lock = '1')
					report "==========================================================================================================> PrbsLock achieved ..." 		severity note;
				elsif count(0) = '0' and count_no_match(7) = '1' then -- Receive 128 consecutive words not correct before declaring loss
					lock <= '0';
					else
						lock <= lock;
				end if;



					next_prbs <= next_prbs_pipe; -- Retime next_prbs for performance

					FOR J in 0 to 7	Loop			
			           if ( next_prbs((15 + (16*J)) downto (16*J)) /= LSBRcvData((15 + (16*J)) downto (16*J)) )  then
                        no_match_W(J) <= '1';
                    else
                        no_match_W(J) <= '0';
                    end if;
					end loop;



                    -- check for zeroes

					FOR J in 0 to 7	Loop			
			           if ( LSBRcvData((15 + (16*J)) downto (16*J)) = X"0000")  then
                        no_match_Z(J) <= '1';
                    else
                        no_match_Z(J) <= '0';
                    end if;
					end loop;





					if (no_match_Z(0) = '1') and ( no_match_Z(1) = '1') and ( no_match_Z(2) = '1') and ( no_match_Z(3) = '1') and (no_match_Z(4) = '1') and ( no_match_Z(5) = '1') and ( no_match_Z(6) = '1') and ( no_match_Z(7) = '1') then
                        no_match_zero <= '1';
                    else
                        no_match_zero <= '0';
                    end if;


					if (no_match_W(0) = '1') or ( no_match_W(1) = '1') or ( no_match_W(2) = '1') or ( no_match_W(3) = '1') or (no_match_W(4) = '1') or ( no_match_W(5) = '1') or ( no_match_W(6) = '1') or ( no_match_W(7) = '1') or (no_match_zero = '1') then
                        no_match <= '1';        -- One pipeline stage for performance
					if lock = '1' then
						report "==========================================================================================================> Found a data mis-match in last received word " severity note;
					end if;
				else
					no_match <= '0';
				end if;	
		end if;
   end if;
		end if;
	end process;

-- PRBS 2^7-1 (parallel 128bit serializer) (T[7,6]
next_prbs_7(0) <= prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(1) <= prbs2_7(0);
next_prbs_7(2) <= prbs2_7(1);
next_prbs_7(3) <= prbs2_7(2);
next_prbs_7(4) <= prbs2_7(3);
next_prbs_7(5) <= prbs2_7(4);
next_prbs_7(6) <= prbs2_7(5);
next_prbs_7(7) <= prbs2_7(6);
next_prbs_7(8) <= prbs2_7(0) XOR prbs2_7(6);
next_prbs_7(9) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(6);
next_prbs_7(10) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(6);
next_prbs_7(11) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(6);
next_prbs_7(12) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(13) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(14) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(15) <= prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(16) <= prbs2_7(0) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(17) <= prbs2_7(1) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(18) <= prbs2_7(0) XOR prbs2_7(2) XOR prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(19) <= prbs2_7(1) XOR prbs2_7(3) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(20) <= prbs2_7(0) XOR prbs2_7(2) XOR prbs2_7(4);
next_prbs_7(21) <= prbs2_7(1) XOR prbs2_7(3) XOR prbs2_7(5);
next_prbs_7(22) <= prbs2_7(2) XOR prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(23) <= prbs2_7(0) XOR prbs2_7(3) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(24) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(4);
next_prbs_7(25) <= prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(5);
next_prbs_7(26) <= prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(6);
next_prbs_7(27) <= prbs2_7(0) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(28) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(29) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(5);
next_prbs_7(30) <= prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(6);
next_prbs_7(31) <= prbs2_7(0) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(32) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(33) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(34) <= prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(35) <= prbs2_7(0) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4);
next_prbs_7(36) <= prbs2_7(1) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(37) <= prbs2_7(2) XOR prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(38) <= prbs2_7(0) XOR prbs2_7(3) XOR prbs2_7(5);
next_prbs_7(39) <= prbs2_7(1) XOR prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(40) <= prbs2_7(0) XOR prbs2_7(2) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(41) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(3);
next_prbs_7(42) <= prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(4);
next_prbs_7(43) <= prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(5);
next_prbs_7(44) <= prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(45) <= prbs2_7(0) XOR prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(46) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(5);
next_prbs_7(47) <= prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(6);
next_prbs_7(48) <= prbs2_7(0) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(6);
next_prbs_7(49) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(50) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(51) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(5);
next_prbs_7(52) <= prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(53) <= prbs2_7(0) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(54) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(55) <= prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(56) <= prbs2_7(0) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(5);
next_prbs_7(57) <= prbs2_7(1) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(58) <= prbs2_7(0) XOR prbs2_7(2) XOR prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(59) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(3) XOR prbs2_7(5);
next_prbs_7(60) <= prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(61) <= prbs2_7(0) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(62) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(3) XOR prbs2_7(4);
next_prbs_7(63) <= prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(64) <= prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(65) <= prbs2_7(0) XOR prbs2_7(3) XOR prbs2_7(4);
next_prbs_7(66) <= prbs2_7(1) XOR prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(67) <= prbs2_7(2) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(68) <= prbs2_7(0) XOR prbs2_7(3);
next_prbs_7(69) <= prbs2_7(1) XOR prbs2_7(4);
next_prbs_7(70) <= prbs2_7(2) XOR prbs2_7(5);
next_prbs_7(71) <= prbs2_7(3) XOR prbs2_7(6);
next_prbs_7(72) <= prbs2_7(0) XOR prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(73) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(74) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2);
next_prbs_7(75) <= prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3);
next_prbs_7(76) <= prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4);
next_prbs_7(77) <= prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(78) <= prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(79) <= prbs2_7(0) XOR prbs2_7(5);
next_prbs_7(80) <= prbs2_7(1) XOR prbs2_7(6);
next_prbs_7(81) <= prbs2_7(0) XOR prbs2_7(2) XOR prbs2_7(6);
next_prbs_7(82) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(3) XOR prbs2_7(6);
next_prbs_7(83) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(84) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(85) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4);
next_prbs_7(86) <= prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(87) <= prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(88) <= prbs2_7(0) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(89) <= prbs2_7(1) XOR prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(90) <= prbs2_7(0) XOR prbs2_7(2) XOR prbs2_7(5);
next_prbs_7(91) <= prbs2_7(1) XOR prbs2_7(3) XOR prbs2_7(6);
next_prbs_7(92) <= prbs2_7(0) XOR prbs2_7(2) XOR prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(93) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(3) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(94) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(4);
next_prbs_7(95) <= prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(5);
next_prbs_7(96) <= prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(97) <= prbs2_7(0) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(98) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(99) <= prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(100) <= prbs2_7(0) XOR prbs2_7(2) XOR prbs2_7(3);
next_prbs_7(101) <= prbs2_7(1) XOR prbs2_7(3) XOR prbs2_7(4);
next_prbs_7(102) <= prbs2_7(2) XOR prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(103) <= prbs2_7(3) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(104) <= prbs2_7(0) XOR prbs2_7(4);
next_prbs_7(105) <= prbs2_7(1) XOR prbs2_7(5);
next_prbs_7(106) <= prbs2_7(2) XOR prbs2_7(6);
next_prbs_7(107) <= prbs2_7(0) XOR prbs2_7(3) XOR prbs2_7(6);
next_prbs_7(108) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(109) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(110) <= prbs2_7(0) XOR prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3);
next_prbs_7(111) <= prbs2_7(1) XOR prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4);
next_prbs_7(112) <= prbs2_7(2) XOR prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(113) <= prbs2_7(3) XOR prbs2_7(4) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(114) <= prbs2_7(0) XOR prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(115) <= prbs2_7(1) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(116) <= prbs2_7(0) XOR prbs2_7(2);
next_prbs_7(117) <= prbs2_7(1) XOR prbs2_7(3);
next_prbs_7(118) <= prbs2_7(2) XOR prbs2_7(4);
next_prbs_7(119) <= prbs2_7(3) XOR prbs2_7(5);
next_prbs_7(120) <= prbs2_7(4) XOR prbs2_7(6);
next_prbs_7(121) <= prbs2_7(0) XOR prbs2_7(5) XOR prbs2_7(6);
next_prbs_7(122) <= prbs2_7(0) XOR prbs2_7(1);
next_prbs_7(123) <= prbs2_7(1) XOR prbs2_7(2);
next_prbs_7(124) <= prbs2_7(2) XOR prbs2_7(3);
next_prbs_7(125) <= prbs2_7(3) XOR prbs2_7(4);
next_prbs_7(126) <= prbs2_7(4) XOR prbs2_7(5);
next_prbs_7(127) <= prbs2_7(5) XOR prbs2_7(6);

-- PRBS 2^13-1 (PRBS13 [13,12,2,1] (parallel 128-bit serializer)	
next_prbs_13(0) <= prbs2_13(5) XOR prbs2_13(9) XOR prbs2_13(10) ;
next_prbs_13(1) <= prbs2_13(6) XOR prbs2_13(10) XOR prbs2_13(11) ;
next_prbs_13(2) <= prbs2_13(7) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(3) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(8) ;
next_prbs_13(4) <= prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(9) ;
next_prbs_13(5) <= prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(10) ;
next_prbs_13(6) <= prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(11) ;
next_prbs_13(7) <= prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(12) ;
next_prbs_13(8) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(12) ;
next_prbs_13(9) <= prbs2_13(0) XOR prbs2_13(3) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(12) ;
next_prbs_13(10) <= prbs2_13(0) XOR prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(12) ;
next_prbs_13(11) <= prbs2_13(0) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(12) <= prbs2_13(0) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(13) <= prbs2_13(0) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(10) XOR prbs2_13(11) ;
next_prbs_13(14) <= prbs2_13(1) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(8) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(15) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(9) ;
next_prbs_13(16) <= prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(10) ;
next_prbs_13(17) <= prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(11) ;
next_prbs_13(18) <= prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(19) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(20) <= prbs2_13(0) XOR prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(11) ;
next_prbs_13(21) <= prbs2_13(1) XOR prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(10) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(22) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(11) ;
next_prbs_13(23) <= prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(6) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(12) ;
next_prbs_13(24) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(3) XOR prbs2_13(7) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(25) <= prbs2_13(0) XOR prbs2_13(4) XOR prbs2_13(8) XOR prbs2_13(10) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(26) <= prbs2_13(0) XOR prbs2_13(2) XOR prbs2_13(5) XOR prbs2_13(9) XOR prbs2_13(11) ;
next_prbs_13(27) <= prbs2_13(1) XOR prbs2_13(3) XOR prbs2_13(6) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(28) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(4) XOR prbs2_13(7) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(29) <= prbs2_13(0) XOR prbs2_13(5) XOR prbs2_13(8) ;
next_prbs_13(30) <= prbs2_13(1) XOR prbs2_13(6) XOR prbs2_13(9) ;
next_prbs_13(31) <= prbs2_13(2) XOR prbs2_13(7) XOR prbs2_13(10) ;
next_prbs_13(32) <= prbs2_13(3) XOR prbs2_13(8) XOR prbs2_13(11) ;
next_prbs_13(33) <= prbs2_13(4) XOR prbs2_13(9) XOR prbs2_13(12) ;
next_prbs_13(34) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(5) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(35) <= prbs2_13(0) XOR prbs2_13(3) XOR prbs2_13(6) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(36) <= prbs2_13(0) XOR prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(7) ;
next_prbs_13(37) <= prbs2_13(1) XOR prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(8) ;
next_prbs_13(38) <= prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(9) ;
next_prbs_13(39) <= prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(10) ;
next_prbs_13(40) <= prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(8) XOR prbs2_13(11) ;
next_prbs_13(41) <= prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(9) XOR prbs2_13(12) ;
next_prbs_13(42) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(6) XOR prbs2_13(8) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(43) <= prbs2_13(0) XOR prbs2_13(3) XOR prbs2_13(7) XOR prbs2_13(9) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(44) <= prbs2_13(0) XOR prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(8) XOR prbs2_13(10) ;
next_prbs_13(45) <= prbs2_13(1) XOR prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(9) XOR prbs2_13(11) ;
next_prbs_13(46) <= prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(47) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(48) <= prbs2_13(0) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(8) ;
next_prbs_13(49) <= prbs2_13(1) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(9) ;
next_prbs_13(50) <= prbs2_13(2) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(8) XOR prbs2_13(10) ;
next_prbs_13(51) <= prbs2_13(3) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(9) XOR prbs2_13(11) ;
next_prbs_13(52) <= prbs2_13(4) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(53) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(5) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(54) <= prbs2_13(0) XOR prbs2_13(3) XOR prbs2_13(6) XOR prbs2_13(9) XOR prbs2_13(10) ;
next_prbs_13(55) <= prbs2_13(1) XOR prbs2_13(4) XOR prbs2_13(7) XOR prbs2_13(10) XOR prbs2_13(11) ;
next_prbs_13(56) <= prbs2_13(2) XOR prbs2_13(5) XOR prbs2_13(8) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(57) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(6) XOR prbs2_13(9) ;
next_prbs_13(58) <= prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(7) XOR prbs2_13(10) ;
next_prbs_13(59) <= prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(8) XOR prbs2_13(11) ;
next_prbs_13(60) <= prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(9) XOR prbs2_13(12) ;
next_prbs_13(61) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(62) <= prbs2_13(0) XOR prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(63) <= prbs2_13(0) XOR prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(9) ;
next_prbs_13(64) <= prbs2_13(1) XOR prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(10) ;
next_prbs_13(65) <= prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(11) ;
next_prbs_13(66) <= prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(67) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(8) XOR prbs2_13(10) XOR prbs2_13(11) ;
next_prbs_13(68) <= prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(9) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(69) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(8) XOR prbs2_13(10) ;
next_prbs_13(70) <= prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(9) XOR prbs2_13(11) ;
next_prbs_13(71) <= prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(8) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(72) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(9) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(73) <= prbs2_13(0) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(10) ;
next_prbs_13(74) <= prbs2_13(1) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(11) ;
next_prbs_13(75) <= prbs2_13(2) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(76) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(10) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(77) <= prbs2_13(0) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(11) ;
next_prbs_13(78) <= prbs2_13(1) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(79) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(80) <= prbs2_13(0) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(10) XOR prbs2_13(11) ;
next_prbs_13(81) <= prbs2_13(1) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(82) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(8) XOR prbs2_13(9) ;
next_prbs_13(83) <= prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(9) XOR prbs2_13(10) ;
next_prbs_13(84) <= prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(10) XOR prbs2_13(11) ;
next_prbs_13(85) <= prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(86) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(5) ;
next_prbs_13(87) <= prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(6) ;
next_prbs_13(88) <= prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(7) ;
next_prbs_13(89) <= prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(8) ;
next_prbs_13(90) <= prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(8) XOR prbs2_13(9) ;
next_prbs_13(91) <= prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(9) XOR prbs2_13(10) ;
next_prbs_13(92) <= prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(10) XOR prbs2_13(11) ;
next_prbs_13(93) <= prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(94) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(10) ;
next_prbs_13(95) <= prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(11) ;
next_prbs_13(96) <= prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(10) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(97) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(11) ;
next_prbs_13(98) <= prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(12) ;
next_prbs_13(99) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(12) ;
next_prbs_13(100) <= prbs2_13(0) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(12) ;
next_prbs_13(101) <= prbs2_13(0) XOR prbs2_13(2) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(12) ;
next_prbs_13(102) <= prbs2_13(0) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(103) <= prbs2_13(0) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(104) <= prbs2_13(0) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(11) ;
next_prbs_13(105) <= prbs2_13(1) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(106) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(10) XOR prbs2_13(11) ;
next_prbs_13(107) <= prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(108) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(3) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(9) ;
next_prbs_13(109) <= prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(10) ;
next_prbs_13(110) <= prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(11) ;
next_prbs_13(111) <= prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(112) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(10) XOR prbs2_13(11) ;
next_prbs_13(113) <= prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(8) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(114) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(9) ;
next_prbs_13(115) <= prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(10) ;
next_prbs_13(116) <= prbs2_13(2) XOR prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(11) ;
next_prbs_13(117) <= prbs2_13(3) XOR prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(118) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(2) XOR prbs2_13(4) XOR prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(10) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(119) <= prbs2_13(0) XOR prbs2_13(3) XOR prbs2_13(5) XOR prbs2_13(6) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(11) ;
next_prbs_13(120) <= prbs2_13(1) XOR prbs2_13(4) XOR prbs2_13(6) XOR prbs2_13(7) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(121) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(5) XOR prbs2_13(7) XOR prbs2_13(8) XOR prbs2_13(10) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(122) <= prbs2_13(0) XOR prbs2_13(6) XOR prbs2_13(8) XOR prbs2_13(9) XOR prbs2_13(11) ;
next_prbs_13(123) <= prbs2_13(1) XOR prbs2_13(7) XOR prbs2_13(9) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(124) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(8) XOR prbs2_13(10) XOR prbs2_13(11) XOR prbs2_13(12) ;
next_prbs_13(125) <= prbs2_13(0) XOR prbs2_13(9) XOR prbs2_13(11) ;
next_prbs_13(126) <= prbs2_13(1) XOR prbs2_13(10) XOR prbs2_13(12) ;
next_prbs_13(127) <= prbs2_13(0) XOR prbs2_13(1) XOR prbs2_13(11) XOR prbs2_13(12) ;



-- PRBS 2^23-1 [23,18] (parallel 128bit serializer)	
next_prbs_23(0) <= prbs2_23(0) XOR prbs2_23(3) XOR prbs2_23(8) XOR prbs2_23(10) XOR prbs2_23(13) XOR prbs2_23(16) XOR prbs2_23(21) ;
next_prbs_23(1) <= prbs2_23(1) XOR prbs2_23(4) XOR prbs2_23(9) XOR prbs2_23(11) XOR prbs2_23(14) XOR prbs2_23(17) XOR prbs2_23(22) ;
next_prbs_23(2) <= prbs2_23(0) XOR prbs2_23(2) XOR prbs2_23(5) XOR prbs2_23(10) XOR prbs2_23(12) XOR prbs2_23(15) ;
next_prbs_23(3) <= prbs2_23(1) XOR prbs2_23(3) XOR prbs2_23(6) XOR prbs2_23(11) XOR prbs2_23(13) XOR prbs2_23(16) ;
next_prbs_23(4) <= prbs2_23(2) XOR prbs2_23(4) XOR prbs2_23(7) XOR prbs2_23(12) XOR prbs2_23(14) XOR prbs2_23(17) ;
next_prbs_23(5) <= prbs2_23(3) XOR prbs2_23(5) XOR prbs2_23(8) XOR prbs2_23(13) XOR prbs2_23(15) XOR prbs2_23(18) ;
next_prbs_23(6) <= prbs2_23(4) XOR prbs2_23(6) XOR prbs2_23(9) XOR prbs2_23(14) XOR prbs2_23(16) XOR prbs2_23(19) ;
next_prbs_23(7) <= prbs2_23(5) XOR prbs2_23(7) XOR prbs2_23(10) XOR prbs2_23(15) XOR prbs2_23(17) XOR prbs2_23(20) ;
next_prbs_23(8) <= prbs2_23(6) XOR prbs2_23(8) XOR prbs2_23(11) XOR prbs2_23(16) XOR prbs2_23(18) XOR prbs2_23(21) ;
next_prbs_23(9) <= prbs2_23(7) XOR prbs2_23(9) XOR prbs2_23(12) XOR prbs2_23(17) XOR prbs2_23(19) XOR prbs2_23(22) ;
next_prbs_23(10) <= prbs2_23(0) XOR prbs2_23(8) XOR prbs2_23(10) XOR prbs2_23(13) XOR prbs2_23(20) ;
next_prbs_23(11) <= prbs2_23(1) XOR prbs2_23(9) XOR prbs2_23(11) XOR prbs2_23(14) XOR prbs2_23(21) ;
next_prbs_23(12) <= prbs2_23(2) XOR prbs2_23(10) XOR prbs2_23(12) XOR prbs2_23(15) XOR prbs2_23(22) ;
next_prbs_23(13) <= prbs2_23(0) XOR prbs2_23(3) XOR prbs2_23(11) XOR prbs2_23(13) XOR prbs2_23(16) XOR prbs2_23(18) ;
next_prbs_23(14) <= prbs2_23(1) XOR prbs2_23(4) XOR prbs2_23(12) XOR prbs2_23(14) XOR prbs2_23(17) XOR prbs2_23(19) ;
next_prbs_23(15) <= prbs2_23(2) XOR prbs2_23(5) XOR prbs2_23(13) XOR prbs2_23(15) XOR prbs2_23(18) XOR prbs2_23(20) ;
next_prbs_23(16) <= prbs2_23(3) XOR prbs2_23(6) XOR prbs2_23(14) XOR prbs2_23(16) XOR prbs2_23(19) XOR prbs2_23(21) ;
next_prbs_23(17) <= prbs2_23(4) XOR prbs2_23(7) XOR prbs2_23(15) XOR prbs2_23(17) XOR prbs2_23(20) XOR prbs2_23(22) ;
next_prbs_23(18) <= prbs2_23(0) XOR prbs2_23(5) XOR prbs2_23(8) XOR prbs2_23(16) XOR prbs2_23(21) ;
next_prbs_23(19) <= prbs2_23(1) XOR prbs2_23(6) XOR prbs2_23(9) XOR prbs2_23(17) XOR prbs2_23(22) ;
next_prbs_23(20) <= prbs2_23(0) XOR prbs2_23(2) XOR prbs2_23(7) XOR prbs2_23(10) ;
next_prbs_23(21) <= prbs2_23(1) XOR prbs2_23(3) XOR prbs2_23(8) XOR prbs2_23(11) ;
next_prbs_23(22) <= prbs2_23(2) XOR prbs2_23(4) XOR prbs2_23(9) XOR prbs2_23(12) ;
next_prbs_23(23) <= prbs2_23(3) XOR prbs2_23(5) XOR prbs2_23(10) XOR prbs2_23(13) ;
next_prbs_23(24) <= prbs2_23(4) XOR prbs2_23(6) XOR prbs2_23(11) XOR prbs2_23(14) ;
next_prbs_23(25) <= prbs2_23(5) XOR prbs2_23(7) XOR prbs2_23(12) XOR prbs2_23(15) ;
next_prbs_23(26) <= prbs2_23(6) XOR prbs2_23(8) XOR prbs2_23(13) XOR prbs2_23(16) ;
next_prbs_23(27) <= prbs2_23(7) XOR prbs2_23(9) XOR prbs2_23(14) XOR prbs2_23(17) ;
next_prbs_23(28) <= prbs2_23(8) XOR prbs2_23(10) XOR prbs2_23(15) XOR prbs2_23(18) ;
next_prbs_23(29) <= prbs2_23(9) XOR prbs2_23(11) XOR prbs2_23(16) XOR prbs2_23(19) ;
next_prbs_23(30) <= prbs2_23(10) XOR prbs2_23(12) XOR prbs2_23(17) XOR prbs2_23(20) ;
next_prbs_23(31) <= prbs2_23(11) XOR prbs2_23(13) XOR prbs2_23(18) XOR prbs2_23(21) ;
next_prbs_23(32) <= prbs2_23(12) XOR prbs2_23(14) XOR prbs2_23(19) XOR prbs2_23(22) ;
next_prbs_23(33) <= prbs2_23(0) XOR prbs2_23(13) XOR prbs2_23(15) XOR prbs2_23(18) XOR prbs2_23(20) ;
next_prbs_23(34) <= prbs2_23(1) XOR prbs2_23(14) XOR prbs2_23(16) XOR prbs2_23(19) XOR prbs2_23(21) ;
next_prbs_23(35) <= prbs2_23(2) XOR prbs2_23(15) XOR prbs2_23(17) XOR prbs2_23(20) XOR prbs2_23(22) ;
next_prbs_23(36) <= prbs2_23(0) XOR prbs2_23(3) XOR prbs2_23(16) XOR prbs2_23(21) ;
next_prbs_23(37) <= prbs2_23(1) XOR prbs2_23(4) XOR prbs2_23(17) XOR prbs2_23(22) ;
next_prbs_23(38) <= prbs2_23(0) XOR prbs2_23(2) XOR prbs2_23(5) ;
next_prbs_23(39) <= prbs2_23(1) XOR prbs2_23(3) XOR prbs2_23(6) ;
next_prbs_23(40) <= prbs2_23(2) XOR prbs2_23(4) XOR prbs2_23(7) ;
next_prbs_23(41) <= prbs2_23(3) XOR prbs2_23(5) XOR prbs2_23(8) ;
next_prbs_23(42) <= prbs2_23(4) XOR prbs2_23(6) XOR prbs2_23(9) ;
next_prbs_23(43) <= prbs2_23(5) XOR prbs2_23(7) XOR prbs2_23(10) ;
next_prbs_23(44) <= prbs2_23(6) XOR prbs2_23(8) XOR prbs2_23(11) ;
next_prbs_23(45) <= prbs2_23(7) XOR prbs2_23(9) XOR prbs2_23(12) ;
next_prbs_23(46) <= prbs2_23(8) XOR prbs2_23(10) XOR prbs2_23(13) ;
next_prbs_23(47) <= prbs2_23(9) XOR prbs2_23(11) XOR prbs2_23(14) ;
next_prbs_23(48) <= prbs2_23(10) XOR prbs2_23(12) XOR prbs2_23(15) ;
next_prbs_23(49) <= prbs2_23(11) XOR prbs2_23(13) XOR prbs2_23(16) ;
next_prbs_23(50) <= prbs2_23(12) XOR prbs2_23(14) XOR prbs2_23(17) ;
next_prbs_23(51) <= prbs2_23(13) XOR prbs2_23(15) XOR prbs2_23(18) ;
next_prbs_23(52) <= prbs2_23(14) XOR prbs2_23(16) XOR prbs2_23(19) ;
next_prbs_23(53) <= prbs2_23(15) XOR prbs2_23(17) XOR prbs2_23(20) ;
next_prbs_23(54) <= prbs2_23(16) XOR prbs2_23(18) XOR prbs2_23(21) ;
next_prbs_23(55) <= prbs2_23(17) XOR prbs2_23(19) XOR prbs2_23(22) ;
next_prbs_23(56) <= prbs2_23(0) XOR prbs2_23(20) ;
next_prbs_23(57) <= prbs2_23(1) XOR prbs2_23(21) ;
next_prbs_23(58) <= prbs2_23(2) XOR prbs2_23(22) ;
next_prbs_23(59) <= prbs2_23(0) XOR prbs2_23(3) XOR prbs2_23(18) ;
next_prbs_23(60) <= prbs2_23(1) XOR prbs2_23(4) XOR prbs2_23(19) ;
next_prbs_23(61) <= prbs2_23(2) XOR prbs2_23(5) XOR prbs2_23(20) ;
next_prbs_23(62) <= prbs2_23(3) XOR prbs2_23(6) XOR prbs2_23(21) ;
next_prbs_23(63) <= prbs2_23(4) XOR prbs2_23(7) XOR prbs2_23(22) ;
next_prbs_23(64) <= prbs2_23(0) XOR prbs2_23(5) XOR prbs2_23(8) XOR prbs2_23(18) ;
next_prbs_23(65) <= prbs2_23(1) XOR prbs2_23(6) XOR prbs2_23(9) XOR prbs2_23(19) ;
next_prbs_23(66) <= prbs2_23(2) XOR prbs2_23(7) XOR prbs2_23(10) XOR prbs2_23(20) ;
next_prbs_23(67) <= prbs2_23(3) XOR prbs2_23(8) XOR prbs2_23(11) XOR prbs2_23(21) ;
next_prbs_23(68) <= prbs2_23(4) XOR prbs2_23(9) XOR prbs2_23(12) XOR prbs2_23(22) ;
next_prbs_23(69) <= prbs2_23(0) XOR prbs2_23(5) XOR prbs2_23(10) XOR prbs2_23(13) XOR prbs2_23(18) ;
next_prbs_23(70) <= prbs2_23(1) XOR prbs2_23(6) XOR prbs2_23(11) XOR prbs2_23(14) XOR prbs2_23(19) ;
next_prbs_23(71) <= prbs2_23(2) XOR prbs2_23(7) XOR prbs2_23(12) XOR prbs2_23(15) XOR prbs2_23(20) ;
next_prbs_23(72) <= prbs2_23(3) XOR prbs2_23(8) XOR prbs2_23(13) XOR prbs2_23(16) XOR prbs2_23(21) ;
next_prbs_23(73) <= prbs2_23(4) XOR prbs2_23(9) XOR prbs2_23(14) XOR prbs2_23(17) XOR prbs2_23(22) ;
next_prbs_23(74) <= prbs2_23(0) XOR prbs2_23(5) XOR prbs2_23(10) XOR prbs2_23(15) ;
next_prbs_23(75) <= prbs2_23(1) XOR prbs2_23(6) XOR prbs2_23(11) XOR prbs2_23(16) ;
next_prbs_23(76) <= prbs2_23(2) XOR prbs2_23(7) XOR prbs2_23(12) XOR prbs2_23(17) ;
next_prbs_23(77) <= prbs2_23(3) XOR prbs2_23(8) XOR prbs2_23(13) XOR prbs2_23(18) ;
next_prbs_23(78) <= prbs2_23(4) XOR prbs2_23(9) XOR prbs2_23(14) XOR prbs2_23(19) ;
next_prbs_23(79) <= prbs2_23(5) XOR prbs2_23(10) XOR prbs2_23(15) XOR prbs2_23(20) ;
next_prbs_23(80) <= prbs2_23(6) XOR prbs2_23(11) XOR prbs2_23(16) XOR prbs2_23(21) ;
next_prbs_23(81) <= prbs2_23(7) XOR prbs2_23(12) XOR prbs2_23(17) XOR prbs2_23(22) ;
next_prbs_23(82) <= prbs2_23(0) XOR prbs2_23(8) XOR prbs2_23(13) ;
next_prbs_23(83) <= prbs2_23(1) XOR prbs2_23(9) XOR prbs2_23(14) ;
next_prbs_23(84) <= prbs2_23(2) XOR prbs2_23(10) XOR prbs2_23(15) ;
next_prbs_23(85) <= prbs2_23(3) XOR prbs2_23(11) XOR prbs2_23(16) ;
next_prbs_23(86) <= prbs2_23(4) XOR prbs2_23(12) XOR prbs2_23(17) ;
next_prbs_23(87) <= prbs2_23(5) XOR prbs2_23(13) XOR prbs2_23(18) ;
next_prbs_23(88) <= prbs2_23(6) XOR prbs2_23(14) XOR prbs2_23(19) ;
next_prbs_23(89) <= prbs2_23(7) XOR prbs2_23(15) XOR prbs2_23(20) ;
next_prbs_23(90) <= prbs2_23(8) XOR prbs2_23(16) XOR prbs2_23(21) ;
next_prbs_23(91) <= prbs2_23(9) XOR prbs2_23(17) XOR prbs2_23(22) ;
next_prbs_23(92) <= prbs2_23(0) XOR prbs2_23(10) ;
next_prbs_23(93) <= prbs2_23(1) XOR prbs2_23(11) ;
next_prbs_23(94) <= prbs2_23(2) XOR prbs2_23(12) ;
next_prbs_23(95) <= prbs2_23(3) XOR prbs2_23(13) ;
next_prbs_23(96) <= prbs2_23(4) XOR prbs2_23(14) ;
next_prbs_23(97) <= prbs2_23(5) XOR prbs2_23(15) ;
next_prbs_23(98) <= prbs2_23(6) XOR prbs2_23(16) ;
next_prbs_23(99) <= prbs2_23(7) XOR prbs2_23(17) ;
next_prbs_23(100) <= prbs2_23(8) XOR prbs2_23(18) ;
next_prbs_23(101) <= prbs2_23(9) XOR prbs2_23(19) ;
next_prbs_23(102) <= prbs2_23(10) XOR prbs2_23(20) ;
next_prbs_23(103) <= prbs2_23(11) XOR prbs2_23(21) ;
next_prbs_23(104) <= prbs2_23(12) XOR prbs2_23(22) ;
next_prbs_23(105) <= prbs2_23(0) XOR prbs2_23(13) XOR prbs2_23(18) ;
next_prbs_23(106) <= prbs2_23(1) XOR prbs2_23(14) XOR prbs2_23(19) ;
next_prbs_23(107) <= prbs2_23(2) XOR prbs2_23(15) XOR prbs2_23(20) ;
next_prbs_23(108) <= prbs2_23(3) XOR prbs2_23(16) XOR prbs2_23(21) ;
next_prbs_23(109) <= prbs2_23(4) XOR prbs2_23(17) XOR prbs2_23(22) ;
next_prbs_23(110) <= prbs2_23(0) XOR prbs2_23(5) ;
next_prbs_23(111) <= prbs2_23(1) XOR prbs2_23(6) ;
next_prbs_23(112) <= prbs2_23(2) XOR prbs2_23(7) ;
next_prbs_23(113) <= prbs2_23(3) XOR prbs2_23(8) ;
next_prbs_23(114) <= prbs2_23(4) XOR prbs2_23(9) ;
next_prbs_23(115) <= prbs2_23(5) XOR prbs2_23(10) ;
next_prbs_23(116) <= prbs2_23(6) XOR prbs2_23(11) ;
next_prbs_23(117) <= prbs2_23(7) XOR prbs2_23(12) ;
next_prbs_23(118) <= prbs2_23(8) XOR prbs2_23(13) ;
next_prbs_23(119) <= prbs2_23(9) XOR prbs2_23(14) ;
next_prbs_23(120) <= prbs2_23(10) XOR prbs2_23(15) ;
next_prbs_23(121) <= prbs2_23(11) XOR prbs2_23(16) ;
next_prbs_23(122) <= prbs2_23(12) XOR prbs2_23(17) ;
next_prbs_23(123) <= prbs2_23(13) XOR prbs2_23(18) ;
next_prbs_23(124) <= prbs2_23(14) XOR prbs2_23(19) ;
next_prbs_23(125) <= prbs2_23(15) XOR prbs2_23(20) ;
next_prbs_23(126) <= prbs2_23(16) XOR prbs2_23(21) ;
next_prbs_23(127) <= prbs2_23(17) XOR prbs2_23(22) ;



-- PRBS 2^31-1 [31,28] (parallel 128 bit serializer)

next_prbs_31(0) <= prbs2_31(12) XOR prbs2_31(15) XOR prbs2_31(24) XOR prbs2_31(27);
next_prbs_31(1) <= prbs2_31(13) XOR prbs2_31(16) XOR prbs2_31(25) XOR prbs2_31(28);
next_prbs_31(2) <= prbs2_31(14) XOR prbs2_31(17) XOR prbs2_31(26) XOR prbs2_31(29);
next_prbs_31(3) <= prbs2_31(15) XOR prbs2_31(18) XOR prbs2_31(27) XOR prbs2_31(30);
next_prbs_31(4) <= prbs2_31(0) XOR prbs2_31(16) XOR prbs2_31(19);
next_prbs_31(5) <= prbs2_31(1) XOR prbs2_31(17) XOR prbs2_31(20);
next_prbs_31(6) <= prbs2_31(2) XOR prbs2_31(18) XOR prbs2_31(21);
next_prbs_31(7) <= prbs2_31(3) XOR prbs2_31(19) XOR prbs2_31(22);
next_prbs_31(8) <= prbs2_31(4) XOR prbs2_31(20) XOR prbs2_31(23);
next_prbs_31(9) <= prbs2_31(5) XOR prbs2_31(21) XOR prbs2_31(24);
next_prbs_31(10) <= prbs2_31(6) XOR prbs2_31(22) XOR prbs2_31(25);
next_prbs_31(11) <= prbs2_31(7) XOR prbs2_31(23) XOR prbs2_31(26);
next_prbs_31(12) <= prbs2_31(8) XOR prbs2_31(24) XOR prbs2_31(27);
next_prbs_31(13) <= prbs2_31(9) XOR prbs2_31(25) XOR prbs2_31(28);
next_prbs_31(14) <= prbs2_31(10) XOR prbs2_31(26) XOR prbs2_31(29);
next_prbs_31(15) <= prbs2_31(11) XOR prbs2_31(27) XOR prbs2_31(30);
next_prbs_31(16) <= prbs2_31(0) XOR prbs2_31(12);
next_prbs_31(17) <= prbs2_31(1) XOR prbs2_31(13);
next_prbs_31(18) <= prbs2_31(2) XOR prbs2_31(14);
next_prbs_31(19) <= prbs2_31(3) XOR prbs2_31(15);
next_prbs_31(20) <= prbs2_31(4) XOR prbs2_31(16);
next_prbs_31(21) <= prbs2_31(5) XOR prbs2_31(17);
next_prbs_31(22) <= prbs2_31(6) XOR prbs2_31(18);
next_prbs_31(23) <= prbs2_31(7) XOR prbs2_31(19);
next_prbs_31(24) <= prbs2_31(8) XOR prbs2_31(20);
next_prbs_31(25) <= prbs2_31(9) XOR prbs2_31(21);
next_prbs_31(26) <= prbs2_31(10) XOR prbs2_31(22);
next_prbs_31(27) <= prbs2_31(11) XOR prbs2_31(23);
next_prbs_31(28) <= prbs2_31(12) XOR prbs2_31(24);
next_prbs_31(29) <= prbs2_31(13) XOR prbs2_31(25);
next_prbs_31(30) <= prbs2_31(14) XOR prbs2_31(26);
next_prbs_31(31) <= prbs2_31(15) XOR prbs2_31(27);
next_prbs_31(32) <= prbs2_31(16) XOR prbs2_31(28);
next_prbs_31(33) <= prbs2_31(17) XOR prbs2_31(29);
next_prbs_31(34) <= prbs2_31(18) XOR prbs2_31(30);
next_prbs_31(35) <= prbs2_31(0) XOR prbs2_31(19) XOR prbs2_31(28);
next_prbs_31(36) <= prbs2_31(1) XOR prbs2_31(20) XOR prbs2_31(29);
next_prbs_31(37) <= prbs2_31(2) XOR prbs2_31(21) XOR prbs2_31(30);
next_prbs_31(38) <= prbs2_31(0) XOR prbs2_31(3) XOR prbs2_31(22) XOR prbs2_31(28);
next_prbs_31(39) <= prbs2_31(1) XOR prbs2_31(4) XOR prbs2_31(23) XOR prbs2_31(29);
next_prbs_31(40) <= prbs2_31(2) XOR prbs2_31(5) XOR prbs2_31(24) XOR prbs2_31(30);
next_prbs_31(41) <= prbs2_31(0) XOR prbs2_31(3) XOR prbs2_31(6) XOR prbs2_31(25) XOR prbs2_31(28);
next_prbs_31(42) <= prbs2_31(1) XOR prbs2_31(4) XOR prbs2_31(7) XOR prbs2_31(26) XOR prbs2_31(29);
next_prbs_31(43) <= prbs2_31(2) XOR prbs2_31(5) XOR prbs2_31(8) XOR prbs2_31(27) XOR prbs2_31(30);
next_prbs_31(44) <= prbs2_31(0) XOR prbs2_31(3) XOR prbs2_31(6) XOR prbs2_31(9);
next_prbs_31(45) <= prbs2_31(1) XOR prbs2_31(4) XOR prbs2_31(7) XOR prbs2_31(10);
next_prbs_31(46) <= prbs2_31(2) XOR prbs2_31(5) XOR prbs2_31(8) XOR prbs2_31(11);
next_prbs_31(47) <= prbs2_31(3) XOR prbs2_31(6) XOR prbs2_31(9) XOR prbs2_31(12);
next_prbs_31(48) <= prbs2_31(4) XOR prbs2_31(7) XOR prbs2_31(10) XOR prbs2_31(13);
next_prbs_31(49) <= prbs2_31(5) XOR prbs2_31(8) XOR prbs2_31(11) XOR prbs2_31(14);
next_prbs_31(50) <= prbs2_31(6) XOR prbs2_31(9) XOR prbs2_31(12) XOR prbs2_31(15);
next_prbs_31(51) <= prbs2_31(7) XOR prbs2_31(10) XOR prbs2_31(13) XOR prbs2_31(16);
next_prbs_31(52) <= prbs2_31(8) XOR prbs2_31(11) XOR prbs2_31(14) XOR prbs2_31(17);
next_prbs_31(53) <= prbs2_31(9) XOR prbs2_31(12) XOR prbs2_31(15) XOR prbs2_31(18);
next_prbs_31(54) <= prbs2_31(10) XOR prbs2_31(13) XOR prbs2_31(16) XOR prbs2_31(19);
next_prbs_31(55) <= prbs2_31(11) XOR prbs2_31(14) XOR prbs2_31(17) XOR prbs2_31(20);
next_prbs_31(56) <= prbs2_31(12) XOR prbs2_31(15) XOR prbs2_31(18) XOR prbs2_31(21);
next_prbs_31(57) <= prbs2_31(13) XOR prbs2_31(16) XOR prbs2_31(19) XOR prbs2_31(22);
next_prbs_31(58) <= prbs2_31(14) XOR prbs2_31(17) XOR prbs2_31(20) XOR prbs2_31(23);
next_prbs_31(59) <= prbs2_31(15) XOR prbs2_31(18) XOR prbs2_31(21) XOR prbs2_31(24);
next_prbs_31(60) <= prbs2_31(16) XOR prbs2_31(19) XOR prbs2_31(22) XOR prbs2_31(25);
next_prbs_31(61) <= prbs2_31(17) XOR prbs2_31(20) XOR prbs2_31(23) XOR prbs2_31(26);
next_prbs_31(62) <= prbs2_31(18) XOR prbs2_31(21) XOR prbs2_31(24) XOR prbs2_31(27);
next_prbs_31(63) <= prbs2_31(19) XOR prbs2_31(22) XOR prbs2_31(25) XOR prbs2_31(28);
next_prbs_31(64) <= prbs2_31(20) XOR prbs2_31(23) XOR prbs2_31(26) XOR prbs2_31(29);
next_prbs_31(65) <= prbs2_31(21) XOR prbs2_31(24) XOR prbs2_31(27) XOR prbs2_31(30);
next_prbs_31(66) <= prbs2_31(0) XOR prbs2_31(22) XOR prbs2_31(25);
next_prbs_31(67) <= prbs2_31(1) XOR prbs2_31(23) XOR prbs2_31(26);
next_prbs_31(68) <= prbs2_31(2) XOR prbs2_31(24) XOR prbs2_31(27);
next_prbs_31(69) <= prbs2_31(3) XOR prbs2_31(25) XOR prbs2_31(28);
next_prbs_31(70) <= prbs2_31(4) XOR prbs2_31(26) XOR prbs2_31(29);
next_prbs_31(71) <= prbs2_31(5) XOR prbs2_31(27) XOR prbs2_31(30);
next_prbs_31(72) <= prbs2_31(0) XOR prbs2_31(6);
next_prbs_31(73) <= prbs2_31(1) XOR prbs2_31(7);
next_prbs_31(74) <= prbs2_31(2) XOR prbs2_31(8);
next_prbs_31(75) <= prbs2_31(3) XOR prbs2_31(9);
next_prbs_31(76) <= prbs2_31(4) XOR prbs2_31(10);
next_prbs_31(77) <= prbs2_31(5) XOR prbs2_31(11);
next_prbs_31(78) <= prbs2_31(6) XOR prbs2_31(12);
next_prbs_31(79) <= prbs2_31(7) XOR prbs2_31(13);
next_prbs_31(80) <= prbs2_31(8) XOR prbs2_31(14);
next_prbs_31(81) <= prbs2_31(9) XOR prbs2_31(15);
next_prbs_31(82) <= prbs2_31(10) XOR prbs2_31(16);
next_prbs_31(83) <= prbs2_31(11) XOR prbs2_31(17);
next_prbs_31(84) <= prbs2_31(12) XOR prbs2_31(18);
next_prbs_31(85) <= prbs2_31(13) XOR prbs2_31(19);
next_prbs_31(86) <= prbs2_31(14) XOR prbs2_31(20);
next_prbs_31(87) <= prbs2_31(15) XOR prbs2_31(21);
next_prbs_31(88) <= prbs2_31(16) XOR prbs2_31(22);
next_prbs_31(89) <= prbs2_31(17) XOR prbs2_31(23);
next_prbs_31(90) <= prbs2_31(18) XOR prbs2_31(24);
next_prbs_31(91) <= prbs2_31(19) XOR prbs2_31(25);
next_prbs_31(92) <= prbs2_31(20) XOR prbs2_31(26);
next_prbs_31(93) <= prbs2_31(21) XOR prbs2_31(27);
next_prbs_31(94) <= prbs2_31(22) XOR prbs2_31(28);
next_prbs_31(95) <= prbs2_31(23) XOR prbs2_31(29);
next_prbs_31(96) <= prbs2_31(24) XOR prbs2_31(30);
next_prbs_31(97) <= prbs2_31(0) XOR prbs2_31(25) XOR prbs2_31(28);
next_prbs_31(98) <= prbs2_31(1) XOR prbs2_31(26) XOR prbs2_31(29);
next_prbs_31(99) <= prbs2_31(2) XOR prbs2_31(27) XOR prbs2_31(30);
next_prbs_31(100) <= prbs2_31(0) XOR prbs2_31(3);
next_prbs_31(101) <= prbs2_31(1) XOR prbs2_31(4);
next_prbs_31(102) <= prbs2_31(2) XOR prbs2_31(5);
next_prbs_31(103) <= prbs2_31(3) XOR prbs2_31(6);
next_prbs_31(104) <= prbs2_31(4) XOR prbs2_31(7);
next_prbs_31(105) <= prbs2_31(5) XOR prbs2_31(8);
next_prbs_31(106) <= prbs2_31(6) XOR prbs2_31(9);
next_prbs_31(107) <= prbs2_31(7) XOR prbs2_31(10);
next_prbs_31(108) <= prbs2_31(8) XOR prbs2_31(11);
next_prbs_31(109) <= prbs2_31(9) XOR prbs2_31(12);
next_prbs_31(110) <= prbs2_31(10) XOR prbs2_31(13);
next_prbs_31(111) <= prbs2_31(11) XOR prbs2_31(14);
next_prbs_31(112) <= prbs2_31(12) XOR prbs2_31(15);
next_prbs_31(113) <= prbs2_31(13) XOR prbs2_31(16);
next_prbs_31(114) <= prbs2_31(14) XOR prbs2_31(17);
next_prbs_31(115) <= prbs2_31(15) XOR prbs2_31(18);
next_prbs_31(116) <= prbs2_31(16) XOR prbs2_31(19);
next_prbs_31(117) <= prbs2_31(17) XOR prbs2_31(20);
next_prbs_31(118) <= prbs2_31(18) XOR prbs2_31(21);
next_prbs_31(119) <= prbs2_31(19) XOR prbs2_31(22);
next_prbs_31(120) <= prbs2_31(20) XOR prbs2_31(23);
next_prbs_31(121) <= prbs2_31(21) XOR prbs2_31(24);
next_prbs_31(122) <= prbs2_31(22) XOR prbs2_31(25);
next_prbs_31(123) <= prbs2_31(23) XOR prbs2_31(26);
next_prbs_31(124) <= prbs2_31(24) XOR prbs2_31(27);
next_prbs_31(125) <= prbs2_31(25) XOR prbs2_31(28);
next_prbs_31(126) <= prbs2_31(26) XOR prbs2_31(29);
next_prbs_31(127) <= prbs2_31(27) XOR prbs2_31(30);




	
next_prbs_pipe   <=  next_prbs_13  WHEN PrbsSelect_s3 = "00" ELSE
					 next_prbs_7  WHEN PrbsSelect_s3 = "11" ELSE
                next_prbs_23 WHEN PrbsSelect_s3 = "01" ELSE
                next_prbs_31 WHEN PrbsSelect_s3 = "10" ELSE
                --next_prbs_15 WHEN PrbsSelect_s3 = "011" ELSE
                --next_prbs_9 WHEN PrbsSelect_s3 = "110" ELSE
                (OTHERS => '0');
	

	

Process(Clock)
variable N : Array_16x8bit;
Begin
	if Clock'event AND Clock = '1' then
		if (ResetErrorcount = '1') or (Reset_dupA2 = '1') then
		
			FOR i IN 0 to 15 LOOP
				Difference(i) <= (OTHERS => '0');
			end loop;
			
			FOR i IN 0 to 3 LOOP
				Difference_min(i) <= (OTHERS => '0');
			end loop;			

			Difference_tot  <= (OTHERS => '0');
			Difference_adder  <= (OTHERS => '0');
			
			ErrorCount_sim  <= (OTHERS => '0');
			
    	else

		if Enable = '1' then
			FOR i IN 0 to 15 LOOP
            N(I) := (OTHERS => '0');
			END LOOP;
			
			FOR J in 0 to 15 Loop
            for I in 0 to 7 loop
					if next_prbs(J*8 + I) /= LSBRcvData(J*8 + I) then
						N(J) := N(J) +1;
					end if;
				end loop;
			end loop;
			
			FOR i IN 0 to 15 LOOP
				Difference(I) <= N(I);
			END LOOP;

			for I in 0 to 3 loop
					Difference_min(I)  <= Difference(0+4*I) + Difference(1+4*I)  + Difference(2+4*I)  + Difference(3+4*I);
			end loop;
			
         Difference_tot   <= Difference_min(0) + Difference_min(1) + Difference_min(2) + Difference_min(3);
			Difference_pipe  <= Difference_tot; -- extra pipeline


			if lock = '1' then		
				Difference_adder <= Difference_pipe;
			else
				Difference_adder <= (OTHERS => '0');
			end if;
			
			--Fast simulation without accumulator
			
            if lock = '1' then
                ErrorCount_sim <= ErrorCount_sim + Difference_adder;
            end if;

				
			end if; -- Validdata

	end if;			
 end if;
End Process;

Process(Clock)
Begin
	if Clock'event AND Clock = '1' then
			Resetadder <= ResetErrorcount  or Reset_dupB2 ; -- to remove recovery timing issue
	end if;
end process;

generate_adder_hw:
if (USE_ADDER_HW) generate
adder_hw_inst :  adder_hw
	port map (
	   accum_sload => '0',
		aclr0   => Resetadder,
		clock0  => Clock,
		ena0	  => Enable,
		dataa_0 => Difference_adder_27b,
		datab_0 => const_one,
		result  => ErrorCount_adder_hw
	);
end generate generate_adder_hw;

const_one <= "000000000000000000000000001";	
Difference_adder_27b <= "0000000000000000000" & Difference_adder;

PrbsLocked <= lock;

-- choose either the output from the accumulator or the simulation output.
ErrorCount_Q <= ErrorCount_adder_hw when (USE_ADDER_HW) else ErrorCount_sim;

-- PrbsLock_Alarm_Count 	


-----------------------------------------------------------------------------------------------------------
--	PrbsLock_Alarm_Count 	
-----------------------------------------------------------------------------------------------------------	


   process(Clock)
	begin
		if rising_edge(Clock) then
			if (Reset_PrbsLockAlarm = '1') then
				count_prbslock_alarm <= (OTHERS => '0');
				lock_q <= '0';
				--start_counter_check_bitslip <= '0';
			else
				lock_q <= lock;				
				if (lock_q /= lock) and (lock = '0') then -- detect falling edge prbslock
					--start_counter_check_bitslip <= '1';
					count_prbslock_alarm <= count_prbslock_alarm + 1;
--				else
--					start_counter_check_bitslip <= '0';			   
				end if;
			end if;
		end if;
	end process;	



-----------------------------------------------------------------------------------------------------------
--	Check for Bitslip (if bitslip occurs prbslock is back asserted after 128ish clock cycles	
-----------------------------------------------------------------------------------------------------------	

--	process (Clock)
--	begin
--		if rising_edge(Clock) then	
--			if (Reset_PrbsLockAlarm = '1') then
--				Check_State <= Check_State_Reset;	
--			else
--				CASE Check_State IS
--		         WHEN Check_State_Reset    	=> 	Check_State <= Idle;
--					
--					WHEN Idle			 			=> 	if start_counter_check_bitslip = '1' then  
--																	Check_State <= Counting;
--																end if;
--					WHEN Counting		 			=>  	if (count_bitslip_check = x"88") then  
--																	Check_State <= Check_Lock;
--																end if;
--					WHEN Check_Lock		 		=>  	Check_State <= Idle;						
--					When OTHERS						=> 	Check_State <= Idle;
--				end case;								
--			end if;
--		end if;
--   end process;
		

--   process(Clock)
--	begin
--		if rising_edge(Clock) then
--			if (Reset_PrbsLockAlarm = '1') then
--				count_bitslip_check <= (OTHERS => '0');
--				bitslip_counter	  <= (OTHERS => '0');
--			else
--
--				CASE Check_State IS
--		         WHEN Check_State_Reset    	=> 	bitslip_counter <= (OTHERS => '0');
--																count_bitslip_check <= (OTHERS => '0');
--					
--					WHEN Idle			 			=> 	count_bitslip_check <= (OTHERS => '0');
--					
--					WHEN Counting		 			=>  	count_bitslip_check <= count_bitslip_check + 1;
--					
--					WHEN Check_Lock		 		=>  	if lock = '1' then
--																		bitslip_counter <= bitslip_counter + 1;
--																end if;	
--					When OTHERS						=> 	count_bitslip_check <= (OTHERS => '0');
--				end case;
--
--				
--			end if;
--		end if;
--	end process;		

	
	
-- alternative

   process(Clock)
	begin
		if rising_edge(Clock) then
			if (Reset_PrbsLockAlarm = '1') then
				bitslip_1 	<= '0';
				bitslip_2 	<= '0';
				bitslip 		<= '0';
				bitslip_q 	<= '0';
				bitslip_counter	  <= (OTHERS => '0');
			else
				if lock = '1' then					
					if (next_prbs(33 downto 2) = LSBRcvData(31 downto 0))  then
						bitslip_1 <= '1';
					end if;
					
					if (next_prbs(33 downto 2) = LSBRcvData(35 downto 4))  then
						bitslip_2 <= '1';
					end if;				
					
					if (bitslip_1 = '1') or (bitslip_2 = '1') then
						bitslip <= '1';
					end if;
					
					bitslip_q <= bitslip;
					
					if (bitslip_q /= bitslip) and (bitslip = '1') then -- detect rising edge bitslip
						bitslip_counter <= bitslip_counter + 1;	
					end if;
				
				else
					bitslip_1 	<= '0';
					bitslip_2 	<= '0';
					bitslip 		<= '0';
					bitslip_q 	<= '0';
				end if;
							
					
					
		 end if;
	 end if;
  end process;		
	
	

Prbslock_Alarm_Count(15 downto 0)  <= count_prbslock_alarm;
Prbslock_Alarm_Count(31 downto 16) <= bitslip_counter;		
	
end;



