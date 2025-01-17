--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Control_Setting.behav
--
-- Created:
--          by - matho019.student-liu.se (muxen2-114.ad.liu.se)
--          at - 18:09:51 09/27/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Control_Output_Setting IS
   PORT( 
      down                : IN     std_logic;
      left                : IN     std_logic;
      right               : IN     std_logic;
      up                  : IN     std_logic;
      Balance_setting     : OUT    std_logic_vector (3 DOWNTO 0);
      Echo_room_setting   : OUT    std_logic_vector (3 DOWNTO 0);
      Echo_volume_setting : OUT    std_logic_vector (3 DOWNTO 0);
      Volume_setting      : OUT    std_logic_vector (3 DOWNTO 0);
      Selected_setting    : OUT    std_logic_vector (1 DOWNTO 0);
      fpga_clk            : IN     std_logic;
      fpga_reset_n        : IN     std_logic
   );

-- Declarations

END Control_Output_Setting ;

ARCHITECTURE behav OF Control_Output_Setting IS

  --subtype int_limited_ten is integer range 0 to 9;
  --type limited_int_array is array(0 to 3) of int_limited_ten;

  signal selected_setting_index : integer range 0 to 3 := 0;
  signal setting_values_array : integer_vector(0 to 3) := (0,5,0,0);
  signal setting_value : integer range 0 to 10 := 5;
  --signal setting_value : int_limited_ten := 0;
  --signal setting_values_array : limited_int_array := (0,0,0,0);

BEGIN
  process(fpga_clk, fpga_reset_n)
  begin
    if fpga_reset_n = '0' then
      selected_setting_index <= 0;
      setting_value <= 0;
      setting_values_array <= (0,5,0,0);
    elsif rising_edge(fpga_clk) then
      
      if up = '1' and selected_setting_index > 0 then  -- < 3
        selected_setting_index <= selected_setting_index - 1; -- +1
      elsif down = '1' and selected_setting_index < 3 then  --- > 00
        selected_setting_index <= selected_setting_index + 1; -- -1
      end if;

      if left = '1' and setting_values_array(selected_setting_index) > 0 then
        setting_values_array(selected_setting_index) <= setting_values_array(selected_setting_index) - 1;
      elsif right = '1' and setting_values_array(selected_setting_index) < 10 then
        setting_values_array(selected_setting_index) <= setting_values_array(selected_setting_index) + 1;
      end if;

    end if;
  end process;

  Volume_setting <= std_logic_vector(to_unsigned(setting_values_array(0), 4));
  Balance_setting <= std_logic_vector(to_unsigned(setting_values_array(1), 4));
  Echo_room_setting <= std_logic_vector(to_unsigned(setting_values_array(2), 4));
  Echo_volume_setting <= std_logic_vector(to_unsigned(setting_values_array(3), 4));
  Selected_setting <= std_logic_vector(to_unsigned(selected_setting_index, 2));

END ARCHITECTURE behav;

