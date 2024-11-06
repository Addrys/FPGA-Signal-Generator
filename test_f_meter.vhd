library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_f_meter is
  port (
    CLK    : in  std_logic;
    RST    : in  std_logic;
    DATO   : in  std_logic_vector(12 downto 0);
    LED    : out std_logic_vector(12 downto 0);
    AND_30 : out std_logic_vector(3 downto 0);
    DP     : out std_logic;
    SEG_AG : out std_logic_vector(6 downto 0));
end test_f_meter;

architecture rtl of test_f_meter is

  constant CTE      : natural := 10010;  --10kHz
  signal   CNT      : integer range 0 to CTE-1;
  signal   CNT_PROG : unsigned(12 downto 0);
  signal   ce       : std_logic;
  signal   F_OUT    : std_logic;
  signal   F_MED_OK : std_logic;
  signal   F_MED    : std_logic_vector(15 downto 0);

begin  -- rtl
  LED <= dato;

  process (all)
  begin
    if RST = '1' then
      CNT   <= 0;
      ce    <= '0';
    elsif CLK'event and CLK = '1' then
      if CNT = CTE-1 then
        CNT <= 0;
        ce  <= '1';
      else
        CNT <= CNT+1;
        ce  <= '0';
      end if;
    end if;
  end process;


  process (all)
  begin
    if RST = '1' then
      CNT_PROG     <= (others => '0');
      F_OUT        <= '0';
    elsif CLK'event and CLK = '1' then
      F_OUT        <= '0';
      if ce = '1' then
        if CNT_PROG = unsigned(DATO)-1 then
          CNT_PROG <= (others => '0');
          F_OUT    <= '1';
        else
          CNT_PROG <= CNT_PROG +1;
        end if;
      end if;
    end if;
  end process;

  U1 : entity work.f_meter
    port map (
      CLK      => CLK,
      RST      => RST,
      F_OUT    => F_OUT,
      F_MED_OK => F_MED_OK,
      F_MED    => F_MED);

  U2 : entity work.cnt_display
    port map (
      CLK         => CLK,
      RST         => RST,
      DATO_BCD    => F_MED,
      DATO_BCD_OK => F_MED_OK,
      AND_30      => AND_30,
      DP          => DP,
      SEG_AG      => SEG_AG);

end rtl;

