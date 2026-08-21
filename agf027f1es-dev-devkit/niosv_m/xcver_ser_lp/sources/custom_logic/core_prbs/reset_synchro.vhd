------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2007-2022 Intel Corporation
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

entity reset_synchro is
port
	(
	clk			: in std_logic;
	reset_in		: in std_logic;
	reset_out	: out std_logic
	);
end;


architecture rtl of reset_synchro is

signal synchro : std_logic_vector(4 downto 0) := (OTHERS => '1');

begin

-- Assert asynchronously
process(clk,reset_in)
begin
	if (reset_in = '1') then
		reset_out	 	<= '1';
		synchro			<= (OTHERS => '1');
	elsif rising_edge(clk) then
		synchro		<= synchro(3 downto 0) & (reset_in);
		reset_out	<= synchro(4);
	end if;
end process;

end;