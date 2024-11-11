--
-- VHDL Architecture Lab2_lib.vcnt_ent.vcnt_arch
--
-- Created:
--          by - emibj862.student-liu.se (muxen2-110.ad.liu.se)
--          at - 16:14:52 09/19/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Visual_vcnt_ent IS
   PORT( 
      vcnt         : OUT    unsigned (9 DOWNTO 0);
      hsyncr       : IN     std_logic;
      fpga_clk_65M : IN     std_logic;
      fpga_reset_n : IN     std_logic
   );

-- Declarations

END Visual_vcnt_ent ;

--
ARCHITECTURE vcnt_arch OF Visual_vcnt_ent IS
  
  signal hsync_old: std_logic := '0';
  
BEGIN
  
  process (fpga_reset_n, fpga_clk_65M, hsyncr, vcnt)
  
  begin 
    
    if fpga_reset_n = '0' then
        vcnt <= (others => '0');
    elsif rising_edge(fpga_clk_65M) then
      if hsyncr and not hsync_old then
        vcnt <= vcnt + 1;
        if vcnt = 805 then
          vcnt <= (others => '0');  
        end if;   
      end if;
      hsync_old <= hsyncr;
    end if;
  end process;
  
END ARCHITECTURE vcnt_arch;
