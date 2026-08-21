------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2017-2022 Intel Corporation
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

entity synchronizer is
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
end;

architecture rtl of synchronizer is


component synchro is
port
	(
	clk			: in std_logic;
	data_in		: in std_logic;
	data_out		: out std_logic
	);
end component;



begin

Generate_Synchro_bus:
FOR i IN 0 to BUS_WIDTH-1 GENERATE
synchro_x: synchro PORT MAP (
		clk	 	=> clk,
		data_in	=> data_in(i),
		data_out => data_out(i)
	);
END GENERATE;

						
		
end;