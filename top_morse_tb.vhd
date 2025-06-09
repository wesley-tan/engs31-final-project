--------------------------------------------------------------------------------
--  tb_top_morse.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_top_morse is
end entity;

architecture sim of tb_top_morse is

  -----------------------------------------------------------------------------
  --  DUT component declaration
  -----------------------------------------------------------------------------
  component Top_Morse is
    port (
      clk       : in  std_logic;
      rx        : in  std_logic;
      led_out   : out std_logic;
      sound_out : out std_logic
    );
  end component;

  -----------------------------------------------------------------------------
  --  Simulation constants
  -----------------------------------------------------------------------------
  constant CLK_PERIOD  : time := 10 ns;           
  constant clk_period_divided : time := 1000 ns;
  constant BAUD_PERIOD: integer:= 104;      -- 9600baud
    

  -----------------------------------------------------------------------------
  --  UUT I/O signals
  -----------------------------------------------------------------------------
  signal clk       : std_logic := '0';
  signal rx        : std_logic := '1';  -- UART line idles high
  signal led_out_s   : std_logic;
  signal sound_out_s : std_logic;

begin
  ---------------------------------------------------------------------------
  --  clock generator
  ---------------------------------------------------------------------------
   clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

  ---------------------------------------------------------------------------
  --  DUT instantiation
  ---------------------------------------------------------------------------
  uut : Top_Morse
    port map (
      clk       => clk,
      rx        => rx,
      led_out   => led_out_s,
      sound_out => sound_out_s
    );


  stim : process
   
    begin
    
             Rx <= '1';
        
        wait for clk_period_divided * 10;
        
        -- Scenario 1: Load data with '1'
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;

        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;

        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '1';  -- Load the data  
        wait for BAUD_PERIOD* clk_period_divided;


        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD*clk_period_divided;
        
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD*clk_period_divided;
        Rx <= '1';  -- Load the data
		wait for BAUD_PERIOD*clk_period_divided;
		
		-- SPACE 
		
		Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        

        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;

        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;

        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '1';  -- Load the data  
        wait for BAUD_PERIOD* clk_period_divided;


        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD*clk_period_divided;
        
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD*clk_period_divided;
        
        Rx <= '1';  -- stop
          
        wait for BAUD_PERIOD*clk_period_divided;

        -- Restart Transmission 'a'
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        

        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;

        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;

        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '1';  -- Load the data  
        wait for BAUD_PERIOD* clk_period_divided;


        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD*clk_period_divided;
        
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD*clk_period_divided;
        
        Rx <= '1';  -- stop
          
        wait for BAUD_PERIOD*clk_period_divided;
          
       Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        

        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;

        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;

        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '1';  -- Load the data  
        wait for BAUD_PERIOD* clk_period_divided;


        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD*clk_period_divided;
        
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD*clk_period_divided;
        
        Rx <= '1';  -- stop
          
        wait for BAUD_PERIOD*clk_period_divided;
        -- restart transmission 'enter'
		
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        

        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;

        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;

        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period_divided;
        
        Rx <= '0';  -- Load the data  
        wait for BAUD_PERIOD* clk_period_divided;


        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD*clk_period_divided;
        
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD*clk_period_divided;
        
        Rx <= '1';  -- stop
        wait;
 
  end process;

end architecture sim;
