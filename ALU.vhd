library ieee;
use ieee.std_logic_1164.all;

-- The Logic processor will compute logical operations on given input data when either one of push buttons [2..0] are ON.

entity ALU is port (
	hexA		: in  std_logic_vector(3 downto 0);
	hexB		: in  std_logic_vector(3 downto 0);
	push2		: in  std_logic;
	push1		: in  std_logic;
	push0		: in  std_logic;
	ALU_out 	: out std_logic_vector(3 downto 0)  -- 4 bit logical operation result
);

end ALU;

architecture ALU_logic of ALU is 

signal c : std_logic_vector(2 downto 0); -- control signal to select output of MUX
-- The following statement executes one of logical (AND, OR, XOR) operations on two 4 bit inputs, when the corresponding push button is ON.
--
begin 
c <= (push2 & push1 & push0);			
with c select ALU_out <= (hexA AND hexB) when "110",	-- AND when pb[0] is ON
						 (hexA OR hexB) when "101",		-- OR when pb[1] is ON
						 (hexA XOR hexB) when "011",	-- XOR when pb[2] is ON
						 "0000" when "111",				-- all LEDs OFF
						 "1111" when others;			-- all LEDS ON
	
end ALU_logic;