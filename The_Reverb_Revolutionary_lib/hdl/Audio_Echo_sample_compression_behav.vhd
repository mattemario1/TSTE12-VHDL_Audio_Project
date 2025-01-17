--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Audio_Echo_sample_compression.behav
--
-- Created:
--          by - akhpr339.student-liu.se (muxen2-112.ad.liu.se)
--          at - 14:43:58 10/14/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Audio_Echo_sample_compression IS
   PORT( 
      audio_in           : IN     std_logic_vector (15 DOWNTO 0);
      audio_echo_feedback_in : IN std_logic_vector (15 DOWNTO 0);
      audio_out          : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END Audio_Echo_sample_compression ;

--
ARCHITECTURE behav OF Audio_Echo_sample_compression IS
BEGIN
  audio_out <= std_logic_vector(signed(audio_in) + signed(audio_echo_feedback_in));
END ARCHITECTURE behav;

