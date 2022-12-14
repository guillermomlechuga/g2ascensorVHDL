----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2022 10:51:00
-- Design Name: 
-- Module Name: motor_ascensor - Behavioral
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

entity motor_ascensor is
    Port ( RESET_N : in STD_LOGIC;
           CLK : in STD_LOGIC;
           signal_ascensor : in STD_LOGIC_VECTOR (1 downto 0);
           motor_ascensor : out STD_LOGIC_VECTOR (1 downto 0));
end motor_ascensor;

architecture Behavioral of motor_ascensor is

begin
process (clk, RESET_N)
    begin
        if RESET_N = '0' then
            motor_ascensor <= "00";--motor stdby
        elsif rising_edge (clk ) then --flanco 
            if (signal_ascensor = "10" ) then  --Subir
            	motor_ascensor <= "10";--motor subiendo
        	elsif (signal_ascensor = "01") then--bajar
        		motor_ascensor <= "01";--motor bajando
    		else
    			motor_ascensor <= "00";--motor stdby
		    end if;
        end if;
	end process; 

end Behavioral;
