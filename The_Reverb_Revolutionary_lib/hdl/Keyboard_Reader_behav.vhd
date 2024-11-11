--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Keyboard_Reader.behav
--
-- Created:
--          by - matho019.student-liu.se (muxen2-114.ad.liu.se)
--          at - 18:09:28 09/27/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Control_Keyboard_Reader IS
   PORT( 
      kb_clk       : IN     std_logic;
      kb_data      : IN     std_logic;
      left         : OUT    std_logic;
      right        : OUT    std_logic;
      up           : OUT    std_logic;
      down         : OUT    std_logic;
      fpga_clk     : IN     std_logic;
      fpga_reset_n : IN     std_logic
   );

-- Declarations

END Control_Keyboard_Reader ;

--
ARCHITECTURE behav OF Control_Keyboard_Reader IS

   -- PS/2 Keyboard Scancode constants for Arrow Keys
   constant LEFT_KEY  : std_logic_vector(7 downto 0) := x"6B";
   constant RIGHT_KEY : std_logic_vector(7 downto 0) := x"74";
   constant UP_KEY    : std_logic_vector(7 downto 0) := x"75";
   constant DOWN_KEY  : std_logic_vector(7 downto 0) := x"72";
   constant BREAK_CODE: std_logic_vector(7 downto 0) := x"F0";

   signal kb_data_sync  : std_logic;
   signal kb_clk_sync_0 : std_logic;
   signal kb_clk_sync_1 : std_logic;
   signal kb_clk_fall   : std_logic;  -- Detect falling edge of PS/2 clock

   signal shift_registry : std_logic_vector(9 downto 0);
   signal bit_count      : integer range 0 to 10 := 0;

   type get_kb_data_state is (IDLE, RECEIVE);
   signal current_kb_data_state : get_kb_data_state := IDLE;

   type key_press_state is (IDLE, WAIT_FOR_BREAK, WAIT_FOR_CORRECT_KEY);
   signal current_key_press_state : key_press_state := IDLE;
   signal received_correct_kb_data : std_logic_vector(7 DOWNTO 0);

   signal received_kb_data : std_logic_vector(7 DOWNTO 0);

   signal data_ready : std_logic;

BEGIN

   clk_synchronizer: process(fpga_clk,fpga_reset_n)
   begin
      if fpga_reset_n = '0' then
         kb_clk_sync_0 <= '0';
         kb_clk_sync_1 <= '0';
      elsif rising_edge(fpga_clk) then
         kb_clk_sync_0 <= kb_clk;
         kb_clk_sync_1 <= kb_clk_sync_0;
         kb_data_sync <= kb_data;
      end if;
   end process clk_synchronizer;

   -- Detect falling edge of kb_clk
   kb_clk_fall <= kb_clk_sync_0 and not kb_clk_sync_1;

   get_data: process(fpga_clk, fpga_reset_n)
   begin
      if fpga_reset_n  = '0' then
         current_kb_data_state <= IDLE;
         received_kb_data <= "00000000";
         data_ready <= '0';
      elsif rising_edge(fpga_clk) then
         case current_kb_data_state is
            when IDLE =>
               data_ready <= '0';

               if kb_clk_fall = '1' and kb_data_sync = '0' then -- Start bit is '0'
                  current_kb_data_state <= RECEIVE;
                  bit_count <= 0;
               end if;
            when RECEIVE =>
               if kb_clk_fall = '1' then
                  shift_registry(bit_count) <= kb_data_sync;
                  bit_count <= bit_count + 1;
               end if;
               if bit_count = 10 then
                  current_kb_data_state <= IDLE;
                  bit_count <= 0;
                  if shift_registry(9) = '1' then -- Stop bit is '1'
                     received_kb_data <= shift_registry(7 downto 0);
                     data_ready <= '1';
                  end if;
               else
                  data_ready <= '0';
               end if;
            when others =>
               current_kb_data_state <= IDLE;
            end case;
      end if;
   end process get_data;
   

   
   
   
   key_decoder: process(fpga_clk, fpga_reset_n)
   begin
      if fpga_reset_n = '0' then
         left  <= '0';
         right <= '0';
         up    <= '0';
         down  <= '0';
         current_key_press_state <= IDLE;
         received_correct_kb_data <= "00000000";
      elsif rising_edge(fpga_clk) then

         if data_ready = '1' then

            -- State machine for only getting one key press
            case current_key_press_state is
               when IDLE =>
                  if received_kb_data = LEFT_KEY or received_kb_data = RIGHT_KEY or received_kb_data = DOWN_KEY or received_kb_data = UP_KEY then
                     current_key_press_state <= WAIT_FOR_BREAK;
                     received_correct_kb_data <= received_kb_data;
                  end if;
               when WAIT_FOR_BREAK =>
                  if received_kb_data = BREAK_CODE then
                     current_key_press_state <= WAIT_FOR_CORRECT_KEY;
                  end if;
               when WAIT_FOR_CORRECT_KEY =>
                  if received_kb_data = received_correct_kb_data then
                     current_key_press_state <= IDLE;
                  else
                     current_key_press_state <= WAIT_FOR_BREAK;
                  end if;
            end case;

            if current_key_press_state = IDLE then
               case received_kb_data is
                  when LEFT_KEY =>
                     left <= '1';
                  when RIGHT_KEY =>
                     right <= '1';
                     when UP_KEY =>
                     up <= '1';
                     when DOWN_KEY =>
                     down <= '1';
                     when others =>
                     -- Ignore other keys
                     null;
               end case;
            end if;

         else 
            left  <= '0';
            right <= '0';
            up    <= '0';
            down  <= '0';
         end if;
      end if;
   end process key_decoder;



END ARCHITECTURE behav;

