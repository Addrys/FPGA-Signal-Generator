library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity f_meter is
  port(
    CLK      : in  std_logic;
    RST      : in  std_logic;
    F_OUT    : in  std_logic;
    F_MED_OK : out std_logic;
    F_MED    : out std_logic_vector(15 downto 0));
end f_meter;

architecture rtl2 of f_meter is
    --declaracion de variables o señales que usaremos en todo el programa
    signal contador_BCD_out : std_logic_vector(15 downto 0);
    signal prescaler_out : std_logic;
    signal contador : unsigned(31 downto 0);
    signal t_puerta : integer;
begin  -- rtl
    t_puerta <= 100000;
    --Contador BCD, con F_OUT como CE, (solo está activo 10ms por período)
    process(all)
    --declaracion de señales o variables del proceso
    begin
        if(RST = '1') then
            contador_BCD_out <= (others => '0');
        elsif(CLK'Event and CLK = '1') then
            if(prescaler_out = '1') then
                contador_BCD_out <= (others => '0');
            elsif(F_OUT = '1') then
                for  i in 0 to 3 loop
                    if(unsigned(contador_BCD_out((3 + 4*i) downto (i*4))) < 9) then
                        contador_BCD_out((3+ 4*i) downto (i*4)) <= std_logic_vector((unsigned(contador_BCD_out((3+ 4*i) downto (i*4))) + 1));
                        exit;
                    else
                        contador_BCD_out((3+ 4*i) downto (i*4)) <= "0000";
                    end if;
                        
                end loop;
                    
            end if;
        end if;
    end process;
    
    --Prescaler, para validar el dato 
    process(all)     
    begin
        if(RST = '1') then
            contador <= (others => '0');
            prescaler_out <= '0';
        elsif(CLK'Event and CLK = '1') then
            contador <= contador + 1;
            if(contador = t_puerta) then --10e8 en el real
                contador <= (others => '0');
                prescaler_out <= '1';
            else
                prescaler_out <= '0';
            end if; 
        end if;
    end process;
    
    --Registro
    process(all)
    begin
        if(Rst = '1') then
            F_MED <= (others => '0');
        elsif(CLK'Event and CLK = '1') then
            if(prescaler_out = '1') then
                F_MED <= contador_BCD_out;
            end if;
        end if;
    end process;
    
    --biestable
    process(all)
    begin
        if ( RST = '1') then
            F_MED_OK <= '0';
        elsif(CLK'Event and CLK = '1') then
            F_MED_OK <= prescaler_out;
        end if;
    end process;
end rtl2;
