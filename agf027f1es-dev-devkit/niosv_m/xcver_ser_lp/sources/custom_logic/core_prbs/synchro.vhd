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

entity synchro is
port
	(
	Clk			: in std_logic;
	data_in		: in std_logic;
	data_out		: out std_logic
	);
end;


architecture rtl of synchro is

signal Synchro_reg : std_logic_vector(4 downto 0) := (OTHERS => '0');

begin

process(Clk)
begin
if rising_edge(Clk) then
		Synchro_reg		<= Synchro_Reg(3 downto 0) & (data_in);
		data_out			<= Synchro_Reg(4);
end if;
end process;

end;