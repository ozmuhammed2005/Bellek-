library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_AI_DualPort_Memory is

end tb_AI_DualPort_Memory;

architecture Behavioral of tb_AI_DualPort_Memory is

    component AI_DualPort_Memory is
        Generic (
            DATA_WIDTH : integer := 32;
            ADDR_WIDTH : integer := 13
        );
        Port (
            clk      : in  std_logic;
            we_a     : in  std_logic;
            addr_a   : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
            din_a    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
            dout_a   : out std_logic_vector(DATA_WIDTH-1 downto 0);
            we_b     : in  std_logic;
            addr_b   : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
            din_b    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
            dout_b   : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;
    signal clk      : std_logic := '0';
    signal we_a     : std_logic := '0';
    signal addr_a   : std_logic_vector(12 downto 0) := (others => '0');
    signal din_a    : std_logic_vector(31 downto 0) := (others => '0');
    signal dout_a   : std_logic_vector(31 downto 0);
    
    signal we_b     : std_logic := '0';
    signal addr_b   : std_logic_vector(12 downto 0) := (others => '0');
    signal din_b    : std_logic_vector(31 downto 0) := (others => '0');
    signal dout_b   : std_logic_vector(31 downto 0);


    constant clk_period : time := 10 ps;

begin

    uut: AI_DualPort_Memory
        generic map (
            DATA_WIDTH => 32,
            ADDR_WIDTH => 13
        )
        port map (
            clk    => clk,
            we_a   => we_a,
            addr_a => addr_a,
            din_a  => din_a,
            dout_a => dout_a,
            we_b   => we_b,
            addr_b => addr_b,
            din_b  => din_b,
            dout_b => dout_b
        );

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin		
        wait for 20 ps;

        -- TEST 1: Port A üzerinden 5. adrese veri yazma
        we_a <= '1';
        addr_a <= std_logic_vector(to_unsigned(5, 13));
        din_a <= x"ABCD1234"; -- Örnek veri
        wait for clk_period;
        we_a <= '0';

        -- TEST 2: Port B üzerinden 10. adrese veri yazma
        we_b <= '1';
        addr_b <= std_logic_vector(to_unsigned(10, 13));
        din_b <= x"1234ABCD"; -- Örnek veri
        wait for clk_period;
        we_b <= '0';

        -- TEST 3: Okuma Testi
        -- Port A'dan 10. adresi, Port B'den 5. adresi oku (Cross-read)
        addr_a <= std_logic_vector(to_unsigned(10, 13));
        addr_b <= std_logic_vector(to_unsigned(5, 13));
        wait for clk_period;

        -- Simülasyonu bitir (Vivado'da simülasyonun durması için)
        wait;
    end process;

end Behavioral;