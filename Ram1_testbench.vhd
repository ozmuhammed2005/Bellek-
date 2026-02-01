library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Bellek_testbench is

end Bellek_testbench;

architecture Behavioral of Bellek_testbench is
    signal clk : std_logic := '0';
    signal we : std_logic := '0';
    signal addr : std_logic_vector(10 downto 0) := (others =>'0');
    signal din : std_logic_vector(31 downto 0) := (others => '0');
    signal dout : std_logic_vector(31 downto 0) := (others => '0'); 
    constant clk_period : time := 10ps; 
begin

    clk_process : process -- burada clk'nın calısmasını kontrol ediyoruz. 
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;
    
    stim_process : process
    begin
        -- 1. yazma işleminde 5. adrese "ABCDE123" bilgisini yazıyoruz.
        wait for 20 ps;
        addr <= std_logic_vector(to_unsigned(5,11));
        din <= x"ABCDE123";
        we <= '1';
        wait for clk_period;
        
        --2. yazma işlemi 10. adrese "98765432" bilgisini yazalım.
        addr <= std_logic_vector(to_unsigned(10,11));
        din <= x"98765432";
        wait for clk_period;
        we <= '0';
        --3. seferde okuma yapacagız. 5. adresteki veriyi okuyacagız.
        addr <= std_logic_vector(to_unsigned(5,11));
        wait for clk_period;
        --bu sefer dout signalinde "ABCDE123" görmem gerekiyo.
        
        wait;
    end process;    
  



end Behavioral;
