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

entity multi_prbsgenerate_128bit is
PORT(
	coreclk  	: in std_logic;
	Enable		: in std_logic;
	StartValue	: in std_logic_vector(127 downto 0);
	Reset	 	: in std_logic;
	PrbsSelect	: in std_logic_vector(1 downto 0);
	Inserterror : in std_logic;
	Prbsout 	: out std_logic_vector(127 downto 0);
	Valid		: out std_logic;
	deskew_pulse : out std_logic -- Only for E-tile
	);
END multi_prbsgenerate_128bit;	


architecture rtl of multi_prbsgenerate_128bit is


component Synchro is
port
	(
	Clk			: in std_logic;
	data_in		: in std_logic;
	data_out		: out std_logic
	);
end component;
signal prbs 			: std_logic_vector(127 downto 0);
signal tx_data 			: std_logic_vector(127 downto 0);
signal tx_data_sig 		: std_logic_vector(127 downto 0) := (OTHERS => '0');
signal detect_inserterror	: std_logic;
signal delayed_error    : std_logic;
signal inserterror_Q	: std_logic;
signal inserterror_synchro	: std_logic;

signal PrbsSelect_s1, PrbsSelect_s2, PrbsSelect_s3 : std_logic_vector(1 downto 0); 

signal Reset_dupA1, Reset_dupA2 :  std_logic :='0';
attribute preserve_syn_only : boolean;
attribute preserve_syn_only of Reset_dupA1 : signal is true;
signal count_deskew		: std_logic_Vector(1 downto 0);
signal Valid_min1 		: std_logic;


begin

Synchro_inst : Synchro
port map(
Clk 			=> coreclk,
data_in 		=> inserterror,
data_out 	=> inserterror_synchro
);
process(coreclk)
	begin
	if rising_edge(coreclk) then
				Reset_dupA1 <= Reset;
				Reset_dupA2 <= Reset_dupA1;	
		if (Reset_dupA2 = '1') then
				prbs <= StartValue;
				--count <= (OTHERS => '0');
				PrbsSelect_s1 <= (OTHERS => '0'); 
				PrbsSelect_s2 <= (OTHERS => '0'); 
				PrbsSelect_s3 <= (OTHERS => '0'); 

		else
				PrbsSelect_s1 <= PrbsSelect; 
				PrbsSelect_s2 <= PrbsSelect_s1; 
				PrbsSelect_s3 <= PrbsSelect_s2; 

		if Enable = '1' then
			CASE PrbsSelect_s3 IS
				WHEN "11" =>		-- PRBS 2^7-1 (parallel 128bit serializer) (T[7,6])	
					prbs(0) <= prbs(5) XOR prbs(6);
					prbs(1) <= prbs(0);
					prbs(2) <= prbs(1);
					prbs(3) <= prbs(2);
					prbs(4) <= prbs(3);
					prbs(5) <= prbs(4);
					prbs(6) <= prbs(5);
					prbs(7) <= prbs(6);
					prbs(8) <= prbs(0) XOR prbs(6);
					prbs(9) <= prbs(0) XOR prbs(1) XOR prbs(6);
					prbs(10) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(6);
					prbs(11) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(6);
					prbs(12) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(6);
					prbs(13) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(14) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(5);
					prbs(15) <= prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(16) <= prbs(0) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(5);
					prbs(17) <= prbs(1) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(18) <= prbs(0) XOR prbs(2) XOR prbs(4) XOR prbs(5);
					prbs(19) <= prbs(1) XOR prbs(3) XOR prbs(5) XOR prbs(6);
					prbs(20) <= prbs(0) XOR prbs(2) XOR prbs(4);
					prbs(21) <= prbs(1) XOR prbs(3) XOR prbs(5);
					prbs(22) <= prbs(2) XOR prbs(4) XOR prbs(6);
					prbs(23) <= prbs(0) XOR prbs(3) XOR prbs(5) XOR prbs(6);
					prbs(24) <= prbs(0) XOR prbs(1) XOR prbs(4);
					prbs(25) <= prbs(1) XOR prbs(2) XOR prbs(5);
					prbs(26) <= prbs(2) XOR prbs(3) XOR prbs(6);
					prbs(27) <= prbs(0) XOR prbs(3) XOR prbs(4) XOR prbs(6);
					prbs(28) <= prbs(0) XOR prbs(1) XOR prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(29) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(5);
					prbs(30) <= prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(6);
					prbs(31) <= prbs(0) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(6);
					prbs(32) <= prbs(0) XOR prbs(1) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(33) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(4) XOR prbs(5);
					prbs(34) <= prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(5) XOR prbs(6);
					prbs(35) <= prbs(0) XOR prbs(2) XOR prbs(3) XOR prbs(4);
					prbs(36) <= prbs(1) XOR prbs(3) XOR prbs(4) XOR prbs(5);
					prbs(37) <= prbs(2) XOR prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(38) <= prbs(0) XOR prbs(3) XOR prbs(5);
					prbs(39) <= prbs(1) XOR prbs(4) XOR prbs(6);
					prbs(40) <= prbs(0) XOR prbs(2) XOR prbs(5) XOR prbs(6);
					prbs(41) <= prbs(0) XOR prbs(1) XOR prbs(3);
					prbs(42) <= prbs(1) XOR prbs(2) XOR prbs(4);
					prbs(43) <= prbs(2) XOR prbs(3) XOR prbs(5);
					prbs(44) <= prbs(3) XOR prbs(4) XOR prbs(6);
					prbs(45) <= prbs(0) XOR prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(46) <= prbs(0) XOR prbs(1) XOR prbs(5);
					prbs(47) <= prbs(1) XOR prbs(2) XOR prbs(6);
					prbs(48) <= prbs(0) XOR prbs(2) XOR prbs(3) XOR prbs(6);
					prbs(49) <= prbs(0) XOR prbs(1) XOR prbs(3) XOR prbs(4) XOR prbs(6);
					prbs(50) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(51) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(5);
					prbs(52) <= prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(6);
					prbs(53) <= prbs(0) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(54) <= prbs(0) XOR prbs(1) XOR prbs(3) XOR prbs(4) XOR prbs(5);
					prbs(55) <= prbs(1) XOR prbs(2) XOR prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(56) <= prbs(0) XOR prbs(2) XOR prbs(3) XOR prbs(5);
					prbs(57) <= prbs(1) XOR prbs(3) XOR prbs(4) XOR prbs(6);
					prbs(58) <= prbs(0) XOR prbs(2) XOR prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(59) <= prbs(0) XOR prbs(1) XOR prbs(3) XOR prbs(5);
					prbs(60) <= prbs(1) XOR prbs(2) XOR prbs(4) XOR prbs(6);
					prbs(61) <= prbs(0) XOR prbs(2) XOR prbs(3) XOR prbs(5) XOR prbs(6);
					prbs(62) <= prbs(0) XOR prbs(1) XOR prbs(3) XOR prbs(4);
					prbs(63) <= prbs(1) XOR prbs(2) XOR prbs(4) XOR prbs(5);
					prbs(64) <= prbs(2) XOR prbs(3) XOR prbs(5) XOR prbs(6);
					prbs(65) <= prbs(0) XOR prbs(3) XOR prbs(4);
					prbs(66) <= prbs(1) XOR prbs(4) XOR prbs(5);
					prbs(67) <= prbs(2) XOR prbs(5) XOR prbs(6);
					prbs(68) <= prbs(0) XOR prbs(3);
					prbs(69) <= prbs(1) XOR prbs(4);
					prbs(70) <= prbs(2) XOR prbs(5);
					prbs(71) <= prbs(3) XOR prbs(6);
					prbs(72) <= prbs(0) XOR prbs(4) XOR prbs(6);
					prbs(73) <= prbs(0) XOR prbs(1) XOR prbs(5) XOR prbs(6);
					prbs(74) <= prbs(0) XOR prbs(1) XOR prbs(2);
					prbs(75) <= prbs(1) XOR prbs(2) XOR prbs(3);
					prbs(76) <= prbs(2) XOR prbs(3) XOR prbs(4);
					prbs(77) <= prbs(3) XOR prbs(4) XOR prbs(5);
					prbs(78) <= prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(79) <= prbs(0) XOR prbs(5);
					prbs(80) <= prbs(1) XOR prbs(6);
					prbs(81) <= prbs(0) XOR prbs(2) XOR prbs(6);
					prbs(82) <= prbs(0) XOR prbs(1) XOR prbs(3) XOR prbs(6);
					prbs(83) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(4) XOR prbs(6);
					prbs(84) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(5) XOR prbs(6);
					prbs(85) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(4);
					prbs(86) <= prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(5);
					prbs(87) <= prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(88) <= prbs(0) XOR prbs(3) XOR prbs(4) XOR prbs(5);
					prbs(89) <= prbs(1) XOR prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(90) <= prbs(0) XOR prbs(2) XOR prbs(5);
					prbs(91) <= prbs(1) XOR prbs(3) XOR prbs(6);
					prbs(92) <= prbs(0) XOR prbs(2) XOR prbs(4) XOR prbs(6);
					prbs(93) <= prbs(0) XOR prbs(1) XOR prbs(3) XOR prbs(5) XOR prbs(6);
					prbs(94) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(4);
					prbs(95) <= prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(5);
					prbs(96) <= prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(6);
					prbs(97) <= prbs(0) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(98) <= prbs(0) XOR prbs(1) XOR prbs(4) XOR prbs(5);
					prbs(99) <= prbs(1) XOR prbs(2) XOR prbs(5) XOR prbs(6);
					prbs(100) <= prbs(0) XOR prbs(2) XOR prbs(3);
					prbs(101) <= prbs(1) XOR prbs(3) XOR prbs(4);
					prbs(102) <= prbs(2) XOR prbs(4) XOR prbs(5);
					prbs(103) <= prbs(3) XOR prbs(5) XOR prbs(6);
					prbs(104) <= prbs(0) XOR prbs(4);
					prbs(105) <= prbs(1) XOR prbs(5);
					prbs(106) <= prbs(2) XOR prbs(6);
					prbs(107) <= prbs(0) XOR prbs(3) XOR prbs(6);
					prbs(108) <= prbs(0) XOR prbs(1) XOR prbs(4) XOR prbs(6);
					prbs(109) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(5) XOR prbs(6);
					prbs(110) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(3);
					prbs(111) <= prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(4);
					prbs(112) <= prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(5);
					prbs(113) <= prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(6);
					prbs(114) <= prbs(0) XOR prbs(4) XOR prbs(5);
					prbs(115) <= prbs(1) XOR prbs(5) XOR prbs(6);
					prbs(116) <= prbs(0) XOR prbs(2);
					prbs(117) <= prbs(1) XOR prbs(3);
					prbs(118) <= prbs(2) XOR prbs(4);
					prbs(119) <= prbs(3) XOR prbs(5);
					prbs(120) <= prbs(4) XOR prbs(6);
					prbs(121) <= prbs(0) XOR prbs(5) XOR prbs(6);
					prbs(122) <= prbs(0) XOR prbs(1);
					prbs(123) <= prbs(1) XOR prbs(2);
					prbs(124) <= prbs(2) XOR prbs(3);
					prbs(125) <= prbs(3) XOR prbs(4);
					prbs(126) <= prbs(4) XOR prbs(5);
					prbs(127) <= prbs(5) XOR prbs(6);

				WHEN "00" =>		-- PRBS 2^13-1 (PRBS13 [13,12,2,1] (parallel 128-bit serializer)					
					prbs(0) <= prbs(5) XOR prbs(9) XOR prbs(10) ;
					prbs(1) <= prbs(6) XOR prbs(10) XOR prbs(11) ;
					prbs(2) <= prbs(7) XOR prbs(11) XOR prbs(12) ;
					prbs(3) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(8) ;
					prbs(4) <= prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(9) ;
					prbs(5) <= prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(10) ;
					prbs(6) <= prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(11) ;
					prbs(7) <= prbs(4) XOR prbs(5) XOR prbs(6) XOR prbs(12) ;
					prbs(8) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(5) XOR prbs(6) XOR prbs(7) XOR prbs(12) ;
					prbs(9) <= prbs(0) XOR prbs(3) XOR prbs(6) XOR prbs(7) XOR prbs(8) XOR prbs(12) ;
					prbs(10) <= prbs(0) XOR prbs(2) XOR prbs(4) XOR prbs(7) XOR prbs(8) XOR prbs(9) XOR prbs(12) ;
					prbs(11) <= prbs(0) XOR prbs(2) XOR prbs(3) XOR prbs(5) XOR prbs(8) XOR prbs(9) XOR prbs(10) XOR prbs(12) ;
					prbs(12) <= prbs(0) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(6) XOR prbs(9) XOR prbs(10) XOR prbs(11) XOR prbs(12) ;
					prbs(13) <= prbs(0) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(7) XOR prbs(10) XOR prbs(11) ;
					prbs(14) <= prbs(1) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(6) XOR prbs(8) XOR prbs(11) XOR prbs(12) ;
					prbs(15) <= prbs(0) XOR prbs(1) XOR prbs(4) XOR prbs(5) XOR prbs(6) XOR prbs(7) XOR prbs(9) ;
					prbs(16) <= prbs(1) XOR prbs(2) XOR prbs(5) XOR prbs(6) XOR prbs(7) XOR prbs(8) XOR prbs(10) ;
					prbs(17) <= prbs(2) XOR prbs(3) XOR prbs(6) XOR prbs(7) XOR prbs(8) XOR prbs(9) XOR prbs(11) ;
					prbs(18) <= prbs(3) XOR prbs(4) XOR prbs(7) XOR prbs(8) XOR prbs(9) XOR prbs(10) XOR prbs(12) ;
					prbs(19) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(4) XOR prbs(5) XOR prbs(8) XOR prbs(9) XOR prbs(10) XOR prbs(11) XOR prbs(12) ;
					prbs(20) <= prbs(0) XOR prbs(3) XOR prbs(5) XOR prbs(6) XOR prbs(9) XOR prbs(10) XOR prbs(11) ;
					prbs(21) <= prbs(1) XOR prbs(4) XOR prbs(6) XOR prbs(7) XOR prbs(10) XOR prbs(11) XOR prbs(12) ;
					prbs(22) <= prbs(0) XOR prbs(1) XOR prbs(5) XOR prbs(7) XOR prbs(8) XOR prbs(11) ;
					prbs(23) <= prbs(1) XOR prbs(2) XOR prbs(6) XOR prbs(8) XOR prbs(9) XOR prbs(12) ;
					prbs(24) <= prbs(0) XOR prbs(1) XOR prbs(3) XOR prbs(7) XOR prbs(9) XOR prbs(10) XOR prbs(12) ;
					prbs(25) <= prbs(0) XOR prbs(4) XOR prbs(8) XOR prbs(10) XOR prbs(11) XOR prbs(12) ;
					prbs(26) <= prbs(0) XOR prbs(2) XOR prbs(5) XOR prbs(9) XOR prbs(11) ;
					prbs(27) <= prbs(1) XOR prbs(3) XOR prbs(6) XOR prbs(10) XOR prbs(12) ;
					prbs(28) <= prbs(0) XOR prbs(1) XOR prbs(4) XOR prbs(7) XOR prbs(11) XOR prbs(12) ;
					prbs(29) <= prbs(0) XOR prbs(5) XOR prbs(8) ;
					prbs(30) <= prbs(1) XOR prbs(6) XOR prbs(9) ;
					prbs(31) <= prbs(2) XOR prbs(7) XOR prbs(10) ;
					prbs(32) <= prbs(3) XOR prbs(8) XOR prbs(11) ;
					prbs(33) <= prbs(4) XOR prbs(9) XOR prbs(12) ;
					prbs(34) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(5) XOR prbs(10) XOR prbs(12) ;
					prbs(35) <= prbs(0) XOR prbs(3) XOR prbs(6) XOR prbs(11) XOR prbs(12) ;
					prbs(36) <= prbs(0) XOR prbs(2) XOR prbs(4) XOR prbs(7) ;
					prbs(37) <= prbs(1) XOR prbs(3) XOR prbs(5) XOR prbs(8) ;
					prbs(38) <= prbs(2) XOR prbs(4) XOR prbs(6) XOR prbs(9) ;
					prbs(39) <= prbs(3) XOR prbs(5) XOR prbs(7) XOR prbs(10) ;
					prbs(40) <= prbs(4) XOR prbs(6) XOR prbs(8) XOR prbs(11) ;
					prbs(41) <= prbs(5) XOR prbs(7) XOR prbs(9) XOR prbs(12) ;
					prbs(42) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(6) XOR prbs(8) XOR prbs(10) XOR prbs(12) ;
					prbs(43) <= prbs(0) XOR prbs(3) XOR prbs(7) XOR prbs(9) XOR prbs(11) XOR prbs(12) ;
					prbs(44) <= prbs(0) XOR prbs(2) XOR prbs(4) XOR prbs(8) XOR prbs(10) ;
					prbs(45) <= prbs(1) XOR prbs(3) XOR prbs(5) XOR prbs(9) XOR prbs(11) ;
					prbs(46) <= prbs(2) XOR prbs(4) XOR prbs(6) XOR prbs(10) XOR prbs(12) ;
					prbs(47) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(5) XOR prbs(7) XOR prbs(11) XOR prbs(12) ;
					prbs(48) <= prbs(0) XOR prbs(3) XOR prbs(4) XOR prbs(6) XOR prbs(8) ;
					prbs(49) <= prbs(1) XOR prbs(4) XOR prbs(5) XOR prbs(7) XOR prbs(9) ;
					prbs(50) <= prbs(2) XOR prbs(5) XOR prbs(6) XOR prbs(8) XOR prbs(10) ;
					prbs(51) <= prbs(3) XOR prbs(6) XOR prbs(7) XOR prbs(9) XOR prbs(11) ;
					prbs(52) <= prbs(4) XOR prbs(7) XOR prbs(8) XOR prbs(10) XOR prbs(12) ;
					prbs(53) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(5) XOR prbs(8) XOR prbs(9) XOR prbs(11) XOR prbs(12) ;
					prbs(54) <= prbs(0) XOR prbs(3) XOR prbs(6) XOR prbs(9) XOR prbs(10) ;
					prbs(55) <= prbs(1) XOR prbs(4) XOR prbs(7) XOR prbs(10) XOR prbs(11) ;
					prbs(56) <= prbs(2) XOR prbs(5) XOR prbs(8) XOR prbs(11) XOR prbs(12) ;
					prbs(57) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(6) XOR prbs(9) ;
					prbs(58) <= prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(7) XOR prbs(10) ;
					prbs(59) <= prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(8) XOR prbs(11) ;
					prbs(60) <= prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(6) XOR prbs(9) XOR prbs(12) ;
					prbs(61) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(4) XOR prbs(5) XOR prbs(6) XOR prbs(7) XOR prbs(10) XOR prbs(12) ;
					prbs(62) <= prbs(0) XOR prbs(3) XOR prbs(5) XOR prbs(6) XOR prbs(7) XOR prbs(8) XOR prbs(11) XOR prbs(12) ;
					prbs(63) <= prbs(0) XOR prbs(2) XOR prbs(4) XOR prbs(6) XOR prbs(7) XOR prbs(8) XOR prbs(9) ;
					prbs(64) <= prbs(1) XOR prbs(3) XOR prbs(5) XOR prbs(7) XOR prbs(8) XOR prbs(9) XOR prbs(10) ;
					prbs(65) <= prbs(2) XOR prbs(4) XOR prbs(6) XOR prbs(8) XOR prbs(9) XOR prbs(10) XOR prbs(11) ;
					prbs(66) <= prbs(3) XOR prbs(5) XOR prbs(7) XOR prbs(9) XOR prbs(10) XOR prbs(11) XOR prbs(12) ;
					prbs(67) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(4) XOR prbs(6) XOR prbs(8) XOR prbs(10) XOR prbs(11) ;
					prbs(68) <= prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(5) XOR prbs(7) XOR prbs(9) XOR prbs(11) XOR prbs(12) ;
					prbs(69) <= prbs(0) XOR prbs(1) XOR prbs(3) XOR prbs(4) XOR prbs(6) XOR prbs(8) XOR prbs(10) ;
					prbs(70) <= prbs(1) XOR prbs(2) XOR prbs(4) XOR prbs(5) XOR prbs(7) XOR prbs(9) XOR prbs(11) ;
					prbs(71) <= prbs(2) XOR prbs(3) XOR prbs(5) XOR prbs(6) XOR prbs(8) XOR prbs(10) XOR prbs(12) ;
					prbs(72) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(6) XOR prbs(7) XOR prbs(9) XOR prbs(11) XOR prbs(12) ;
					prbs(73) <= prbs(0) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(7) XOR prbs(8) XOR prbs(10) ;
					prbs(74) <= prbs(1) XOR prbs(4) XOR prbs(5) XOR prbs(6) XOR prbs(8) XOR prbs(9) XOR prbs(11) ;
					prbs(75) <= prbs(2) XOR prbs(5) XOR prbs(6) XOR prbs(7) XOR prbs(9) XOR prbs(10) XOR prbs(12) ;
					prbs(76) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(6) XOR prbs(7) XOR prbs(8) XOR prbs(10) XOR prbs(11) XOR prbs(12) ;
					prbs(77) <= prbs(0) XOR prbs(3) XOR prbs(4) XOR prbs(7) XOR prbs(8) XOR prbs(9) XOR prbs(11) ;
					prbs(78) <= prbs(1) XOR prbs(4) XOR prbs(5) XOR prbs(8) XOR prbs(9) XOR prbs(10) XOR prbs(12) ;
					prbs(79) <= prbs(0) XOR prbs(1) XOR prbs(5) XOR prbs(6) XOR prbs(9) XOR prbs(10) XOR prbs(11) XOR prbs(12) ;
					prbs(80) <= prbs(0) XOR prbs(6) XOR prbs(7) XOR prbs(10) XOR prbs(11) ;
					prbs(81) <= prbs(1) XOR prbs(7) XOR prbs(8) XOR prbs(11) XOR prbs(12) ;
					prbs(82) <= prbs(0) XOR prbs(1) XOR prbs(8) XOR prbs(9) ;
					prbs(83) <= prbs(1) XOR prbs(2) XOR prbs(9) XOR prbs(10) ;
					prbs(84) <= prbs(2) XOR prbs(3) XOR prbs(10) XOR prbs(11) ;
					prbs(85) <= prbs(3) XOR prbs(4) XOR prbs(11) XOR prbs(12) ;
					prbs(86) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(4) XOR prbs(5) ;
					prbs(87) <= prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(5) XOR prbs(6) ;
					prbs(88) <= prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(6) XOR prbs(7) ;
					prbs(89) <= prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(7) XOR prbs(8) ;
					prbs(90) <= prbs(4) XOR prbs(5) XOR prbs(6) XOR prbs(8) XOR prbs(9) ;
					prbs(91) <= prbs(5) XOR prbs(6) XOR prbs(7) XOR prbs(9) XOR prbs(10) ;
					prbs(92) <= prbs(6) XOR prbs(7) XOR prbs(8) XOR prbs(10) XOR prbs(11) ;
					prbs(93) <= prbs(7) XOR prbs(8) XOR prbs(9) XOR prbs(11) XOR prbs(12) ;
					prbs(94) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(8) XOR prbs(9) XOR prbs(10) ;
					prbs(95) <= prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(9) XOR prbs(10) XOR prbs(11) ;
					prbs(96) <= prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(10) XOR prbs(11) XOR prbs(12) ;
					prbs(97) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(11) ;
					prbs(98) <= prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(6) XOR prbs(12) ;
					prbs(99) <= prbs(0) XOR prbs(1) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(6) XOR prbs(7) XOR prbs(12) ;
					prbs(100) <= prbs(0) XOR prbs(4) XOR prbs(5) XOR prbs(6) XOR prbs(7) XOR prbs(8) XOR prbs(12) ;
					prbs(101) <= prbs(0) XOR prbs(2) XOR prbs(5) XOR prbs(6) XOR prbs(7) XOR prbs(8) XOR prbs(9) XOR prbs(12) ;
					prbs(102) <= prbs(0) XOR prbs(2) XOR prbs(3) XOR prbs(6) XOR prbs(7) XOR prbs(8) XOR prbs(9) XOR prbs(10) XOR prbs(12) ;
					prbs(103) <= prbs(0) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(7) XOR prbs(8) XOR prbs(9) XOR prbs(10) XOR prbs(11) XOR prbs(12) ;
					prbs(104) <= prbs(0) XOR prbs(2) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(8) XOR prbs(9) XOR prbs(10) XOR prbs(11) ;
					prbs(105) <= prbs(1) XOR prbs(3) XOR prbs(4) XOR prbs(5) XOR prbs(6) XOR prbs(9) XOR prbs(10) XOR prbs(11) XOR prbs(12) ;
					prbs(106) <= prbs(0) XOR prbs(1) XOR prbs(4) XOR prbs(5) XOR prbs(6) XOR prbs(7) XOR prbs(10) XOR prbs(11) ;
					prbs(107) <= prbs(1) XOR prbs(2) XOR prbs(5) XOR prbs(6) XOR prbs(7) XOR prbs(8) XOR prbs(11) XOR prbs(12) ;
					prbs(108) <= prbs(0) XOR prbs(1) XOR prbs(3) XOR prbs(6) XOR prbs(7) XOR prbs(8) XOR prbs(9) ;
					prbs(109) <= prbs(1) XOR prbs(2) XOR prbs(4) XOR prbs(7) XOR prbs(8) XOR prbs(9) XOR prbs(10) ;
					prbs(110) <= prbs(2) XOR prbs(3) XOR prbs(5) XOR prbs(8) XOR prbs(9) XOR prbs(10) XOR prbs(11) ;
					prbs(111) <= prbs(3) XOR prbs(4) XOR prbs(6) XOR prbs(9) XOR prbs(10) XOR prbs(11) XOR prbs(12) ;
					prbs(112) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(4) XOR prbs(5) XOR prbs(7) XOR prbs(10) XOR prbs(11) ;
					prbs(113) <= prbs(1) XOR prbs(2) XOR prbs(3) XOR prbs(5) XOR prbs(6) XOR prbs(8) XOR prbs(11) XOR prbs(12) ;
					prbs(114) <= prbs(0) XOR prbs(1) XOR prbs(3) XOR prbs(4) XOR prbs(6) XOR prbs(7) XOR prbs(9) ;
					prbs(115) <= prbs(1) XOR prbs(2) XOR prbs(4) XOR prbs(5) XOR prbs(7) XOR prbs(8) XOR prbs(10) ;
					prbs(116) <= prbs(2) XOR prbs(3) XOR prbs(5) XOR prbs(6) XOR prbs(8) XOR prbs(9) XOR prbs(11) ;
					prbs(117) <= prbs(3) XOR prbs(4) XOR prbs(6) XOR prbs(7) XOR prbs(9) XOR prbs(10) XOR prbs(12) ;
					prbs(118) <= prbs(0) XOR prbs(1) XOR prbs(2) XOR prbs(4) XOR prbs(5) XOR prbs(7) XOR prbs(8) XOR prbs(10) XOR prbs(11) XOR prbs(12) ;
					prbs(119) <= prbs(0) XOR prbs(3) XOR prbs(5) XOR prbs(6) XOR prbs(8) XOR prbs(9) XOR prbs(11) ;
					prbs(120) <= prbs(1) XOR prbs(4) XOR prbs(6) XOR prbs(7) XOR prbs(9) XOR prbs(10) XOR prbs(12) ;
					prbs(121) <= prbs(0) XOR prbs(1) XOR prbs(5) XOR prbs(7) XOR prbs(8) XOR prbs(10) XOR prbs(11) XOR prbs(12) ;
					prbs(122) <= prbs(0) XOR prbs(6) XOR prbs(8) XOR prbs(9) XOR prbs(11) ;
					prbs(123) <= prbs(1) XOR prbs(7) XOR prbs(9) XOR prbs(10) XOR prbs(12) ;
					prbs(124) <= prbs(0) XOR prbs(1) XOR prbs(8) XOR prbs(10) XOR prbs(11) XOR prbs(12) ;
					prbs(125) <= prbs(0) XOR prbs(9) XOR prbs(11) ;
					prbs(126) <= prbs(1) XOR prbs(10) XOR prbs(12) ;
					prbs(127) <= prbs(0) XOR prbs(1) XOR prbs(11) XOR prbs(12) ;

								
				WHEN "01" =>	-- PRBS 2^23-1 [23,18] (parallel 128bit serializer)
				
					prbs(0) <= prbs(0) XOR prbs(3) XOR prbs(8) XOR prbs(10) XOR prbs(13) XOR prbs(16) XOR prbs(21) ;
					prbs(1) <= prbs(1) XOR prbs(4) XOR prbs(9) XOR prbs(11) XOR prbs(14) XOR prbs(17) XOR prbs(22) ;
					prbs(2) <= prbs(0) XOR prbs(2) XOR prbs(5) XOR prbs(10) XOR prbs(12) XOR prbs(15) ;
					prbs(3) <= prbs(1) XOR prbs(3) XOR prbs(6) XOR prbs(11) XOR prbs(13) XOR prbs(16) ;
					prbs(4) <= prbs(2) XOR prbs(4) XOR prbs(7) XOR prbs(12) XOR prbs(14) XOR prbs(17) ;
					prbs(5) <= prbs(3) XOR prbs(5) XOR prbs(8) XOR prbs(13) XOR prbs(15) XOR prbs(18) ;
					prbs(6) <= prbs(4) XOR prbs(6) XOR prbs(9) XOR prbs(14) XOR prbs(16) XOR prbs(19) ;
					prbs(7) <= prbs(5) XOR prbs(7) XOR prbs(10) XOR prbs(15) XOR prbs(17) XOR prbs(20) ;
					prbs(8) <= prbs(6) XOR prbs(8) XOR prbs(11) XOR prbs(16) XOR prbs(18) XOR prbs(21) ;
					prbs(9) <= prbs(7) XOR prbs(9) XOR prbs(12) XOR prbs(17) XOR prbs(19) XOR prbs(22) ;
					prbs(10) <= prbs(0) XOR prbs(8) XOR prbs(10) XOR prbs(13) XOR prbs(20) ;
					prbs(11) <= prbs(1) XOR prbs(9) XOR prbs(11) XOR prbs(14) XOR prbs(21) ;
					prbs(12) <= prbs(2) XOR prbs(10) XOR prbs(12) XOR prbs(15) XOR prbs(22) ;
					prbs(13) <= prbs(0) XOR prbs(3) XOR prbs(11) XOR prbs(13) XOR prbs(16) XOR prbs(18) ;
					prbs(14) <= prbs(1) XOR prbs(4) XOR prbs(12) XOR prbs(14) XOR prbs(17) XOR prbs(19) ;
					prbs(15) <= prbs(2) XOR prbs(5) XOR prbs(13) XOR prbs(15) XOR prbs(18) XOR prbs(20) ;
					prbs(16) <= prbs(3) XOR prbs(6) XOR prbs(14) XOR prbs(16) XOR prbs(19) XOR prbs(21) ;
					prbs(17) <= prbs(4) XOR prbs(7) XOR prbs(15) XOR prbs(17) XOR prbs(20) XOR prbs(22) ;
					prbs(18) <= prbs(0) XOR prbs(5) XOR prbs(8) XOR prbs(16) XOR prbs(21) ;
					prbs(19) <= prbs(1) XOR prbs(6) XOR prbs(9) XOR prbs(17) XOR prbs(22) ;
					prbs(20) <= prbs(0) XOR prbs(2) XOR prbs(7) XOR prbs(10) ;
					prbs(21) <= prbs(1) XOR prbs(3) XOR prbs(8) XOR prbs(11) ;
					prbs(22) <= prbs(2) XOR prbs(4) XOR prbs(9) XOR prbs(12) ;
					prbs(23) <= prbs(3) XOR prbs(5) XOR prbs(10) XOR prbs(13) ;
					prbs(24) <= prbs(4) XOR prbs(6) XOR prbs(11) XOR prbs(14) ;
					prbs(25) <= prbs(5) XOR prbs(7) XOR prbs(12) XOR prbs(15) ;
					prbs(26) <= prbs(6) XOR prbs(8) XOR prbs(13) XOR prbs(16) ;
					prbs(27) <= prbs(7) XOR prbs(9) XOR prbs(14) XOR prbs(17) ;
					prbs(28) <= prbs(8) XOR prbs(10) XOR prbs(15) XOR prbs(18) ;
					prbs(29) <= prbs(9) XOR prbs(11) XOR prbs(16) XOR prbs(19) ;
					prbs(30) <= prbs(10) XOR prbs(12) XOR prbs(17) XOR prbs(20) ;
					prbs(31) <= prbs(11) XOR prbs(13) XOR prbs(18) XOR prbs(21) ;
					prbs(32) <= prbs(12) XOR prbs(14) XOR prbs(19) XOR prbs(22) ;
					prbs(33) <= prbs(0) XOR prbs(13) XOR prbs(15) XOR prbs(18) XOR prbs(20) ;
					prbs(34) <= prbs(1) XOR prbs(14) XOR prbs(16) XOR prbs(19) XOR prbs(21) ;
					prbs(35) <= prbs(2) XOR prbs(15) XOR prbs(17) XOR prbs(20) XOR prbs(22) ;
					prbs(36) <= prbs(0) XOR prbs(3) XOR prbs(16) XOR prbs(21) ;
					prbs(37) <= prbs(1) XOR prbs(4) XOR prbs(17) XOR prbs(22) ;
					prbs(38) <= prbs(0) XOR prbs(2) XOR prbs(5) ;
					prbs(39) <= prbs(1) XOR prbs(3) XOR prbs(6) ;
					prbs(40) <= prbs(2) XOR prbs(4) XOR prbs(7) ;
					prbs(41) <= prbs(3) XOR prbs(5) XOR prbs(8) ;
					prbs(42) <= prbs(4) XOR prbs(6) XOR prbs(9) ;
					prbs(43) <= prbs(5) XOR prbs(7) XOR prbs(10) ;
					prbs(44) <= prbs(6) XOR prbs(8) XOR prbs(11) ;
					prbs(45) <= prbs(7) XOR prbs(9) XOR prbs(12) ;
					prbs(46) <= prbs(8) XOR prbs(10) XOR prbs(13) ;
					prbs(47) <= prbs(9) XOR prbs(11) XOR prbs(14) ;
					prbs(48) <= prbs(10) XOR prbs(12) XOR prbs(15) ;
					prbs(49) <= prbs(11) XOR prbs(13) XOR prbs(16) ;
					prbs(50) <= prbs(12) XOR prbs(14) XOR prbs(17) ;
					prbs(51) <= prbs(13) XOR prbs(15) XOR prbs(18) ;
					prbs(52) <= prbs(14) XOR prbs(16) XOR prbs(19) ;
					prbs(53) <= prbs(15) XOR prbs(17) XOR prbs(20) ;
					prbs(54) <= prbs(16) XOR prbs(18) XOR prbs(21) ;
					prbs(55) <= prbs(17) XOR prbs(19) XOR prbs(22) ;
					prbs(56) <= prbs(0) XOR prbs(20) ;
					prbs(57) <= prbs(1) XOR prbs(21) ;
					prbs(58) <= prbs(2) XOR prbs(22) ;
					prbs(59) <= prbs(0) XOR prbs(3) XOR prbs(18) ;
					prbs(60) <= prbs(1) XOR prbs(4) XOR prbs(19) ;
					prbs(61) <= prbs(2) XOR prbs(5) XOR prbs(20) ;
					prbs(62) <= prbs(3) XOR prbs(6) XOR prbs(21) ;
					prbs(63) <= prbs(4) XOR prbs(7) XOR prbs(22) ;
					prbs(64) <= prbs(0) XOR prbs(5) XOR prbs(8) XOR prbs(18) ;
					prbs(65) <= prbs(1) XOR prbs(6) XOR prbs(9) XOR prbs(19) ;
					prbs(66) <= prbs(2) XOR prbs(7) XOR prbs(10) XOR prbs(20) ;
					prbs(67) <= prbs(3) XOR prbs(8) XOR prbs(11) XOR prbs(21) ;
					prbs(68) <= prbs(4) XOR prbs(9) XOR prbs(12) XOR prbs(22) ;
					prbs(69) <= prbs(0) XOR prbs(5) XOR prbs(10) XOR prbs(13) XOR prbs(18) ;
					prbs(70) <= prbs(1) XOR prbs(6) XOR prbs(11) XOR prbs(14) XOR prbs(19) ;
					prbs(71) <= prbs(2) XOR prbs(7) XOR prbs(12) XOR prbs(15) XOR prbs(20) ;
					prbs(72) <= prbs(3) XOR prbs(8) XOR prbs(13) XOR prbs(16) XOR prbs(21) ;
					prbs(73) <= prbs(4) XOR prbs(9) XOR prbs(14) XOR prbs(17) XOR prbs(22) ;
					prbs(74) <= prbs(0) XOR prbs(5) XOR prbs(10) XOR prbs(15) ;
					prbs(75) <= prbs(1) XOR prbs(6) XOR prbs(11) XOR prbs(16) ;
					prbs(76) <= prbs(2) XOR prbs(7) XOR prbs(12) XOR prbs(17) ;
					prbs(77) <= prbs(3) XOR prbs(8) XOR prbs(13) XOR prbs(18) ;
					prbs(78) <= prbs(4) XOR prbs(9) XOR prbs(14) XOR prbs(19) ;
					prbs(79) <= prbs(5) XOR prbs(10) XOR prbs(15) XOR prbs(20) ;
					prbs(80) <= prbs(6) XOR prbs(11) XOR prbs(16) XOR prbs(21) ;
					prbs(81) <= prbs(7) XOR prbs(12) XOR prbs(17) XOR prbs(22) ;
					prbs(82) <= prbs(0) XOR prbs(8) XOR prbs(13) ;
					prbs(83) <= prbs(1) XOR prbs(9) XOR prbs(14) ;
					prbs(84) <= prbs(2) XOR prbs(10) XOR prbs(15) ;
					prbs(85) <= prbs(3) XOR prbs(11) XOR prbs(16) ;
					prbs(86) <= prbs(4) XOR prbs(12) XOR prbs(17) ;
					prbs(87) <= prbs(5) XOR prbs(13) XOR prbs(18) ;
					prbs(88) <= prbs(6) XOR prbs(14) XOR prbs(19) ;
					prbs(89) <= prbs(7) XOR prbs(15) XOR prbs(20) ;
					prbs(90) <= prbs(8) XOR prbs(16) XOR prbs(21) ;
					prbs(91) <= prbs(9) XOR prbs(17) XOR prbs(22) ;
					prbs(92) <= prbs(0) XOR prbs(10) ;
					prbs(93) <= prbs(1) XOR prbs(11) ;
					prbs(94) <= prbs(2) XOR prbs(12) ;
					prbs(95) <= prbs(3) XOR prbs(13) ;
					prbs(96) <= prbs(4) XOR prbs(14) ;
					prbs(97) <= prbs(5) XOR prbs(15) ;
					prbs(98) <= prbs(6) XOR prbs(16) ;
					prbs(99) <= prbs(7) XOR prbs(17) ;
					prbs(100) <= prbs(8) XOR prbs(18) ;
					prbs(101) <= prbs(9) XOR prbs(19) ;
					prbs(102) <= prbs(10) XOR prbs(20) ;
					prbs(103) <= prbs(11) XOR prbs(21) ;
					prbs(104) <= prbs(12) XOR prbs(22) ;
					prbs(105) <= prbs(0) XOR prbs(13) XOR prbs(18) ;
					prbs(106) <= prbs(1) XOR prbs(14) XOR prbs(19) ;
					prbs(107) <= prbs(2) XOR prbs(15) XOR prbs(20) ;
					prbs(108) <= prbs(3) XOR prbs(16) XOR prbs(21) ;
					prbs(109) <= prbs(4) XOR prbs(17) XOR prbs(22) ;
					prbs(110) <= prbs(0) XOR prbs(5) ;
					prbs(111) <= prbs(1) XOR prbs(6) ;
					prbs(112) <= prbs(2) XOR prbs(7) ;
					prbs(113) <= prbs(3) XOR prbs(8) ;
					prbs(114) <= prbs(4) XOR prbs(9) ;
					prbs(115) <= prbs(5) XOR prbs(10) ;
					prbs(116) <= prbs(6) XOR prbs(11) ;
					prbs(117) <= prbs(7) XOR prbs(12) ;
					prbs(118) <= prbs(8) XOR prbs(13) ;
					prbs(119) <= prbs(9) XOR prbs(14) ;
					prbs(120) <= prbs(10) XOR prbs(15) ;
					prbs(121) <= prbs(11) XOR prbs(16) ;
					prbs(122) <= prbs(12) XOR prbs(17) ;
					prbs(123) <= prbs(13) XOR prbs(18) ;
					prbs(124) <= prbs(14) XOR prbs(19) ;
					prbs(125) <= prbs(15) XOR prbs(20) ;
					prbs(126) <= prbs(16) XOR prbs(21) ;
					prbs(127) <= prbs(17) XOR prbs(22) ;

	
					
				WHEN "10"	=>  -- PRBS 2^31-1 [31,28] (parallel 128bit serializer)
				
					prbs(0) <= prbs(12) XOR prbs(15) XOR prbs(24) XOR prbs(27);
					prbs(1) <= prbs(13) XOR prbs(16) XOR prbs(25) XOR prbs(28);
					prbs(2) <= prbs(14) XOR prbs(17) XOR prbs(26) XOR prbs(29);
					prbs(3) <= prbs(15) XOR prbs(18) XOR prbs(27) XOR prbs(30);
					prbs(4) <= prbs(0) XOR prbs(16) XOR prbs(19);
					prbs(5) <= prbs(1) XOR prbs(17) XOR prbs(20);
					prbs(6) <= prbs(2) XOR prbs(18) XOR prbs(21);
					prbs(7) <= prbs(3) XOR prbs(19) XOR prbs(22);
					prbs(8) <= prbs(4) XOR prbs(20) XOR prbs(23);
					prbs(9) <= prbs(5) XOR prbs(21) XOR prbs(24);
					prbs(10) <= prbs(6) XOR prbs(22) XOR prbs(25);
					prbs(11) <= prbs(7) XOR prbs(23) XOR prbs(26);
					prbs(12) <= prbs(8) XOR prbs(24) XOR prbs(27);
					prbs(13) <= prbs(9) XOR prbs(25) XOR prbs(28);
					prbs(14) <= prbs(10) XOR prbs(26) XOR prbs(29);
					prbs(15) <= prbs(11) XOR prbs(27) XOR prbs(30);
					prbs(16) <= prbs(0) XOR prbs(12);
					prbs(17) <= prbs(1) XOR prbs(13);
					prbs(18) <= prbs(2) XOR prbs(14);
					prbs(19) <= prbs(3) XOR prbs(15);
					prbs(20) <= prbs(4) XOR prbs(16);
					prbs(21) <= prbs(5) XOR prbs(17);
					prbs(22) <= prbs(6) XOR prbs(18);
					prbs(23) <= prbs(7) XOR prbs(19);
					prbs(24) <= prbs(8) XOR prbs(20);
					prbs(25) <= prbs(9) XOR prbs(21);
					prbs(26) <= prbs(10) XOR prbs(22);
					prbs(27) <= prbs(11) XOR prbs(23);
					prbs(28) <= prbs(12) XOR prbs(24);
					prbs(29) <= prbs(13) XOR prbs(25);
					prbs(30) <= prbs(14) XOR prbs(26);
					prbs(31) <= prbs(15) XOR prbs(27);
					prbs(32) <= prbs(16) XOR prbs(28);
					prbs(33) <= prbs(17) XOR prbs(29);
					prbs(34) <= prbs(18) XOR prbs(30);
					prbs(35) <= prbs(0) XOR prbs(19) XOR prbs(28);
					prbs(36) <= prbs(1) XOR prbs(20) XOR prbs(29);
					prbs(37) <= prbs(2) XOR prbs(21) XOR prbs(30);
					prbs(38) <= prbs(0) XOR prbs(3) XOR prbs(22) XOR prbs(28);
					prbs(39) <= prbs(1) XOR prbs(4) XOR prbs(23) XOR prbs(29);
					prbs(40) <= prbs(2) XOR prbs(5) XOR prbs(24) XOR prbs(30);
					prbs(41) <= prbs(0) XOR prbs(3) XOR prbs(6) XOR prbs(25) XOR prbs(28);
					prbs(42) <= prbs(1) XOR prbs(4) XOR prbs(7) XOR prbs(26) XOR prbs(29);
					prbs(43) <= prbs(2) XOR prbs(5) XOR prbs(8) XOR prbs(27) XOR prbs(30);
					prbs(44) <= prbs(0) XOR prbs(3) XOR prbs(6) XOR prbs(9);
					prbs(45) <= prbs(1) XOR prbs(4) XOR prbs(7) XOR prbs(10);
					prbs(46) <= prbs(2) XOR prbs(5) XOR prbs(8) XOR prbs(11);
					prbs(47) <= prbs(3) XOR prbs(6) XOR prbs(9) XOR prbs(12);
					prbs(48) <= prbs(4) XOR prbs(7) XOR prbs(10) XOR prbs(13);
					prbs(49) <= prbs(5) XOR prbs(8) XOR prbs(11) XOR prbs(14);
					prbs(50) <= prbs(6) XOR prbs(9) XOR prbs(12) XOR prbs(15);
					prbs(51) <= prbs(7) XOR prbs(10) XOR prbs(13) XOR prbs(16);
					prbs(52) <= prbs(8) XOR prbs(11) XOR prbs(14) XOR prbs(17);
					prbs(53) <= prbs(9) XOR prbs(12) XOR prbs(15) XOR prbs(18);
					prbs(54) <= prbs(10) XOR prbs(13) XOR prbs(16) XOR prbs(19);
					prbs(55) <= prbs(11) XOR prbs(14) XOR prbs(17) XOR prbs(20);
					prbs(56) <= prbs(12) XOR prbs(15) XOR prbs(18) XOR prbs(21);
					prbs(57) <= prbs(13) XOR prbs(16) XOR prbs(19) XOR prbs(22);
					prbs(58) <= prbs(14) XOR prbs(17) XOR prbs(20) XOR prbs(23);
					prbs(59) <= prbs(15) XOR prbs(18) XOR prbs(21) XOR prbs(24);
					prbs(60) <= prbs(16) XOR prbs(19) XOR prbs(22) XOR prbs(25);
					prbs(61) <= prbs(17) XOR prbs(20) XOR prbs(23) XOR prbs(26);
					prbs(62) <= prbs(18) XOR prbs(21) XOR prbs(24) XOR prbs(27);
					prbs(63) <= prbs(19) XOR prbs(22) XOR prbs(25) XOR prbs(28);
					prbs(64) <= prbs(20) XOR prbs(23) XOR prbs(26) XOR prbs(29);
					prbs(65) <= prbs(21) XOR prbs(24) XOR prbs(27) XOR prbs(30);
					prbs(66) <= prbs(0) XOR prbs(22) XOR prbs(25);
					prbs(67) <= prbs(1) XOR prbs(23) XOR prbs(26);
					prbs(68) <= prbs(2) XOR prbs(24) XOR prbs(27);
					prbs(69) <= prbs(3) XOR prbs(25) XOR prbs(28);
					prbs(70) <= prbs(4) XOR prbs(26) XOR prbs(29);
					prbs(71) <= prbs(5) XOR prbs(27) XOR prbs(30);
					prbs(72) <= prbs(0) XOR prbs(6);
					prbs(73) <= prbs(1) XOR prbs(7);
					prbs(74) <= prbs(2) XOR prbs(8);
					prbs(75) <= prbs(3) XOR prbs(9);
					prbs(76) <= prbs(4) XOR prbs(10);
					prbs(77) <= prbs(5) XOR prbs(11);
					prbs(78) <= prbs(6) XOR prbs(12);
					prbs(79) <= prbs(7) XOR prbs(13);
					prbs(80) <= prbs(8) XOR prbs(14);
					prbs(81) <= prbs(9) XOR prbs(15);
					prbs(82) <= prbs(10) XOR prbs(16);
					prbs(83) <= prbs(11) XOR prbs(17);
					prbs(84) <= prbs(12) XOR prbs(18);
					prbs(85) <= prbs(13) XOR prbs(19);
					prbs(86) <= prbs(14) XOR prbs(20);
					prbs(87) <= prbs(15) XOR prbs(21);
					prbs(88) <= prbs(16) XOR prbs(22);
					prbs(89) <= prbs(17) XOR prbs(23);
					prbs(90) <= prbs(18) XOR prbs(24);
					prbs(91) <= prbs(19) XOR prbs(25);
					prbs(92) <= prbs(20) XOR prbs(26);
					prbs(93) <= prbs(21) XOR prbs(27);
					prbs(94) <= prbs(22) XOR prbs(28);
					prbs(95) <= prbs(23) XOR prbs(29);
					prbs(96) <= prbs(24) XOR prbs(30);
					prbs(97) <= prbs(0) XOR prbs(25) XOR prbs(28);
					prbs(98) <= prbs(1) XOR prbs(26) XOR prbs(29);
					prbs(99) <= prbs(2) XOR prbs(27) XOR prbs(30);
					prbs(100) <= prbs(0) XOR prbs(3);
					prbs(101) <= prbs(1) XOR prbs(4);
					prbs(102) <= prbs(2) XOR prbs(5);
					prbs(103) <= prbs(3) XOR prbs(6);
					prbs(104) <= prbs(4) XOR prbs(7);
					prbs(105) <= prbs(5) XOR prbs(8);
					prbs(106) <= prbs(6) XOR prbs(9);
					prbs(107) <= prbs(7) XOR prbs(10);
					prbs(108) <= prbs(8) XOR prbs(11);
					prbs(109) <= prbs(9) XOR prbs(12);
					prbs(110) <= prbs(10) XOR prbs(13);
					prbs(111) <= prbs(11) XOR prbs(14);
					prbs(112) <= prbs(12) XOR prbs(15);
					prbs(113) <= prbs(13) XOR prbs(16);
					prbs(114) <= prbs(14) XOR prbs(17);
					prbs(115) <= prbs(15) XOR prbs(18);
					prbs(116) <= prbs(16) XOR prbs(19);
					prbs(117) <= prbs(17) XOR prbs(20);
					prbs(118) <= prbs(18) XOR prbs(21);
					prbs(119) <= prbs(19) XOR prbs(22);
					prbs(120) <= prbs(20) XOR prbs(23);
					prbs(121) <= prbs(21) XOR prbs(24);
					prbs(122) <= prbs(22) XOR prbs(25);
					prbs(123) <= prbs(23) XOR prbs(26);
					prbs(124) <= prbs(24) XOR prbs(27);
					prbs(125) <= prbs(25) XOR prbs(28);
					prbs(126) <= prbs(26) XOR prbs(29);
					prbs(127) <= prbs(27) XOR prbs(30);

					
--				WHEN "11"  => -- Clock pattern
--					
--					--prbs(127 downto 0)	<= X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
--					--prbs(127 downto 0)	<= X"AAFF00AAAAAAAAAAAAAAAAAAAAAAAAAA";	
--					-- counter pattern 
--					--prbs <= X"0123456789ABCDEF00000000FFFFFFFF";
--					-- clock pattern (ok for transmit but receiver does not lock on this)
--					prbs(127 downto 0)	<= X"0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F"; 
--					

					
				WHEN OTHERS => NULL;

				END CASE;
			end if; -- Enable
		  end if;
		end if;
	end process;

process(coreclk)
	begin
	if rising_edge(coreclk) then
		if (Reset_dupA2 = '1') then
				tx_data <= X"07070707070707070707070707070707";
				Valid_min1 <= '0';

				detect_inserterror <= '0';	
				count_deskew <= (OTHERS => '0');
				deskew_pulse <= '0';
				delayed_error <= '0';
				inserterror_q <= '0';

		else

				

				inserterror_q <= inserterror_synchro;

				
				-- Generate deskew pulse
				
				if (count_deskew = "11") then
					deskew_pulse <= '1';
					count_deskew <= (OTHERS => '0');
				else
					deskew_pulse <= '0';
					count_deskew <= count_deskew + 1;
				end if;
				
				if (inserterror_q /= inserterror_synchro) and (inserterror_synchro = '1') then
					detect_inserterror <= '1';
				else
					detect_inserterror <= '0';
				end if;
				
			if Enable = '1' then 
					--CountPattern <= CountPattern + 1;

					if delayed_error = '1' then
						delayed_error <= '0';
					end if;	
				if detect_inserterror = '1' or delayed_error = '1' then 
					report "==========================================================================================================> Inserted one bit error in Tx data ..." severity note;
					tx_data <= (not prbs(127)) & prbs(126 downto 0);			-- insert One biterror
					--tx_data <= (not prbs(127 downto 121) & prbs(120 downto 0) );			-- insert 7 biterrors	
					--tx_data <= (not prbs(127 downto 64) & prbs(63 downto 0) );			-- insert 64 biterrors	
					--tx_data <= (not prbs(127 downto 1) & prbs(0) );			-- insert 127 biterrors	
					--tx_data <= (not prbs(127 downto 0));			-- insert 128 biterrors	
				else
					tx_data <= prbs(127 downto 0);
					--tx_data <= tx_data + 1;
				end if;
				Valid_min1 <= '1';
			else
					if detect_inserterror = '1' then
						delayed_error <= '1';
					end if;					
					tx_data <= X"07070707070707070707070707070707";
					Valid_min1 <= '0';
			end if;

		
		end if;
		end if;
	end process;
	
	process(coreclk)
	begin
		if rising_edge(coreclk) then		
			SwapMSB_With_LSB:
			FOR i IN 0 to 127 LOOP
				tx_data_sig(i) <= tx_data(127-i);
			END LOOP SwapMSB_With_LSB;		
			
		

		 Valid <= Valid_min1;	
		
		end if;
	end process;
	
Prbsout <= tx_data_sig;

		
			
end;


