
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

--Se encarga de decodificar el dato recibido por el puerto serie(Dato_RX) y generar los datos a enviar al DAC
entity signal_generator is
  port ( RST        : in  std_logic;
         CLK        : in  std_logic;
         DATO_RX    : in  std_logic_vector (7 downto 0);
         DATO_RX_OK : in  std_logic;
         DOUT       : out std_logic_vector (11 downto 0);
         F_OUT      : out std_logic;
         DOUT_OK    : out std_logic);
end signal_generator;

architecture rtl of signal_generator is
    signal frecuencia : std_logic_vector(5 downto 0);
    signal ganancia : std_logic_vector(3 downto 0);
    signal dc : std_logic_vector(11 downto 0);
    signal tipo_signal : std_logic_vector( 2 downto 0);
    signal address : std_logic_vector (7 downto 0);
    signal contador : std_logic_vector (19 downto 0);
    --signal pulso_contador : std_logic;
    signal DOUT_sin_saturacion : std_logic_vector(12 downto 0);
    signal forma_onda : std_logic_vector(7 downto 0);
    signal forma_seno : std_logic_vector(7 downto 0);

begin

    --proceso que captura los parametros de la señal a generar
    process(all)
    begin
    
        if(RST = '1') then
            --valores iniciales de las salidas DOUT señal seno, frec = 100hz, ganancia = 3, DC = 0.
            frecuencia <= "001001"; -- 95 < f < 6000 -- F aprox 860hz, con estos valores
            ganancia <= "0011";
            dc <= (others => '0');
            tipo_signal <= "110";
            
           -- forma_onda <= (others => '0');
        elsif(CLK'Event and CLK = '1')then
            if(DATO_RX_OK = '1') then
                case DATO_RX(7 downto 6) is
                    when "01" => frecuencia <= DATO_RX(5 downto 0);
                    when "10" => ganancia <= DATO_RX (3 downto 0);
                    when "11" => dc(11 downto 6) <= DATO_RX (5 downto 0);
                    when others => tipo_signal <= DATO_RX(2 downto 0);
                end case;
            end if;
        end if;
    end process;

    --generador de direcciones
    -- fvout = (F/2**20)Fclk.  Fclk = 100Mhz real, 100Khz simulacion.  95hz < Fvoout < 6Khz
    
    process(all)
    begin
        if(RST = '1') then
            contador <= (others => '0');
        elsif(CLK'Event and CLK = '1')then
            contador <= std_logic_vector(unsigned(contador) + unsigned(frecuencia));
            
        end if;
    end process;
    
     --truncador
     process(all)
     begin
        if(RST = '1') then
            address <= (others => '0');
        elsif(CLK'Event and CLK = '1') then
            --if(address /= contador(19 downto 12)) then
                  address <= contador(19 downto 12);
                  --pulso_contador <= '1';
             -- else
                 --pulso_contador <= '0';
            -- end if;
        end if;
     end process;
     
    --sistema secuencial, usando cada cambio en address para generar F_OUT y DOUT_OK
    process(all)
    begin
        if ( RST = '1') then
            DOUT_OK <= '0';
            F_OUT <= '0';
        elsif(CLK'event and CLK = '1') then
            DOUT_OK <= '0';
            F_OUT <= '0';
            if(address(7)= '0' and contador(19) = '1') then
                F_OUT <= '1';
            end if;
            
            if(address(0) /= contador(12)) then
                DOUT_OK <= '1';
            end if;
        end if;
    
    
    end process;
    
    --generacion de las formas de onda (combinacional) -- con forma_onda
    process(all)
    begin
         forma_onda <= (others => '0');
        case tipo_signal is
            when "110" => --seno
                forma_onda <= forma_seno;
            when  "101" => --triangular
                forma_onda <= address sll 1;
                if(address(7) = '1') then
                    forma_onda <= std_logic_vector("11111111" - unsigned(address sll 1));
                end if;
                --forma_onda <= forma_seno;
            when "100" => --diente sierras
                forma_onda <=  address sll 1; --equivalente a multiplicar por 2
            when "011" => --cuadrada D = 50%
                if(address(7) = '1') then
                    forma_onda <= (others => '1');
                end if;
               -- forma_onda <= address;
            when "010" => -- cuadrada D=25%
                if(address(7)='1' and address(6)='1') then
                    forma_onda <= (others => '1');
                end if;
            when "001" => -- cuadradaD=75%
                if( address(7)='1' or address(6)='1') then
                     forma_onda <= (others => '1');
                 end if;
            when others => 
                forma_onda <= (others => '0');
        end case;
                
        
    end process;
    
    DOUT_sin_saturacion <= std_logic_vector(unsigned('0' & forma_onda) * unsigned(ganancia) + unsigned(dc));
   
    with DOUT_sin_saturacion(12) select
        DOUT <=
            (Others => '1') when '1',
            DOUT_sin_saturacion(11 downto 0) when others;
    
    --DOUT <= forma_onda;
    U1 : entity work.seno
        port map(
            ADDR => address,
            CLK => CLK,
            DOUT => forma_seno);
end;
