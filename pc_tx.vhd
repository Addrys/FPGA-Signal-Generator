library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pc_tx is
  port (
    tx : out std_logic);
end pc_tx;

architecture rtl of pc_tx is

  constant cte_baudios : integer   :=921600;
   constant CNT1         : time    := 10 ms;
  signal   trama_tx    : std_logic_vector(10 downto 0);
  signal   dato_tx     : std_logic_vector(7 downto 0);
  signal   err         : std_logic := '0';
begin  -- rtl



  process (dato_tx,err)
    variable aux_par : std_logic;
  begin

    trama_tx             <= (0 => '0', others => '1');
    trama_tx(8 downto 1) <= dato_tx;
    aux_par     := '0';
    for i in dato_tx'range loop
      if dato_tx(i) = '1' then
        aux_par := not aux_par;
      end if;
    end loop;  -- i
    if err = '0' then
      trama_tx(9)        <= not aux_par;
    else
      trama_tx(9)        <= aux_par;
    end if;

  end process;

  process
    procedure tx_data is
      variable T_tx_aux : time := 10 ns;
    begin
      wait for 1 us;
      T_tx_aux                 := 1 sec/ cte_baudios;
      wait for 1 us;
      for j in 0 to 10 loop
        tx <= trama_tx(j);
        wait for T_tx_aux;
      end loop;  -- j     
      wait for 5 us;
    end tx_data;

  begin
    err     <= '0';
	--seleccionar ganancia 
    dato_tx(7 downto 6)  <= "10";
    dato_tx (5 downto 0) <= "100111";
    dato_tx <= x"38";
    tx      <= '1';
    wait for  1 ns;
    tx_data;
    wait for CNT1;
 --seleccionar forma de onda 
    dato_tx(7 downto 6)  <= "00";
    dato_tx (5 downto 0) <= "000110";
    wait for  1 ns;
        tx_data;
        wait for CNT1;

    -- seleccionar frecuencia
    dato_tx(7 downto 6)  <= "01";
    dato_tx (5 downto 0) <= "111111";
    wait for  1 ns;
        tx_data;
        wait for CNT1;

     --seleccionar ganacia
    dato_tx(7 downto 6)  <= "10";
    dato_tx (5 downto 0) <= "000111";
    err     <= '1';
   wait for  1 ns;
        tx_data;
        wait for CNT1;
        
    err     <= '0';
    --seleccionar ganacia 
    dato_tx(7 downto 6)  <= "10";
    dato_tx (5 downto 0) <= "010111";
   wait for  1 ns;
        tx_data;
        wait for CNT1;
-- seleccionar nivel de continua 
    dato_tx(7 downto 6)  <= "11";
    dato_tx (5 downto 0) <= "000111";
    wait for  1 ns;
        tx_data;
        wait for CNT1;
-- seleccionar ganancia
     dato_tx(7 downto 6)  <= "10";
    dato_tx (5 downto 0) <= "110111";
   wait for  1 ns;
        tx_data;
        wait for CNT1;
    -- seleccionar seÃ±al
    dato_tx(7 downto 6)  <= "00";
	dato_tx (5 downto 0) <= "000100";
    wait for  1 ns;
        tx_data;
        wait for CNT1;
		-- seleccionar seÃ±al
    dato_tx(7 downto 6)  <= "00";
    dato_tx (5 downto 0) <= "000100";
    err     <= '1';
    wait for  1 ns;
        tx_data;
        wait for CNT1;
		-- seleccionar s´ñal
    dato_tx(7 downto 6)  <= "00";
     dato_tx (5 downto 0) <= "000010";
    err     <= '0';
    wait for  1 ns;
        tx_data;
        wait for CNT1;
    -- seleccionar frecuencia
    dato_tx(7 downto 6)  <= "00";
	dato_tx (5 downto 0) <= "000011";
    wait for  1 ns;
        tx_data;
        wait for CNT1;

    report "FIN CONTROLADO DE LA SIMULACION" severity failure;
  end process;


end rtl;
