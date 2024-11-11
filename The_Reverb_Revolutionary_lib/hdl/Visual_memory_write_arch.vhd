--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Visual_memory_write.arch
--
-- Created:
--          by - emipi270.student-liu.se (muxen2-104.ad.liu.se)
--          at - 17:51:45 10/08/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Visual_memory_write IS
   PORT( 
      c0        : IN     STD_LOGIC;
      locked    : IN     STD_LOGIC;
      vblanc    : IN     std_logic;
      hblanc    : IN     std_logic;
      hcnt      : IN     unsigned (10 DOWNTO 0);
      vcnt      : IN     unsigned (9 DOWNTO 0);
      SRAM_Data : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END Visual_memory_write ;

--
ARCHITECTURE arch OF Visual_memory_write IS
BEGIN
  
  process
  begin 
    
    if rising_edge(c0) then 
      if not (vblanc or hblanc ) then 
        
      if hcnt > 800 and vcnt > 100 and hcnt < 900 and vcnt < 684 then 
        SRAM_Data <= "1111110000000000";
      else 
        SRAM_Data <= (others => '1');
    end if;
  end if; 
end if; 
  
  
  end process; 
  
END ARCHITECTURE arch;

