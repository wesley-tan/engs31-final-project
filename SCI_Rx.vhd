library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SCI_Rx is
  port (
    clk          : in  std_logic;
    Rx           : in  std_logic;
    Receive_en   : in  std_logic;
    Parallel_out : out std_logic_vector(7 downto 0);
    Rx_done      : out std_logic;
    Valid        : out std_logic
  );
end SCI_Rx;


architecture Behavioral of SCI_Rx is

  -- Baud settings for 25.6 kHz @ 100 MHz clk
  constant BAUD_PERIOD      : integer := 391;
  constant BAUD_PERIOD_HALF : integer := 195;
  constant BIT_COUNT        : integer := 10;  -- start + 8 data + stop

  type state_type is (idle, wait_half, shift, wait_full, data_ready);
  signal CS, NS : state_type := idle;

  signal shift_reg       : std_logic_vector(9 downto 0) := (others => '0');
  signal baud_counter    : unsigned(9 downto 0) := (others => '0');
  signal bit_counter     : unsigned(3 downto 0) := (others => '0');

  signal tc_baud         : std_logic := '0';
  signal tc_half_baud    : std_logic := '0';
  signal tc_bit          : std_logic := '0';
  signal shift_en        : std_logic := '0';

  signal clr_baud        : std_logic := '0';
  signal clr_bit         : std_logic := '0';
  signal clr_shift_reg   : std_logic := '0';
  signal tc_en           : std_logic := '0';
  signal tc_half_en      : std_logic := '0';

  signal rx_done_int     : std_logic := '0';
  signal valid_int       : std_logic := '0';

begin

  ---------------------------------------
  -- State Register
  ---------------------------------------
  process(clk)
  begin
    if rising_edge(clk) then
      CS <= NS;
    end if;
  end process;

  ---------------------------------------
  -- Next-State Logic
  ---------------------------------------
  process(CS, Rx, tc_baud, tc_half_baud, tc_bit, Receive_en)
  begin
    NS <= CS;
    case CS is
      when idle =>
        if Receive_en = '1' and Rx = '0' then
          NS <= wait_half;
        end if;

      when wait_half =>
        if tc_half_baud = '1' then
          NS <= shift;
        end if;

      when shift =>
        if tc_bit = '1' then
          NS <= data_ready;
        else
          NS <= wait_full;
        end if;

      when wait_full =>
        if tc_baud = '1' then
          NS <= shift;
        end if;

      when data_ready =>
        NS <= idle;

      when others =>
        NS <= idle;
    end case;
  end process;

  ---------------------------------------
  -- Output Logic
  ---------------------------------------
  process(CS)
  begin
    shift_en      <= '0';
    clr_baud      <= '0';
    clr_bit       <= '0';
    clr_shift_reg <= '0';
    tc_half_en    <= '0';
    tc_en         <= '0';
    rx_done_int   <= '0';
    valid_int     <= '1';  -- assume valid unless disqualified

    case CS is
      when idle =>
        clr_baud      <= '1';
        clr_bit       <= '1';
        clr_shift_reg <= '1';

      when wait_half =>
        tc_half_en <= '1';

      when shift =>
        shift_en <= '1';
        clr_baud <= '1';
        tc_en    <= '1';

      when wait_full =>
        tc_en <= '1';

      when data_ready =>
        rx_done_int <= '1';
        clr_bit     <= '1';
        -- check for valid ASCII
        if to_integer(unsigned(shift_reg(8 downto 1))) < 32 or
           to_integer(unsigned(shift_reg(8 downto 1))) > 122 then
          valid_int <= '0';
        end if;

      when others =>
        null;
    end case;
  end process;

  ---------------------------------------
  -- Datapath: Baud counter & bit counter
  ---------------------------------------
  process(clk)
  begin
    if rising_edge(clk) then
      if clr_baud = '1' then
        baud_counter <= (others => '0');
      else
        baud_counter <= baud_counter + 1;
      end if;

      if clr_bit = '1' then
        bit_counter <= (others => '0');
      elsif tc_baud = '1' or tc_half_baud = '1' then
        bit_counter <= bit_counter + 1;
      end if;
    end if;
  end process;

  ---------------------------------------
  -- Shift register
  ---------------------------------------
  process(clk)
  begin
    if rising_edge(clk) then
      if clr_shift_reg = '1' then
        shift_reg <= (others => '0');
      elsif shift_en = '1' then
        shift_reg <= Rx & shift_reg(9 downto 1);
      end if;
    end if;
  end process;

  ---------------------------------------
  -- Terminal Count Checks
  ---------------------------------------
  process(baud_counter)
  begin
    if tc_en = '1' and baud_counter = BAUD_PERIOD - 1 then
      tc_baud <= '1';
    else
      tc_baud <= '0';
    end if;
  end process;

  process(baud_counter)
  begin
    if tc_half_en = '1' and baud_counter = BAUD_PERIOD_HALF - 1 then
      tc_half_baud <= '1';
    else
      tc_half_baud <= '0';
    end if;
  end process;

  process(bit_counter)
  begin
    if bit_counter = BIT_COUNT - 1 then
      tc_bit <= '1';
    else
      tc_bit <= '0';
    end if;
  end process;

  ---------------------------------------
  -- Output assignments
  ---------------------------------------
  Parallel_out <= shift_reg(8 downto 1);  -- exclude start/stop bits
  Rx_done      <= rx_done_int;
  Valid        <= valid_int;

end Behavioral;
