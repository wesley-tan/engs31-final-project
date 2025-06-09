-- tb_queue.vhd 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Queue_tb is
end Queue_tb;

architecture testbench of Queue_tb is

  -----------------------------------------------------------------
  --  Component under test
  -----------------------------------------------------------------
  component Queue is
    port (
      clk          : in  STD_LOGIC;               -- 10MHz clock (100 ns)
      Write        : in  STD_LOGIC;
      read         : in  STD_LOGIC;
      parallel_out : in  STD_LOGIC_VECTOR(7 downto 0);
      Data_out     : out STD_LOGIC_VECTOR(7 downto 0);
      Empty        : out STD_LOGIC;
      Full         : out STD_LOGIC
    );
  end component;

  -----------------------------------------------------------------
  --  Signals
  -----------------------------------------------------------------
  signal clk          : STD_LOGIC := '0';
  signal Write        : STD_LOGIC := '0';
  signal Read         : STD_LOGIC := '0';
  signal parallel_out : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
  signal Data_out     : STD_LOGIC_VECTOR(7 downto 0);
  signal Empty        : STD_LOGIC;
  signal Full         : STD_LOGIC;

  constant CLK_PER : time := 10 ns;  -- 100 MHz

begin
  -----------------------------------------------------------------
  --  Instantiate DUT
  -----------------------------------------------------------------
  uut : Queue
    port map (
      clk          => clk,
      Write        => Write,
      read         => Read,
      parallel_out => parallel_out,
      Data_out     => Data_out,
      Empty        => Empty,
      Full         => Full
    );

  -----------------------------------------------------------------
  --  100 MHz clock
  -----------------------------------------------------------------
  clk_proc : process
  begin
    clk <= '0';
    wait for CLK_PER/2;
    clk <= '1';
    wait for CLK_PER/2;
  end process;

  -----------------------------------------------------------------
  --  Stimulus
  -----------------------------------------------------------------
  stim_proc : process
    -- simple helpers
    procedure push(constant b : STD_LOGIC_VECTOR) is
    begin
      parallel_out <= b;
      Write        <= '1';
      wait for CLK_PER;
      Write        <= '0';
      wait for 3*CLK_PER;  
    end procedure;

    procedure pop is
    begin
      Read <= '1';
      wait for CLK_PER;
      Read <= '0';
      wait for 3*CLK_PER;
    end procedure;
  begin
    -----------------------------------------------------------------
    -- 1.  Fill the FIFO with 20 bytes (0x00 .. 0x13)
    -----------------------------------------------------------------
    for i in 0 to 19 loop
      push(std_logic_vector(to_unsigned(i,8)));
    end loop;

    -- 2.  Attempt an extra write while Full='1'
    push(x"8C");

    -- 3.  Pop two bytes
    pop; pop;

    -- 4.  Write two new bytes (0xC7, 0x01) - exercises wrap-around
    push(x"C7");
    push(x"01");

    -- 5.  Drain the queue completely (20 pops)
    for j in 1 to 20 loop
      pop;
    end loop;

    -- 6.  Extra pop when Empty = '1'  (ignored)
    pop;

    -- 7.  Final push / pop to confirm continued operation
    push(x"FF");
    pop;

    wait;                              -- end of test bench
  end process;

end testbench;
