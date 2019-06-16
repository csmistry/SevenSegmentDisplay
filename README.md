# Seven Segment Display

This project was completed using an Altera FPGA along with Quartus Prime software used for compilation, simulation and hardware programming of the code.

Project Overview:

The purpose of this project is to take inputs from onboard switches and display the result on two seven segement displays. 
Each switch can input a binary 0 or 1 while represent the binary placeholder. (i.e switch[0] is 2^0, switch[1] is 2^1 etc.)
Switches [7..4] will control the first seven segement display, while the remaining switches [3..0] control the second display.

Input from the switches is in binary, and the displayed result will be the hexadecimal equivalent. 
Push buttons [2..0] are used to display the result of a logical operation. 

Logical operations occur between the two operands on the seven segement displays. Logical AND, OR and XOR are processed in the ALU and the result is displayed in binary on the onboard LEDs. 

Arithmetic Add between the operands can be performed when push button [3] is pressed. Arithmetic is performed in the 4-bit Adder and displayed on the seven segement displays
