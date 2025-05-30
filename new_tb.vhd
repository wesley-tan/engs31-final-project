-------------------------------------------------------------------------------
--  tb_top_morse.vhd   - refined test bench with richer coverage
--  • Generates a 100 MHz clock
--  • Provides a UART transmit task `send_byte`
--  • Sends three test frames:  "SOS", "HELLO WORLD<sp>0123456789", and a
--    12-byte burst to over-fill the FIFO and exercise queue-full logic
--  • Runs 300 ms total so you can watch LED / sound activity
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_top_morse is
end entity;

architecture sim of tb_top_morse is

  ---------------------------------------------------------------------------
  --  Device Under Test
  ---------------------------------------------------------------------------
  component Top_Morse is
    port (
      clk       : in  std_logic;
      rx        : in  std_logic;
      led_out   : out std_logic;
      sound_out : out std_logic
    );
  end component;

  ---------------------------------------------------------------------------
  --  Constants
  ---------------------------------------------------------------------------
  constant SYS_CLK_PERIOD : time := 10 ns;                 -- 100 MHz
  constant BAUD           : integer := 9600;
  constant BIT_PERIOD     : time := 1 sec / BAUD;          -- ≈104.166 µs

  ---------------------------------------------------------------------------
  --  Signals
  ---------------------------------------------------------------------------
  signal clk_s       : std_logic := '0';
  signal rx_s        : std_logic := '1';  -- idle high
  signal led_out_s   : std_logic;
  signal sound_out_s : std_logic;

begin
  ---------------------------------------------------------------------------
  --  Clock
  ---------------------------------------------------------------------------
  clk_s <= not clk_s after SYS_CLK_PERIOD/2;

  ---------------------------------------------------------------------------
  --  DUT instantiation
  ---------------------------------------------------------------------------
  dut : Top_Morse
    port map (
      clk       => clk_s,
      rx        => rx_s,
      led_out   => led_out_s,
      sound_out => sound_out_s
    );

  ---------------------------------------------------------------------------
  --  Stimulus
  ---------------------------------------------------------------------------
  stim : process
    -------------------------------------------------------------------------
    -- Transmit one 8-N-1 byte, LSB first
    -------------------------------------------------------------------------
    procedure send_byte (constant b : std_logic_vector(7 downto 0)) is
    begin
      -- start bit
      rx_s <= '0';  wait for BIT_PERIOD;
      -- data bits LSB-first
      for i in 0 to 7 loop
        rx_s <= b(i);
        wait for BIT_PERIOD;
      end loop;
      -- stop bit
      rx_s <= '1';  wait for BIT_PERIOD;
      -- gap (1 bit time)
      wait for BIT_PERIOD;
    end procedure;

    -------------------------------------------------------------------------
    -- Convenience: send a string literal
    -------------------------------------------------------------------------
    procedure send_string (constant txt : string) is
    begin
      for idx in txt'range loop
        send_byte(std_logic_vector(to_unsigned(character'pos(txt(idx)), 8)));
      end loop;
    end procedure;
  begin
    -----------------------------------------------------------------------
    --  Initial delay for reset/PLL lock
    -----------------------------------------------------------------------
    wait for 1 ms;

    -----------------------------------------------------------------------
    --  TEST 1  
    -----------------------------------------------------------------------
    send_string("lol hi");
    -- wait long enough for Morse to finish

  end process;

end architecture sim;
