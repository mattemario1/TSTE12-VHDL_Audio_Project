-- VHDL Entity The_Reverb_Revolutionary_lib.VISUAL_Subsystem.symbol
--
-- Created:
--          by - matho019.student-liu.se (muxen2-109.ad.liu.se)
--          at - 18:43:04 10/28/24
--
-- Generated by Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY VISUAL_Subsystem IS
   PORT( 
      Audio_bar           : IN     std_logic_vector (17 DOWNTO 0);
      Balance_setting     : IN     std_logic_vector (3 DOWNTO 0);
      Echo_room_setting   : IN     std_logic_vector (3 DOWNTO 0);
      Echo_volume_setting : IN     std_logic_vector (3 DOWNTO 0);
      SRAM_Data           : IN     std_logic_vector (15 DOWNTO 0);
      Selected_setting    : IN     std_logic_vector (1 DOWNTO 0);
      Volume_setting      : IN     std_logic_vector (3 DOWNTO 0);
      fpga_clk            : IN     std_logic;
      fpga_reset_n        : IN     std_logic;
      c0                  : OUT    STD_LOGIC;
      locked              : OUT    STD_LOGIC;
      sram_address        : OUT    std_logic_vector (19 DOWNTO 0);
      sram_ce_n           : OUT    std_logic;
      sram_lb_n           : OUT    std_logic;
      sram_oe_n           : OUT    std_logic;
      sram_ub_n           : OUT    std_logic;
      sram_we_n           : OUT    std_logic;
      vga_b               : OUT    std_logic_vector (7 DOWNTO 0);
      vga_blank_n         : OUT    std_logic;
      vga_clk             : OUT    std_logic;
      vga_g               : OUT    std_logic_vector (7 DOWNTO 0);
      vga_hsync_n         : OUT    std_logic;
      vga_r               : OUT    std_logic_vector (7 DOWNTO 0);
      vga_sync            : OUT    std_logic;
      vga_vsync_n         : OUT    std_logic
   );

-- Declarations

type exemplar_string_array is array (natural range <>, natural range <>) of character;
attribute pin_number : string;
attribute array_pin_number : exemplar_string_array;
attribute pin_number of fpga_clk : signal is "Y2";
attribute pin_number of fpga_reset_n : signal is "M23";
attribute pin_number of vga_clk : signal is "A12";
attribute pin_number of vga_sync : signal is "C10";
attribute pin_number of vga_blank_n : signal is "F11";
attribute array_pin_number of vga_r : signal is ("H10", "H8 ", "J12", "G10", "F12", "D10", "E11", "E12");
attribute array_pin_number of vga_g : signal is ("C9 ", "F10", "B8 ", "C8 ", "H12", "F8 ", "G11", "G8 ");
attribute array_pin_number of vga_b : signal is ("D12", "D11", "C12", "A11", "B11", "C11", "A10", "B10");
attribute pin_number of vga_hsync_n : signal is "G13";
attribute pin_number of vga_vsync_n : signal is "C13";
attribute array_pin_number of sram_data : signal is ("AG3", "AF3", "AE4", "AE3", "AE1", "AE2", "AD2", "AD1", "AF7", "AG6", "AH6", "AF6", "AH4", "AG4", "AF4", "AH3");
attribute array_pin_number of sram_address : signal is ("T8  ", "AB8 ", "AB9 ", "AC11", "AB11", "AA4 ", "AC3 ", "AB4 ", "AD3 ", "AF2 ", "T7  ", "AF5 ", "AC5 ", "AB5 ", "AE6 ", "AB6 ", "AC7 ", "AE7 ", "AD7 ", "AB7 ");
attribute pin_number of sram_we_n : signal is "AE8";
attribute pin_number of sram_oe_n : signal is "AD5";
attribute pin_number of sram_ce_n : signal is "AF8";
attribute pin_number of sram_lb_n : signal is "AD4";
attribute pin_number of sram_ub_n : signal is "AC4";
attribute array_pin_number of HEX6 : signal is ("AC17","AA15","AB15","AB17","AA16","AB16","AA17");
attribute array_pin_number of HEX7 : signal is ("AA14","AG18","AF17","AH17","AG17","AE17","AD17");
attribute pin_number of gled0 : signal is "E21";
attribute pin_number of gled1 : signal is "E22";

END VISUAL_Subsystem ;

--
-- VHDL Architecture The_Reverb_Revolutionary_lib.VISUAL_Subsystem.struct
--
-- Created:
--          by - matho019.student-liu.se (muxen2-109.ad.liu.se)
--          at - 18:43:04 10/28/24
--
-- Generated by Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY The_Reverb_Revolutionary_lib;

ARCHITECTURE struct OF VISUAL_Subsystem IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Screen_overlay        : std_logic_vector(15 DOWNTO 0);
   SIGNAL Screen_overlay_active : std_logic;
   SIGNAL Visual_output         : std_logic_vector(15 DOWNTO 0);
   SIGNAL dout                  : std_logic;
   SIGNAL hblanc                : std_logic;
   SIGNAL hcnt                  : unsigned(10 DOWNTO 0);
   SIGNAL vblanc                : std_logic;
   SIGNAL vcnt                  : unsigned(9 DOWNTO 0);

   -- Implicit buffer signal declarations
   SIGNAL c0_internal          : STD_LOGIC;
   SIGNAL locked_internal      : STD_LOGIC;
   SIGNAL vga_hsync_n_internal : std_logic;
   SIGNAL vga_vsync_n_internal : std_logic;


   -- Component Declarations
   COMPONENT PLL65M
   PORT (
      areset : IN     STD_LOGIC  := '0';
      inclk0 : IN     STD_LOGIC  := '0';
      c0     : OUT    STD_LOGIC;
      locked : OUT    STD_LOGIC
   );
   END COMPONENT;
   COMPONENT Visual_SRAM_or_overlay
   PORT (
      SRAM_Data             : IN     std_logic_vector (15 DOWNTO 0);
      Screen_overlay        : IN     std_logic_vector (15 DOWNTO 0);
      Screen_overlay_active : IN     std_logic ;
      c0                    : IN     STD_LOGIC ;
      locked                : IN     STD_LOGIC ;
      Visual_output         : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT Visual_graphic_gen
   PORT (
      SRAM_Data    : IN     std_logic_vector (15 DOWNTO 0);
      fpga_clk_65M : IN     std_logic ;
      fpga_reset_n : IN     std_logic ;
      hblanc       : OUT    std_logic ;
      hcnt         : OUT    unsigned (10 DOWNTO 0);
      hsyncr       : OUT    std_logic ;
      vblanc       : OUT    std_logic ;
      vcnt         : OUT    unsigned (9 DOWNTO 0);
      vga_b        : OUT    std_logic_vector (7 DOWNTO 0);
      vga_blank_n  : OUT    std_logic ;
      vga_g        : OUT    std_logic_vector (7 DOWNTO 0);
      vga_r        : OUT    std_logic_vector (7 DOWNTO 0);
      vga_sync     : OUT    std_logic ;
      vsyncr       : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT Visual_memory_interface
   PORT (
      Audio_bar             : IN     std_logic_vector (17 DOWNTO 0);
      Balance_setting       : IN     std_logic_vector (3 DOWNTO 0);
      Echo_room_setting     : IN     std_logic_vector (3 DOWNTO 0);
      Echo_volume_setting   : IN     std_logic_vector (3 DOWNTO 0);
      Selected_setting      : IN     std_logic_vector (1 DOWNTO 0);
      Volume_setting        : IN     std_logic_vector (3 DOWNTO 0);
      c0                    : IN     STD_LOGIC ;
      hblanc                : IN     std_logic ;
      hcnt                  : IN     unsigned (10 DOWNTO 0);
      locked                : IN     STD_LOGIC ;
      vblanc                : IN     std_logic ;
      vcnt                  : IN     unsigned (9 DOWNTO 0);
      vga_hsync_n           : IN     std_logic ;
      vga_vsync_n           : IN     std_logic ;
      Screen_overlay        : OUT    std_logic_vector (15 DOWNTO 0);
      Screen_overlay_active : OUT    std_logic ;
      sram_address          : OUT    std_logic_vector (19 DOWNTO 0);
      sram_ce_n             : OUT    std_logic ;
      sram_lb_n             : OUT    std_logic ;
      sram_oe_n             : OUT    std_logic ;
      sram_ub_n             : OUT    std_logic ;
      sram_we_n             : OUT    std_logic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : PLL65M USE ENTITY The_Reverb_Revolutionary_lib.PLL65M;
   FOR ALL : Visual_SRAM_or_overlay USE ENTITY The_Reverb_Revolutionary_lib.Visual_SRAM_or_overlay;
   FOR ALL : Visual_graphic_gen USE ENTITY The_Reverb_Revolutionary_lib.Visual_graphic_gen;
   FOR ALL : Visual_memory_interface USE ENTITY The_Reverb_Revolutionary_lib.Visual_memory_interface;
   -- pragma synthesis_on


BEGIN

   -- ModuleWare code(v1.12) for instance 'U_0' of 'inv'
   dout <= NOT(fpga_reset_n);

   -- ModuleWare code(v1.12) for instance 'U_3' of 'inv'
   vga_clk <= NOT(c0_internal);

   -- Instance port mappings.
   U_1 : PLL65M
      PORT MAP (
         areset => dout,
         inclk0 => fpga_clk,
         c0     => c0_internal,
         locked => locked_internal
      );
   U_4 : Visual_SRAM_or_overlay
      PORT MAP (
         SRAM_Data             => SRAM_Data,
         Screen_overlay        => Screen_overlay,
         Screen_overlay_active => Screen_overlay_active,
         c0                    => c0_internal,
         locked                => locked_internal,
         Visual_output         => Visual_output
      );
   U_2 : Visual_graphic_gen
      PORT MAP (
         SRAM_Data    => Visual_output,
         fpga_clk_65M => c0_internal,
         fpga_reset_n => locked_internal,
         hblanc       => hblanc,
         hcnt         => hcnt,
         hsyncr       => vga_hsync_n_internal,
         vblanc       => vblanc,
         vcnt         => vcnt,
         vga_b        => vga_b,
         vga_blank_n  => vga_blank_n,
         vga_g        => vga_g,
         vga_r        => vga_r,
         vga_sync     => vga_sync,
         vsyncr       => vga_vsync_n_internal
      );
   U_5 : Visual_memory_interface
      PORT MAP (
         Audio_bar             => Audio_bar,
         Balance_setting       => Balance_setting,
         Echo_room_setting     => Echo_room_setting,
         Echo_volume_setting   => Echo_volume_setting,
         Selected_setting      => Selected_setting,
         Volume_setting        => Volume_setting,
         c0                    => c0_internal,
         hblanc                => hblanc,
         hcnt                  => hcnt,
         locked                => locked_internal,
         vblanc                => vblanc,
         vcnt                  => vcnt,
         vga_hsync_n           => vga_hsync_n_internal,
         vga_vsync_n           => vga_vsync_n_internal,
         Screen_overlay        => Screen_overlay,
         Screen_overlay_active => Screen_overlay_active,
         sram_address          => sram_address,
         sram_ce_n             => sram_ce_n,
         sram_lb_n             => sram_lb_n,
         sram_oe_n             => sram_oe_n,
         sram_ub_n             => sram_ub_n,
         sram_we_n             => sram_we_n
      );

   -- Implicit buffered output assignments
   c0          <= c0_internal;
   locked      <= locked_internal;
   vga_hsync_n <= vga_hsync_n_internal;
   vga_vsync_n <= vga_vsync_n_internal;

END struct;
