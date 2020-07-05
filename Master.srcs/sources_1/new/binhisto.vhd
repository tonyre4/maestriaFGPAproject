library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity binhisto is
generic ( u : unsigned (7 downto 0) := to_unsigned(51,8);
          d : unsigned (7 downto 0) := (others => '0'));
port ( clk, rst, en, vsync: in  std_logic;
            val : in  unsigned (7 downto 0);
            h : out  unsigned (31 downto 0));

end binhisto;

architecture main of binhisto is
signal hh : unsigned (31 downto 0) := (others =>'0');
begin

h <= hh;

process (clk,rst,vsync,en)
begin
    if rst='1' or vsync='1' then 
            hh <= (others => '0');
    elsif en='1' then
        if clk'event and clk='1' then
            if val>=d and val<u then
                hh <= hh+1;
            end if;
        end if;
    end if;
end process;

end architecture;

