LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Shift_reg_tb IS
END Shift_reg_tb;

ARCHITECTURE testbench OF Shift_reg_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Shift_reg
    PORT (
      clk         : in  STD_LOGIC;
      shift_en    : in STD_LOGIC;
      decoded_out : in  STD_LOGIC_VECTOR(26 downto 0);
      output_bit  : out STD_LOGIC;
      shift_done  : out STD_LOGIC
    );
    END COMPONENT;
    
    --Inputs
    signal clk     : std_logic := '0';
    signal shift_en : std_logic := '0';
    signal decoded_out : STD_LOGIC_VECTOR(26 downto 0) := (others => '0');
    --Outputs
   
    signal Output_bit    : std_logic := '0';
    signal shift_done    : std_logic := '0';

    -- Clock period definitions
    constant clk_period : time := 100 ns; -- 10 MHz

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: Shift_reg PORT MAP (
        clk     => clk,
        shift_en => shift_en,
        decoded_out    => decoded_out,
        output_bit => Output_bit,
        shift_done => shift_done
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
        shift_en <= '0';
        
        wait for clk_period * 10;
        
        shift_en <= '1';
        -- Scenario 1: Load data 
        decoded_out <= "111010111010000000000001110";
        
        wait for clk_period;
        shift_en <= '0';
        wait for 20*clk_period;

        
        
        
         shift_en <= '1';
        -- Scenario 1: Load data 
        decoded_out <= "101110101000000000000001100";
        wait for clk_period;
        shift_en <= '0';
        
        
        wait for 30* clk_period;
        
       
        -- Wait for transmission to complete
        wait for clk_period * 500;


        -- Complete the simulation
        wait;
    end process;

END testbench;
