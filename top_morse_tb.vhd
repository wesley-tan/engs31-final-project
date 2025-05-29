-------------------------------------------------------------------------------
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
  component Morse_Top is
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
  constant CLK_PERIOD  : time := 10 ns;           -- 100 MHz
  constant BAUD_PERIOD : time := 104.167 us;      -- 9600 baud
    

  -----------------------------------------------------------------------------
  --  DUT I/O signals
  -----------------------------------------------------------------------------
  signal clk_s       : std_logic := '0';
  signal rx_s        : std_logic := '1';  -- UART line idles high
  signal led_out_s   : std_logic;
  signal sound_out_s : std_logic;

begin
  ---------------------------------------------------------------------------
  --  clock generator
  ---------------------------------------------------------------------------
  clk_s <= not clk_s after CLK_PERIOD/2;

  ---------------------------------------------------------------------------
  --  DUT instantiation
  ---------------------------------------------------------------------------
  dut : Morse_Top
    port map (
      clk       => clk_s,
      rx        => rx_s,
      led_out   => led_out_s,
      sound_out => sound_out_s
    );

  ---------------------------------------------------------------------------
  --  Stimulus process : sends "SOS" over UART
  ---------------------------------------------------------------------------
  stim : process
    -------------------------------------------------------------------------
    -- helper to transmit one 8-N-1 UART byte (LSB first)
    -------------------------------------------------------------------------
    procedure send_byte(constant data : std_logic_vector(7 downto 0)) is
    begin
      -- start bit
      rx_s <= '0';
      wait for BAUD_PERIOD;

      -- 8 data bits LSB-first
      for i in 0 to 7 loop
        rx_s <= data(i);
        wait for BAUD_PERIOD;
      end loop;

      -- stop bit (1)
      rx_s <= '1';
      wait for BAUD_PERIOD;

      -- 4-bit idle gap for clarity
      wait for BAUD_PERIOD * 4;
    end procedure;
  begin
      ----------------------------------------------------------------------
      --  Initial idle time so DUT clocks up
      ----------------------------------------------------------------------
      wait for 50 us;

      ----------------------------------------------------------------------
      --  Transmit the ASCII string "SOS" (0x53 0x4F 0x53)
      ----------------------------------------------------------------------
      send_byte(x"53");  -- 'S'
      send_byte(x"4F");  -- 'O'
      send_byte(x"53");  -- 'S'

      wait for 200 ms;

  end process;

end architecture sim;
