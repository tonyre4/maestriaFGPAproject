

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pipe is
    generic( uw : integer := 2;
             sw : integer := 2
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           uns : in unsigned (uw-1 downto 0);
           st : in STD_LOGIC_VECTOR (sw-1 downto 0);
           unso : out unsigned (uw-1 downto 0);
           sto : out STD_LOGIC_VECTOR (sw-1 downto 0));
end pipe;

architecture main of pipe is

begin
process(clk,rst)
begin
    if rst = '1' then
        unso <= (others => '0');
        sto <= (others => '0');
    elsif clk'event and clk='1' then
        unso <= uns;
        sto <= st;
    end if;
end process;


end main;
