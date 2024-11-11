--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Audio_i2c_control.behav
--
-- Created:
--          by - akhpr339.student-liu.se (muxen1-102.ad.liu.se)
--          at - 12:40:32 10/03/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Audio_i2c_control IS
   PORT( 
      fpga_clk      : IN     std_logic;
      fpga_reset_n  : IN     std_logic;
      i2c_start     : IN     std_logic;                     -- signal to initiate i2c transaction
      slave_addr    : IN     std_logic_vector(7 downto 0);  -- 7-bit i2c address + R/W bit
      register_addr : IN     std_logic_vector(7 downto 0);  -- register address to write to
      data_in       : IN     std_logic_vector(7 downto 0);  -- data to write
      i2c_scl       : OUT    std_logic;                     -- i2c clock
      sda           : INOUT  std_logic;                     -- i2c data line
      ack           : OUT    std_logic;                     -- acknowledge received from slave
      busy          : OUT    std_logic                      -- busy signal during i2c transaction
      
   );

-- Declarations

END Audio_i2c_control ;

--
ARCHITECTURE behav OF Audio_i2c_control IS
  
  signal scl_internal   : std_logic := '1';           -- internal clock for scl
  signal sda_internal   : std_logic := '1';           -- internal data signal for sda
  signal sda_out        : std_logic := '1';           -- sda output signal
  signal sda_dir        : std_logic := '1';           -- sda direction (1 for in, 0 for out)
  signal bit_counter    : integer range 0 to 7 := 0;  -- bit counter for each byte
  signal byte_counter   : integer range 0 to 2 := 0;  -- byte counter (slave_addr, register_addr + data)
  
  type state_type is (IDLE, START_CONDITION, SEND_BYTE, RECEIVE_ACK, STOP_CONDITION);
  signal state          : state_type := IDLE;
  
  constant CLOCK_DIVIDE : integer := 500;
  signal clock_divider  : integer range 0 to CLOCK_DIVIDE := 0;
  
  
BEGIN
  
  i2c_clk_gen : process(fpga_clk, fpga_reset_n)
  begin
    
    if fpga_reset_n = '1' then
      scl_internal <= '1';
      clock_divider <= 0;
    
    elsif rising_edge(fpga_clk) then
      
      if clock_divider = CLOCK_DIVIDE then
        scl_internal <= not scl_internal;     -- toggle clock
        clock_divider <= 0;
      
      else
        clock_divider <= clock_divider +1;
      
      end if;
    
    end if;
      
  end process i2c_clk_gen;
  
  i2c_scl <= scl_internal;
  
  
  i2c_data_manage : process(fpga_clk, fpga_reset_n)
  begin
    
    if fpga_reset_n = '1' then
      state <= IDLE;
      bit_counter <= 0;
      sda_internal <= '1';
      sda_dir <= '1';       -- set sda to input by default
      busy <= '0';
      ack <= '0';
    
    elsif rising_edge(fpga_clk) then
      case state is
        
        -- waiting for start signal
        when IDLE =>
          busy <= '0';
          sda_internal <= '1';    -- sda high
          scl_internal <= '1';    -- scl high
          if i2c_start = '1' then
            state <= START_CONDITION;
            busy <= '1';
          end if;
          
        -- initiate i2c communication
        when START_CONDITION =>
          sda_dir <= '0';           -- sda is output
          sda_internal <= '0';      -- sda goes low (start condition)
          if scl_internal = '1' then
            state <= SEND_BYTE;
            bit_counter <= 7;
            byte_counter <= 0;
          end if;
          
        -- transmit address and data bytes
        when SEND_BYTE =>
          case byte_counter is
            when 0 =>
              -- send slave address
              sda_internal <= slave_addr(bit_counter);
            when 1 =>
              -- sending register address
              sda_internal <= register_addr(bit_counter);
            when 2 =>
              -- sending data byte
              sda_internal <= data_in(bit_counter);
            when others =>
              sda_internal <= '1';
          end case;
          
          if scl_internal = '1' then
            if bit_counter = 0 then
              state <= RECEIVE_ACK;
              sda_dir <= '1';       -- switch sda to input
            else
              bit_counter <= bit_counter - 1;
            end if;
          end if;
        
        -- check for ack from slave  
        when RECEIVE_ACK =>
          if scl_internal = '1' then
            ack <= not sda;       -- ack is active-low
            sda_dir <= '0';       -- switch sda back to output
            if byte_counter = 2 then
              state <= STOP_CONDITION;
            else
              byte_counter <= byte_counter + 1;
              state <= SEND_BYTE;
              bit_counter <= 7;   -- reset bit counter for next byte
            end if;
          end if;
        
        -- end i2c communication
        when STOP_CONDITION =>
          sda_internal <= '0';    -- sda low
          if scl_internal = '1' then
            sda_internal <= '1';  -- sda high(stop condition)
            state <= IDLE;
            busy <= '0';
          end if;
          
        when others =>
          state <= IDLE;
        
      end case;
          
    end if;
      
  end process i2c_data_manage;
  
  
  -- sda signal management (output if sda_dir = '0', input otherwise)
  sda <= 'Z' when sda_dir = '1' else sda_internal;    -- tristate when reading
  
  
  
  
END ARCHITECTURE behav;


