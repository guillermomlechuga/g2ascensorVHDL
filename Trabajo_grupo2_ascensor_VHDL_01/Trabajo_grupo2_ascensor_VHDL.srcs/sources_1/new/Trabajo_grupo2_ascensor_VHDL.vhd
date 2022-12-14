----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2022 10:32:54
-- Design Name: 
-- Module Name: decoder_planta - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder_planta is
    Port ( CLK : in STD_LOGIC;
           boton_planta : in STD_LOGIC_VECTOR (6 downto 0);
           planta : out STD_LOGIC_VECTOR (2 downto 0));
end decoder_planta;

architecture Behavioral of decoder_planta is

begin
process(clk)
begin 
    if rising_edge(clk) then --flanco subida reloj
        case boton_planta is
                when "0000001" => planta <= "001"; 
                when "0000010" => planta <= "010"; 
                when "0000100" => planta <= "011"; 
                when "0001000" => planta <= "100";
                when "0010000" => planta <= "101";
                when "0100000" => planta <= "110";   
                when "1000000" => planta <= "111";
                when others =>  planta <= "000";
         end case;
      end if;
end process;

end Behavioral;
