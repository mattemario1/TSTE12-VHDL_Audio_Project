--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Audio_Volume.behav
--
-- Created:
--          by - matho019.student-liu.se (muxen2-109.ad.liu.se)
--          at - 14:19:10 10/07/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

ENTITY Audio_Volume IS
   PORT( 
      fpga_clk            : IN     std_logic;
      fpga_reset_n        : IN     std_logic;
      Volume_setting      : IN     std_logic_vector (3 DOWNTO 0) ;
      audio_in            : IN     std_logic_vector (15 DOWNTO 0); -- new signal
      audio_out           : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END Audio_Volume ;

--
ARCHITECTURE behav OF Audio_Volume IS

    signal vol_output     : signed(15 downto 0);
    signal Volume_sample  : signed(15 downto 0);
    signal Vol_gain_value : integer range 0 to 10;
    
    signal gain_factor    : real;
    signal base, result   : real;
    signal exp            : integer;

BEGIN
  
   process(fpga_clk, fpga_reset_n)
    begin
--           
     -- if rising_edge(fpga_clk) then
----     base    <= 2; 
----     exp     <= 15;  
----     result  <= base ** exp;
----    
        if fpga_reset_n = '0' then
           audio_out <= (others => '0');  --  Reset output to zero
            Volume_sample <= (others => '0');
            Vol_gain_value <= 0;
       
       elsif rising_edge(fpga_clk) then
            -- Convert the  input (std_logic_vector) to signed type
          Volume_sample <= signed(audio_in);

            -- Convert Balance_setting (std_logic_vector) to integer for gain
            Vol_gain_value <= to_integer(unsigned(Volume_setting));

           case Vol_gain_value is
----              -- for 16 bit signed integer, 32767 is the max it can store 
                
                when 0 =>
                 audio_out <= (others => '0');
                   
                  
                when 1 =>
                   -- vol_output <= floor ((Volume_sample*0.1*result)/result);            
                  vol_output <= resize((Volume_sample * 3277) / 32767, 16);  -- 10% volume  
                   
                when 2 =>
                   -- vol_output <= floor ((Volume_sample*0.1*result)/result);
                vol_output <= resize((Volume_sample * 6554) / 32767, 16);  -- 10% volume


   
                when 3 =>
                   -- vol_output <= floor ((Volume_sample*0.1*result)/result);
                  vol_output <= resize((Volume_sample * 9830) / 32767, 16);  -- 10% volume  
               

   
                when 4 =>
                   -- vol_output <= floor ((Volume_sample*0.1*result)/result); 
                  vol_output <= resize((Volume_sample * 13107) / 32767, 16);  -- 10% volume  
                 

   
                when 5 =>
                   -- vol_output <= floor ((Volume_sample*0.1*result)/result);
                  vol_output <= resize((Volume_sample * 16384) / 32767, 16);  -- 10% volume  
                 
   
                when 6 =>
                   -- vol_output <= floor ((Volume_sample*0.1*result)/result);
                  vol_output <= resize((Volume_sample * 19660) / 32767, 16);  -- 10% volume  
                 

   
                when 7 =>
                   -- vol_output <= floor ((Volume_sample*0.1*result)/result);
                  vol_output <= resize((Volume_sample * 22937) / 32767, 16);  -- 10% volume  
                

  
                when 8 =>
                   -- vol_output <= floor ((Volume_sample*0.1*result)/result);              
                  vol_output <= resize((Volume_sample * 26214) / 32767, 16);  -- 10% volume  
                 
   
                when 9 =>
                   -- vol_output <= floor ((Volume_sample*0.1*result)/result);    
                  vol_output <= resize((Volume_sample * 29490) / 32767, 16);  -- 10% volume  
                 
                  
               when others =>
                    vol_output <= (Volume_sample) ;      --  Full volume 
                    
              end case;
            
            
         --    Convert outputs to std_logic_vector for output
            audio_out <= std_logic_vector(vol_output);  --
           
       end if;
    end process;
END ARCHITECTURE behav;















--
--
--
--
--                 
--                when 1 =>
--                    vol_output <= floor ((Volume_sample*0.1*result)/result);
--                   --resize((Volume_sample * 3277) / 32767, 16);  -- 10% volume  
--                   --32768 = 2�5
--                   -- 
--                   -- Option 1: vol_output = floor (Volume_sample*gain/2^15) where gain = round (0.1*2^15)
--                   -- Option 2: vol_output = floor (Volume_sample*0.1*2^15)/2^15)
--                   
--                when 2 =>
--                    vol_output <= floor ((Volume_sample*0.2*result)/result);  -- 20% volume 
--                    
--                when 3 =>
--                    vol_output <= floor ((Volume_sample*0.3*result)/result);  -- 30% volume 
--                    
--                when 4 =>
--                    vol_output <= floor ((Volume_sample*0.4*result)/result);  -- 40% volume 
--                                    
--                when 5 =>
--                    vol_output <= floor ((Volume_sample*0.5*result)/result);  -- 50% volume
--                                                   
--                when 6 =>
--                    vol_output <= floor ((Volume_sample*0.6*result)/result);  -- 60% volume 
--
--                when 7 =>
--                    vol_output <= floor ((Volume_sample*0.7*result)/result);  -- 70% volume
--                
--                when 8 =>            
--                    vol_output <= floor ((Volume_sample*0.8*result)/result);  -- 80% volume 
--                    
--               
--                when 9 =>
--                    vol_output <= floor ((Volume_sample*0.9*result)/result);  -- 90% volume 
--                   
--                
 













       -- -- Convert Volume_setting (std_logic_vector) to integer for gain
--            Vol_gain_value <= to_integer(unsigned(Volume_setting));
--
--            -- Calculate the gain factor (percentage of volume based on setting)
--            -- Here we use 0.1 * gain for the corresponding setting, e.g., 10% for 1, 20% for 2, etc.
--            gain_factor <= real(Vol_gain_value) / 10.0;
--
--            -- Base and exponent for scaling (optional use of exponentiation)
--            base <= 2.0;
--            exp <= 15;
--            result <= base ** exp;  -- Calculate 2^15
--
--            -- Apply gain to the audio sample using floating-point arithmetic
--            case Vol_gain_value is
--                when 0 =>
--                    vol_output <= (others => '0');  -- Silent
--
--                when others =>
--                    -- Perform volume scaling
--                    -- Convert Volume_sample to real for multiplication
--                    vol_output <= signed(to_integer(floor(real(Volume_sample) * gain_factor)));
--                    -- Gain factor example: For setting = 5 -> gain_factor = 0.5 -> 50% volume
--                    -- Multiplies the signed value by the percentage gain