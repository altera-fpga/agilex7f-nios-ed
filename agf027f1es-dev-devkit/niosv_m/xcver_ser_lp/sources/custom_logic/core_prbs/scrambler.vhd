------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2011-2022 Intel Corporation
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

-- VHDL converted from Gregg Baecklers descrambler in verilog

-- Self Synchronizing scrambler : The polynomial used for the scrambler is 1 + x^39 + x^58 according to the IEEE.


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity scrambler is
GENERIC
(
	WIDTH  : integer range 0 to 512 :=64
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
END scrambler;
  
architecture rtl of scrambler is

signal scram_state 		: std_logic_vector(57 downto 0);
signal history			: std_logic_vector(WIDTH+58-1 downto 0);
signal dout_r 			: std_logic_vector(WIDTH-1 downto 0);

begin

history(57 downto 0) <= scram_state;

Generate_history:
FOR i IN 58 to WIDTH+58-1 GENERATE
	history(i) <= history(i-58) xor history(i-39) xor din(i-58);
end generate;

--process(clk,arst)
--begin
--	if arst = '1' then
--		dout 			<= (OTHERS => '0');
--		scram_state 	<= (OTHERS => '1');
--	elsif rising_edge(clk) then
--		if ena = '1' then
--			dout 		<= history(WIDTH+58-1 downto 58);
--			scram_state <= history(WIDTH+58-1 downto WIDTH);
--		end if;
--	end if;
--end process;


process(clk)
begin
	if rising_edge(clk) then
	if srst = '1' then
		--dout_r 			<= (OTHERS => '0');
		dout_r 			<= din;		
		scram_state 	<= (OTHERS => '1');
	else	
		if ena = '1' then
			dout_r 		<= history(WIDTH+58-1 downto 58);
			scram_state <= history(WIDTH+58-1 downto WIDTH);
		end if;
	end if;
	end if;
end process;

dout <= dout_r when (use_scrambler = '1') else din;

end;
		
