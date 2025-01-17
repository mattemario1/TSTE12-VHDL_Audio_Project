-- VHDL Entity The_Reverb_Revolutionary_lib.Audio_Echo_top_block.symbol
--
-- Created:
--          by - matho019.student-liu.se (muxen2-109.ad.liu.se)
--          at - 15:36:32 10/28/24
--
-- Generated by Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Audio_Echo_top_block IS
   PORT( 
      Audio_valid         : IN     std_logic;
      Echo_room_setting   : IN     std_logic_vector (3 DOWNTO 0);
      Echo_volume_setting : IN     std_logic_vector (3 DOWNTO 0);
      audio_in            : IN     std_logic_vector (15 DOWNTO 0);
      fpga_clk            : IN     std_logic;
      fpga_reset_n        : IN     std_logic;
      audio_out           : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END Audio_Echo_top_block ;

--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Audio_Echo_top_block.struct
--
-- Created:
--          by - matho019.student-liu.se (muxen2-106.ad.liu.se)
--          at - 16:14:23 11/11/24
--
-- Generated by Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE IEEE.MATH_REAL.ALL;

LIBRARY The_Reverb_Revolutionary_lib;

ARCHITECTURE struct OF Audio_Echo_top_block IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Volume_setting   : std_logic_vector(3 DOWNTO 0);
   SIGNAL audio_echo1      : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_echo2      : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_echo3      : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_echo4      : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_echo_out1  : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_echo_out2  : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_echo_out3  : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_echo_out4  : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_out1       : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_out2       : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_out3       : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_out4       : std_logic_vector(15 DOWNTO 0);
   SIGNAL echo1_delay_time : unsigned(16 DOWNTO 0);
   SIGNAL echo1_volume     : std_logic_vector(3 DOWNTO 0);
   SIGNAL echo2_delay_time : unsigned(16 DOWNTO 0);
   SIGNAL echo2_volume     : std_logic_vector(3 DOWNTO 0);
   SIGNAL echo3_delay_time : unsigned(16 DOWNTO 0);
   SIGNAL echo3_volume     : std_logic_vector(3 DOWNTO 0);
   SIGNAL echo4_delay_time : unsigned(16 DOWNTO 0);
   SIGNAL echo4_volume     : std_logic_vector(3 DOWNTO 0);


   -- Component Declarations
   COMPONENT Audio_Echo_add_echo
   PORT (
      audio_echo_in : IN     std_logic_vector (15 DOWNTO 0);
      audio_in      : IN     std_logic_vector (15 DOWNTO 0);
      fpga_clk      : IN     std_logic;
      fpga_reset_n  : IN     std_logic;
      audio_out     : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT Audio_Echo_add_echos_together
   PORT (
      audio_echo1 : IN     std_logic_vector (15 DOWNTO 0);
      audio_echo2 : IN     std_logic_vector (15 DOWNTO 0);
      audio_echo3 : IN     std_logic_vector (15 DOWNTO 0);
      audio_echo4 : IN     std_logic_vector (15 DOWNTO 0);
      audio_out   : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT Audio_Echo_delay
   PORT (
      audio_in        : IN     std_logic_vector (15 DOWNTO 0);
      audio_valid     : IN     std_logic;
      delay_time1     : IN     unsigned (16 DOWNTO 0);
      delay_time2     : IN     unsigned (16 DOWNTO 0);
      delay_time3     : IN     unsigned (16 DOWNTO 0);
      delay_time4     : IN     unsigned (16 DOWNTO 0);
      fpga_clk        : IN     std_logic;
      fpga_reset_n    : IN     std_logic;
      audio_echo_out1 : OUT    std_logic_vector (15 DOWNTO 0);
      audio_echo_out2 : OUT    std_logic_vector (15 DOWNTO 0);
      audio_echo_out3 : OUT    std_logic_vector (15 DOWNTO 0);
      audio_echo_out4 : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT Audio_Echo_presets
   PORT (
      Echo_room_setting : IN     std_logic_vector (3 DOWNTO 0);
      fpga_clk          : IN     std_logic;
      fpga_reset_n      : IN     std_logic;
      echo1_delay_time  : OUT    unsigned (16 DOWNTO 0);
      echo1_volume      : OUT    std_logic_vector (3 DOWNTO 0);
      echo2_delay_time  : OUT    unsigned (16 DOWNTO 0);
      echo2_volume      : OUT    std_logic_vector (3 DOWNTO 0);
      echo3_delay_time  : OUT    unsigned (16 DOWNTO 0);
      echo3_volume      : OUT    std_logic_vector (3 DOWNTO 0);
      echo4_delay_time  : OUT    unsigned (16 DOWNTO 0);
      echo4_volume      : OUT    std_logic_vector (3 DOWNTO 0);
      feedback_volume   : OUT    std_logic_vector (3 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT Audio_Echo_sample_compression
   PORT (
      audio_echo_feedback_in : IN     std_logic_vector (15 DOWNTO 0);
      audio_in               : IN     std_logic_vector (15 DOWNTO 0);
      audio_out              : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT Audio_Volume
   PORT (
      Volume_setting : IN     std_logic_vector (3 DOWNTO 0);
      audio_in       : IN     std_logic_vector (15 DOWNTO 0);
      fpga_clk       : IN     std_logic;
      fpga_reset_n   : IN     std_logic;
      audio_out      : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : Audio_Echo_add_echo USE ENTITY The_Reverb_Revolutionary_lib.Audio_Echo_add_echo;
   FOR ALL : Audio_Echo_add_echos_together USE ENTITY The_Reverb_Revolutionary_lib.Audio_Echo_add_echos_together;
   FOR ALL : Audio_Echo_delay USE ENTITY The_Reverb_Revolutionary_lib.Audio_Echo_delay;
   FOR ALL : Audio_Echo_presets USE ENTITY The_Reverb_Revolutionary_lib.Audio_Echo_presets;
   FOR ALL : Audio_Echo_sample_compression USE ENTITY The_Reverb_Revolutionary_lib.Audio_Echo_sample_compression;
   FOR ALL : Audio_Volume USE ENTITY The_Reverb_Revolutionary_lib.Audio_Volume;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_4 : Audio_Echo_add_echo
      PORT MAP (
         fpga_clk      => fpga_clk,
         fpga_reset_n  => fpga_reset_n,
         audio_in      => audio_in,
         audio_echo_in => audio_out3,
         audio_out     => audio_out
      );
   U_5 : Audio_Echo_add_echos_together
      PORT MAP (
         audio_echo1 => audio_echo1,
         audio_echo2 => audio_echo2,
         audio_echo3 => audio_echo3,
         audio_echo4 => audio_echo4,
         audio_out   => audio_out4
      );
   U_1 : Audio_Echo_delay
      PORT MAP (
         fpga_clk        => fpga_clk,
         fpga_reset_n    => fpga_reset_n,
         audio_in        => audio_out2,
         audio_echo_out1 => audio_echo_out1,
         audio_echo_out2 => audio_echo_out2,
         audio_echo_out3 => audio_echo_out3,
         audio_echo_out4 => audio_echo_out4,
         audio_valid     => Audio_valid,
         delay_time1     => echo1_delay_time,
         delay_time2     => echo2_delay_time,
         delay_time3     => echo3_delay_time,
         delay_time4     => echo4_delay_time
      );
   U_2 : Audio_Echo_presets
      PORT MAP (
         fpga_clk          => fpga_clk,
         fpga_reset_n      => fpga_reset_n,
         feedback_volume   => Volume_setting,
         echo1_volume      => echo1_volume,
         echo2_volume      => echo2_volume,
         echo3_volume      => echo3_volume,
         echo4_volume      => echo4_volume,
         echo1_delay_time  => echo1_delay_time,
         echo2_delay_time  => echo2_delay_time,
         echo3_delay_time  => echo3_delay_time,
         echo4_delay_time  => echo4_delay_time,
         Echo_room_setting => Echo_room_setting
      );
   U_0 : Audio_Echo_sample_compression
      PORT MAP (
         audio_in               => audio_in,
         audio_echo_feedback_in => audio_out1,
         audio_out              => audio_out2
      );
   U_3 : Audio_Volume
      PORT MAP (
         fpga_clk       => fpga_clk,
         fpga_reset_n   => fpga_reset_n,
         Volume_setting => echo4_volume,
         audio_in       => audio_echo_out4,
         audio_out      => audio_echo1
      );
   U_6 : Audio_Volume
      PORT MAP (
         fpga_clk       => fpga_clk,
         fpga_reset_n   => fpga_reset_n,
         Volume_setting => echo3_volume,
         audio_in       => audio_echo_out3,
         audio_out      => audio_echo2
      );
   U_7 : Audio_Volume
      PORT MAP (
         fpga_clk       => fpga_clk,
         fpga_reset_n   => fpga_reset_n,
         Volume_setting => echo2_volume,
         audio_in       => audio_echo_out2,
         audio_out      => audio_echo3
      );
   U_8 : Audio_Volume
      PORT MAP (
         fpga_clk       => fpga_clk,
         fpga_reset_n   => fpga_reset_n,
         Volume_setting => echo1_volume,
         audio_in       => audio_echo_out1,
         audio_out      => audio_echo4
      );
   U_9 : Audio_Volume
      PORT MAP (
         fpga_clk       => fpga_clk,
         fpga_reset_n   => fpga_reset_n,
         Volume_setting => Volume_setting,
         audio_in       => audio_out4,
         audio_out      => audio_out1
      );
   U_10 : Audio_Volume
      PORT MAP (
         fpga_clk       => fpga_clk,
         fpga_reset_n   => fpga_reset_n,
         Volume_setting => Echo_volume_setting,
         audio_in       => audio_out4,
         audio_out      => audio_out3
      );

END struct;
