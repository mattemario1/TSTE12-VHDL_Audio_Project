--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Hardware_testing.behav
--
-- Created:
--          by - matho019.student-liu.se (muxen2-111.ad.liu.se)
--          at - 18:35:16 10/01/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Control_Hardware_testing IS
   PORT( 
      Balance_setting     : IN     std_logic_vector (3 DOWNTO 0);
      Echo_room_setting   : IN     std_logic_vector (3 DOWNTO 0);
      Echo_volume_setting : IN     std_logic_vector (3 DOWNTO 0);
      Selected_setting    : IN     std_logic_vector (1 DOWNTO 0);
      Volume_setting      : IN     std_logic_vector (3 DOWNTO 0);
      fpga_clk            : IN     std_logic;
      fpga_reset_n        : IN     std_logic;
      Hex0                : OUT    std_logic_vector (6 DOWNTO 0);
      Hex1                : OUT    std_logic_vector (6 DOWNTO 0);
      Hex2                : OUT    std_logic_vector (6 DOWNTO 0);
      Hex6                : OUT    std_logic_vector (6 DOWNTO 0);
      Hex7                : OUT    std_logic_vector (6 DOWNTO 0);
      db                  : OUT    std_logic_vector (9 DOWNTO 0)
   );

-- Declarations

END Control_Hardware_testing ;

--
ARCHITECTURE behav OF Control_Hardware_testing IS

  constant led_display1 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111001"; 
  constant led_display2 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0100100"; 
  constant led_display3 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0110000"; 
  constant led_display4 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0011001"; 
  constant led_display5 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0010010"; 
  constant led_display6 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000010"; 
  constant led_display7 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111000"; 
  constant led_display8 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000"; 
  constant led_display9 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0010000"; 
  constant led_display0 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1000000"; 
  constant led_displayE : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000110"; 
  
  signal current_setting_t : integer range 0 to 3 := 0;
  signal balance_setting_t : integer range 0 to 10 := 0;
  signal volume_setting_t : integer range 0 to 10 := 0;
  signal echo_room_setting_t : integer range 0 to 10 := 0;
  signal echo_volume_setting_t : integer range 0 to 10 := 0;
  
  signal current_setting_value : integer range 0 to 10 := 0;



  BEGIN

  Hex6 <= led_display9;
  Hex7 <= led_display0;

  current_setting_t <= to_integer(unsigned(Selected_setting));
  balance_setting_t <= to_integer(unsigned(Balance_setting));
  volume_setting_t  <= to_integer(unsigned(Volume_setting));
  echo_room_setting_t <= to_integer(unsigned(Echo_room_setting));
  echo_volume_setting_t <= to_integer(unsigned(Echo_volume_setting));

  process(current_setting_t, current_setting_value)
  begin
    case current_setting_t is
      when 0 =>
        Hex2 <= led_display0;
        current_setting_value <= volume_setting_t;
        db(3 downto 0) <= Volume_setting;
      when 1 =>
        Hex2 <= led_display1;
        current_setting_value <= balance_setting_t;
        db(3 downto 0) <= Balance_setting;
      when 2 =>
        Hex2 <= led_display2;
        current_setting_value <= echo_room_setting_t;
        db(3 downto 0) <= Echo_room_setting;
      when 3 =>
        Hex2 <= led_display3;
        current_setting_value <= echo_volume_setting_t;
        db(3 downto 0) <= Echo_volume_setting;
      when others =>
        Hex2 <= led_displayE;
    end case;

    case current_setting_value is
      when 0 =>
        Hex0 <= led_display0;
      when 1 =>
        Hex0 <= led_display1;
      when 2 =>
        Hex0 <= led_display2;
      when 3 =>
        Hex0 <= led_display3;
      when 4 =>
        Hex0 <= led_display4;
      when 5 =>
        Hex0 <= led_display5;
      when 6 =>
        Hex0 <= led_display6;
      when 7 =>
        Hex0 <= led_display7;
      when 8 =>
        Hex0 <= led_display8;
      when 9 =>
        Hex0 <= led_display9;
      when others =>
        Hex0 <= led_displayE;
    end case;
  end process;


END ARCHITECTURE behav;

