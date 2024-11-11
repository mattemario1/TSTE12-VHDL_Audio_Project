--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Audio_i2s_interface.behav
--
-- Created:
--          by - simel970.student-liu.se (muxen2-106.ad.liu.se)
--          at - 17:44:27 10/03/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Audio_i2s_interface IS
   PORT( 
      fpga_clk       : IN     std_logic;
      fpga_reset_n   : IN     std_logic;
      config_done    : IN     std_logic;
      Audio_L_output : IN     std_logic_vector (15 DOWNTO 0);
      Audio_R_output : IN     std_logic_vector (15 DOWNTO 0);
      adcdat        : IN std_logic;
      sample_l       : OUT    std_logic_vector (15 DOWNTO 0);
      sample_r       : OUT    std_logic_vector (15 DOWNTO 0);
      audio_valid    : OUT    std_logic;
      dacdat         : OUT    std_logic;
      xck            : OUT    std_logic;
      db             : OUT    std_logic_vector (17 DOWNTO 0);
      adclrck        : OUT    std_logic;
      daclrck        : OUT    std_logic;
      bclk           : OUT    std_logic
      --ADC_en         : OUT    std_logic;
      --DAC_en         : OUT    std_logic


   );

-- Declarations

END Audio_i2s_interface ;

--
ARCHITECTURE behav OF Audio_i2s_interface IS
  
  signal rx_bit_count  : integer range 0 to 16 := 0;                         -- count bits in one audio sample
  signal tx_bit_count  : integer range 0 to 16 := 0;                         -- bit counter for transmitting
  signal sample_tmp    : std_logic_vector(15 downto 0) := (others => '0');
  signal word_select   : std_logic := '0';                                   -- previous state of word select
  signal audio_ready_flag : std_logic := '0';

  type rx_state_type is (RX_IDLE, RECEIVE_LEFT, RECEIVE_RIGHT);
  signal rx_state      : rx_state_type := RX_IDLE;               -- i2s receive state machine
  
  type tx_state_type is (TX_IDLE, TRANSMIT_LEFT, TRANSMIT_RIGHT);
  signal tx_state      : tx_state_type := TX_IDLE;
                          
  signal mclk_clk_toggle    : std_logic := '0';
  signal mclk_div_count     : integer := 0;
  signal bclk_clk_toggle    : std_logic := '0';
  signal bclk_div_count     : integer := 0;
  signal lrclk_clk_toggle    : std_logic := '0';
  signal lrclk_div_count     : integer := 0;
  signal looong_count    : std_logic := '0';
  signal looong_count2    : std_logic := '0';
  signal looong_count_div     : integer := 0;
  
  signal bclk_rising   : std_logic := '0';
  signal bclk_falling   : std_logic := '0';
  signal bclk_old       : std_logic := '0';

  signal ADC_en_tmp : std_logic := '0';
  signal DAC_en_tmp : std_logic := '0';
  signal DAC_en_tmp2 : std_logic := '0';
  signal mclk_clk_old : std_logic := '0';
  signal ADC_en : std_logic := '0';
  signal DAC_en : std_logic := '0';

  signal adclrck_old : std_logic := '0';

  signal daclrck_old : std_logic := '0';
  signal internal_Audio_L_output : std_logic_vector(15 downto 0);
  signal internal_Audio_R_output : std_logic_vector(15 downto 0);
  signal dacdat_internal : std_logic;

  signal bclk_delay : integer := 0;


  -- signal db : std_logic_vector (17 DOWNTO 0);
  
BEGIN
  
  -- Clock Divider to generate codec master clock (65MHz/6 = 10.83MHz)
  clock_div : process(fpga_clk, fpga_reset_n)
  begin
    if fpga_reset_n = '0' then
      mclk_clk_toggle <= '0';
      mclk_div_count <= 0;
    
    elsif rising_edge(fpga_clk) then
      
      if mclk_div_count = 5 then
        mclk_clk_toggle <= not mclk_clk_toggle;     -- toggle master clock
        mclk_div_count <= 0;                   -- reset counter


        if bclk_div_count = 3 then
          bclk_clk_toggle <= not bclk_clk_toggle;     -- toggle bit clock
          bclk_div_count <= 0;                   -- reset counter


          if lrclk_div_count = 63 then
            lrclk_clk_toggle <= not lrclk_clk_toggle;     -- toggle left/right clock
            lrclk_div_count <= 0;                   -- reset counter
            ADC_en_tmp <= '1';
            DAC_en_tmp <= '1';

            if looong_count_div = 1000 then
              looong_count <= '1';
              looong_count_div <= 0;
              looong_count2 <= not looong_count2;
            else
              looong_count <= '0';
              looong_count_div <= looong_count_div + 1;
            end if;

          else
            lrclk_div_count <= lrclk_div_count + 1;

          end if;

        else
          bclk_div_count <= bclk_div_count + 1;
        end if;

      else
        mclk_div_count <= mclk_div_count + 1;
        ADC_en <= '0';
      end if;

      mclk_clk_old <= mclk_clk_toggle;

      if DAC_en_tmp = '1' and mclk_clk_toggle = '1' and mclk_clk_old = '0' then
        DAC_en_tmp <= '1';
        DAC_en_tmp2 <= '0';
      else
        DAC_en_tmp <= '0';
      end if;
      
      bclk_old <= bclk;
    
    end if;
    
  end process clock_div;
  
  xck <= mclk_clk_toggle;
  bclk <= bclk_clk_toggle;
  adclrck <= lrclk_clk_toggle;
  daclrck <= lrclk_clk_toggle;
  DAC_en <= DAC_en_tmp2;
  ADC_en <= ADC_en_tmp;
  
  bclk_rising <= bclk and not bclk_old;
  bclk_falling <= bclk_old and not bclk;

 
  audio_receive_process : process(fpga_clk, fpga_reset_n)
  begin
    if fpga_reset_n = '0' then
      rx_state <= RX_IDLE;
      rx_bit_count <= 0;
      sample_l <= (others => '0');
      sample_r <= (others => '0');
      word_select <= '0';
      audio_valid <= '0';
      audio_ready_flag <= '0';
      -- db <= (others => '1');
    
    elsif rising_edge(fpga_clk) then
      

        case rx_state is
          
          when RX_IDLE =>      -- idle state
            
            -- db(0) <= '0';
            
            rx_bit_count <= 0;                -- reset bit count on adclrck edge (start of new word)
            audio_valid <= '0';
            adclrck_old <= adclrck;
            if adclrck /= adclrck_old then
              if bclk_falling = '1' then
              -- db(10) <= '0';
                if config_done = '1' then
                  -- db(1) <= '0';
                  if adclrck = '0' then
                    -- db(2) <= '0';
                    rx_state <= RECEIVE_LEFT;      -- start receiving left channel
                  else
                    -- db(6) <= '0';
                    rx_state <= RECEIVE_RIGHT;      -- start receiving right channel
                  end if; 
                end if;
              end if;
            end if;
              
          when RECEIVE_LEFT =>      -- receiving left channel
            if bclk_rising = '1' then
              -- db(3) <= '0';
              if bclk_delay = 1 then
                if rx_bit_count < 16 then 
                  -- db(4) <= '0';
                  sample_tmp(15 - rx_bit_count) <= adcdat;
                  rx_bit_count <= rx_bit_count + 1;
                else
                  -- db(5) <= '0';
                  sample_l <= sample_tmp;
                  audio_valid <= '1';
                  rx_bit_count <= 0;
                  rx_state <= RX_IDLE;
                  bclk_delay <= 0;
                end if;
              else
                bclk_delay <= 1;
              end if;
            end if;
            
          when RECEIVE_RIGHT =>      -- receiving right channel
            if bclk_rising = '1' then
              -- db(7) <= '0';
              if bclk_delay = 1 then

                if rx_bit_count < 16 then 
                  -- db(8) <= '0';
                  sample_tmp(15 - rx_bit_count) <= adcdat;
                  rx_bit_count <= rx_bit_count + 1;
                else
                  -- db(9) <= '0';
                  sample_r <= sample_tmp;
                  audio_valid <= '1';
                  rx_bit_count <= 0;
                  rx_state <= RX_IDLE;
                  bclk_delay <= 0;
                end if;
              else
                bclk_delay <= 1;
              end if;
            end if;

          when others =>
            rx_state <= RX_IDLE;          -- default back to idle
          
        end case;
        
      end if;
      
  end process audio_receive_process;


  
  audio_transmit_process : process(fpga_clk, fpga_reset_n)
  begin
    if fpga_reset_n = '0' then
      tx_bit_count <= 0;
      dacdat_internal <= '0';
      -- db <= (others => '1');
      tx_state <= TX_IDLE;
      
    elsif rising_edge(fpga_clk) then
      

      if looong_count = '1' then
        -- internal_Audio_L_output <= "1000000000000000";
        -- internal_Audio_R_output <= "0100000000000000";
        db(14 downto 0) <= Audio_R_output(14 downto 0) when Audio_R_output(15) = '0' else not Audio_R_output(14 downto 0);
      else
        -- internal_Audio_L_output <= (others => '0');
        -- internal_Audio_R_output <= (others => '0');
      end if;

        case tx_state is
          
          when TX_IDLE =>
          
            dacdat_internal <= '0';
            daclrck_old <= daclrck;
            if daclrck_old /= daclrck then
              if bclk_falling = '1' then
                -- db(12) <= '0';
                internal_Audio_L_output <= Audio_L_output;
                internal_Audio_R_output <= Audio_R_output;
                

                if daclrck = '0' then
                  -- db(13) <= '0';
                  tx_state <= TRANSMIT_LEFT;
                else
                  tx_state <= TRANSMIT_RIGHT;
                  -- db(14) <= '0';
                end if;
              end if;
            end if;
            
          when TRANSMIT_LEFT =>
            if bclk_falling = '1' then
              if tx_bit_count < 16 then
                -- db(15) <= '0';
                tx_bit_count <= tx_bit_count +1;
                dacdat_internal <= internal_Audio_L_output(15 - tx_bit_count);
              else
                -- db(16) <= '0';
                tx_bit_count <= 0;
                tx_state <= TX_IDLE;
              end if;
            end if;
            
          when TRANSMIT_RIGHT =>
            if bclk_falling = '1' then
              if tx_bit_count < 16 then
                tx_bit_count <= tx_bit_count +1;
                dacdat_internal <= internal_Audio_R_output(15 - tx_bit_count);
              else
                tx_bit_count <= 0;
                tx_state <= TX_IDLE;
              end if;
            end if;
            
          when others =>
            tx_state <= TX_IDLE;
          
        end case;
          
      end if;
      
    
  end process audio_transmit_process;

  dacdat <= dacdat_internal;


  
  
END ARCHITECTURE behav;


























