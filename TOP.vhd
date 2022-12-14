----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2022 11:13:40
-- Design Name: 
-- Module Name: TOP - Behavioral
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

entity TOP is
    Port ( RESET_N : in STD_LOGIC;
           DETECTA_PERSONA : in STD_LOGIC;
           BOTON_FISICO_TOP : in STD_LOGIC;
           BOTON_PLANTA : in STD_LOGIC_VECTOR (6 downto 0);
           CLK : in STD_LOGIC;
           PANTALLA : out STD_LOGIC_VECTOR (6 downto 0);
           LUZ_PUERTA : out STD_LOGIC;
           LUZ_MOTOR : out STD_LOGIC);
end TOP;

architecture structural of TOP is

    signal Hz60: std_logic;
    signal Hz1: std_logic;
    signal Hz2: std_logic; 
    
    --FSM
    signal boton_espera_FSM_TOP : std_logic_vector (1 downto 0);
    signal planta_actual_FSM_TOP : std_logic_vector (2 downto 0);
    signal planta_FSM_TOP: std_logic_vector (2 downto 0);
    signal signal_puerta_FSM_TOP : std_logic_vector (1 downto 0);  
    signal signal_ascensor_FSM_TOP: std_logic_vector (1 downto 0);   
    signal destino_planta_TOP : std_logic_vector (2 downto 0);
     signal signal_ascensor_TOP : std_logic_vector(1 downto 0);
     signal signal_puerta_TOP : std_logic_vector(1 downto 0);
   
    --Inputs
    signal motor_puerta_TOP : std_logic_vector (1 downto 0);
    signal motor_ascensor_TOP: std_logic_vector (1 downto 0);
    --Outputs
    signal planta_TOP : std_logic_vector (6 downto 0);
    
    COMPONENT DISPLAY
    PORT (
        RESET_N : in std_logic;
        CLK: in std_logic;
        planta_actual : in std_logic_vector (2 downto 0);
        LED : OUT STD_LOGIC_VECTOR (6 downto 0)
        
        );
    END COMPONENT;        
    
    COMPONENT CLOCK_DIVIDER
    GENERIC (frecuencia: integer := 50000000 );
    PORT ( 
        CLOCK     : in std_logic;
        RESET_N  : in std_logic;
        CLK: out std_logic
        );
    END COMPONENT;
    
    COMPONENT FSM
    PORT (
        CLK : in std_logic; 
        RESET_N: in std_logic;
        boton_espera_FSM : in std_logic_vector (1 downto 0);
        boton_fisico_FSM : in std_logic; 
        detecta_persona : in std_logic;
        planta_FSM: in std_logic_vector (2 downto 0);
        planta_actual_FSM : in std_logic_vector (2 downto 0);
        destino_planta : out std_logic_vector (2 downto 0);
        signal_ascensor_FSM: out std_logic_vector (1 downto 0);
        signal_puerta_FSM: out std_logic_vector (1 downto 0)
       );
    END COMPONENT;
    
    COMPONENT motor_puerta
    PORT (
        CLK : in std_logic;
        signal_puerta: in std_logic_vector (1 downto 0);
        motor_puerta: out std_logic_vector (1 downto 0)
        );
    END COMPONENT;
    
    COMPONENT motor_ascensor
    PORT (
        CLK: in std_logic;
        RESET_N: in std_logic;
        signal_ascensor : in std_logic_vector (1 downto 0);
        motor_ascensor : out std_logic_vector (1 downto 0)
        );
    END COMPONENT;

    COMPONENT E_PUERTA 
    PORT (
        E_motor_puerta : in std_logic_vector (1 downto 0);
        CLK : in std_logic;
        RESET_N : in std_logic;
        boton_espera: out std_logic_vector (1 downto 0)
        );
    END COMPONENT;

    COMPONENT E_PLANTA
    PORT (
        subir_bajar : in std_logic_vector (1 downto 0);
        CLK : in std_logic;        
        RESET_N : in std_logic;
        planta : out std_logic_vector (6 downto 0)
        );
    END COMPONENT;

    COMPONENT decoder_planta
    PORT (
        boton_planta: in std_logic_vector (6 downto 0);
        planta : out std_logic_vector (2 downto 0);
        CLK : in std_logic
        );
    END COMPONENT;

begin

    clock_divider1: CLOCK_DIVIDER
    GENERIC MAP ( frecuencia => 100000000 )
    PORT MAP (
        clock => clk,
        clk => Hz1,     
        reset_n => reset_n
        );
        
    clock_divider2:     CLOCK_DIVIDER
    GENERIC MAP ( frecuencia => 200000000 )
    PORT MAP (
        clock => clk,
        clk => Hz2,     
        reset_n => reset_n
        );
        
    clock_divider60:     CLOCK_DIVIDER
    GENERIC MAP ( frecuencia => 62500 )
    PORT MAP (
        clock => clk,
        clk => Hz60,     
        reset_n => reset_n
        );

                
    display_map:  display 
    PORT MAP (
        clk => Hz60,
        RESET_N => reset_n,
        planta_actual=> planta_actual_FSM_TOP,
        LED => pantalla
        );                       
                
    fsm_map:  FSM
    PORT MAP (
        clk => Hz60,
        reset_n => reset_n,
        planta_FSM => planta_FSM_TOP,
        destino_planta => destino_planta_TOP,
        boton_espera_FSM =>boton_espera_FSM_TOP,
        planta_actual_FSM =>planta_actual_FSM_TOP,
        boton_fisico_FSM=> BOTON_FISICO_TOP,
        detecta_persona => DETECTA_PERSONA,
        signal_ascensor_FSM => signal_ascensor_TOP,
        signal_puerta_FSM => signal_puerta_TOP
        );
        
    motor_puerta_map:  motor_puerta
    PORT MAP ( 
        clk => Hz60,
        signal_puerta => signal_puerta_TOP,
        motor_puerta => signal_puerta_FSM_TOP
        );
        
    motor_ascensor_map : motor_ascensor
    PORT MAP (
        clk=> Hz60,
        reset_n => reset_n,
        signal_ascensor => signal_ascensor_TOP,
        motor_ascensor => motor_ascensor_TOP
        );            

    E_PLANTA_MAP : E_PLANTA
    PORT MAP (
        CLK => Hz1,
        RESET_N => reset_n,
        subir_bajar =>motor_ascensor_TOP,
        planta => planta_TOP
        );

    E_PUERTA_MAP : E_PUERTA
    PORT MAP (
        CLK => Hz2,
        RESET_N => reset_n,
        E_motor_puerta => signal_puerta_FSM_TOP,
        boton_espera=> boton_espera_FSM_TOP
        );

    decoder_planta_MAP : decoder_planta
    PORT MAP (
        boton_planta => boton_planta,
        CLK => Hz60,
        planta => planta_FSM_TOP
        );

    decoder_planta_MAP2 :decoder_planta
    PORT MAP (
        CLK => Hz60,
        boton_planta => planta_TOP,
        planta => planta_actual_FSM_TOP
        );
end structural;
