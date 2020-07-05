----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/18/2020 01:37:35 PM
-- Design Name: 
-- Module Name: fivebinhisto - Behavioral
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

entity fivebinhisto is
Generic ( b0: unsigned (7 downto 0) := to_unsigned(0,8);
          b1: unsigned (7 downto 0) := to_unsigned(51,8);
          b2: unsigned (7 downto 0) := to_unsigned(102,8);
          b3: unsigned (7 downto 0) := to_unsigned(153,8);
          b4: unsigned (7 downto 0) := to_unsigned(204,8);
          b5: unsigned (7 downto 0) := to_unsigned(255,8));
              
Port (  clk, rst, de, roi, vsync, roiend: std_logic;
        val  : in  unsigned (7 downto 0);
        valo  : out  unsigned (7 downto 0);
        bin0 : out unsigned (13 downto 0);
        bin1 : out unsigned (13 downto 0);
        bin2 : out unsigned (13 downto 0);
        bin3 : out unsigned (13 downto 0);
        bin4 : out unsigned (13 downto 0);
        h : out unsigned(69 downto 0);
        ct0 : out unsigned (13 downto 0);
        ct1 : out unsigned (13 downto 0);
        ct2 : out unsigned (13 downto 0);
        ct3 : out unsigned (13 downto 0);
        ct4 : out unsigned (13 downto 0);
        pixcnt: out unsigned (49 downto 0));

end fivebinhisto;

--architecture main of fivebinhisto is

--signal bt0,bt1,bt2,bt3,bt4: unsigned (31 downto 0);
--signal cnt: unsigned (49 downto 0) := (others => '0');
--signal clk1,clk2 :std_logic;
--signal pipe: unsigned (7 downto 0);

--Begin


--process(clk,rst,vsync) --para contar los pixeles de la roi
--begin
--    if rst='1' or vsync='1' then 
--        cnt <= (others=>'0');
--    elsif clk'event and clk='1' then    
--        if en='1' then
--            cnt <= cnt + 1;
--        end if;
--    end if;
--End process;

--process(clk)
--begin
--    if clk'event and clk='1' then
--        pipe <= val;
--    end if;
--end process;

--clk1 <= not clk;
--clk2 <= not clk1;

--pixcnt <= cnt;

--bh1: entity work.binhisto (main) generic map(b1,b0) port map(clk1,rst, en, vsync, pipe, bt0);
--bh2: entity work.binhisto (main) generic map(b2,b1) port map(clk1,rst, en, vsync, pipe, bt1);
--bh3: entity work.binhisto (main) generic map(b3,b2) port map(clk1,rst, en, vsync, pipe, bt2);
--bh4: entity work.binhisto (main) generic map(b4,b3) port map(clk1,rst, en, vsync, pipe, bt3);
--bh5: entity work.binhisto (main) generic map(b5,b4) port map(clk1,rst, en, vsync, pipe, bt4);

--ct0 <= bt0(13 downto 0);
--ct1 <= bt1(13 downto 0);
--ct2 <= bt2(13 downto 0);
--ct3 <= bt3(13 downto 0);
--ct4 <= bt4(13 downto 0);

--process (roiend)
--constant diezmil: unsigned (31 downto 0) := to_unsigned(10000,32);
--variable m0,m1,m2,m3,m4: unsigned (63 downto 0);
--variable mm0,mm1,mm2,mm3,mm4: unsigned (63 downto 0);
--Begin

--if roiend'event and roiend='0' then
--    --32*32=64/50=14bits
--    m0 := bt0*diezmil;
--    m1 := bt1*diezmil;
--    m2 := bt2*diezmil;
--    m3 := bt3*diezmil;
--    m4 := bt4*diezmil;
  
--    mm0 := (m0)/cnt;
--    mm1 := (m1)/cnt;
--    mm2 := (m2)/cnt;
--    mm3 := (m3)/cnt;
--    mm4 := (m4)/cnt;
    
--    bin0 <= mm0(13 downto 0);
--    bin1 <= mm1(13 downto 0);
--    bin2 <= mm2(13 downto 0);
--    bin3 <= mm3(13 downto 0);
--    bin4 <= mm4(13 downto 0);
--end if;

--End process;

--end architecture;


architecture mainn of fivebinhisto is
signal bi0,bi1,bi2,bi3,bi4 : unsigned (13 downto 0);
begin

process(clk,vsync) --para contar los pixeles de la roi
    variable bt0,bt1,bt2,bt3,bt4: unsigned (31 downto 0) := (others => '0');
    variable cntt: unsigned (49 downto 0) := (others => '0');
    constant diezmil: unsigned (31 downto 0) := to_unsigned(10000,32);
    variable m0,m1,m2,m3,m4: unsigned (63 downto 0);
    variable mm0,mm1,mm2,mm3,mm4: unsigned (63 downto 0);
begin
    if vsync='1' then 
        cntt := (others=>'0');
        bt0 := (others=>'0');
        bt1 := (others=>'0');
        bt2 := (others=>'0');
        bt3 := (others=>'0');
        bt4 := (others=>'0');
    elsif clk'event and clk='0' then
        if roi='1' and de='1' then
            cntt := cntt + 1;
            if val<b1 then
                bt0 := bt0 + 1;
            end if;
            if val>=b1 and val<b2 then
                bt1 := bt1 + 1;
            end if;
            if val>=b2 and val<b3 then
                bt2 := bt2 + 1;
            end if;
            if val>=b3 and val<b4 then
                bt3 := bt3 + 1;
            end if;
            if val>=b4 and val<=b5 then
                bt4 := bt4 + 1;
            end if;
        end if;
        
        --if roiend = '1' then
        
            m0 := bt0*diezmil;
            m1 := bt1*diezmil;
            m2 := bt2*diezmil;
            m3 := bt3*diezmil;
            m4 := bt4*diezmil;
          
            if cntt/=0 then
                mm0 := (m0)/cntt;
                mm1 := (m1)/cntt;
                mm2 := (m2)/cntt;
                mm3 := (m3)/cntt;
                mm4 := (m4)/cntt;
            end if;
            
            bi0 <= mm0(13 downto 0);
            bi1 <= mm1(13 downto 0);
            bi2 <= mm2(13 downto 0);
            bi3 <= mm3(13 downto 0);
            bi4 <= mm4(13 downto 0);
        --end if;
        
        
        
        pixcnt <= cntt;
        ct0 <= bt0(13 downto 0);
        ct1 <= bt1(13 downto 0);
        ct2 <= bt2(13 downto 0);
        ct3 <= bt3(13 downto 0);
        ct4 <= bt4(13 downto 0);
    end if;
    
    h <= bi4 & bi3 & bi2 & bi1 & bi0;
    bin0 <= bi0;
    bin1 <= bi1;
    bin2 <= bi2;
    bin3 <= bi3;
    bin4 <= bi4;
    
end process;


valo <= val;

end architecture;


--architecture veri of fivebinhisto is

--component fbh is 
--    port( clk,rst,en,vsync,roiend : in std_logic;
--          val  : in  unsigned (7 downto 0);
--          valo  : out  unsigned (7 downto 0);
--          bin0,ct0: out unsigned(13 downto 0);
--          pixcnt: out unsigned(49 downto 0)
--    );
--end component;

--begin

--ver : fbh
--port map
--(
--    clk => clk,
--    rst => rst,
--    en => en,
--    vsync => vsync,
--    roiend => roiend,
--    bin0 => bin0,
--    ct0 => ct0,
--    pixcnt => pixcnt,
--    valo=> valo,
--    val=>val
--);

--end architecture;