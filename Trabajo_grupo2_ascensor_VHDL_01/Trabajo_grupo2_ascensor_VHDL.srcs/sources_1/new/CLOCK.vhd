----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2022 11:02:41
-- Design Name: 
-- Module Name: CLOCK - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLOCK_DIVIDER is

 Generic (
        frecuencia: integer:=50000000 );  
        
    Port ( RESET_N : in STD_LOGIC;
           CLOCK : in STD_LOGIC;
           CLK : out STD_LOGIC);
end CLOCK_DIVIDER;

architecture Behavioral of CLOCK_DIVIDER is
SIGNAL clk_signal: STD_LOGIC;
begin
process (reset_n, clock)
    variable count: integer;
    
    begin
    if(reset_n='0')   then
        count := 0;
        clk_signal<='0';
    elsif rising_edge(clock)  then
        if (count = frecuencia)   then
            count := 0;
            clk_signal<=not (clk_signal);
        else 
            count := count + 1;
        end if;
    end if;
    end process;
    
clk <= clk_signal;

end Behavioral;
