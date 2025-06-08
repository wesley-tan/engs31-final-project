-- controller_fsm_tb.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity controller_fsm_tb is
end entity;

architecture testbench of controller_fsm_tb is

  -----------------------------------------------------------------
  --  Component under test
  -----------------------------------------------------------------
  component controller_fsm is
    port (
      clk        : in  std_logic;
      empty      : in  std_logic;
      shift_done : in  std_logic;
      enter      : in  std_logic;
      read       : out std_logic;
      shift_en   : out std_logic
    );
  end component;

  -----------------------------------------------------------------
  --  Signals
  -----------------------------------------------------------------
  signal clk        : std_logic := '0';
  signal empty      : std_logic := '1';
  signal shift_done : std_logic := '0';
  signal enter      : std_logic := '0';
  signal read       : std_logic;
  signal shift_en   : std_logic;

  constant CLK_PER : time := 10 ns;  -- 100?MHz

begin
  -----------------------------------------------------------------
  --  Instantiate DUT
  -----------------------------------------------------------------
  uut : controller_fsm
    port map (
      clk        => clk,
      empty      => empty,
      shift_done => shift_done,
      enter      => enter,
      read       => read,
      shift_en   => shift_en
    );

  -----------------------------------------------------------------
  --  clock
  -----------------------------------------------------------------
  clk_proc : process
  begin
    clk <= '0'; wait for CLK_PER/2;
    clk <= '1'; wait for CLK_PER/2;
  end process;

  -----------------------------------------------------------------
  --  Stimulus
  -----------------------------------------------------------------
  stim_proc : process
  begin
    wait for 50 ns;                     -- reset/settle

    -------------------------------------------------------------------
    -- Packet 1: queue not empty, user presses ENTER
    -------------------------------------------------------------------
    empty  <= '0';
    enter  <= '1';                      -- pulse ENTER
    wait for CLK_PER;
    enter  <= '0';

    -- POP LOAD occur automatically next two clocks
    wait for 2*CLK_PER;

    -- FSM now in SHIFT; give it a done pulse
    shift_done <= '1';
    wait for CLK_PER;
    shift_done <= '0';

    -------------------------------------------------------------------
    -- Packet 2 still in queue (empty='0'); FSM should POP again
    -------------------------------------------------------------------
    wait for 3*CLK_PER;
    shift_done <= '1';                  -- done with second packet
    wait for CLK_PER;
    shift_done <= '0';
    wait for 3*CLK_PER;

    -------------------------------------------------------------------
    -- Queue becomes empty, FSM returns to IDLE
    -------------------------------------------------------------------
    empty <= '1';
    shift_done <= '1';
    wait for 10*CLK_PER;

    -------------------------------------------------------------------
    -- End of simulation
    -------------------------------------------------------------------
    wait;
  end process;

end architecture;
