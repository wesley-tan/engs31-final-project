--=========================================================
--  Test bench for top_morse.vhd
--  Sends "SOS" and lets the simulation run long enough
--  to see LED / beep activity.
--=========================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_morse is
end entity;

architecture sim of tb_top_morse is

component top_morse is
  port (
    clk         : in  std_logic;  -- 100 MHz clock
    Rx          : in  std_logic;  -- UART Rx input from host
    led_out     : out std_logic
  );
end component;

  ------------------------------------------------------------------
  -- constants
  ------------------------------------------------------------------
  constant CLK_PERIOD   : time := 10 ns;        -- 100?MHz
  constant BAUD_PERIOD  : time := 3.91 us;      -- 391 clks @ 100?MHz

  ------------------------------------------------------------------
  -- DUT ports
  ------------------------------------------------------------------
  signal clk      : std_logic := '0';
  signal rx       : std_logic := '1';           -- idle high
  signal led_out  : std_logic;

begin
  ------------------------------------------------------------------
  -- Clock generator  (100?MHz square wave)
  ------------------------------------------------------------------
  clk <= not clk after CLK_PERIOD/2;

  ------------------------------------------------------------------
  -- Instantiate the design-under-test
  ------------------------------------------------------------------
  uut : top_morse
    port map (
      clk      => clk,
      Rx       => rx,
      led_out  => led_out
    );

  ------------------------------------------------------------------
  -- Stimulus process
  ------------------------------------------------------------------
  stim : process
    ----------------------------------------------------------------
    -- local procedure to transmit one UART byte, LSB first
    ----------------------------------------------------------------
    procedure send_byte (constant data : std_logic_vector(7 downto 0)) is
    begin
      -- start bit
      rx <= '0';
      wait for BAUD_PERIOD;

      -- 8 data bits  (LSB first)
      for i in 0 to 7 loop
        rx <= data(i);
        wait for BAUD_PERIOD;
      end loop;

      -- stop bit
      rx <= '1';
      wait for BAUD_PERIOD;

      -- small idle gap between bytes
      wait for BAUD_PERIOD * 4;
    end procedure;
  begin
    ----------------------------------------------------------------
    -- initial reset time / idle line
    ----------------------------------------------------------------
    wait for 50 us;                    -- settle

    ----------------------------------------------------------------
    -- Send the string "SOS"
    ----------------------------------------------------------------
    send_byte(x"53");  -- 'S'
    send_byte(x"4F");  -- 'O'
    send_byte(x"53");  -- 'S'

    ----------------------------------------------------------------
    -- allow plenty of time for Morse output to finish
    ----------------------------------------------------------------
    wait for 200 ms;

  end process;
end architecture;
