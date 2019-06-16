library ieee;
use ieee.std_logic_1164.all;

-- This multiplexer selects the appropriate signal bases on the state of push button [3]

entity LED_mux is port (
	hex_combine		: in  std_logic_vector(7 downto 0);
	sum_led			: in  std_logic_vector(7 downto 0);
	push3			: in  std_logic;
	push2			: in  std_logic;
	push1			: in  std_logic;
	push0			: in  std_logic;
	led_out 		: out std_logic_vector(7 downto 0)
);

end LED_mux;

architecture LED_logic of LED_mux is 

signal c : std_logic_vector(3 downto 0);  -- control signal to select output of MUX

begin 
c <= (push3 & push2 & push1 &push0);
with c select 
	led_out <= sum_led when "0111",			-- sum when pb[3] is ON
			   hex_combine when "1110",		-- normal switch inputs when pb[2..0] are ON
			   hex_combine when "1101",
			   hex_combine when "1011",
			   "00000000" when "1111",		-- all leds off when pb[3..0] are OFF
			   "11111111" when others;		-- Error condition, to turn on all leds when 2 or more pb's are pressed
	
end LED_logic;



