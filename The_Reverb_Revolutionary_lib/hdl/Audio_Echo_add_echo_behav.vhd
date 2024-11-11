--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Audio_Echo_add_echo.behav
--
-- Created:
--          by - matho019.student-liu.se (muxen2-109.ad.liu.se)
--          at - 14:16:27 10/23/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Audio_Echo_add_echo IS
   PORT(
      fpga_clk            : IN     std_logic; 
      fpga_reset_n        : IN     std_logic; 
      audio_in            : IN     std_logic_vector (15 DOWNTO 0);
      audio_echo_in       : IN     std_logic_vector (15 DOWNTO 0);
      audio_out           : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END Audio_Echo_add_echo ;

--
ARCHITECTURE behav OF Audio_Echo_add_echo IS
BEGIN

  process(fpga_clk, fpga_reset_n)
  begin
    if fpga_reset_n = '0' then
      audio_out <= (others => '0');
    elsif rising_edge(fpga_clk) then
      audio_out <= std_logic_vector(signed(audio_echo_in) + signed(audio_in));
      -- if (x"FFFF" < (unsigned(audio_in) + unsigned(audio_echo_in))) then
      --   audio_out <= std_logic_vector(unsigned(audio_echo_in) + unsigned(audio_in));
      -- else
      --   audio_out <= x"FFFF";
      -- end if;
    end if;
  end process;
END ARCHITECTURE behav;

