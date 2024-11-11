--
-- VHDL Architecture The_Reverb_Revolutionary_lib.Visual_memory_read.arch
--
-- Created:
--          by - emipi270.student-liu.se (muxen2-104.ad.liu.se)
--          at - 16:41:55 10/08/24
--
-- using Siemens HDL Designer(TM) 2024.1 Built on 24 Jan 2024 at 18:06:06
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Visual_memory_read IS
   PORT( 
      c0                    : IN     STD_LOGIC;
      hblanc                : IN     std_logic;
      hcnt                  : IN     unsigned (10 DOWNTO 0);
      locked                : IN     STD_LOGIC;
      vblanc                : IN     std_logic;
      vcnt                  : IN     unsigned (9 DOWNTO 0);
      vga_hsync_n           : IN     std_logic;
      vga_vsync_n           : IN     std_logic;
      sram_lb_n             : OUT    std_logic;
      sram_oe_n             : OUT    std_logic;
      sram_ub_n             : OUT    std_logic;
      sram_ce_n             : OUT    std_logic;
      sram_we_n             : OUT    std_logic;
      Screen_overlay        : OUT    std_logic_vector (15 DOWNTO 0);
      Screen_overlay_active : OUT    std_logic;
      sram_address          : OUT    std_logic_vector (19 DOWNTO 0);
      Balance_setting       : IN     std_logic_vector (3 DOWNTO 0);
      Echo_room_setting     : IN     std_logic_vector (3 DOWNTO 0);
      Echo_volume_setting   : IN     std_logic_vector (3 DOWNTO 0);
      Volume_setting        : IN     std_logic_vector (3 DOWNTO 0);
      Selected_setting      : IN     std_logic_vector (1 DOWNTO 0);
      Audio_bar             : IN     std_logic_vector (17 DOWNTO 0)
   );

-- Declarations

END Visual_memory_read ;

ARCHITECTURE arch OF Visual_memory_read IS
  signal current_bar : std_logic_vector(3 downto 0) := "0000";
  constant volume_color : std_logic_vector(15 downto 0) := x"E15A"; -- pink
  constant balance_color : std_logic_vector(15 downto 0) := x"3498";
  constant echo_volume_color : std_logic_vector(15 downto 0) := x"0F75";
  constant echo_room_color : std_logic_vector(15 downto 0) := x"F54D";
  constant arrow_color : std_logic_vector(15 downto 0) := x"FF00";
  signal bar_color : std_logic_vector(15 downto 0);
  signal sram_cnt : std_logic_vector (19 downto 0) := (others => '0');
  
  signal balance : std_logic_vector (3 DOWNTO 0) := ("0101");
  signal balance_init : std_logic := '0';
  signal balance_bar : std_logic_vector(3 downto 0) := "0101";
  
  
BEGIN

process 
begin 
  if rising_edge(c0) then   -- will need signal for key press othervise volume
                            -- setting will change to zero every cycle 
    
      if (not hblanc) then
        sram_cnt <= std_logic_vector(unsigned(sram_cnt) + 1);  
      end if;
      
      if vblanc then
        sram_cnt <= (others => '0');
      end if;

    if (vcnt < (546+29)) and (hcnt > (346-1)) and (vcnt > (209-1)) and (hcnt < (387)) then
    
      case Selected_setting is
        when ("00") => --00
           current_bar <= Volume_setting;
          bar_color <= volume_color;
 
          if not ( hblanc or vblanc) then   --and vga_hsync_n and vga_vsync_n then --  
            if vcnt < (235+29) and hcnt > (346) and vcnt > (215+29) and hcnt < (386) then
              Screen_overlay <= arrow_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;
          
        when ("01") => --01
          balance_bar <= Balance_setting; -- change here 
        --  bar_color <= balance_color;     --

          if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if vcnt < (325+29) and hcnt > (346) and vcnt > (305+29) and hcnt < (386) then
              Screen_overlay <= arrow_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;

        when ("10") => --10
          current_bar <= Echo_room_setting;
          bar_color <= echo_room_color;

          if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if vcnt < (434+29) and hcnt > (346) and vcnt > (414+29) and hcnt < (386) then
              Screen_overlay <= arrow_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;

        when ("11") => --11
          current_bar <= Echo_volume_setting;
          bar_color <= echo_volume_color;

          if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if vcnt < (545+29) and hcnt > (346) and vcnt > (525+29) and hcnt < (386) then
              Screen_overlay <= arrow_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;

        when others =>
          current_bar <= Volume_setting;
          bar_color <= volume_color;

          if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if vcnt < (6+150+53+50) and hcnt > (346) and vcnt > (6+150+53) and hcnt < (386) then
              Screen_overlay <= bar_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;

      end case;
    end if;


------------------------------ balnce bar here ----------------


    if vcnt < 728 and vcnt > 644 and hcnt < 813+296 and hcnt > 216+296 then 
      
      
    if balance_bar = "0000" and balance_init = '0' then 
      balance_bar <= "0101";
      balance_init <= '1'; 
    end if;
      
      
    case balance_bar is 
                    
                           
      when ("0101") =>  
        
        if not ( hblanc or vblanc) then -- stage 0, nothing on screen  
            if ((vcnt < 725+6) and (hcnt > 511+296) and (vcnt > 670) and (hcnt < 296+512)) then
              Screen_overlay <= balance_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if; 
          
                    
     when ("0000") =>
        if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if ((vcnt < 725+6) and (hcnt > 216+296) and (vcnt > 670) and (hcnt < 512+296)) then
              Screen_overlay <= balance_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if; 
   
     when ("0001") =>
        if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if ((vcnt < 725+6) and (hcnt > 271+296) and (vcnt > 670) and (hcnt < 512+296)) then
              Screen_overlay <= balance_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if; 
          
            
     when ("0010") =>
        if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if ((vcnt < 725+6) and (hcnt > 331+296) and (vcnt > 670) and (hcnt < 512+296)) then
              Screen_overlay <= balance_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if; 
          
        
        
     when ("0011") =>
        if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if ((vcnt < 725+6) and (hcnt > 391+296) and (vcnt > 670) and (hcnt < 512+296)) then
              Screen_overlay <= balance_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if; 
          
        
     when ("0100") =>
        if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if ((vcnt < 725+6) and (hcnt > 451+296) and (vcnt > 670) and (hcnt < 512+296)) then
              Screen_overlay <= balance_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if; 
          
     
    
     when ("0110") =>
        if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if ((vcnt < 725+6) and (hcnt > 515+296) and (vcnt > 670) and (hcnt < 570+296)) then
              Screen_overlay <= balance_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if; 
          
          
     when ("0111") =>
        if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if ((vcnt < 725+6) and (hcnt > 515+296) and (vcnt > 670) and (hcnt < 630+296)) then
              Screen_overlay <= balance_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if; 
          
          
     when ("1000") =>
        if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if ((vcnt < 725+6) and (hcnt > 515+296) and (vcnt > 670) and (hcnt < 690+296)) then
              Screen_overlay <= balance_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if; 
          
          
          
          
     when ("1001") =>
        if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if ((vcnt < 725+6) and (hcnt > 515+296) and (vcnt > 670) and (hcnt < 750+296)) then
              Screen_overlay <= balance_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if; 
          
      when ("1010") =>
        if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if ((vcnt < 725+6) and (hcnt > 515+296) and (vcnt > 670) and (hcnt < 810+296)) then
              Screen_overlay <= balance_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if; 
        
      
 
      when others => 
        if not ( hblanc or vblanc) then
          if vcnt < (725+ 6) and hcnt > (511+296) and vcnt > 670 and hcnt < (512+296) then
            Screen_overlay <= balance_color;
            Screen_overlay_active <= '1';
          else  
            Screen_overlay_active <= '0';
           end if;
         end if;
         
       end case;
       
  end if;
    





------------------------------ Audio bar here ----------------


if vcnt < 134 and vcnt > 50 and hcnt < 813+296 and hcnt > 216+296 then 
    
    
  if Audio_bar < ("000000000000000001") then
    if not ( hblanc or vblanc) then -- stage 0, nothing on screen  
        if ((vcnt < 134) and (hcnt > 296+216) and (vcnt > 50) and (hcnt < 296+216+10)) then
          Screen_overlay <= x"F37B";
          Screen_overlay_active <= '1';
        else  
          Screen_overlay_active <= '0';
        end if;
      end if; 
                  
                         
    elsif Audio_bar < ("000000000000000011") then
      if not ( hblanc or vblanc) then -- stage 0, nothing on screen  
          if ((vcnt < 134) and (hcnt > 296+216) and (vcnt > 50) and (hcnt < 296+216+40)) then
            Screen_overlay <= x"F3E3";
            Screen_overlay_active <= '1';
          else  
            Screen_overlay_active <= '0';
          end if;
        end if; 
        
                  
    elsif Audio_bar < ("000000000000000111") then
      if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
          if ((vcnt < 134) and (hcnt > 296+216) and (vcnt > 50) and (hcnt < 296+216+80)) then
            Screen_overlay <= x"F3E3";
            Screen_overlay_active <= '1';
          else  
            Screen_overlay_active <= '0';
          end if;
        end if; 
 
    elsif Audio_bar < ("000000000000001111") then
      if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
          if ((vcnt < 134) and (hcnt > 296+216) and (vcnt > 50) and (hcnt < 296+216+120)) then
            Screen_overlay <= x"C7F3";
            Screen_overlay_active <= '1';
          else  
            Screen_overlay_active <= '0';
          end if;
      end if;
        
          
    elsif Audio_bar < ("000000000000011111") then
      if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
          if ((vcnt < 134) and (hcnt > 296+216) and (vcnt > 50) and (hcnt < 296+216+160)) then
            Screen_overlay <= x"7BF3";
            Screen_overlay_active <= '1';
          else  
            Screen_overlay_active <= '0';
          end if;
        end if; 
        
      
      
    elsif Audio_bar < ("000000000000111111") then
      if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
          if ((vcnt < 134) and (hcnt > 296+216) and (vcnt > 50) and (hcnt < 296+216+200)) then
            Screen_overlay <= x"23F3";
            Screen_overlay_active <= '1';
          else  
            Screen_overlay_active <= '0';
          end if;
        end if; 
        
      
    elsif Audio_bar < ("000000000001111111") then
      if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
          if ((vcnt < 134) and (hcnt > 296+216) and (vcnt > 50) and (hcnt < 296+216+240)) then
            Screen_overlay <= x"23EC";
            Screen_overlay_active <= '1';
          else  
            Screen_overlay_active <= '0';
          end if;
        end if; 
        
   
  
    elsif Audio_bar < ("000000000011111111") then
      if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
          if ((vcnt < 134) and (hcnt > 296+216) and (vcnt > 50) and (hcnt < 296+216+280)) then
            Screen_overlay <= x"2349";
            Screen_overlay_active <= '1';
          else  
            Screen_overlay_active <= '0';
          end if;
        end if; 
        
        
    elsif Audio_bar < ("000000000111111111") then
      if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
          if ((vcnt < 134) and (hcnt > 296+216) and (vcnt > 50) and (hcnt < 296+216+320)) then
            Screen_overlay <= x"7E23";
            Screen_overlay_active <= '1';
          else  
            Screen_overlay_active <= '0';
          end if;
        end if; 
        
        
    elsif Audio_bar < ("000000001111111111") then
      if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
          if ((vcnt < 134) and (hcnt > 296+216) and (vcnt > 50) and (hcnt < 296+216+360)) then
            Screen_overlay <= x"C233";
            Screen_overlay_active <= '1';
          else  
            Screen_overlay_active <= '0';
          end if;
        end if; 
        
        
        
    elsif Audio_bar < ("000000111111111111") then
      if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
          if ((vcnt < 134) and (hcnt > 296+216) and (vcnt > 50) and (hcnt < 296+216+400)) then
            Screen_overlay <= x"C323";
            Screen_overlay_active <= '1';
          else  
            Screen_overlay_active <= '0';
          end if;
        end if; 
        
    elsif Audio_bar < ("000011111111111111") then
      if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
        if ((vcnt < 134) and (hcnt > 296+216) and (vcnt > 50) and (hcnt < 296+216+440)) then
          Screen_overlay <= x"F323";
          Screen_overlay_active <= '1';
        else  
          Screen_overlay_active <= '0';
        end if;
      end if; 

    elsif Audio_bar < ("000111111111111111") then
      if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
        if ((vcnt < 134) and (hcnt > 296+216) and (vcnt > 50) and (hcnt < 296+216+480)) then
          Screen_overlay <= x"F323";
          Screen_overlay_active <= '1';
        else  
          Screen_overlay_active <= '0';
        end if;
      end if; 
      

    elsif Audio_bar < ("001111111111111111") then
      if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
        if ((vcnt < 134) and (hcnt > 296+216) and (vcnt > 50) and (hcnt < 296+216+550)) then
          Screen_overlay <= x"F323";
          Screen_overlay_active <= '1';
        else  
          Screen_overlay_active <= '0';
        end if;
      end if;


    elsif Audio_bar < ("01111111111111111") then
      if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
        if ((vcnt < 134) and (hcnt > 296+216) and (vcnt > 50) and (hcnt < 296+216+595)) then
          Screen_overlay <= x"F323";
          Screen_overlay_active <= '1';
        else  
          Screen_overlay_active <= '0';
        end if;
      end if;
    

    else
      if not ( hblanc or vblanc) then
        if vcnt < (134) and hcnt > (296+216) and vcnt > 50 and hcnt < (296+216+595) then
          Screen_overlay <= x"F323";
          Screen_overlay_active <= '1';
        else  
          Screen_overlay_active <= '0';
         end if;
       end if;
    end if;
       
     
end if;


  -----------------------------------------------------------------
 
    
    

    if ((vcnt < 714) and (hcnt > 1207) and (vcnt > 84+29) and (hcnt < 1287)) then
    
      case current_bar is 

        when ("1010") => -- volume 10
          if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if ((vcnt < 714) and (hcnt > 1207) and (vcnt > 85+29) and (hcnt < 1286)) then
              Screen_overlay <= bar_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if; 
        
        when ("1001") => -- volume 9  
          if not ( hblanc or vblanc) then--and vga_hsync_n and vga_vsync_n then --  
            if vcnt < 714 and hcnt > 1207 and vcnt > 173 and hcnt < 1286 then
              Screen_overlay <= bar_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;
          
        when ("1000" ) => -- volume 8
          if not ( hblanc or vblanc) then
            if vcnt < 714 and hcnt > 1207 and vcnt > 233 and hcnt < 1286 then
              Screen_overlay <= bar_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;
          
        when ("0111" ) => -- volume 7
          if not ( hblanc or vblanc) then
            if vcnt < 714 and hcnt > 1207 and vcnt > 293 and hcnt < 1286 then
              Screen_overlay <= bar_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;
          
        when ("0110" ) => -- volume 6
          if not ( hblanc or vblanc) then
            if vcnt < 714 and hcnt > 1207 and vcnt > 353 and hcnt < 1286 then
              Screen_overlay <= bar_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;
          
        when ("0101" ) => -- volume 5
          if not ( hblanc or vblanc) then
            if vcnt < 714 and hcnt > 1207 and vcnt > 413 and hcnt < 1286 then
              Screen_overlay <= bar_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;
          
        when ( "0100" ) => -- volume 4
          if not ( hblanc or vblanc) then
            if vcnt < 7142 and hcnt > 1207 and vcnt > 473 and hcnt < 1286 then
              Screen_overlay <= bar_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;
          
        when ( "0011" ) => -- volume 3
          if not ( hblanc or vblanc) then
            if vcnt < 714 and hcnt > 1207 and vcnt > 533 and hcnt < 1286 then
              Screen_overlay <= bar_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;
          
        when ( "0010" ) => -- volume 2
          if not ( hblanc or vblanc) then
            if vcnt < 714 and hcnt > 1207 and vcnt > 593 and hcnt < 1286 then
              Screen_overlay <= bar_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;

        when ( "0001" ) => -- volume 1
          if not ( hblanc or vblanc) then
            if vcnt < 714 and hcnt > 1207 and vcnt > 653 and hcnt < 1286 then
              Screen_overlay <= bar_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;
          
        when ( "0000" ) => -- volume 0
          if not ( hblanc or vblanc) then
            if vcnt < 714 and hcnt > 1207 and vcnt > 713 and hcnt < 1286 then
              Screen_overlay <= bar_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;

        when others => 
          if not ( hblanc or vblanc) then
            if vcnt < 714 and hcnt > 1207 and vcnt > 759 and hcnt < 1286 then
              Screen_overlay <= bar_color;
              Screen_overlay_active <= '1';
            else  
              Screen_overlay_active <= '0';
            end if;
          end if;
          
        end case;    
    end if;
       
  end if;
        
end process; 

  sram_ce_n  <= '0';
  sram_lb_n  <= '0';
  sram_oe_n  <= '0';
  sram_ub_n  <= '0';
  sram_we_n  <= '1';
  
  sram_address <= sram_cnt;

END ARCHITECTURE arch;

