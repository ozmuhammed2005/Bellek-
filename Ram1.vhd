library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Bellek is
    Port (
     clk : in std_logic;
     we : in std_logic;
     addr : in std_logic_vector(10 downto 0);
     din : in std_logic_vector(31 downto 0);
     dout : out std_logic_vector(31 downto 0)
    );
end Bellek;

architecture Behavioral of Bellek is
    type ram_type is array(2047 downto 0) of std_logic_vector(31 downto 0);
    signal RAM : ram_type;

begin
    process(clk)
    begin
        if rising_edge(clk) then 
            if we = '1' then
                RAM(to_integer(unsigned(addr))) <= din;
            end if;
            
            dout <= RAM(to_integer(unsigned(addr)));
            
        end if;
    end process;


end Behavioral;
