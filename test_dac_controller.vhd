library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity test_dac_controlller is
  port ( CLK   : in  std_logic;
         RST   : in  std_logic;
         SW    : in  std_logic_vector(11 downto 0);
         SW_OK : in  std_logic;
         SYNC  : out std_logic;
         SCLK  : out std_logic;
         DIN : out std_logic);

end test_dac_controlller;

architecture Behavioral of test_dac_controlller is
  signal SW_OK_REG, LOAD : std_logic;

begin
  process (CLK, RST)
  begin
    if RST = '1' then
      LOAD      <= '0';
      SW_OK_REG <= '0';
    elsif CLK'event and CLK = '1' then
      SW_OK_REG <= SW_OK;
      LOAD      <= (not SW_OK_REG) and SW_OK;
    end if;
  end process;


  U_DAC : entity work.dac_controller
    port map (
      CLK     => CLK,
      RST     => RST,
      DOUT    => SW,
      DOUT_OK => LOAD,
      SYNC    => SYNC,
      SCLK    => SCLK,
      DIN   => DIN);

end Behavioral;
