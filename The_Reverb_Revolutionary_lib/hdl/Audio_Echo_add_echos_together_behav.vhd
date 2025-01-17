--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Audio_Echo_add_echos_together.behav
--
-- Created:
--          by - matho019.student-liu.se (muxen2-109.ad.liu.se)
--          at - 16:12:10 10/28/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE IEEE.MATH_REAL.ALL;

ENTITY Audio_Echo_add_echos_together IS
   PORT( 
      audio_echo1 : IN     std_logic_vector (15 DOWNTO 0);
      audio_echo2 : IN     std_logic_vector (15 DOWNTO 0);
      audio_echo3 : IN     std_logic_vector (15 DOWNTO 0);
      audio_echo4 : IN     std_logic_vector (15 DOWNTO 0);
      audio_out  : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END Audio_Echo_add_echos_together ;

--
ARCHITECTURE behav OF Audio_Echo_add_echos_together IS
BEGIN

   audio_out <= std_logic_vector(signed(audio_echo1) + signed(audio_echo2) + signed(audio_echo3) + signed(audio_echo4));

END ARCHITECTURE behav;

