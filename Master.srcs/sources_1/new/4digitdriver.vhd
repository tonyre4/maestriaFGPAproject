----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/16/2020 11:08:04 AM
-- Design Name: 
-- Module Name: 4digitdriver - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fourdigitdriver is
    generic(
            mode: std_logic:='0'
        );
    Port ( N,N2 : in unsigned (13 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ca : out STD_LOGIC;
           cb : out STD_LOGIC;
           cc : out STD_LOGIC;
           cd : out STD_LOGIC;
           ce : out STD_LOGIC;
           cf : out STD_LOGIC;
           cg : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end fourdigitdriver;

architecture main of fourdigitdriver is

signal BCD0,BCD1,BCD2,BCD3,BCD4,BCD5,BCD6,BCD7 : std_logic_vector(3 downto 0);
signal Nu : unsigned(13 downto 0);
signal Nu2 : unsigned(13 downto 0);
signal Cs,D0,D1,D2,D3,D4,D5,D6,D7 : std_logic_vector(6 downto 0);
signal cntr : unsigned(10 downto 0) := (others => '0');
signal s : unsigned(2 downto 0):= (others => '0');
signal ck : std_logic;

constant zero   : std_logic_vector(6 downto 0) := "0111111";
constant one    : std_logic_vector(6 downto 0) := "0000110";
constant two    : std_logic_vector(6 downto 0) := "1011011";
constant three  : std_logic_vector(6 downto 0) := "1001111";
constant four   : std_logic_vector(6 downto 0) := "1100110";
constant five   : std_logic_vector(6 downto 0) := "1101101";
constant six    : std_logic_vector(6 downto 0) := "1111101";
constant seven  : std_logic_vector(6 downto 0) := "0000111";
constant eight  : std_logic_vector(6 downto 0) := "1111111";
constant nine   : std_logic_vector(6 downto 0) := "1101111";
constant a      : std_logic_vector(6 downto 0) := "1110111";
constant b      : std_logic_vector(6 downto 0) := "1111100";
constant c      : std_logic_vector(6 downto 0) := "0111001";
constant d      : std_logic_vector(6 downto 0) := "1011111";
constant e      : std_logic_vector(6 downto 0) := "1111001";
constant f      : std_logic_vector(6 downto 0) := "1110001";

begin
--Nu <= unsigned(N);
--Nu2 <= unsigned(N2);
Nu <= N;
Nu2 <= N2;

ca <= Cs(0);
cb <= Cs(1);
cc <= Cs(2);
cd <= Cs(3);
ce <= Cs(4);
cf <= Cs(5);
cg <= Cs(6);

process(clk)
begin
    if clk'event and clk='1' then
        if rst = '1' then
            cntr <= (others => '0');
        else
            cntr <= cntr + 1; 
        end if;
    end if;
end process;

ck <= std_logic(cntr(10));

process(ck)
begin
    if ck'event and ck='1' then
        if rst = '1' then
            s <= (others => '0');
        else
            s <= s + 1; 
        end if;
    end if;
end process;


process(s)
begin
    case (s) is
        when "000"=>
            AN <= "01111111";
            Cs <= not D3;
        when "001"=>
            AN <= "10111111";
            Cs <= not D2;
        when "010"=>
            AN <= "11011111";
            Cs <= not D1;
        when "011"=>
            AN <= "11101111";
            Cs <= not D0;
        when "100"=>
            AN <= "11110111";
            Cs <= not D7;
        when "101"=>
            AN <= "11111011";
            Cs <= not D6;
        when "110"=>
            AN <= "11111101";
            Cs <= not D5;
        when others=>
            AN <= "11111110";
            Cs <= not D4;
    end case;
end process;

hmode: if mode='1' generate
    BCD0 <= std_logic_vector(Nu(3 downto 0));
    BCD1 <= std_logic_vector(Nu(7 downto 4));
    BCD2 <= std_logic_vector(Nu(11 downto 8));
    BCD3 <=  "00" & std_logic_vector(Nu(13 downto 12));

    BCD4 <= std_logic_vector(Nu2(3 downto 0));
    BCD5 <= std_logic_vector(Nu2(7 downto 4));
    BCD6 <= std_logic_vector(Nu2(11 downto 8));
    BCD7 <=  "00" & std_logic_vector(Nu2(13 downto 12));
end generate;

dmode: if mode='0' generate
    process(Nu)
    variable d1,d2,d3,d4 : unsigned(13 downto 0);
    variable dd1,dd2,dd3,dd4 : unsigned(13 downto 0);
    begin
        d1 := Nu mod 10; 
        d2 := ((Nu mod 100) - d1);
        d3 := ((Nu mod 1000) - d2 ) - d1;
        d4 := ((Nu mod 10000) - d3 - d2 - d1);
        
        dd1 := d1;
        dd2 := d2/10;
        dd3 := d3/100;
        dd4 := d4/1000;
    
        BCD0 <= std_logic_vector(dd1(3 downto 0));
        BCD1 <= std_logic_vector(dd2(3 downto 0));
        BCD2 <= std_logic_vector(dd3(3 downto 0));
        BCD3 <= std_logic_vector(dd4(3 downto 0));
    
    end process;
    
    process(Nu2)
    variable d1,d2,d3,d4 : unsigned(13 downto 0);
    variable dd1,dd2,dd3,dd4 : unsigned(13 downto 0);
    begin
        d1 := Nu2 mod 10; 
        d2 := ((Nu2 mod 100) - d1);
        d3 := ((Nu2 mod 1000) - d2 ) - d1;
        d4 := ((Nu2 mod 10000) - d3 - d2 - d1);
        
        dd1 := d1;
        dd2 := d2/10;
        dd3 := d3/100;
        dd4 := d4/1000;
    
        BCD4 <= std_logic_vector(dd1(3 downto 0));
        BCD5 <= std_logic_vector(dd2(3 downto 0));
        BCD6 <= std_logic_vector(dd3(3 downto 0));
        BCD7 <= std_logic_vector(dd4(3 downto 0));
    
    end process;
end generate;    

process(BCD0)
begin
    case BCD0 is
    when "0000" => D0 <= zero; -- "0"     
    when "0001" => D0 <= one; -- "1" 
    when "0010" => D0 <= two; -- "2" 
    when "0011" => D0 <= three; -- "3" 
    when "0100" => D0 <= four; -- "4" 
    when "0101" => D0 <= five; -- "5" 
    when "0110" => D0 <= six; -- "6" 
    when "0111" => D0 <= seven; -- "7" 
    when "1000" => D0 <= eight; -- "8"     
    when "1001" => D0 <= nine; -- "9" 
    when "1010" => D0 <= a; -- a
    when "1011" => D0 <= b; -- b
    when "1100" => D0 <= c; -- C
    when "1101" => D0 <= d; -- d
    when "1110" => D0 <= e; -- E
    when "1111" => D0 <= f; -- F
    end case;
end process;

process(BCD1)
begin
    case BCD1 is
    when "0000" => D1 <= zero; -- "0"     
    when "0001" => D1 <= one; -- "1" 
    when "0010" => D1 <= two; -- "2" 
    when "0011" => D1 <= three; -- "3" 
    when "0100" => D1 <= four; -- "4" 
    when "0101" => D1 <= five; -- "5" 
    when "0110" => D1 <= six; -- "6" 
    when "0111" => D1 <= seven; -- "7" 
    when "1000" => D1 <= eight; -- "8"     
    when "1001" => D1 <= nine; -- "9" 
    when "1010" => D1 <= a; -- a
    when "1011" => D1 <= b; -- b
    when "1100" => D1 <= c; -- C
    when "1101" => D1 <= d; -- d
    when "1110" => D1 <= e; -- E
    when "1111" => D1 <= f; -- F
    end case;
end process;

process(BCD2)
begin
    case BCD2 is
    when "0000" => D2 <= zero; -- "0"     
    when "0001" => D2 <= one; -- "1" 
    when "0010" => D2 <= two; -- "2" 
    when "0011" => D2 <= three; -- "3" 
    when "0100" => D2 <= four; -- "4" 
    when "0101" => D2 <= five; -- "5" 
    when "0110" => D2 <= six; -- "6" 
    when "0111" => D2 <= seven; -- "7" 
    when "1000" => D2 <= eight; -- "8"     
    when "1001" => D2 <= nine; -- "9" 
    when "1010" => D2 <= a; -- a
    when "1011" => D2 <= b; -- b
    when "1100" => D2 <= c; -- C
    when "1101" => D2 <= d; -- d
    when "1110" => D2 <= e; -- E
    when "1111" => D2 <= f; -- F
    end case;
end process;

process(BCD3)
begin
    case BCD3 is
    when "0000" => D3 <= zero; -- "0"     
    when "0001" => D3 <= one; -- "1" 
    when "0010" => D3 <= two; -- "2" 
    when "0011" => D3 <= three; -- "3" 
    when "0100" => D3 <= four; -- "4" 
    when "0101" => D3 <= five; -- "5" 
    when "0110" => D3 <= six; -- "6" 
    when "0111" => D3 <= seven; -- "7" 
    when "1000" => D3 <= eight; -- "8"     
    when "1001" => D3 <= nine; -- "9" 
    when "1010" => D3 <= a; -- a
    when "1011" => D3 <= b; -- b
    when "1100" => D3 <= c; -- C
    when "1101" => D3 <= d; -- d
    when "1110" => D3 <= e; -- E
    when "1111" => D3 <= f; -- F
    end case;
end process;

process(BCD4)
begin
    case BCD4 is
    when "0000" => D4 <= zero; -- "0"     
    when "0001" => D4 <= one; -- "1" 
    when "0010" => D4 <= two; -- "2" 
    when "0011" => D4 <= three; -- "3" 
    when "0100" => D4 <= four; -- "4" 
    when "0101" => D4 <= five; -- "5" 
    when "0110" => D4 <= six; -- "6" 
    when "0111" => D4 <= seven; -- "7" 
    when "1000" => D4 <= eight; -- "8"     
    when "1001" => D4 <= nine; -- "9" 
    when "1010" => D4 <= a; -- a
    when "1011" => D4 <= b; -- b
    when "1100" => D4 <= c; -- C
    when "1101" => D4 <= d; -- d
    when "1110" => D4 <= e; -- E
    when "1111" => D4 <= f; -- F
    end case;
end process;

process(BCD5)
begin
    case BCD5 is
    when "0000" => D5 <= zero; -- "0"     
    when "0001" => D5 <= one; -- "1" 
    when "0010" => D5 <= two; -- "2" 
    when "0011" => D5 <= three; -- "3" 
    when "0100" => D5 <= four; -- "4" 
    when "0101" => D5 <= five; -- "5" 
    when "0110" => D5 <= six; -- "6" 
    when "0111" => D5 <= seven; -- "7" 
    when "1000" => D5 <= eight; -- "8"     
    when "1001" => D5 <= nine; -- "9" 
    when "1010" => D5 <= a; -- a
    when "1011" => D5 <= b; -- b
    when "1100" => D5 <= c; -- C
    when "1101" => D5 <= d; -- d
    when "1110" => D5 <= e; -- E
    when "1111" => D5 <= f; -- F
    end case;
end process;

process(BCD6)
begin
    case BCD6 is
    when "0000" => D6 <= zero; -- "0"     
    when "0001" => D6 <= one; -- "1" 
    when "0010" => D6 <= two; -- "2" 
    when "0011" => D6 <= three; -- "3" 
    when "0100" => D6 <= four; -- "4" 
    when "0101" => D6 <= five; -- "5" 
    when "0110" => D6 <= six; -- "6" 
    when "0111" => D6 <= seven; -- "7" 
    when "1000" => D6 <= eight; -- "8"     
    when "1001" => D6 <= nine; -- "9" 
    when "1010" => D6 <= a; -- a
    when "1011" => D6 <= b; -- b
    when "1100" => D6 <= c; -- C
    when "1101" => D6 <= d; -- d
    when "1110" => D6 <= e; -- E
    when "1111" => D6 <= f; -- F
    end case;
end process;

process(BCD7)
begin
    case BCD7 is
    when "0000" => D7 <= zero; -- "0"     
    when "0001" => D7 <= one; -- "1" 
    when "0010" => D7 <= two; -- "2" 
    when "0011" => D7 <= three; -- "3" 
    when "0100" => D7 <= four; -- "4" 
    when "0101" => D7 <= five; -- "5" 
    when "0110" => D7 <= six; -- "6" 
    when "0111" => D7 <= seven; -- "7" 
    when "1000" => D7 <= eight; -- "8"     
    when "1001" => D7 <= nine; -- "9" 
    when "1010" => D7 <= a; -- a
    when "1011" => D7 <= b; -- b
    when "1100" => D7 <= c; -- C
    when "1101" => D7 <= d; -- d
    when "1110" => D7 <= e; -- E
    when "1111" => D7 <= f; -- F
    end case;
end process;




end main;
