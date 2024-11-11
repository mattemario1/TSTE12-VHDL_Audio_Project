--
-- VHDL Architecture Lab2_lib.vga_gen_ent.vga_gen_arch
--
-- Created:
--          by - emipi270.student-liu.se (muxen2-110.ad.liu.se)
--          at - 11:33:40 09/24/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Visual_vga_gen IS
   PORT( 
      pixel_data   : IN     std_logic_vector (15 DOWNTO 0);
      vga_r        : OUT    std_logic_vector (7 DOWNTO 0);
      vga_g        : OUT    std_logic_vector (7 DOWNTO 0);
      vga_b        : OUT    std_logic_vector (7 DOWNTO 0);
      fpga_clk_65M : IN     std_logic;
      vga_blank_n  : IN     std_logic
   );

-- Declarations

END Visual_vga_gen ;

--
ARCHITECTURE arch OF Visual_vga_gen IS
BEGIN
  
  process (fpga_clk_65M, vga_blank_n, pixel_data, vga_r, vga_g, vga_b) 
  begin 
  if rising_edge(fpga_clk_65M) then 
    if vga_blank_n then 
      
    vga_r(7 downto 2) <= pixel_data(15 downto 10);
    vga_r(1 downto 0) <= b"00";
    
    vga_g(7 downto 3) <= pixel_data(9 downto 5);
    vga_g(2 downto 0) <= b"000";
    
    vga_b(7 downto 3) <= pixel_data(4 downto 0);
    vga_b(2 downto 0) <= b"000";
  
   else 
     
    vga_r(7 downto 0) <= b"00000000";
    vga_g(7 downto 0) <= b"00000000";
    vga_b(7 downto 0) <= b"00000000";
    
    end if; 
  end if;
end process;

  
  
  
END ARCHITECTURE arch;
