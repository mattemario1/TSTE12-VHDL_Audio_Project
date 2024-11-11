--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Visua_memory_write.arch
--
-- Created:
--          by - emipi270.student-liu.se (muxen2-111.ad.liu.se)
--          at - 15:12:01 10/09/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Visua_memory_write IS
   PORT( 
      c0     : IN     STD_LOGIC;
      locked : IN     STD_LOGIC
   );

-- Declarations

END Visua_memory_write ;

--
ARCHITECTURE arch OF Visua_memory_write IS
  
  type square is array (0 to 2499) of std_logic_vector(19 downto 0);
--  signal pixel_square : square := (others => x"f800"); 
 -- signal addr_cnt : integer(19 downto 0) := sram_adress;
  signal colour : std_logic_vector(15 downto 0) := x"f800";
  signal write_to_sram : std_logic_vector(15 downto 0);
BEGIN  
  
  
  
  
  
  process
  begin
  if rising_edge(c0) then 
  ----  if sram_ce_n = '1' then 
   --  if sram_we_n = '1' then 
    
       --if hblanc or vblanc then 
          for square in 0 to square'length loop
          write_to_sram <= colour;
      --    sram_address(19 downto 0) <= addr_cnt + 1;
        end loop; 
         
      
    --end if; 
  --end if;
end if;
--end if; 
  end process; 

  
END ARCHITECTURE arch;

