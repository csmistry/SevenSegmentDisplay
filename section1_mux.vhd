library ieee;
use ieee.std_logic_1164.all;

-- This multiplexer selects the appropriate signal based on the state of push button [3]
--
entity section1_mux is port (
	hexAB 		: in  std_logic_vector(7 downto 0);
	hex_sum		: in  std_logic_vector(7 downto 0);
	push3		: in  std_logic;
	push2		: in  std_logic;
	push1		: in  std_logic;
	push0		: in  std_logic;
	hex_out 	: out std_logic_vector(7 downto 0)
);

end section1_mux;

architecture sec1_logic of section1_mux is 

signal c : std_logic_vector(3 downto 0);

-- send switch input or arthmetic sum or "88" to SevenSegement Decorders 
begin 
c <= (push3 & push2 & push1 & push0);
with c select hex_out <= hexAB when "1111", -- display switch inputs
			  hexAB when "1110",
			  hexAB when "1101",
			  hexAB when "1011",
			  hex_sum when "0111",			-- display sum when pb[3] is ON
			  "10001000" when others; 		-- display "88" when more than one push buttons are pressed
end sec1_logic;


