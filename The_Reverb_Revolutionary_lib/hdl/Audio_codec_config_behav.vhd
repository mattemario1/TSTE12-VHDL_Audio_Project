--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Audio_codec_config.behav
--
-- Created:
--          by - akhpr339.student-liu.se (muxen1-102.ad.liu.se)
--          at - 12:38:54 10/03/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Audio_codec_config IS
   PORT( 
      fpga_clk     : IN     std_logic;
      fpga_reset_n : IN     std_logic;
      config_done  : OUT    std_logic;
      i2c_sda      : INOUT  std_logic;
      i2c_scl      : OUT    std_logic
   );

-- Declarations

END Audio_codec_config ;

--
ARCHITECTURE behav OF Audio_codec_config IS
  
  type state_type is (IDLE, START, CODEC_ADDRESS, WRITE_ADDRESS, WRITE_DATA, WAIT_ACK, STOP);    -- State machine states
  signal state          : state_type := IDLE;             -- Default state
  signal last_state     : state_type := IDLE;             -- Previous state
  signal bit_count : integer range 0 to 8 := 0;      -- Bit counter for I2C
  signal register_addr  : std_logic_vector(7 downto 0);   -- Register address to write to
  signal data_byte      : std_logic_vector(7 downto 0);   -- Data byte to send to codec
  signal config_index   : integer range 0 to 10 := 0;      -- Index for configuration data
  signal retry_count : integer range 0 to 3 := 0;
  signal counter        : integer range 0 to 5 := 0;
  signal sda_internal   : std_logic := '1';
  
  signal codec_addr : std_logic_vector(7 downto 0) := "00110100";
  
  type config_array is array (0 to 9) of std_logic_vector(15 downto 0);   
  
  signal config_data : config_array := (                            -- Array of configuration registers and data
    -- X"0C02", -- Power down control (power on everything except mic)
    -- X"0702", -- Digital audio interface format (i2s format with 16-bit wordlength)
    -- X"0810", -- Analog audio path control (line input selected)
    -- X"0900", -- Digital audio path control (disable everything)
    -- X"001F", -- Left line in control (line input gain to 0dB)
    -- X"011F", -- Right line in control (line input gain to 0dB)
    -- X"0A00"  -- Sample rate control (44,1 kHz)

    "0000000000010111",
    "0000001000010111",
    "0000010001111001",
    "0000011001111001",
    "0000100000010000",
    "0000101000000000",
    "0000110000000010",
    "0000111000000010",
    "0001000000000000",
    "0001001000000001"
  );
  
  signal scl_internal    : std_logic := '1';                         -- Internal clock for I2C
  constant CLOCK_DIVIDE  : integer := (650 - 1);                     -- Divider value for I2C clock generation (100 kHz)
  signal clock_divider   : integer range 0 to CLOCK_DIVIDE:= 0;      -- Clock divider counter
  signal scl_middle      : std_logic := '0';
  signal db : std_logic_vector (17 DOWNTO 0);
  
  
BEGIN
  
  --------------------------------------------------
  -- Generate I2C Clock Process
  --------------------------------------------------
  i2c_clk_gen : process(fpga_clk, fpga_reset_n)
  begin
    if fpga_reset_n = '0' then
      scl_internal <= '1';                    -- Reset clock to high
      clock_divider <= 0;                     -- Reset clock divider counter
      
    
    elsif rising_edge(fpga_clk) then
      
      if clock_divider = CLOCK_DIVIDE then
        
        scl_internal <= not scl_internal;     -- Toggle clock
        clock_divider <= 0;                   -- Reset clock divider counter
      else
        clock_divider <= clock_divider +1;    -- Increment counter
      end if;
      
      if clock_divider = (CLOCK_DIVIDE+1)/2 then --and scl_internal = '0' then
        scl_middle <= '1';
      else
        scl_middle <= '0';
      end if;
      
    end if;
  end process i2c_clk_gen;
    
  --------------------------------------------------
  -- Codec Configuration Process
  --------------------------------------------------
  codec_config : process(fpga_clk, fpga_reset_n)
  begin
    
    if fpga_reset_n = '0' then
      -- Reset state and signals
      state <= IDLE;
      last_state <= IDLE;
      config_done <= '0';
      config_index <= 0;
      sda_internal <= '1';             -- SDA high during reset
      db <= (others => '1');
    
    elsif rising_edge(fpga_clk) then
      if scl_middle then
        
        case state is
          when IDLE =>
            -- Idle state (waiting to start configuration)
            db(0) <= '0';
            retry_count <= 0;
            db(7 downto 1) <= (others => '1');
            
            if scl_internal = '1' then
              sda_internal <= '1';         -- SDA high (idle)
            end if;
            
            if config_index = 10 then
              db(17) <= '0';
              config_done <= '1';  -- All configuration finished
            else
              -- db(config_index) <= '0';
              register_addr <= config_data(config_index)(15 downto 8);  -- Set register address
              data_byte <= config_data(config_index)(7 downto 0);       -- Set data byte to write
              bit_count <= 8;
              state <= START;                                           -- Move to START state
            end if;
            
          when START =>

            if scl_internal = '1' then
              db(1) <= '0';
              sda_internal <= '0';                 -- SDA goes low (start condition)
              state <= CODEC_ADDRESS;         -- Start writing slave address
            end if;
  
              
          when CODEC_ADDRESS =>
            
            if scl_internal = '0' then
              db(2) <= '0';
              if bit_count = 0 then
                sda_internal <= '1';
                last_state <= CODEC_ADDRESS;
                state <= WAIT_ACK;
                bit_count <= 8;
              else
                sda_internal <= codec_addr(bit_count - 1);
                bit_count <= bit_count - 1;
              end if;
            end if;
          
          when WRITE_ADDRESS =>
            
            if scl_internal = '0' then
              if bit_count = 0 then
                  sda_internal <= '1';                       -- release SDA
                  last_state <= WRITE_ADDRESS;          -- Store previous state
                  state <= WAIT_ACK;                    -- Wait for acknowledgement after sending
                  bit_count <= 8;                       -- Reset bit counter
              else
                sda_internal <= register_addr(bit_count-1);    -- Send register address bit by bit
                bit_count <= bit_count - 1;           -- Decrement bit counter
              end if; 
            end if;
            
          when WRITE_DATA =>
            
            if scl_internal = '0' then
              if bit_count = 0 then
                sda_internal <= '1';
                last_state <= WRITE_DATA;
                state <= WAIT_ACK;                      -- Wait for ACK
                bit_count <= 8;
              else
                sda_internal <= data_byte(bit_count-1);          -- Send data one bit at a time
                bit_count <= bit_count - 1;             -- Decrement bit counter
              end if;
            end if;
            
          when WAIT_ACK =>
            db(3) <= '0';
            if i2c_sda = '0' then
              db(4) <= '0';
              if last_state = CODEC_ADDRESS then
                db(5) <= '0';
                state <= WRITE_ADDRESS;
              elsif last_state = WRITE_ADDRESS then
                db(6) <= '0';
                state <= WRITE_DATA;
              elsif last_state = WRITE_DATA then
                db(7) <= '0';
                if config_index < 10 then
                  config_index <= config_index + 1;   -- next configuration
                end if;
                sda_internal <= '1';
                state <= IDLE;
              end if;
              counter <= 0;
            elsif counter < 5 then
              counter <= counter + 1;
            
            elsif counter = 5 then
              if retry_count < 3 then
                retry_count <= retry_count +1;
                sda_internal <= '0';
                state <= last_state;
              else
                state <= STOP;
              end if;
              counter <= 0;
            end if;
            
          when STOP =>
            
            sda_internal <= '1';         -- sda high (stop condition)
            
          when others =>
            state <= IDLE;
            
        end case;
      end if;
    end if;
    
  end process codec_config;
  
  i2c_scl <= 'Z' when scl_internal = '1' else '0';
  i2c_sda <= 'Z' when sda_internal = '1' else '0';

  
END ARCHITECTURE behav;


