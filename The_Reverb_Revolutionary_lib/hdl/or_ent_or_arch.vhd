--
-- VHDL Architecture Lab2_lib.or_ent.or_arch
--
-- Created:
--          by - emibj862.student-liu.se (muxen2-110.ad.liu.se)
--          at - 16:08:16 09/19/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Visual_or_ent IS
   PORT( 
      hblanc       : IN     std_logic;
      vblanc       : IN     std_logic;
      fpga_clk_65M : IN     std_logic;
      vga_blank_n  : OUT    std_logic
   );

-- Declarations

END Visual_or_ent ;

--
ARCHITECTURE or_arch OF Visual_or_ent IS
BEGIN
  process(fpga_clk_65M ,vga_blank_n, hblanc, vblanc)
  begin 
    if falling_edge(fpga_clk_65M) then -- falling_edge
      
      vga_blank_n <= not (hblanc or vblanc);
  
    end if; 
  end process; 
    
  
END ARCHITECTURE or_arch;
