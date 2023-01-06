library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 use ieee.std_logic_arith.ALL;
 use ieee.std_logic_unsigned.ALL;

entity FSM is
PORT (
   RESET_N : in std_logic;
   CLK : in std_logic; 
   planta_FSM: in std_logic_vector(2 downto 0); 
   planta_actual_FSM:in std_logic_vector(2 downto 0);
   boton_fisico_FSM:in std_logic;
   boton_espera_FSM: in std_logic_vector(1 downto 0); --10 abierto, 01 cerrado, 00 stdby
   signal_ascensor_FSM: out std_logic_vector(1 downto 0);--10 subir, 01 bajar,00 stdby
   signal_puerta_FSM: out std_logic_vector(1 downto 0);--10 abrir,01 cerrar
   destino_planta: out std_logic_vector(2 downto 0)
   );
end FSM;

architecture Behavioral of FSM is
type STATES is (inicio,marcha,espera,abrir,cerrar);
signal current_state : STATES:=inicio;
signal next_state : STATES;
shared variable destino_i: std_logic_vector(2 downto 0):="001";-- variable donde se queda el valor del piso al que queremos ir

begin
decoder_state: process(CLK,RESET_N)--cambiar el estado en el que estamos
begin
 if RESET_N ='0' then
  current_state<=inicio;
 elsif rising_edge(CLK) then 
  current_state<=next_state; -- todavía no tenemos valor de next state
 end if;
end process;

decoder_next_state: process(current_state,planta_FSM,planta_actual_FSM,boton_fisico_FSM,boton_espera_FSM)--cambiamos el proximo estado en funcion de las entradas
begin
next_state <= current_state; -- lo inicializamos para que no de errores
 
 case current_state is
      when inicio=>
        if planta_actual_FSM="001" and boton_espera_FSM ="01" then  -- estamos en el piso uno y la pueta esta cerrada
            next_state<=abrir;
        end if;
       when abrir=>
        if boton_espera_FSM="10" then --esta abierta las puertas 
            destino_i:=(others=>'0'); --si ya hemos llegado al piso y hemos abierto las puertas
            next_state<=espera;
        end if;
        when espera=>
            if planta_FSM /= "000" and planta_actual_FSM/= planta_FSM then --si pulsas un boton y no es en el que estas
              -- destino_i:=planta_FSM;--guardamos el piso pulsado
                next_state<=cerrar;
            end if;
        when cerrar=>
            if boton_fisico_FSM='1' then --mientras que cirra entra alguien
                next_state<=abrir; --si viene alguien volvemos a abrir
                elsif boton_espera_FSM ="01" then --la puerta haya terminado de cerrarse
                next_state<=marcha;
            end if;
         when marcha=>
            destino_i:=planta_FSM;
            if destino_i=planta_actual_FSM then --si estamos en el piso al que queremos ir 
                next_state<=abrir;
            end if;
      end case;
end process;

movimiento_motor :process(current_state,boton_espera_FSM)
begin
case current_state is
    when inicio =>
        --piso_actual<="001";--inicializamos al piso 1
        if boton_espera_FSM/="01" then -- puertas cerradas
            signal_puerta_FSM<="01";--mandamos la señal de abrir
        end if;
        if planta_actual_FSM /= "001" and boton_espera_FSM="01" then --si no estamos en la primera y las puertas estan cerradas 
            signal_ascensor_FSM<="01"; --bajamos hasta estar en la planta 1
            signal_puerta_FSM<="00";-- las puertas no se mueven, el ascensor esta en marcha
         else --si estamos en la planta 1 y las puertas abiertas
            signal_ascensor_FSM<="00";
            signal_puerta_FSM<="00"; --no movemos puertas ni motor
         end if;
         
     when marcha =>
     		
				if (destino_i > planta_actual_FSM) then--quiero subir
					signal_ascensor_FSM <= "10";	-- señal Subir
				elsif (destino_i < planta_actual_FSM ) then --quiero bajar
					signal_ascensor_FSM <= "01"; 	-- señal Bajar
				else
					signal_ascensor_FSM <= "00"; 	--stdby
				end if;		
				signal_puerta_FSM <= "00";	--mantenemos el estado de cerrado 

			when abrir => 
				signal_puerta_FSM <= "10"; 		--Abrir puerta
				signal_ascensor_FSM <=  "00"; 		       --motor en stdby mientras se abre la puerta

			when cerrar => 
				signal_puerta_FSM <= "01";	     --Cerrar puerta;
				signal_ascensor_FSM <= "00";		     --motor en stdby mientras se cierra la puerta

			when espera => 
				signal_puerta_FSM <= "00"; 	--Puerta stdby
				signal_ascensor_FSM<= "00";  --motor stdby

			when others => 	--Por defecto stdby
				signal_ascensor_FSM <= "00";
				signal_puerta_FSM <= "00";
		end case;
end process;
destino_planta<=destino_i;
      
end Behavioral;
