--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Audio_Balance.behav
--
-- Created:
--          by - akhpr339.student-liu.se (muxen2-108.ad.liu.se)
--          at - 15:59:01 10/08/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY Audio_Balance IS
   PORT( 
      audio_in  : IN     std_logic_vector (15 DOWNTO 0);
      Balance_setting : IN     std_logic_vector (3 DOWNTO 0);
      fpga_clk        : IN     std_logic;
      fpga_reset_n    : IN     std_logic;
      audio_L_output  : OUT    std_logic_vector (15 DOWNTO 0);
      audio_R_output  : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END Audio_Balance ;

ARCHITECTURE behav OF Audio_Balance IS
    
    signal mono_sample     : signed(15 downto 0);   -- Signed 16-bit signal for mono input
    signal left_output     : signed(15 downto 0);   -- Signed 16-bit signal for left audio output
    signal right_output    : signed(15 downto 0);   -- Signed 16-bit signal for right audio output
    signal gain_value      : integer range 0 to 10;  -- Gain value from Balance_setting
   

BEGIN

    process(fpga_clk, fpga_reset_n)
    begin
        if fpga_reset_n = '0' then
            audio_L_output <= (others => '0');   -- Reset left output to zero
            audio_R_output <= (others => '0');   -- Reset right output to zero
          elsif rising_edge(fpga_clk) then 
       
         elsif rising_edge(fpga_clk) then
            -- Convert the mono input (std_logic_vector) to signed type
            mono_sample <= signed(audio_in);

            -- Convert Balance_setting (std_logic_vector) to integer for gain
            gain_value <= to_integer(unsigned(Balance_setting));

            -- Determine left and right output based on gain value (Balance_setting from 0 to 10)
            case gain_value is
              -- for 16 bit signed integer, 32767 is the max it can store 
                when 0 =>
                    -- Full volume to right, muted left
                    left_output <= (others => '0');  -- Silent
                    right_output <= mono_sample;     -- Full volume to right
                when 1 =>
                    -- 10% left, 90% right
                    left_output <= resize((mono_sample * 3277) / 32767, 16);  -- 10% volume to left
                    right_output <= resize((mono_sample * 29490) / 32767, 16); -- 90% volume to right
                when 2 =>
                    -- 20% left, 80% right
                    left_output <= resize((mono_sample * 6554) / 32767, 16);  -- 20% volume to left
                    right_output <= resize((mono_sample * 26213) / 32767, 16); -- 80% volume to right
                when 3 =>
                    -- 30% left, 70% right
                    left_output <= resize((mono_sample * 9830) / 32767, 16);  -- 30% volume to left
                    right_output <= resize((mono_sample * 22937) / 32767, 16); -- 70% volume to right
                when 4 =>
                    -- 40% left, 60% right
                    left_output <= resize((mono_sample * 13107) / 32767, 16);  -- 40% volume to left
                    right_output <= resize((mono_sample * 19660) / 32767, 16); -- 60% volume to right
                when 5 =>
                    -- Equal volume to left and right (50% each)
                    left_output <= resize((mono_sample * 16383) / 32767, 16);  -- 50% volume to left
                    right_output <= resize((mono_sample * 16383) / 32767, 16); -- 50% volume to right
                when 6 =>
                    -- 60% left, 40% right
                    left_output <= resize((mono_sample * 19660) / 32767, 16);  -- 60% volume to left
                    right_output <= resize((mono_sample * 13107) / 32767, 16); -- 40% volume to right
                when 7 =>
                    -- 70% left, 30% right
                    left_output <= resize((mono_sample * 22937) / 32767, 16);  -- 70% volume to left
                    right_output <= resize((mono_sample * 9830) / 32767, 16);  -- 30% volume to right
                when 8 =>
                    -- 80% left, 20% right
                    left_output <= resize((mono_sample * 26213) / 32767, 16);  -- 80% volume to left
                    right_output <= resize((mono_sample * 6554) / 32767, 16);  -- 20% volume to right
                when 9 =>
                    -- 90% left, 10% right
                    left_output <= resize((mono_sample * 29490) / 32767, 16);  -- 90% volume to left
                    right_output <= resize((mono_sample * 3277) / 32767, 16);  -- 10% volume to right
                when others =>
                    -- Full volume to left, muted right (default case when gain_value = 10)
                    left_output <= mono_sample;       -- Full volume to left
                    right_output <= (others => '0');  -- Silent on right
            end case;
            
            --maybe use resize to make it from 32 bits to 16 bits 
            -- resize((mono_sample * left or right_gain_factor) / 32767, 16);  

            -- Convert outputs to std_logic_vector for output
            audio_L_output <= std_logic_vector(left_output);
            audio_R_output <= std_logic_vector(right_output);
        end if;
    end process;

END ARCHITECTURE behav;
