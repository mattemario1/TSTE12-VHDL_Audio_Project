-- VHDL Entity The_Reverb_Revolutionary_lib.Audio_Echo_add_echo1.generatedInstance
--
-- Created:
--          by - matho019.student-liu.se (muxen2-109.ad.liu.se)
--          at - 15:21:44 10/23/24
--
-- Generated by Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Audio_Echo_add_echo1 IS
   PORT( 
      audio_in            : IN     std_logic_vector (15 DOWNTO 0);
      audio_out           : OUT    std_logic_vector (15 DOWNTO 0);
      audio_out3          : IN     std_logic_vector (15 DOWNTO 0);
      Echo_volume_setting : IN     std_logic_vector (3 DOWNTO 0)
   );

END Audio_Echo_add_echo1 ;

-- 
-- Auto generated dummy architecture for leaf level instance.
-- 
ARCHITECTURE generatedInstance OF Audio_Echo_add_echo1 IS 
BEGIN


END generatedInstance;
