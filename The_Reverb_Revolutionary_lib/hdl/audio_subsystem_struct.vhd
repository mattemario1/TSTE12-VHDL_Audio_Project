-- VHDL Entity The_Reverb_Revolutionary_lib.AUDIO_Subsystem.symbol
--
-- Created:
--          by - matho019.student-liu.se (muxen2-109.ad.liu.se)
--          at - 18:10:47 10/28/24
--
-- Generated by Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY AUDIO_Subsystem IS
   PORT( 
      Balance_setting     : IN     std_logic_vector (3 DOWNTO 0);
      Echo_room_setting   : IN     std_logic_vector (3 DOWNTO 0);
      Echo_volume_setting : IN     std_logic_vector (3 DOWNTO 0);
      Volume_setting      : IN     std_logic_vector (3 DOWNTO 0);
      adcdat              : IN     std_logic;
      fpga_clk            : IN     std_logic;
      fpga_reset_n        : IN     std_logic;
      adclrck             : OUT    std_logic;
      bclk                : OUT    std_logic;
      dacdat              : OUT    std_logic;
      daclrck             : OUT    std_logic;
      db                  : OUT    std_logic_vector (17 DOWNTO 0);
      i2c_scl             : OUT    std_logic;
      xck                 : OUT    std_logic;
      i2c_sda             : INOUT  std_logic
   );

-- Declarations

END AUDIO_Subsystem ;

--
-- VHDL Architecture The_Reverb_Revolutionary_lib.AUDIO_Subsystem.struct
--
-- Created:
--          by - matho019.student-liu.se (muxen2-109.ad.liu.se)
--          at - 18:10:47 10/28/24
--
-- Generated by Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

LIBRARY The_Reverb_Revolutionary_lib;

ARCHITECTURE struct OF AUDIO_Subsystem IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL audio_L_output : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_R_output : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_in       : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_in1      : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_out      : std_logic_vector(15 DOWNTO 0);
   SIGNAL audio_valid    : std_logic;
   SIGNAL left_in        : std_logic_vector(15 DOWNTO 0);
   SIGNAL right_in       : std_logic_vector(15 DOWNTO 0);


   -- Component Declarations
   COMPONENT Audio_Balance
   PORT (
      Balance_setting : IN     std_logic_vector (3 DOWNTO 0);
      audio_in        : IN     std_logic_vector (15 DOWNTO 0);
      fpga_clk        : IN     std_logic;
      fpga_reset_n    : IN     std_logic;
      audio_L_output  : OUT    std_logic_vector (15 DOWNTO 0);
      audio_R_output  : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT Audio_Echo_top_block
   PORT (
      Audio_valid         : IN     std_logic ;
      Echo_room_setting   : IN     std_logic_vector (3 DOWNTO 0);
      Echo_volume_setting : IN     std_logic_vector (3 DOWNTO 0);
      audio_in            : IN     std_logic_vector (15 DOWNTO 0);
      fpga_clk            : IN     std_logic ;
      fpga_reset_n        : IN     std_logic ;
      audio_out           : OUT    std_logic_vector (15 DOWNTO 0)
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
   COMPONENT Audio_codec_block
   PORT (
      Audio_L_output : IN     std_logic_vector (15 DOWNTO 0);
      Audio_R_output : IN     std_logic_vector (15 DOWNTO 0);
      adcdat         : IN     std_logic ;
      fpga_clk       : IN     std_logic ;
      fpga_reset_n   : IN     std_logic ;
      adclrck        : OUT    std_logic ;
      audio_valid    : OUT    std_logic ;
      bclk           : OUT    std_logic ;
      config_done    : OUT    std_logic ;
      dacdat         : OUT    std_logic ;
      daclrck        : OUT    std_logic ;
      db             : OUT    std_logic_vector (17 DOWNTO 0);
      i2c_scl        : OUT    std_logic ;
      sample_l       : OUT    std_logic_vector (15 DOWNTO 0);
      sample_r       : OUT    std_logic_vector (15 DOWNTO 0);
      xck            : OUT    std_logic ;
      i2c_sda        : INOUT  std_logic 
   );
   END COMPONENT;
   COMPONENT Audio_stereo_2_mono
   PORT (
      fpga_clk     : IN     std_logic;
      fpga_reset_n : IN     std_logic;
      left_in      : IN     std_logic_vector (15 DOWNTO 0);
      right_in     : IN     std_logic_vector (15 DOWNTO 0);
      mono_out     : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : Audio_Balance USE ENTITY The_Reverb_Revolutionary_lib.Audio_Balance;
   FOR ALL : Audio_Echo_top_block USE ENTITY The_Reverb_Revolutionary_lib.Audio_Echo_top_block;
   FOR ALL : Audio_Volume USE ENTITY The_Reverb_Revolutionary_lib.Audio_Volume;
   FOR ALL : Audio_codec_block USE ENTITY The_Reverb_Revolutionary_lib.Audio_codec_block;
   FOR ALL : Audio_stereo_2_mono USE ENTITY The_Reverb_Revolutionary_lib.Audio_stereo_2_mono;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_3 : Audio_Balance
      PORT MAP (
         audio_in        => audio_in,
         Balance_setting => Balance_setting,
         fpga_clk        => fpga_clk,
         fpga_reset_n    => fpga_reset_n,
         audio_L_output  => audio_L_output,
         audio_R_output  => audio_R_output
      );
   U_4 : Audio_Echo_top_block
      PORT MAP (
         Audio_valid         => audio_valid,
         Echo_room_setting   => Echo_room_setting,
         Echo_volume_setting => Echo_volume_setting,
         audio_in            => audio_in1,
         fpga_clk            => fpga_clk,
         fpga_reset_n        => fpga_reset_n,
         audio_out           => audio_out
      );
   U_1 : Audio_Volume
      PORT MAP (
         fpga_clk       => fpga_clk,
         fpga_reset_n   => fpga_reset_n,
         Volume_setting => Volume_setting,
         audio_in       => audio_out,
         audio_out      => audio_in
      );
   U_0 : Audio_codec_block
      PORT MAP (
         Audio_L_output => audio_L_output,
         Audio_R_output => audio_R_output,
         adcdat         => adcdat,
         fpga_clk       => fpga_clk,
         fpga_reset_n   => fpga_reset_n,
         adclrck        => adclrck,
         audio_valid    => audio_valid,
         bclk           => bclk,
         config_done    => OPEN,
         dacdat         => dacdat,
         daclrck        => daclrck,
         db             => db,
         i2c_scl        => i2c_scl,
         sample_l       => left_in,
         sample_r       => right_in,
         xck            => xck,
         i2c_sda        => i2c_sda
      );
   U_2 : Audio_stereo_2_mono
      PORT MAP (
         fpga_clk     => fpga_clk,
         fpga_reset_n => fpga_reset_n,
         mono_out     => audio_in1,
         left_in      => left_in,
         right_in     => right_in
      );

END struct;
