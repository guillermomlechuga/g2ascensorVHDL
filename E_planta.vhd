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
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity E_PLANTA is
    Port ( RESET_N : in STD_LOGIC;
           CLK : in STD_LOGIC;
            SUBIR_BAJAR : in STD_LOGIC_VECTOR (1 downto 0);
           PLANTA : out STD_LOGIC_VECTOR (6 downto 0));
end E_PLANTA;

architecture Behavioral of E_PLANTA is
signal p_actual : std_logic_vector (2 downto 0):="001";
begin
process (CLK, RESET_N) -- este process asigna la planta actual
begin
if reset_n = '0' then
			p_actual <= "001";
		elsif rising_edge (clk) then
			if SUBIR_BAJAR = "10" and p_actual /= "111" then-- subir
				p_actual <= p_actual +1;--hemos subido una planta
			elsif SUBIR_BAJAR = "01" and p_actual /= "001" then--bajar
				p_actual <= p_actual -1 ;--hemos bajado una planta
			elsif SUBIR_BAJAR ="00" then p_actual<=p_actual; -- no nos movemos
			end if;
		end if;
	end process;
	
	process (p_actual)  -- este process transforma planta actual en la salida planta
	begin
		case (p_actual) is
			when "001" => 
				PLANTA <= "0000001"; -- piso 1
			when "010" => 
				PLANTA <= "0000010"; --piso 2
			when "011" => 
				PLANTA <= "0000100"; --piso 3
			when "100" => 
				PLANTA <= "0001000"; --piso 4
			when "101" => 
				PLANTA <= "0010000"; --piso 5
			when "110" => 
				PLANTA <= "0100000"; --piso 6
			when "111" => 
				PLANTA <= "1000000"; --piso 7	
            when others => 
                PLANTA <= "0000000"; --stdby
                
		end case;
	end process;
end Behavioral;


