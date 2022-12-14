----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2022 11:11:56
-- Design Name: 
-- Module Name: E_puerta - Behavioral
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

entity E_puerta is
    Port ( RESET_N : in STD_LOGIC;
           E_motor_puerta : in STD_LOGIC_VECTOR (1 downto 0);
           CLK : in STD_LOGIC;
           boton_espera : out STD_LOGIC_VECTOR (1 downto 0));
end E_puerta;

architecture Behavioral of E_puerta is
signal boton_wait: std_logic_vector (1 downto 0):="01"; 
begin
process (clk, reset_n)
    begin 
        if reset_n= '0' then 
            boton_wait <= "10";--pulsando boton
        elsif rising_edge (clk) then
            if E_motor_puerta = "00" then 
            boton_wait <= boton_wait; --abrir puerta 
			elsif E_motor_puerta = "01" then
				boton_wait <= "01"; --cierrar puerta; 
			elsif E_motor_puerta <= "10"  then
				boton_wait <= "10";--se ha pulsado el boton cuando ya se está abriendo la puerta
			end if;
		end if;
	end process;
    
    boton_espera <= boton_wait;

end Behavioral;
