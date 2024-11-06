library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dac_controller is
  port (
    CLK     : in  std_logic;
    RST     : in  std_logic;
    DOUT    : in  std_logic_vector(11 downto 0);
    DOUT_OK : in  std_logic;
    SYNC    : out std_logic;
    SCLK    : out std_logic;
    DIN     : out std_logic);
end dac_controller;

architecture RTL of dac_controller is
    signal dout_reg : std_logic_vector (15 downto 0);
   -- signal contador : std_logic_vector(3 downto 0);
    signal ce_shift : std_logic;
    signal ce_cnt : std_logic;
    signal sync_next : std_logic;
    signal sclk_next : std_logic;
    
    signal cnt : std_logic_vector(4 downto 0); --5 bits para poder llegar al 16
    signal cnt_out : std_logic;
    
    type FSM is (S0, S1, S2, S3, S4);
    signal std_act, prox_std :FSM;
begin
    
    
    --SCLK , T = 40ns -> 1/
    
    --capturamos el dato con un registro multifuncion
    process(all)
    begin
        if(RST = '1') then
            dout_reg <= (others => '0');
        elsif(CLK'Event and CLK = '1') then --CLK? --Dout_ok como enable
            if(DOUT_OK = '1') then
                --los bits 15 y 14 no se usan, los de PowerDown(13 y 12) a '0'
                dout_reg <= "0000"  & DOUT;
            elsif( ce_shift = '1') then --hacemos un shift a la izquierda
                dout_reg <= dout_reg(14 downto 0) & '0' ;
            end if;
        end if;
    end process;
    
    --registro para el dato din
    process(all)
    begin
        if(RST = '1') then
            DIN <= '0';
        elsif(CLK'Event and CLK = '1') then
            DIN <= dout_reg(15);
        end if;
    end process;
    
    --contador de bits transmitidos 0->16, 5bits
    process(all)
    begin
        if(RST = '1') then
            cnt <= (others => '0');
            cnt_out <= '0';
        elsif(CLK'Event and CLK = '1') then
            cnt_out <= '0';
            if(ce_cnt = '1') then
                cnt_out <= '0';
                cnt <= std_logic_vector(unsigned(cnt)+1);
                if(unsigned(cnt) = 16) then --reseteamos para que no se pase de 16
                    cnt <= (others => '0');
                    cnt_out <= '1';
                end if;
            end if;
            
            if(dout_ok = '1') then
                cnt <= (others => '0');
            end if;
        end if;
            
    end process;
    
    --FSM-------------------------------------------------------
    --Calculo del proximo estado (combinacional)
    process(all)
    begin
        case std_act is
            when S0 =>
                if (dout_ok= '1') then
                prox_std <= S1;
                else
                prox_std <= S0;
                end if;
            when S1 =>
                prox_std <= S2;
            when S2 =>
                prox_std <= S3;
            when S3 =>
                prox_std <= S4;
            when S4 =>
                if(unsigned(cnt) < 16) then
                    prox_std <= S1;
                else
                    prox_std <= S0;
                end if;
        end case;
    end process;
    --REGISTRO
    process(all)
    begin
        if(RST = '1') then
            std_act <= S0;
        elsif(CLK'Event and CLK = '1') then
            std_act <= prox_std;
        end if;
    end process;
    -- Calculo de las salidas (combinacional)
    process(all)
    begin
        --salidas default
        ce_shift <= '0';
        ce_cnt <= '0';
        sync_next <= '1';
        sclk_next <= '0';
        
        case std_act is
            when S0 =>
                -- las default
                ce_shift <= '0';
                ce_cnt <= '0';
                sync_next <= '1';
                sclk_next <= '0';
            when S1 =>
                sync_next <= '0';
                sclk_next <= '1';
                ce_cnt <= '1';
            when S2 =>
                sync_next <= '0';
                sclk_next <= '1';
            when S3 =>
                --ce_cnt <= '1';
                sync_next <= '0';
            when S4 =>
                sync_next <= '0';
                ce_shift <= '1';
                --ce_cnt <= '1';
                
        end case;
    end process;
    --FIN FSM------------------------------------------------------
    --Biestables para SCLK y sync
    process(all)
    begin
        if(RST = '1') then
            SCLK <= '0'; --default
            SYNC <= '1'; --default
        elsif(CLK'Event and CLK = '1') then
            SCLK <= sclk_next;
            SYNC <= sync_next;
        end if;
    end process;

end;
