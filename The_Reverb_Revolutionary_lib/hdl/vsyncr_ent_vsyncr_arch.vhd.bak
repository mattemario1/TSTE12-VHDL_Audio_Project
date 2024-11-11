--
-- VHDL Architecture Lab2_lib.vsyncr_ent.vsync_arch
--
-- Created:
--          by - emibj862.student-liu.se (muxen2-110.ad.liu.se)
--          at - 11:53:20 09/19/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Visual_vsyncr_ent IS
   PORT( 
      vcnt         : IN     unsigned (9 DOWNTO 0);
      vga_sync     : OUT    std_logic;
      vsyncr       : OUT    std_logic;
      vblanc       : OUT    std_logic;
      fpga_clk_65M : IN     std_logic
   );

-- Declarations

END Visual_vsyncr_ent ;

--
ARCHITECTURE vsync_arch OF Visual_vsyncr_ent IS
  
BEGIN
  
  process (fpga_clk_65M, vcnt, vsyncr, vga_sync)
  begin 
    
    if rising_edge(fpga_clk_65M) then
      if (vcnt = 805)then 
        vsyncr <= '0';
      elsif vcnt > 6 then
        vsyncr <= '1';
      end if;
      if vcnt < 797 and vcnt > 29 then
          vblanc <= '0';
        elsif vcnt < 29 or vcnt > 797 then  
          vblanc <= '1';
        end if;
    end if;
      
    
  end process; 
  
  vga_sync <= '0';

END ARCHITECTURE vsync_arch;
