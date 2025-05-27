LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Shift_reg_tb IS
END Shift_reg_tb;

ARCHITECTURE testbench OF Shift_reg_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Shift_reg
  port (
    clk          : in  std_logic;
    process_done : in  std_logic;  -- pulse to load new data
    Data_in      : in  std_logic_vector(21 downto 0);
    Data_len     : in  std_logic_vector(4 downto 0);
    Output_bit   : out std_logic
  );
    END COMPONENT;
    
    --Inputs
    signal clk     : std_logic := '0';
    signal Process_done : std_logic := '0';
    signal Data_in : STD_LOGIC_VECTOR(21 downto 0) := (others => '0');
    signal Data_len : STD_LOGIC_VECTOR(4 downto 0) := (others =>       '0');
    --Outputs
   
    signal Output_bit    : std_logic := '0';
    signal shift_done    : std_logic := '0';

    -- Clock period definitions
    constant clk_period : time := 100 ns; -- 10 MHz

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: Shift_reg PORT MAP (
        clk     => clk,
        Process_done => Process_done,
        Data_in    => Data_in,
        Data_len      => Data_len,
        Output_bit => Output_bit
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
        Process_done <= '0';
        
        wait for clk_period * 10;
        
        Process_done <= '1';
        -- Scenario 1: Load data 
        Data_in <= "1110101110100000000000";
        Data_len <= "01110";
        wait for clk_period;
        process_done <= '0';
        wait for 30* clk_period;
        
       
        -- Wait for transmission to complete
        wait for clk_period * 500;


        -- Complete the simulation
        wait;
    end process;

END testbench;