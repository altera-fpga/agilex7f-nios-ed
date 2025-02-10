library ieee;
use ieee.std_logic_1164.all;


 PACKAGE package_registertype IS

           type   Register_Array_16bit	 is array (0 to 3) of std_logic_vector(15 downto 0); 
			  type   Register_Array_32bit	 is array (0 to 3) of std_logic_vector(31 downto 0);
			  type   Register_Array_21bit	 is array (0 to 3) of std_logic_vector(20 downto 0);
			  type   Register_Array_4bit	 is array (0 to 3) of std_logic_vector(3 downto 0);			  
			  type   Register_Array_64bit	 is array (0 to 3) of std_logic_vector(63 downto 0);
			  type   Register_Array_128bit	 is array (0 to 3) of std_logic_vector(127 downto 0);			  
			  
 END package_registertype ;



