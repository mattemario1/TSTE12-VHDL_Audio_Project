--
-- VHDL Architecture Lab2_lib.pixel_reg_ent.pixel_reg_arch
--
-- Created:
--          by - emibj862.student-liu.se (muxen2-116.ad.liu.se)
--          at - 15:17:44 09/20/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Visual_pixel_reg IS
   PORT( 
      SRAM_Data    : IN     std_logic_vector (15 DOWNTO 0);
      fpga_clk_65M : IN     std_logic;
      fpga_reset_n : IN     std_logic;
      pixel_data   : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END Visual_pixel_reg ;

--
ARCHITECTURE arch OF Visual_pixel_reg IS

BEGIN
  
  process (fpga_reset_n, fpga_clk_65M, pixel_data)
  begin
    if rising_edge(fpga_clk_65M) then 
      
    if fpga_reset_n = '0' then 
     pixel_data <= (others => '0');     
   
    else pixel_data <= SRAM_Data;    
   
    end if;   
    end if;
     
  end process;
  
END ARCHITECTURE arch;
