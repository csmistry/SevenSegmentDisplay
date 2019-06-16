library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab2_top is port (
   clkin_50			: in	std_logic;
	pb				: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds				: out std_logic_vector(7 downto 0); -- for displaying the switch content
   seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
   seg7_char1  		: out	std_logic;				    -- seg7 digit1 selector
   seg7_char2  		: out	std_logic				    -- seg7 digit2 selector
	
); 
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is
--
-- Components Used ---
------------------------------------------------------------------- 
  component SevenSegment port (
   hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   ); 
   end component;
	
	component segment7_mux port(
		clk: in std_logic := '0';
		DIN2: in std_logic_vector(6 downto 0);
		DIN1: in std_logic_vector(6 downto 0);
		DOUT: out std_logic_vector(6 downto 0);
		DIG2: out std_logic;
		DIG1: out std_logic
	);
	end component;
	
	component section1_mux port(
		hexAB 		: in  std_logic_vector(7 downto 0); -- concatenated hex_A and hex_B input
		hex_sum		: in  std_logic_vector(7 downto 0); -- 8 bit sum from 4 bit adder 
		push3		: in  std_logic;					-- Push Button [3..0] for control
		push2		: in  std_logic;
		push1		: in  std_logic;
		push0		: in  std_logic;
		hex_out 	: out std_logic_vector(7 downto 0)	-- Either hexAB or hex_sum is connected depending on push button state
		);
	end component;
	
	component Bit4Adder port(
		hexA 		: in  std_logic_vector(3 downto 0);  
		hexB		: in  std_logic_vector(3 downto 0); 
		sum_out 	: out std_logic_vector(7 downto 0) 	-- 8 bit sum of inputs hexA and hexB
	);
	end component;
	
	component ALU port(
	hexA		: in  std_logic_vector(3 downto 0);		
	hexB		: in  std_logic_vector(3 downto 0);
	push2		: in  std_logic;						-- Using push buttons [2..0] as control for logical operations
	push1		: in  std_logic;
	push0		: in  std_logic;
	ALU_out 	: out std_logic_vector(3 downto 0)		-- 4 bit result of logical operation, either one of (AND, OR, XOR)
	);
	end component; 
	
	component LED_mux port(
	hex_combine		: in  std_logic_vector(7 downto 0);	-- 4 bit logical operation result concatenated with "0000" (total 8 bit input)
	sum_led			: in  std_logic_vector(7 downto 0); -- 8 bit sum from 4 bit adder
	push3			: in  std_logic;				-- Push Button [3..0] input to control mux output
	push2			: in  std_logic;
	push1			: in  std_logic;
	push0			: in  std_logic;
	led_out 		: out std_logic_vector(7 downto 0) -- Either 8 bit sum for arthmetic result or 8 bit logical operation result dependent on state of Push button [3]
	);
	end component;
	
-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--
------ Push Button inputs [3..0]  -------
	signal pb3 			: std_logic;
	signal pb2 			: std_logic;
	signal pb1 			: std_logic;
	signal pb0 			: std_logic;
------ 4 Bit inputs from switches -------
	signal hex_A		: std_logic_vector(3 downto 0);
	signal hex_B		: std_logic_vector(3 downto 0);
------ 7 bit output of SevenSegment decoder
	signal seg7_A		: std_logic_vector(6 downto 0); 
	signal seg7_B		: std_logic_vector(6 downto 0);
	
	signal hex_concat : std_logic_vector(7 downto 0);	-- 8 bits consisting of 4 bit hex_A concatenated with 4 bit hex_B
	signal sum 			: std_logic_vector(7 downto 0); -- arithmetic sum result from 4 bit adder
	signal hexOUT		: std_logic_vector(7 downto 0); -- output of section1_mux 
	signal ALUout 		: std_logic_vector(3 downto 0); -- output of ALU (logical operation result)
	signal led_concat : std_logic_vector(7 downto 0); 	-- 8 bits consisting of "0000" concatenated with 4-bit ALU logical operation result
	signal led_display: std_logic_vector(7 downto 0);	-- signal to carry 8 bit data to control LED's
	

------ Here the circuit begins --------

begin

	hex_A <= sw(7 downto 4); -- 4 bit input from switches [7..4]
	hex_B <= sw(3 downto 0); -- 4 bit input from switches [3..0]

-- Assigning push buttons [3..0] to push button signals 
	pb3 <= pb(3);
	pb2 <= pb(2);
	pb1 <= pb(1);
	pb0 <= pb(0);
	
	hex_concat <= hex_A & hex_B;   -- concatenating 4 bit switch inputs for section1_mux
	led_concat <= "0000" & ALUout; -- concatenating ALU result for LED_mux
	leds <= led_display;    	  
	
--------- COMPONENT HOOKUP ---------

-- generate the seven segment coding
	INST1: SevenSegment port map(hexOUT(7 downto 4), seg7_A); -- split 8 bit output of section1_mux (4 bits per seven segement decoder)
	INST2: SevenSegment port map(hexOUT(3 downto 0), seg7_B);
	
-- mapping generated seven segment coding to seven segement displays 
	INST3: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data, seg7_char1, seg7_char2);

-- select what is to be displayed on seven segement displays
	INST4: section1_mux port map(hex_concat, sum, pb3, pb2, pb1, pb0, hexOUT);
	
-- generate arthmetic sum output of two 4 bit inputs 
	INST5: Bit4Adder port map(hex_A, hex_B, sum);
	
-- generate logical operation output
	INST6: ALU port map(hex_A, hex_B, pb2, pb1, pb0, ALUout);

-- display arthmetic result or result of logical operation
	INST7: LED_mux port map(led_concat, sum, pb3, pb2, pb1, pb0, led_display);
	

end SimpleCircuit; 