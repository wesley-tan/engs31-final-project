-- clock_divider.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
  generic (
    DIVISOR : integer := 100
  );
  port (
    clk       : in  std_logic;
    reset     : in  std_logic;
    tick_T    : out std_logic
  );
end entity;

architecture Behavioral of clock_divider is
  signal count : unsigned(23 downto 0) := (others => '0');
  signal tick  : std_logic := '0';
begin

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        count <= (others => '0');
        tick  <= '0';
      elsif count = DIVISOR - 1 then
        count <= (others => '0');
        tick  <= '1';
      else
        count <= count + 1;
        tick  <= '0';
      end if;
    end if;
  end process;

  tick_T <= tick;

end architecture;
