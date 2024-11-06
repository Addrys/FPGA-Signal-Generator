library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cnt_display is
  port (
    CLK         : in  std_logic;
    RST         : in  std_logic;
    DATO_BCD    : in  std_logic_vector(15 downto 0);
    DATO_BCD_OK : in  std_logic;
    AND_30      : out std_logic_vector(3 downto 0);
    DP          : out std_logic;
    SEG_AG      : out std_logic_vector(6 downto 0));
end cnt_display;

architecture rtl of cnt_display is
  signal DATO_BCD_OUT : std_logic_vector(15 downto 0);
  signal DATO_BCD_FORMATEADO : std_logic_vector(15 downto 0);
  signal CONTADOR_CE : std_logic;
  --signal CONTADOR : unsigned(1 downto 0);
  signal MUX_OUT : std_logic_vector(3 downto 0);
  signal cuenta : unsigned(16 downto 0); --Dimensionado para el valor maximo de cuenta, que es 10e5.
  signal CTE_DISP : unsigned(16 downto 0);
begin  -- rtl
  -- CTE_DISP <= d"100"; -- para simulacion
   CTE_DISP <= d"100000";   -- para implementacion
  DP <= '1'; --Lo mantenemos apagado permanentemente.

  --Registro de entrada
  process(all)
  begin
    if RST = '1' then
      DATO_BCD_OUT <= (Others => '0');
    elsif (CLK'event and CLK = '1') then
      if (DATO_BCD_OK = '1') then
        Dato_BCD_out <= Dato_BCD;
      end if;
    end if;
  end process;

  --CCombinacional que pone los valores adecuados
  -- 'L' -> x"B"
  -- ' ' -> x"C"
  process(all)
  variable ceroIzq : boolean;
  variable indice : Integer range 0 to 16;
  variable dato : unsigned (3 downto 0);
  variable datofinal : unsigned (15 downto 0);
  variable fail : boolean;
  begin
    fail := false;
    ceroIzq := true;
    datofinal := (Others => '0');
    for i in 3 downto 0 loop
      if(not fail) then
        dato := unsigned(Dato_BCD_out((i*4+3) downto (i*4)));
        datofinal((i*4+3) downto (i*4)) := dato;
        if(dato > 9) then 
        datofinal := x"FA1B"; -- FAIL
        exit;
        elsif(ceroIzq and i /= 0) then
          if(dato = 0) then
            datofinal((i*4+3) downto (i*4)) := x"C"; -- Lo apagamos
          else
            ceroIzq := false;
          end if;
        end if;
      end if;
      
    end loop;
      Dato_BCD_formateado <= std_logic_vector(datofinal);
    end process;
  
    --Prescaler
    process(all)
    begin
      if(RST = '1') then
        cuenta <= (others => '0');
      elsif(CLK'Event and CLK = '1') then
        cuenta <= cuenta + 1;
        if ( cuenta = 100000) then
          CONTADOR_CE <= '1';
          cuenta <= (Others => '0');
        else
          CONTADOR_CE <= '0';
        end if;
      end if;
    end process;
/*
    --Contador
    process(all)

    begin
      if(RST = '1') then
        CONTADOR<= (others => '0');
      elsif(CLK'Event and CLK = '1') then
        if(CONTADOR_CE = '1') then
          CONTADOR <= CONTADOR + 1; -- se resetea solo al ser unsigned y llegar al overflow.
          if(CONTADOR = "11") then
            CONTADOR <= "00";
          end if;
        end if;
      end if;
    end process;

    --Decodificador
    process(all)

    begin
      case CONTADOR is
        when "00" => AND_30 <= "1110";    --Display 1
        when "01" => AND_30 <= "1101";    --Display 2
        when "10" => AND_30 <= "1011";    --Display 3
        when others => AND_30 <= "0111";  --Display 4
      end case;
    end process;
    --MUX
    process(all)

    begin
      MUX_OUT <= DATO_BCD_FORMATEADO(((to_integer(CONTADOR)*4 )+ 3) downto (to_integer(CONTADOR)*4));
    end process;
*/

    --Contador + Decodificador -> AND_30 driver
    process(all)
    begin
      if(RST = '1') then
        AND_30<= "0111";
      elsif(CLK'Event and CLK = '1') then
        if(CONTADOR_CE = '1') then
          AND_30 <= AND_30 rol 1;
        end if;
      end if;
    end process;

    --MUX One Hot encoding
    process(all)

    begin
      MUX_OUT <= (Others => '0');
      for i in 3 downto 0 loop
        if(AND_30(i) = '0') then
          MUX_OUT <= DATO_BCD_FORMATEADO(((i*4)+ 3) downto (i*4));
        end if;
      end loop;
    end process;


    --Decodificador
    process(all)
    begin
      case MUX_OUT is
        when x"0" => SEG_AG <= "1000000";
        when x"1" => SEG_AG <= "1111001";
        when x"2" => SEG_AG <= "0100100";
        when x"3" => SEG_AG <= "0110000";
        when x"4" => SEG_AG <= "0011001";
        when x"5" => SEG_AG <= "0010010";
        when x"6" => SEG_AG <= "0000010";
        when x"7" => SEG_AG <= "1111000";
        when x"8" => SEG_AG <= "0000000";
        when x"9" => SEG_AG <= "0011000";
        when x"A" => SEG_AG <= "0001000";
        when x"B" => SEG_AG <= "1000111"; --Representa la L en el BCD para el display
        when x"F" => SEG_AG <= "0001110";
        when others => SEG_AG <= "1111111"; --Represente al apagado 
      end case;
    end process;
  end rtl;


