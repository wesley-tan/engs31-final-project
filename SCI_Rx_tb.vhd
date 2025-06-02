LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SCI_Rx_tb IS
END SCI_Rx_tb;

ARCHITECTURE testbench OF SCI_Rx_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT SCI_Rx
        PORT ( 	clk			: 	in 	STD_LOGIC;
                Rx 		: 	in 	STD_LOGIC;
                Parallel_out :	out STD_LOGIC_VECTOR(7 downto 0);
                Rx_done		:	out STD_Logic;
                Valid        : out std_logic);
    END COMPONENT;
    
    --Inputs
    signal clk     : std_logic := '0';
    signal Data_in : std_logic := '0';
    signal Rx    : std_logic := '0';

    --Outputs
    signal Parallel_out      : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal Rx_done : std_logic;
    signal Valid : std_logic;
    constant  BAUD_PERIOD : integer := 104;

    -- Clock period definitions
    constant clk_period : time := 1000 ns; -- 10 MHz

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: SCI_Rx PORT MAP (
        clk     => clk,
        Rx    => Rx,
        Parallel_out      => Parallel_out,
        Rx_done => Rx_done,
        Valid   => Valid
    );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin        
        -- Initialize Inputs
        Rx <= '1';
        
        wait for clk_period * 10;
        
        -- Scenario 1: Load data 
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period;
        
     
        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD* clk_period;
        
    
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period;

        
        
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period;

        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period;
        
        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD* clk_period;
        
        Rx <= '1';  -- Load the data  
        wait for BAUD_PERIOD* clk_period;


        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD*clk_period;
        
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD*clk_period;
        Rx <= '1';  -- Load the data
		wait for 2*BAUD_PERIOD*clk_period;

        -- Restart Transmission '
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period;
        
        -- Scenario 2: Load data "11001100"
        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD* clk_period;
        
        -- Scenario 2: Load data "11001100"
        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD* clk_period;

        
        
                -- Scenario 2: Load data "11001100"
        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD* clk_period;

        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD* clk_period;
        
        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD* clk_period;
        
        Rx <= '0';  -- Load the data  
        wait for BAUD_PERIOD* clk_period;


        Rx <= '1';  -- Load the data
        wait for BAUD_PERIOD*clk_period;
        
        Rx <= '0';  -- Load the data
        wait for BAUD_PERIOD*clk_period;
        Rx <= '1';  -- Load the data
		
        
        wait;

        -- Complete the simulation
        wait;
    end process;

END testbench;
