library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AI_DualPort_Memory is
    Generic (
        DATA_WIDTH : integer := 32;
        ADDR_WIDTH : integer := 13
    );
    Port (
        clk      : in  std_logic;
        
        -- PORT A: Çekirdek için 
        we_a     : in  std_logic;                                 
        addr_a   : in  std_logic_vector(ADDR_WIDTH-1 downto 0);   
        din_a    : in  std_logic_vector(DATA_WIDTH-1 downto 0);   
        dout_a   : out std_logic_vector(DATA_WIDTH-1 downto 0);   -- İşlemci okumak isterse (Opsiyonel)
        
        -- PORT B: YZ Hızlandırıcı Arayüzü (Sadece Okuma İçin)
        we_b     : in  std_logic;                                 -- YZ yazma yapacaksa '1', yoksa '0'
        addr_b   : in  std_logic_vector(ADDR_WIDTH-1 downto 0);   -- YZ biriminin istediği adres
        din_b    : in  std_logic_vector(DATA_WIDTH-1 downto 0);   -- YZ yazma verisi (Genelde kullanılmaz)
        dout_b   : out std_logic_vector(DATA_WIDTH-1 downto 0)    -- YZ birimine giden veri
    );
end AI_DualPort_Memory;

architecture Behavioral of AI_DualPort_Memory is

    type ram_type is array (0 to (2**ADDR_WIDTH)-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    

    signal RAM : ram_type := (others => (others => '0'));

begin

    process(clk)
    begin
        if rising_edge(clk) then
            -- PORT A İşlemleri (Öncelik: İşlemci/DMA Yazma)
            if we_a = '1' then
                RAM(to_integer(unsigned(addr_a))) <= din_a;
            end if;
            -- Okuma işlemi her saat darbesinde senkronize yapılır (BRAM inference için kritik)
            dout_a <= RAM(to_integer(unsigned(addr_a)));
            
            -- PORT B İşlemleri (Öncelik: YZ Okuma)
            if we_b = '1' then
                RAM(to_integer(unsigned(addr_b))) <= din_b;
            end if;
            -- YZ Hızlandırıcı veriyi buradan okur
            dout_b <= RAM(to_integer(unsigned(addr_b)));
        end if;
    end process;

end Behavioral;