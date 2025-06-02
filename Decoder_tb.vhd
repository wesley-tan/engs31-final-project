-- morse_decoder_tb.vhd 
library IEEE;
use IEEE.std_logic_1164.all;

entity morse_decoder_tb is
end entity;

architecture testbench of morse_decoder_tb is

  -----------------------------------------------------------------
  --  DUT declaration
  -----------------------------------------------------------------
  component morse_decoder is
    port (
      clk         : in  std_logic;
      data_out    : in  std_logic_vector(7 downto 0);
      read        : in  std_logic;
      decoded_out : out std_logic_vector(26 downto 0)
    );
  end component;

  -----------------------------------------------------------------
  --  Signals
  -----------------------------------------------------------------
  signal clk         : std_logic := '0';
  signal read        : std_logic := '0';
  signal data_out    : std_logic_vector(7 downto 0) := (others => '0');
  signal decoded_out : std_logic_vector(26 downto 0);

  -- 10 ns period = 100 MHz
  constant CLK_PER : time := 10 ns;

begin

  -----------------------------------------------------------------
  --  Instantiate DUT
  -----------------------------------------------------------------
  uut : morse_decoder
    port map (
      clk         => clk,
      data_out    => data_out,
      read        => read,
      decoded_out => decoded_out
    );

  -----------------------------------------------------------------
  --  100?MHz clock
  -----------------------------------------------------------------
  clk_proc : process
  begin
    clk <= '0'; wait for CLK_PER/2;
    clk <= '1'; wait for CLK_PER/2;
  end process;

  -----------------------------------------------------------------
  --  Stimulus (five characters)
  -----------------------------------------------------------------
  stim_proc : process
  begin
    wait for 50 ns;                  -- settle after reset

    -- transmit 'a' (0x61)
    data_out <= x"61"; read <= '1';  wait for CLK_PER;
    read <= '0';                     wait for 30 ns;

    -- transmit 'e' (0x65)
    data_out <= x"65"; read <= '1';  wait for CLK_PER;
    read <= '0';                     wait for 30 ns;

    -- transmit space (0x20)
    data_out <= x"20"; read <= '1';  wait for CLK_PER;
    read <= '0';                     wait for 30 ns;

    -- transmit '2' (0x32)
    data_out <= x"32"; read <= '1';  wait for CLK_PER;
    read <= '0';                     wait for 30 ns;

    -- transmit 'z' (0x7A)
    data_out <= x"7A"; read <= '1';  wait for CLK_PER;
    read <= '0';                     wait for 30 ns;

    wait;                             -- keep simulation running
  end process;

end architecture;
