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

entity prbsgenerate_10bit is
PORT(
	coreclk  	: in std_logic;
	Reset	 	: in std_logic;
	Prbsout 	: out std_logic_vector(9 downto 0)
	);
END prbsgenerate_10bit;	


architecture rtl of prbsgenerate_10bit is


signal prbs 			: std_logic_vector(31 downto 0);
signal tx_data 			: std_logic_vector(9 downto 0);



begin

	

process(coreclk)
begin				
		if rising_edge(coreclk) then	
			if (Reset = '1') then
					prbs <= (others=>'1');
					tx_data <= "1010101010";	
			else		
				-- CASE PrbsSelect IS			
					-- WHEN "00" =>		-- PRBS 2^7-1 (parallel 10bit serializer) (T[7,6])
						-- prbs(0) <= prbs(2) xor prbs(4);
						-- prbs(1) <= prbs(3) xor prbs(5) ;
						-- prbs(2) <= prbs(4) xor prbs(6) ;
						-- prbs(3) <= prbs(0) xor prbs(5) xor prbs(6) ;
						-- prbs(4) <= prbs(0) xor prbs(1) ;
						-- prbs(5) <= prbs(1) xor prbs(2) ;
						-- prbs(6) <= prbs(2) xor prbs(3) ;
						-- prbs(7) <= prbs(3) xor prbs(4);
						-- prbs(8) <= prbs(4) xor prbs(5);
						-- prbs(9) <= prbs(5) xor prbs(6);		
									
					-- WHEN "01" =>	-- PRBS 2^23-1 [23,18] (parallel 10bit serializer)
						-- prbs(0) <= prbs(0) xor prbs(13) xor prbs(18);
						-- prbs(1) <= prbs(1) xor prbs(14) xor prbs(19);
						-- prbs(2) <= prbs(2) xor prbs(15) xor prbs(20);
						-- prbs(3) <= prbs(3) xor prbs(16) xor prbs(21);
						-- prbs(4) <= prbs(4) xor prbs(17) xor prbs(22);
						-- prbs(5) <= prbs(0) xor prbs(18);
						-- prbs(6) <= prbs(1) xor prbs(19);
						-- prbs(7) <= prbs(2) xor prbs(20);
						-- prbs(8) <= prbs(3) xor prbs(21);
						-- prbs(9) <= prbs(4) xor prbs(22);
						-- prbs(22 downto 10) <= prbs(12 downto 0);
						
					-- WHEN "10"	=>  -- PRBS 2^31-1 [31,28] (parallel 10bit serializer)
						prbs(0) <= prbs(18) XOR prbs(21) ;
						prbs(1) <= prbs(19) XOR prbs(22) ;
						prbs(2) <= prbs(20) XOR prbs(23) ;
						prbs(3) <= prbs(21) XOR prbs(24) ;
						prbs(4) <= prbs(22) XOR prbs(25) ;
						prbs(5) <= prbs(23) XOR prbs(26) ;
						prbs(6) <= prbs(24) XOR prbs(27) ;
						prbs(7) <= prbs(25) XOR prbs(28) ;
						prbs(8) <= prbs(26) XOR prbs(29) ;
						prbs(9) <= prbs(27) XOR prbs(30) ;
						prbs(31 downto 10) <= prbs(21 downto 0);
						
	
						tx_data <= prbs(9 downto 0);
						
			end if;
		end if;
end process;



Prbsout <= tx_data;		
			
end;


