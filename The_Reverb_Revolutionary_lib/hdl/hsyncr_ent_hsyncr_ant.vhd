--
-- VHDL Architecture Lab2_lib.hsyncr_ent.hsyncr_ant
--
-- Created:
--          by - emibj862.student-liu.se (muxen2-110.ad.liu.se)
--          at - 11:52:09 09/19/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Visual_hsyncr_ent IS
   PORT( 
      hsyncr       : OUT    std_logic;
      hblanc       : OUT    std_logic;
      hcnt         : IN     unsigned (10 DOWNTO 0);
      fpga_clk_65M : IN     std_logic;
      fpga_reset_n : IN     std_logic
   );

-- Declarations

END Visual_hsyncr_ent ;

--
ARCHITECTURE hsyncr_ant OF Visual_hsyncr_ent IS
  
BEGIN
  
  process (fpga_reset_n, fpga_clk_65M, hcnt, hsyncr, hblanc)
  begin 
    if rising_edge(fpga_clk_65M) then      
        if hcnt > 1342 then 
          hsyncr <= '0';
        elsif (hcnt > 136) and (hcnt < 1343) then
          hsyncr <= '1';
        end if;
        
        if hcnt > (136+160) and hcnt < (136+160+1024) then
          hblanc <= '0';
        elsif hcnt < (136+160) or hcnt > (136+160+1024) then   
          hblanc <= '1';
        end if;
  end if;
      
    
  end process; 
  
  
  
END ARCHITECTURE hsyncr_ant;
