--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Visual_SRAM_or_overlay.arch
--
-- Created:
--          by - emipi270.student-liu.se (muxen2-102.ad.liu.se)
--          at - 12:07:37 10/14/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Visual_SRAM_or_overlay IS
   PORT( 
      SRAM_Data             : IN     std_logic_vector (15 DOWNTO 0);
      Screen_overlay        : IN     std_logic_vector (15 DOWNTO 0);
      Screen_overlay_active : IN     std_logic;
      c0                    : IN     STD_LOGIC;
      locked                : IN     STD_LOGIC;
      Visual_output         : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END Visual_SRAM_or_overlay ;

--
ARCHITECTURE arch OF Visual_SRAM_or_overlay IS
BEGIN
  process(c0)
  begin
    if rising_edge(c0) then
      
    if Screen_overlay_active then
      Visual_output <= Screen_overlay;
     else 
        Visual_output <= SRAM_Data;
     end if;
      end if;
   end process;
END ARCHITECTURE arch;

