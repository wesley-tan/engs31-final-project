library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-------------------------------------------------------------------------------
--  Top_Morse.vhd  (updated for new decoder / controller interfaces)
-------------------------------------------------------------------------------
entity Top_Morse is
  port (
    clk       : in  std_logic;  -- 100 MHz master clock
    rx        : in  std_logic;  -- RS-232 RX
    led_out   : out std_logic;  -- Morse LED
    sound_out : out std_logic   -- Audio gate (mirrors LED)
  );
end entity Top_Morse;

architecture Behavioral of Top_Morse is

  ---------------------------------------------------------------------------
  --  Component declarations
  ---------------------------------------------------------------------------
  component SCI_Rx is
    port (
      clk          : in  std_logic;
      rx           : in  std_logic;
      parallel_out : out std_logic_vector(7 downto 0);
      rx_done      : out std_logic;
      write        : out std_logic;
      valid        : out std_logic
    );
  end component;

  component Queue is
    port (
      clk          : in  std_logic;
      write        : in  std_logic;
      parallel_out : in  std_logic_vector(7 downto 0);
      read         : in  std_logic;
      data_out     : out std_logic_vector(7 downto 0);
      empty        : out std_logic;
      full         : out std_logic
    );
  end component;

  component morse_decoder is
    port (
      clk         : in  std_logic;
      data_out    : in  std_logic_vector(7 downto 0);
      empty       : in  std_logic;
      shift_done  : in  std_logic;
      read        : in  std_logic;
      decoded_out : out std_logic_vector(26 downto 0)
    );
  end component;

  component controller_fsm is
    port (
      clk        : in  std_logic;
      empty      : in  std_logic;
      shift_done : in  std_logic;
      read       : out std_logic;
      shift_en   : out std_logic
    );
  end component;

  component Shift_Reg is
    port (
      clk         : in  std_logic;
      shift_en    : in  std_logic;
      decoded_out : in  std_logic_vector(26 downto 0);
      output_bit  : out std_logic;
      shift_done  : out std_logic
    );
  end component;

  component system_clock_generation is
    port (
      input_clk_port  : in  std_logic;
      system_clk_port : out std_logic
    );
  end component;

  ---------------------------------------------------------------------------
  --  Internal signals
  ---------------------------------------------------------------------------
  signal sys_clk      : std_logic;

  -- UART → FIFO
  signal rx_data      : std_logic_vector(7 downto 0);
  signal rx_done      : std_logic;
  signal valid        : std_logic;

  -- FIFO ↔ Decoder
  signal queue_out    : std_logic_vector(7 downto 0);
  signal queue_empty  : std_logic;
  signal queue_full   : std_logic;
  signal read_sig     : std_logic;
  
  signal write_sig     : std_logic;

  -- Decoder ↔ ShiftReg
  signal decoded_pkt  : std_logic_vector(26 downto 0);
  signal shift_en_sig : std_logic;
  signal shift_done   : std_logic;

  signal morse_bit    : std_logic;

begin
  ---------------------------------------------------------------------------
  -- 0. Clock generation
  ---------------------------------------------------------------------------
  clk_gen : system_clock_generation
    port map (
      input_clk_port  => clk,
      system_clk_port => sys_clk
    );

  ---------------------------------------------------------------------------
  -- 1. UART receiver (8-N-1)
  ---------------------------------------------------------------------------
  U_RX : SCI_Rx
    port map (
      clk          => sys_clk,
      rx           => rx,
      parallel_out => rx_data,
      rx_done      => rx_done,
      write        => write_sig,
      valid        => valid
    );

  ---------------------------------------------------------------------------
  -- 2. FIFO queue (depth 8)
  ---------------------------------------------------------------------------
  U_FIFO : Queue
    port map (
      clk          => sys_clk,
      write        => write_sig,
      parallel_out => rx_data,
      read         => read_sig,
      data_out     => queue_out,
      empty        => queue_empty,
      full         => queue_full
    );

  ---------------------------------------------------------------------------
  -- 3. Controller FSM (orchestrates read & shift_en)
  ---------------------------------------------------------------------------
  ctrl : controller_fsm
    port map (
      clk        => sys_clk,
      empty      => queue_empty,
      shift_done => shift_done,
      read       => read_sig,
      shift_en   => shift_en_sig
    );

  ---------------------------------------------------------------------------
  -- 4. Decoder  (combinational lookup, registers on read)
  ---------------------------------------------------------------------------
  dec : morse_decoder
    port map (
      clk         => sys_clk,
      data_out    => queue_out,
      empty       => queue_empty,   -- ignored inside
      shift_done  => shift_done,    -- ignored inside
      read        => read_sig,
      decoded_out => decoded_pkt
    );

  ---------------------------------------------------------------------------
  -- 5. Shift register
  ---------------------------------------------------------------------------
  shft : Shift_Reg
    port map (
      clk         => sys_clk,
      shift_en    => shift_en_sig,
      decoded_out => decoded_pkt,
      output_bit  => morse_bit,
      shift_done  => shift_done
    );

  ---------------------------------------------------------------------------
  -- 6. Output assignments
  ---------------------------------------------------------------------------
  led_out   <= morse_bit;
  sound_out <= morse_bit;

end architecture Behavioral;
