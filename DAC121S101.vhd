library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity DAC121S101 is

  port (
    VOUT : out real range 0.0 to 3.5;
    SYNC : in  std_logic;
    SCLK : in  std_logic;
    DIN  : in  std_logic);
end DAC121S101;
architecture sim of DAC121S101 is

  signal reg_desp : std_logic_vector(15 downto 0) := (others => '0');
  signal dato_bin : std_logic_vector(11 downto 0) := (others => '0');
  signal cuenta   : natural;


begin

  -- Modelado de funcionamiento.

  process (all)
  begin
    if SYNC = '1' then
      cuenta     <= 0;
      reg_desp   <= (others => '0');
    elsif SCLK'event and SCLK = '0' then
      if cuenta < 16 then
        cuenta   <= cuenta+1;
        reg_desp <= reg_desp(14 downto 0)&DIN;
      end if;
    end if;
  end process;

  process (all)
  begin
    if (SYNC = '0') and (cuenta = 16) then
      dato_bin <= reg_desp(11 downto 0);
    end if;
  end process;

  VOUT <= real(to_integer(unsigned(dato_bin)))*3.3/4096.0;

end sim;
