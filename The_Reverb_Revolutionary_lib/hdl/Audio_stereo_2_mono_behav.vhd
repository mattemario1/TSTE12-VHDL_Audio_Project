--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Audio_stereo_2_mono.behav
--
-- Created:
--          by - akhpr339.student-liu.se (muxen2-108.ad.liu.se)
--          at - 18:17:16 10/08/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Audio_stereo_2_mono IS
   PORT( 
      fpga_clk      : IN     std_logic;
      fpga_reset_n  : IN     std_logic;
      mono_out      : OUT    std_logic_vector (15 DOWNTO 0);
      left_in       : IN     std_logic_vector (15 DOWNTO 0);
      right_in      : IN     std_logic_vector (15 DOWNTO 0)
    );

-- Declarations

END Audio_stereo_2_mono ;

--
ARCHITECTURE behav OF Audio_stereo_2_mono IS
    
    signal left_sample   : signed(15 downto 0);
    signal right_sample  : signed(15 downto 0);
    signal mono_sample   : signed(15 downto 0);

BEGIN

    process(fpga_clk, fpga_reset_n)
    begin
       
        if fpga_reset_n = '0' then
            mono_out <= (others => '0');  -- Reset output to zero
       
        elsif rising_edge(fpga_clk) then        
            -- Convert input audio samples to signed as audio needs negative to be accurate
            if left_in(15) = '1' then 
              left_sample(14 downto 0)  <= signed(left_in(15 downto 1));
              left_sample(15) <= '1';
            else 
              left_sample(14 downto 0)  <= signed(left_in(15 downto 1));
              left_sample(15) <= '0';
          end if; 
              
       if right_in(15) = '1' then 
              right_sample(14 downto 0)  <= signed(right_in(15 downto 1));
              right_sample(15) <= '1';
            else 
              right_sample(14 downto 0)  <= signed(right_in(15 downto 1));
              right_sample(15) <= '0';
          end if;   
        
            mono_sample <= (left_sample + right_sample); --srl 1; --Replaced the division with a bit right shift (srl 1), which is equivalent to dividing by 2 
           
            
            -- Average the left and right samples to create the mono sample
                      -- Assign the mono sample to output (convert back to std_logic_vector)
            mono_out <= std_logic_vector(mono_sample);
        end if;
    end process;
    
END ARCHITECTURE behav;

