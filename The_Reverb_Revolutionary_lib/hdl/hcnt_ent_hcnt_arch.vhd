--
-- VHDL Architecture Lab2_lib.hcnt_ent.hcnt_arch
--
-- Created:
--          by - emibj862.student-liu.se (muxen2-110.ad.liu.se)
--          at - 11:38:09 09/19/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Visual_hcnt_ent IS
   PORT( 
      hcnt         : OUT    unsigned (10 DOWNTO 0);
      fpga_clk_65M : IN     std_logic;
      fpga_reset_n : IN     std_logic
   );

-- Declarations

END Visual_hcnt_ent ;

--
ARCHITECTURE hcnt_arch OF Visual_hcnt_ent IS
  
BEGIN
  process (fpga_reset_n, fpga_clk_65M, hcnt)
  begin 
    
      if fpga_reset_n = '0' then
         hcnt <= (others => '0');
      elsif rising_edge(fpga_clk_65M) then 
          hcnt <= hcnt + 1;       
          if hcnt = 1343 then 
            hcnt <= (others => '0'); 
          end if; 
        end if;
    
  end process; 
  
  
  
END ARCHITECTURE hcnt_arch;
