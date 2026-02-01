library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity bootrom is
    Port
     (
     clk : in std_logic;
     en : in std_logic;
     addr : in std_logic_vector(7 downto 0);
     data_out : out std_logic_vector(31 downto 0)
      );
end bootrom;

architecture Behavioral of bootrom is
    type rom_type is array (0 to 255) of std_logic_vector(31 downto 0);
    constant ROM_CONTENT : rom_type := (
        0      => x"00000513",
        1      => x"00100093",--Burası bir LUT(look up table).0 ve 1 i manuel olarak doldurdum.Kalan kısım şartnameye göre doldurulacak.
        others => x"00000000"  --sistem uyandıgında ilk önce buradaki kodları okuyacak.
    );


begin
    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                data_out <= ROM_CONTENT(to_integer(unsigned(addr)));--enable sinyali 1 iken ROM_CONTENT'teki belirli addresin bitlerini integer şeklinde okuyup
            end if ;--data_out' a atayacak.Yani bir okuma işlemi yapacak.ROM read only (sadece okuma) şeklinde çalışıyor. 
        end if;
    end process;

end Behavioral;
