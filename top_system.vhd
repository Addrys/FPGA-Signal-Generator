library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_system is
  port(RST    : in  std_logic;
       CLK    : in  std_logic;
       --SERIAL PORT
       RX     : in  std_logic;
       LED    : out std_logic;
       -- DAC
       SYNC   : out std_logic;
       SCLK   : out std_logic;
       DIN    : out std_logic;
       --display
       SEG_AG : out std_logic_vector(6 downto 0);  -- gfedcba
       AND_30 : out std_logic_vector(3 downto 0));
end top_system;

architecture rtl of top_system is

  signal DATO_RX_OK  : std_logic;
  signal DATO_RX     : std_logic_vector(7 downto 0);
  signal DOUT        : std_logic_vector (11 downto 0);
  signal DOUT_OK     : std_logic;
  signal F_OUT       : std_logic;
  signal DATO_BCD_OK : std_logic;
  signal DATO_BCD    : std_logic_vector(15 downto 0);
begin  -- rtl 

  u_rx : entity work.receiver
    port map (
      clk         => CLK,
      rst         => RST,
      rx          => RX,
      DATO_RX     => DATO_RX,
      error_recep => LED,
      DATO_RX_OK  => DATO_RX_OK);

  u_sg : entity work.signal_generator
    port map (
      RST        => RST,
      CLK        => CLK,
      DATO_RX    => DATO_RX,
      DATO_RX_OK => DATO_RX_OK,
      DOUT       => DOUT,
      F_OUT      => F_OUT,
      DOUT_OK    => DOUT_OK);

  u_dac : entity work.dac_controller
    port map (
      CLK     => CLK,
      RST     => RST,
      DOUT    => DOUT,
      DOUT_OK => DOUT_OK,
      SYNC    => SYNC,
      SCLK    => SCLK,
      DIN     => DIN);

  u_fm : entity work.f_meter
    port map (
      CLK      => CLK,
      RST      => RST,
      F_OUT    => F_OUT,
      F_MED_OK => DATO_BCD_OK,
      F_MED    => DATO_BCD);

  u_cd : entity work.cnt_display
    port map (
      CLK         => CLK,
      RST         => RST,
      DATO_BCD    => DATO_BCD,
      DATO_BCD_OK => DATO_BCD_OK,
      AND_30      => AND_30,
      SEG_AG      => SEG_AG);

end rtl;
