library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity display is
  port(
    SEG_AG : in std_logic_vector(6 downto 0);  -- gfedcba
    AND_30 : in std_logic_vector(3 downto 0));
end display;

architecture rtl of display is

  signal Data     : character;
  signal Displays : string(4 downto 1) := "----";

begin  -- 

  process (SEG_AG) is
  begin
    case SEG_AG is
      when "1000000" => Data <= '0';
      when "1111001" => Data <= '1';
      when "0100100" => Data <= '2';
      when "0110000" => Data <= '3';
      when "0011001" => Data <= '4';
      when "0010010" => Data <= '5';
      when "0000010" => Data <= '6';
      when "1111000" => Data <= '7';
      when "0000000" => Data <= '8';
      when "0011000" => Data <= '9';
      when "0001110" => Data <= 'F';
      when "0001000" => Data <= 'A';
      when "1001111" => Data <= 'I';
      when "1000111" => Data <= 'L';
      when "1111111" => Data <= ' ';
      when others    => Data <= 'x';
    end case;
  end process;


  process (AND_30, Data) is
  begin

    case AND_30 is
      when "1110" =>
        Displays(1) <= Data;
      when "1101" =>
        Displays(2) <= Data;
      when "1011" =>
        Displays(3) <= Data;
      when "0111" =>
        Displays(4) <= Data;
      when others => null;
    end case;
  end process;

end;
