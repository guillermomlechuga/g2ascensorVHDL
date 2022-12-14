----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2022 10:45:59
-- Design Name: 
-- Module Name: motor_puerta - Behavioral
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

entity motor_puerta is
    Port ( CLK : in STD_LOGIC;
           signal_puerta : in STD_LOGIC_VECTOR (1 downto 0);
           motor_puerta : out STD_LOGIC_VECTOR (1 downto 0));
end motor_puerta;

architecture Behavioral of motor_puerta is

begin
process (clk)
    begin 
        if rising_edge (clk) then
            if signal_puerta = "10" then --abrir
                motor_puerta <= "10"; -- motor abre
            elsif signal_puerta ="01" then --cerrar
                 motor_puerta <= "01"; --motor cierra
            elsif signal_puerta = "00" then 
                motor_puerta <="00"; -- stdby
                
            end if;
         end if;
     end process;

end Behavioral;
