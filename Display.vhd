----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2022 10:59:56
-- Design Name: 
-- Module Name: Display - Behavioral
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

entity Display is
    Port ( RESET_N : in STD_LOGIC;
           CLK : in STD_LOGIC;
           PLANTA_ACTUAL : in STD_LOGIC_VECTOR (2 downto 0);
           LED : out STD_LOGIC_VECTOR (6 downto 0));
end Display;

architecture Behavioral of Display is

signal numero : std_logic_vector (6 downto 0):="1111111";  

begin

    process (reset_n, clk)
    begin
        if reset_n = '0' then
            numero <= "0000000"; -- se enciende todo.  
        elsif rising_edge (clk) then
                case (planta_actual) is
                    when "001" =>
                        numero <= "1001111";   --numero 1
                    when "010" =>
                        numero <= "0010010";   --numero 2
                    when "011" =>
                        numero <= "0000110";   --numero 3
                    when "100" =>
                        numero <= "1001100";   --numero 4
                    when "101" =>
                        numero <= "0100100";   --numero 5
                    when "110" =>
                        numero <= "0100000";   --numero 6
                    when "111" =>
                        numero <= "0001111";   --numero 7
                    when others =>
                        numero <= "1111110";   --espera
                end case;
           end if;
                         
    end process;

    led <= numero;

end Behavioral;
