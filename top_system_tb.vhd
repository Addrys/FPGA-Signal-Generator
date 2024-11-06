-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity top_system_tb is

end top_system_tb;

-------------------------------------------------------------------------------

architecture sim of top_system_tb is

  

  signal RST_i    : std_logic:='1';
  signal CLK_i    : std_logic :='0';
  signal RX_i     : std_logic;
  signal LED_i    : std_logic;
  signal SYNC_i   : std_logic;
  signal SCLK_i   : std_logic;
  signal DIN_i  : std_logic;
  signal SEG_AG_i : std_logic_vector(6 downto 0);
  signal AND_30_i : std_logic_vector(3 downto 0);
signal VOUT : real range 0.0 to 3.5;
begin  -- sim

  DUT: entity work.top_system
    port map (
        RST    => RST_i,
        CLK    => CLK_i,
        RX     => RX_i,
        LED    => LED_i,
        SYNC   => SYNC_i,
        SCLK   => SCLK_i,
        DIN    => DIN_i,
        SEG_AG => SEG_AG_i,
        AND_30 => AND_30_i);

  
  u_tx : entity work.pc_tx
    port map (
          tx        => rx_i);

  clk_i <= not clk_i after 5 ns;
  rst_i <= '0'       after 233 ns;

  dac : entity work.DAC121S101 port map(
    VOUT => VOUT,
    SYNC => SYNC_i,
    SCLK => SCLK_i,
    DIN  =>DIN_i );

      UD : entity work.display
        port map (          
          SEG_AG => SEG_AG_i,
          AND_30 => AND_30_i);


end sim;

-------------------------------------------------------------------------------
