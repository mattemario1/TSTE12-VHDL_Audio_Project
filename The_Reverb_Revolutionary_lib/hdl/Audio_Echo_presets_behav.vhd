--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Audio_Echo_presets.behav
--
-- Created:
--          by - matho019.student-liu.se (muxen2-109.ad.liu.se)
--          at - 13:45:49 10/23/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Audio_Echo_presets IS
   PORT( 
      fpga_clk          : IN std_logic;
      fpga_reset_n      : IN std_logic;
      feedback_volume   : OUT    std_logic_vector (3 DOWNTO 0);
      echo1_volume      : OUT    std_logic_vector (3 DOWNTO 0);
      echo2_volume      : OUT    std_logic_vector (3 DOWNTO 0);
      echo3_volume      : OUT    std_logic_vector (3 DOWNTO 0);
      echo4_volume      : OUT    std_logic_vector (3 DOWNTO 0);
      echo1_delay_time  : OUT    unsigned(16 downto 0);
      echo2_delay_time  : OUT    unsigned(16 downto 0);
      echo3_delay_time  : OUT    unsigned(16 downto 0);
      echo4_delay_time  : OUT    unsigned(16 downto 0);
      Echo_room_setting : IN     std_logic_vector (3 DOWNTO 0)
   );

-- Declarations

END Audio_Echo_presets ;

--
ARCHITECTURE behav OF Audio_Echo_presets IS
BEGIN

  process(fpga_clk, fpga_reset_n)
  begin

    if fpga_reset_n = '0' then

    elsif (rising_edge(fpga_clk)) then
      
      case Echo_room_setting is

        when x"0" =>
          feedback_volume <= x"3";
          echo1_volume <= x"8";
          echo2_volume <= x"5";
          echo3_volume <= x"3";
          echo4_volume <= x"2";
          echo1_delay_time <= to_unsigned(8000, echo1_delay_time'length);
          echo2_delay_time <= to_unsigned(16000, echo1_delay_time'length);
          echo3_delay_time <= to_unsigned(24000, echo1_delay_time'length);
          echo4_delay_time <= to_unsigned(32000, echo1_delay_time'length);
        when x"1" =>
          feedback_volume <= x"3";
          echo1_volume <= x"7";
          echo2_volume <= x"6";
          echo3_volume <= x"5";
          echo4_volume <= x"4";
          echo1_delay_time <= to_unsigned(4000, echo1_delay_time'length);
          echo2_delay_time <= to_unsigned(8000, echo1_delay_time'length);
          echo3_delay_time <= to_unsigned(12000, echo1_delay_time'length);
          echo4_delay_time <= to_unsigned(16000, echo1_delay_time'length);
        when x"2" =>
          feedback_volume <= x"4";
          echo1_volume <= x"9";
          echo2_volume <= x"8";
          echo3_volume <= x"7";
          echo4_volume <= x"6";
          echo1_delay_time <= to_unsigned(2000, echo1_delay_time'length);
          echo2_delay_time <= to_unsigned(3000, echo1_delay_time'length);
          echo3_delay_time <= to_unsigned(4000, echo1_delay_time'length);
          echo4_delay_time <= to_unsigned(5000, echo1_delay_time'length);
        when x"3" =>
          feedback_volume <= x"3";
          echo1_volume <= x"9";
          echo2_volume <= x"7";
          echo3_volume <= x"5";
          echo4_volume <= x"3";
          echo1_delay_time <= to_unsigned(20000, echo1_delay_time'length);
          echo2_delay_time <= to_unsigned(25000, echo1_delay_time'length);
          echo3_delay_time <= to_unsigned(30000, echo1_delay_time'length);
          echo4_delay_time <= to_unsigned(35000, echo1_delay_time'length);
        when x"4" =>
          feedback_volume <= x"2";
          echo1_volume <= x"2";
          echo2_volume <= x"8";
          echo3_volume <= x"7";
          echo4_volume <= x"6";
          echo1_delay_time <= to_unsigned(32544, echo1_delay_time'length);
          echo2_delay_time <= to_unsigned(32554, echo1_delay_time'length);
          echo3_delay_time <= to_unsigned(12546, echo1_delay_time'length);
          echo4_delay_time <= to_unsigned(1232, echo1_delay_time'length);
        when x"5" =>
          feedback_volume <= x"0";
          echo1_volume <= x"4";
          echo2_volume <= x"9";
          echo3_volume <= x"7";
          echo4_volume <= x"6";
          echo1_delay_time <= to_unsigned(32776, echo1_delay_time'length);
          echo2_delay_time <= to_unsigned(25, echo1_delay_time'length);
          echo3_delay_time <= to_unsigned(6000, echo1_delay_time'length);
          echo4_delay_time <= to_unsigned(25, echo1_delay_time'length);
        when x"6" =>
          feedback_volume <= x"0";
          echo1_volume <= x"9";
          echo2_volume <= x"0";
          echo3_volume <= x"0";
          echo4_volume <= x"0";
          echo1_delay_time <= to_unsigned(20000, echo1_delay_time'length);
          echo2_delay_time <= to_unsigned(32000, echo1_delay_time'length);
          echo3_delay_time <= to_unsigned(33000, echo1_delay_time'length);
          echo4_delay_time <= to_unsigned(33000, echo1_delay_time'length);
        when x"7" =>
          feedback_volume <= x"0";
          echo1_volume <= x"6";
          echo2_volume <= x"9";
          echo3_volume <= x"4";
          echo4_volume <= x"2";
          echo1_delay_time <= to_unsigned(44000, echo1_delay_time'length);
          echo2_delay_time <= to_unsigned(40000, echo1_delay_time'length);
          echo3_delay_time <= to_unsigned(6028, echo1_delay_time'length);
          echo4_delay_time <= to_unsigned(69, echo1_delay_time'length);
        when x"8" =>
          feedback_volume <= x"4";
          echo1_volume <= x"9";
          echo2_volume <= x"5";
          echo3_volume <= x"6";
          echo4_volume <= x"3";
          echo1_delay_time <= to_unsigned(1000, echo1_delay_time'length);
          echo2_delay_time <= to_unsigned(1337, echo1_delay_time'length);
          echo3_delay_time <= to_unsigned(29400, echo1_delay_time'length);
          echo4_delay_time <= to_unsigned(8063, echo1_delay_time'length);
        when x"9" =>
          feedback_volume <= x"7";
          echo1_volume <= x"5";
          echo2_volume <= x"4";
          echo3_volume <= x"3";
          echo4_volume <= x"2";
          echo1_delay_time <= to_unsigned(5000, echo1_delay_time'length);
          echo2_delay_time <= to_unsigned(10000, echo1_delay_time'length);
          echo3_delay_time <= to_unsigned(20000, echo1_delay_time'length);
          echo4_delay_time <= to_unsigned(40000, echo1_delay_time'length);
        when x"A" =>
          feedback_volume <= x"A";
          echo1_volume <= x"A";
          echo2_volume <= x"A";
          echo3_volume <= x"A";
          echo4_volume <= x"A";
          echo1_delay_time <= to_unsigned(6969, echo1_delay_time'length);
          echo2_delay_time <= to_unsigned(42069, echo1_delay_time'length);
          echo3_delay_time <= to_unsigned(8008, echo1_delay_time'length);
          echo4_delay_time <= to_unsigned(8008, echo1_delay_time'length);
        when others =>
          feedback_volume <= x"0";
          echo1_volume <= x"0";
          echo2_volume <= x"0";
          echo3_volume <= x"0";
          echo4_volume <= x"0";
          echo1_delay_time <= to_unsigned(0, echo1_delay_time'length);
          echo2_delay_time <= to_unsigned(0, echo1_delay_time'length);
          echo3_delay_time <= to_unsigned(0, echo1_delay_time'length);
          echo4_delay_time <= to_unsigned(0, echo1_delay_time'length);
            
      end case;

    end if;
  end process;


END ARCHITECTURE behav;

