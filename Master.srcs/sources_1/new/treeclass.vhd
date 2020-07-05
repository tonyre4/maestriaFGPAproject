

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity treeclass is
  port (clkv,rst,roi,roiend,de,vsync: in std_logic;
        h,s,v,r,g,b: in unsigned(7 downto 0);
        rdy,sal: out std_logic
        );
end treeclass;

architecture main of treeclass is

signal r0,r1,r2,r3,r4: unsigned(13 downto 0);
signal g0,g1,g2,g3,g4: unsigned(13 downto 0);
signal b0,b1,b2,b3,b4: unsigned(13 downto 0);
signal h0,h1,h2,h3,h4: unsigned(13 downto 0);
signal s0,s1,s2,s3,s4: unsigned(13 downto 0);
signal v0,v1,v2,v3,v4: unsigned(13 downto 0);
signal ss,rd: std_logic;

begin

process(roiend,vsync)
begin
    if vsync = '1' then
        rd <= '0';
        sal <= '0';
    elsif roiend'event and roiend='0' then
        sal <= ss;
        rd <= '1';
    end if;
end process;

rdy <= rd;

Rhist: entity work.fivebinhisto (mainn) port map (  clk => clkv,
                                                    rst => rst,
                                                    roi => roi,
                                                    de => de,
                                                    vsync => vsync,
                                                    roiend => roiend,
                                                    val => r,
                                                    bin0 => r0,
                                                    bin1 => r1,
                                                    bin2 => r2,
                                                    bin3 => r3,
                                                    bin4 => r4);

Ghist: entity work.fivebinhisto (mainn) port map (  clk => clkv,
                                                    rst => rst,
                                                    roi => roi,
                                                    de => de,
                                                    vsync => vsync,
                                                    roiend => roiend,
                                                    val => g,
                                                    bin0 => g0,
                                                    bin1 => g1,
                                                    bin2 => g2,
                                                    bin3 => g3,
                                                    bin4 => g4);
                                                    
Bhist: entity work.fivebinhisto (mainn) port map (  clk => clkv,
                                                    rst => rst,
                                                    roi => roi,
                                                    de => de,
                                                    vsync => vsync,
                                                    roiend => roiend,
                                                    val => b,
                                                    bin0 => b0,
                                                    bin1 => b1,
                                                    bin2 => b2,
                                                    bin3 => b3,
                                                    bin4 => b4);                                                   
                                                   
Hhist: entity work.fivebinhisto (mainn) port map (  clk => clkv,
                                                    rst => rst,
                                                    roi => roi,
                                                    de => de,
                                                    vsync => vsync,
                                                    roiend => roiend,
                                                    val => h,
                                                    bin0 => h0,
                                                    bin1 => h1,
                                                    bin2 => h2,
                                                    bin3 => h3,
                                                    bin4 => h4);                                                    
                                                    
Shist: entity work.fivebinhisto (mainn) port map (  clk => clkv,
                                                    rst => rst,
                                                    roi => roi,
                                                    de => de,
                                                    vsync => vsync,
                                                    roiend => roiend,
                                                    val => s,
                                                    bin0 => s0,
                                                    bin1 => s1,
                                                    bin2 => s2,
                                                    bin3 => s3,
                                                    bin4 => s4);
                                                    
Vhist: entity work.fivebinhisto (mainn) port map (  clk => clkv,
                                                    rst => rst,
                                                    roi => roi,
                                                    de => de,
                                                    vsync => vsync,
                                                    roiend => roiend,
                                                    val => v,
                                                    bin0 => v0,
                                                    bin1 => v1,
                                                    bin2 => v2,
                                                    bin3 => v3,
                                                    bin4 => v4);
                                                    

classer: entity work.colorer (main) port map( 
                                              r0 => r0,
                                              --r1 => r1,
                                              r2 => r2,
                                              r3 => r3,
                                              --r4 => r4,
                                              g0 => g0,
                                              --g1 => g1,
                                              --g2 => g2,
                                              g3 => g3,
                                              --g4 => g4,
                                              b0 => b0,
                                              --b1 => b1,
                                              --b2 => b2,
                                              --b3 => b3,
                                              --b4 => b4,
                                              --h0 => h0,
                                              h1 => h1,
                                              --h2 => h2,
                                              --h3 => h3,
                                              --h4 => h4,
                                              --s0 => s0,
                                              --s1 => s1,
                                              s2 => s2,
                                              s3 => s3,
                                              s4 => s4,
                                              --v0 => v0,
                                              --v1 => v1,
                                              --v2 => v2,
                                              --v3 => v3,
                                              v4 => v4,
                                              s => ss
                                              );
                                             
                                                    
end main;
