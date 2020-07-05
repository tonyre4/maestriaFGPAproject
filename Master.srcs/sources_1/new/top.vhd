----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/14/2020 12:07:18 AM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
    Port ( clk : in STD_LOGIC;
           --ext
           JA : in STD_LOGIC_VECTOR(5 downto 0);
           de_out: out std_logic; --(JA(7))
           --ext
           JB : out STD_LOGIC_VECTOR (7 downto 0);
           
           --ext
           JD : in STD_LOGIC_VECTOR (7 downto 0);
           --board
           LED : out STD_LOGIC_VECTOR (15 downto 0);
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           CA,CB,CC,CD,CE,CF,CG,DP : out std_logic;
           LED1_R, LED1_G, LED1_B : out std_logic;
           LED2_R, LED2_G, LED2_B : out std_logic;
           BTNU : std_logic;
           BTND : std_logic;
           BTNL : std_logic;
           BTNR : std_logic;
           BTNC : std_logic
           );
end top;

architecture Behavioral of top is

signal videoMode: std_logic_vector(3 downto 0);
signal areaMode: std_logic_vector(3 downto 0);

signal r_in,b_in,g_in: std_logic_vector(7 downto 0);
signal r_sec,b_sec,g_sec, dummy: std_logic_vector(7 downto 0);

signal r_o,b_o,g_o: std_logic_vector(7 downto 0);
--signal ve: std_logic;
signal morphmode : std_logic_vector(1 downto 0);


signal rst : std_logic;

signal clkv : STD_LOGIC;
signal hsync : STD_LOGIC;
signal vsync : STD_LOGIC;
signal de_in : STD_LOGIC;
signal sdat : STD_LOGIC_VECTOR(1 downto 0);
signal mode : STD_LOGIC_VECTOR (1 downto 0);
signal RGB, RGBo : STD_LOGIC_VECTOR (7 downto 0);
signal CTL : STD_LOGIC_VECTOR (5 downto 0);
signal row,col : unsigned (10 downto 0);
signal N1ent,N2ent,N22ent: unsigned(13 downto 0);
signal pixes: unsigned(49 downto 0);
signal bh0,bh1,bh2,bh3,bh4: unsigned(13 downto 0);
signal nmode : STD_LOGIC_VECTOR (3 downto 0);
signal ct0,ct1,ct2,ct3,ct4: unsigned(13 downto 0);
signal valrev: unsigned(13 downto 0);

--imageROM
signal clkvROM : STD_LOGIC;
signal hsyncROM : STD_LOGIC;
signal vsyncROM : STD_LOGIC;
signal deROM : STD_LOGIC;
signal RROM,GROM,BROM: std_logic_vector(7 downto 0);

begin



RGB <= JD;
JB <= RGBo;
CTL <= JA;


rst <= '1' when CTL(5 downto 1) = "11111" else BTNC;


--sw assigns
--morphmode <= sw(1 downto 0);
--videomode <= sw(5 downto 2);
--areamode <= sw(9 downto 6);
morphmode <= "00";
videomode <= SW(7 downto 4);
areamode <= SW(3 downto 0);
--VideoMode
	--0: rgb
	--1: r
	--2: g
	--3: b
	--4: hsv
	--5: h
	--6: s
	--7: v
	--8: gray
	--9: mask b/w
	--10: mask cyan
	
--Ardeamode: 
		--0: Dibuja franja roja
		--1: Solo dibuja area de interés
		--2: Limpio
--Morph mode:
   --0: sin morph
   --1: erosionado
   --2: closing
   --3: closing dilatado
clkv <= CTL(0);-- when SW(8)='1' else clkvROM;
hsync <= CTL(1);-- when SW(8)='1' else hsyncROM;
vsync <= CTL(2);-- when SW(8)='1' else vsyncROM;
de_in <= CTL(3);-- when SW(8)='1' else deROM;
r_in <= r_sec;-- when SW(8)='1' else RROM;
g_in <= g_sec;-- when SW(8)='1' else GROM;
b_in <= b_sec;-- when SW(8)='1' else BROM;
sdat <= CTL(5 downto 4);

--img: entity work.image (main)
--    port map(clk => clk,
--             rst => rst,
--             mode => SW(10 downto 9),
--             clkv => clkvROM,
--             R => RROM,
--             G => GROM,
--             B => BROM,
--             hsync => hsyncROM,
--             vsync => vsyncROM,
--             de => deROM,
--             en => SW(7),
--             cntt => open
--    );



--Para probar entradas y salidas
LED(15) <= clkv;
LED(14) <= hsync;
LED(13) <= vsync;
LED(12) <= de_in;



--demux data
process(clk)
begin
        if clk'event and clk='1' then
            case sdat is 
                when "00" =>
                    r_sec <= RGB;
                when "01" =>
                    g_sec <= RGB;
                when "10" =>
                    b_sec <= RGB;
                when others =>
                    dummy <= RGB;
            end case;
        end if;
end process;


--mux data
process(clk)
begin
    if clk'event and clk='1' then
        case sdat is 
            when "00" =>
                RGBo <= r_o;
            when "01" =>
                RGBo <= g_o;
            when "10" =>
                RGBo <= b_o;
            when others =>
                RGBo <= RGBo;
        end case;
    end if;
end process;


top: entity work.core_t (rgbhsvgray) 
         --generic map(50,25,150,200)
         generic map(1,1,598,598)
	     port map(
	     	  --clk => clk,
		      clkv => clkv,
		      rst => rst,
		      hsyncin => hsync,
		      vsyncin => vsync,
		      dein => de_in,
		      rin => r_in,
		      gin => g_in,
		      bin => b_in,
		      morphmode => morphmode,
		      videoMode => videoMode,
		      areaMode => areaMode,
		      clkout => open,
		      hsyncout => LED(11),
		      vsyncout => LED(10),
		      deout => de_out,
		      rout =>r_o,
		      gout =>g_o,
		      bout =>b_o,
		      roww => row,
		      coll => col,
		      clrdy => LED1_R,
		      clr => LED2_R
--		      roi_o => LED1_R,
--		      roiend_o => LED2_R,
--		      bh0 => bh0,
--		      bh1 => bh1,
--		      bh2 => bh2,
--		      bh3 => bh3,
--		      bh4 => bh4,
--		      ct0 => ct0,
--		      ct1 => ct1,
--		      ct2 => ct2,
--		      ct3 => ct3,
--		      ct4 => ct4,
		      --hcnt => pixes,
		      --valrev => valrev
	     );	
	    
LED1_G <= '0';
LED1_B <= '0';
LED2_B <= '0';
LED2_B <= '0';

	     
N1ent <= "000" & row when SW(11)='1' else valrev;
N2ent <= "000" & col;


nmode <= SW(15 downto 12);

--mux data
--process(nmode)
--begin
--        case nmode is 
--            when "0000" =>
--                N2ent <= bh0;
--            when "0001" =>
--                N2ent <= bh1;
--            when "0010" =>
--                N2ent <= bh2; 
--            when "0011" =>
--                N2ent <= bh3; 
--            when "0100" =>
--                N2ent <= bh4;
--           when "1101" =>
--                N2ent <= valrev;  
--            when "1000" =>
--                N2ent <= ct0;
--            when "1001" =>
--                N2ent <= ct1;
--            when "1010" =>
--                N2ent <= ct2; 
--            when "1011" =>
--                N2ent <= ct3; 
--            when "1100" =>
--                N2ent <= ct4;
--            when others =>
--                N2ent <= pixes(13 downto 0); 
--        end case;
--end process;
            
FDD2 : entity work.fourdigitdriver (main)
            port map(
            N2 =>  N1ent,
            N => N2ent,
            clk => clk,
            rst => rst,
            ca => ca,
            cb => cb,
            cc => cc,
            cd => cd,
            ce => ce,
            cf => cf,
            cg => cg,
            AN => AN
            );
DP <= '1';



end Behavioral;




--architecture Behavioral of top is

--constant A : std_logic_vector(7 downto 0) := "11110000";
--constant B : std_logic_vector(7 downto 0) := "10101010";
--constant C : std_logic_valrev: out unsigned(13 downto 0)vector(7 downto 0) := "01010101";
--constant D : std_logic_vector(7 downto 0) := "00001111";

--constant R1 : std_logic_vector(7 downto 0) := A and B;
--constant R2 : std_logic_vector(7 downto 0) := A or B;
--constant R3 : std_logic_vector(7 downto 0) := C and D;
--constant R4 : std_logic_vector(7 downto 0) := C or D;

--signal RO,OP : std_logic_vector(7 downto 0);

--signal sw1,sw2 : std_logic_vector(1 downto 0);

--begin


--RO <= "11111111" when OP=R1 or OP=R2 or OP=R3 or OP=R4 else "00000000";
--JB <= OP;

--sw1 <= SW(15 downto 14);
--sw2 <= SW(13 downto 12);

--process(sw1,sw2,JA,JD)
--begin
--    case (sw1) is
--    when "00"=>
--        LED (15 downto 8) <= JA;
--        LED (7 downto 0) <= JD;
--    when "01"=>
--        LED (15 downto 8) <= OP;
--        LED (7 downto 0) <= RO;
--    when others=>
--        LED <= SW;
--    end case;
    
--    case (sw2) is
--    when "00"=>
--        OP <= JA and JD;
--    when "10"=>
--        OP <= JA;
--    when "11"=>
--        OP <= JD;
--    when others=>
--        OP <= JA or JD;
--    end case;
    
--end process;

--end Behavioral;