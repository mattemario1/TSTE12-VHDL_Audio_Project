--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Audio_Echo_delay.behav
--
-- Created:
--          by - matho019.student-liu.se (muxen2-109.ad.liu.se)
--          at - 15:24:13 10/07/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Audio_Echo_delay IS
   PORT( 
      fpga_clk           : IN     std_logic;
      fpga_reset_n       : IN     std_logic;
      audio_in           : IN     std_logic_vector (15 DOWNTO 0);
      audio_echo_out1          : OUT    std_logic_vector (15 DOWNTO 0);
      audio_echo_out2          : OUT    std_logic_vector (15 DOWNTO 0);
      audio_echo_out3          : OUT    std_logic_vector (15 DOWNTO 0);
      audio_echo_out4          : OUT    std_logic_vector (15 DOWNTO 0);
      audio_valid        : IN     std_logic;
      delay_time1         : IN     unsigned(16 downto 0);
      delay_time2         : IN     unsigned(16 downto 0);
      delay_time3         : IN     unsigned(16 downto 0);
      delay_time4         : IN     unsigned(16 downto 0)
   );

-- Declarations

END Audio_Echo_delay ;

--
ARCHITECTURE behav OF Audio_Echo_delay IS
  constant memory_size : integer := 44100;
  constant sim_memory_size : integer := 10;

  type saved_samples_type is array (0 to memory_size) of std_logic_vector(15 downto 0);
  signal saved_samples : saved_samples_type;

  signal write_pointer : integer := 0;
  signal read_pointer1 : integer := 0;
  signal read_pointer2 : integer := 0;
  signal read_pointer3 : integer := 0;
  signal read_pointer4 : integer := 0;

  constant delay_time_tmp : integer  := 20000;

BEGIN
  process(fpga_clk, fpga_reset_n)
  begin
    
    if fpga_reset_n = '0' then
      write_pointer  <= 0;
      read_pointer1 <= 0;
      read_pointer2 <= 0;
      read_pointer3 <= 0;
      read_pointer4 <= 0;
      audio_echo_out1  <= (others => '0');
      audio_echo_out2  <= (others => '0');
      audio_echo_out3  <= (others => '0');
      audio_echo_out4  <= (others => '0');
      
    elsif rising_edge(fpga_clk) then
      
      if (audio_valid = '1') then
        saved_samples(write_pointer) <= audio_in;

        -- Increese write pointer
        if write_pointer = memory_size - 1 then
          write_pointer <= 0;
        else
          write_pointer <= write_pointer + 1;
        end if;

        -- Calculate read pointer
        if (write_pointer - to_integer(delay_time1)) < 0 then
          read_pointer1 <=  memory_size + (write_pointer - to_integer(delay_time1));
        else
          read_pointer1 <= write_pointer - to_integer(delay_time1);
        end if;

        if (write_pointer - to_integer(delay_time2)) < 0 then
          read_pointer2 <=  memory_size + (write_pointer - to_integer(delay_time2));
        else
          read_pointer2 <= write_pointer - to_integer(delay_time2);
        end if;

        if (write_pointer - to_integer(delay_time3)) < 0 then
          read_pointer3 <=  memory_size + (write_pointer - to_integer(delay_time3));
        else
          read_pointer3 <= write_pointer - to_integer(delay_time3);
        end if;

        if (write_pointer - to_integer(delay_time4)) < 0 then
          read_pointer4 <=  memory_size + (write_pointer - to_integer(delay_time4));
        else
          read_pointer4 <= write_pointer - to_integer(delay_time4);
        end if;


        audio_echo_out1 <= saved_samples(read_pointer1);
        audio_echo_out2 <= saved_samples(read_pointer2);
        audio_echo_out3 <= saved_samples(read_pointer3);
        audio_echo_out4 <= saved_samples(read_pointer4);
        
      end if;
    end if;
  end process;
END ARCHITECTURE behav;

