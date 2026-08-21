------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2006-2022 Intel Corporation
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

entity counter_1ms is
GENERIC
	(
		BITRATE	: std_logic_vector(19 downto 0) :=	X"1E848"  --(125000)
	);
port
	(
	RefClock		: in	std_logic;
	reset			: in	std_logic;
	count_1ms		: buffer std_logic_vector(31 downto 0)
	);
end;

architecture rtl of counter_1ms is

signal count_words	:std_logic_vector(33 downto 0);


begin

	process(RefClock,reset)
	begin
		if reset = '1' then
			count_1ms <= (OTHERS => '0');
			count_words <= (OTHERS => '0');
		elsif rising_edge(RefClock) then
			if count_words = (BITRATE-1) then -- (125000 -1)
			
				count_words <= (OTHERS => '0');
				count_1ms <= count_1ms + 1;
			else
				count_words <= count_words + 1;
			end if;
		end if;
	end process;
									
		
end;