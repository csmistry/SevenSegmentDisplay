library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Bit4Adder is port (
	hexA 		: in  std_logic_vector(3 downto 0);
	hexB		: in  std_logic_vector(3 downto 0);
	sum_out 	: out std_logic_vector(7 downto 0)
);

end Bit4Adder;

architecture Adder of Bit4Adder is 

-- internal signals used to generate arithmetic sum output
signal add_inpA :  std_logic_vector(7 downto 0);
signal add_inpB :  std_logic_vector(7 downto 0);
signal sum_internal : std_logic_vector(7 downto 0);


begin 
	add_inpA <= ("0000" & hexA); -- concatenating to achieve 8 bits for unsigned integer casting
	add_inpB <= ("0000" & hexB);
	sum_internal <= std_logic_vector(unsigned(add_inpA) + unsigned(add_inpB)); -- computing arithmetic sum
	sum_out <= sum_internal; -- result of arithmetic sum
	
end Adder;
 