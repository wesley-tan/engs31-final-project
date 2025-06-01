library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--============================================================
--  Top-level entity
--============================================================
entity Top_Morse is
 Generic(
        CLK_DIVIDER_RATIO : integer := 100);
  port (
    clk        : in  std_logic;  -- 100MHz master clock
    rx    : in  std_logic;  -- RS-232 RX after level shift
    led_out : out std_logic;  -- Dot/dash LED (same as output_bit)
    sound_out : out std_logic;   -- Audio gate (mirrors morse_led)
    amp_gain        : out std_logic;     -- JA2 → '1'
    amp_shutdown_l  : out std_logic      -- JA4 → '1'
  );
end entity Top_Morse;

--============================================================
--  Architecture
--============================================================
architecture Behavioral of Top_Morse is

  ------------------------------------------------------------------
  --  Component declarations (EXACT names & ports)
  ------------------------------------------------------------------
  component SCI_Rx is
    port (
      clk          : in  std_logic;
      rx           : in  std_logic;
      parallel_out : out std_logic_vector(7 downto 0);
      rx_done      : out std_logic;
      write        : out std_logic;
      enter        : out std_logic;
      valid        : out std_logic
    );
  end component;

  component Queue                                                       -- U_FIFO
    port (
      clk       : in  std_logic;
      write     : in  std_logic;
      parallel_out   : in  std_logic_vector(7 downto 0);
      read      : in  std_logic;
      data_out  : out std_logic_vector(7 downto 0);
      empty     : out std_logic;
      full      : out std_logic
    );
  end component;

  component morse_decoder
   port (
    clk          : in  std_logic;
    data_out     : in  std_logic_vector(7 downto 0);                    
    read         : in  std_logic;                      -- from controller
    decoded_out  : out std_logic_vector(26 downto 0) 
  );
  end component;

  component Shift_Reg                                                   -- U_SHFT
    port (
      clk         : in  std_logic;
      shift_en    : in std_logic;
      decoded_out : in  std_logic_vector(26 downto 0);
      output_bit  : out std_logic;
      shift_done  : out std_logic
    );
  end component;
  
 component controller_fsm is
    port (
      clk        : in  std_logic;
      empty      : in  std_logic;
      shift_done : in  std_logic;
      enter      : in std_logic;
      read       : out std_logic;
      shift_en   : out std_logic
  );
  
  end component;

  component system_clock_generation
    port (
      input_clk_port      : in  std_logic;
      system_clk_port  : out std_logic
    );
  end component;

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.



  ------------------------------------------------------------------
  --  Internal signals
  ------------------------------------------------------------------
  signal sys_clk          : std_logic;
   
  signal rx_data      : std_logic_vector(7 downto 0);
  signal rx_done      : std_logic;
  signal valid        : std_logic;

  signal queue_out    : std_logic_vector(7 downto 0);
  signal empty   : std_logic;
  signal full    : std_logic;
  signal read_en   : std_logic;
  
  signal write_sig     : std_logic;

  signal decoded_out  : std_logic_vector(26 downto 0);
  signal shift_en   : std_logic;
  signal shift_done   : std_logic;
  
  signal enter_sig    : std_logic;
 
  signal output_bit : std_logic;
  

  -- -------------- TONE-GENERATION SIGNALS ------------------------
  -- A 440 Hz square wave generator, gated by output_bit
  signal tone_clk      : std_logic := '0';
  signal tone_counter  : unsigned(17 downto 0) := (others => '0');
  -- TONE_N ≈ 100 MHz / (2 × 440 Hz) = 113636
  constant TONE_N      : unsigned(17 downto 0) := to_unsigned(227272, 18);
  
begin
  ------------------------------------------------------------------
  -- 0. Clock
  ------------------------------------------------------------------
  clock_divider_inst : system_clock_generation
    port map (
      input_clk_port  => clk,
      system_clk_port => sys_clk
    );

  ------------------------------------------------------------------
  -- 1. UART receiver
  ------------------------------------------------------------------
  SCI_Rx_inst : SCI_Rx
    port map (
      clk          => sys_clk,
      rx           => rx,
      parallel_out => rx_data,
      rx_done      => rx_done,
      write        => write_sig,
      enter        => enter_sig,
      valid        => valid
    );

  ------------------------------------------------------------------
  -- 2. FIFO queue
  ------------------------------------------------------------------
  queue_inst : Queue
    port map (
      clk          => sys_clk,
      write        => write_sig,
      parallel_out => rx_data,
      read         => read_en,
      data_out     => queue_out,
      empty        => empty,
      full         => full
    );

  ------------------------------------------------------------------
  -- 3. Decoder FSM
  ------------------------------------------------------------------
  decoder_inst : morse_decoder
    port map (
      clk         => sys_clk,
      data_out    => queue_out,
      read        => read_en,
      decoded_out => decoded_out
    );

  ------------------------------------------------------------------
  -- 4. Shift register
  ------------------------------------------------------------------
  shift_reg_inst : Shift_Reg
    port map (
      clk         => sys_clk,
      shift_en    => shift_en,
      decoded_out => decoded_out,
      output_bit  => output_bit,
      shift_done  => shift_done
    );
  
  amp_gain       <= '1';
  amp_shutdown_l <= '1';
  
  ctrl : controller_fsm
    port map (
      clk        => sys_clk,
      empty      => empty,
      shift_done => shift_done,
      enter      => enter_sig,
      read       => read_en,
      shift_en   => shift_en
    );

  ------------------------------------------------------------------
  --  5. Tone generator: divide sys_clk ? 440?Hz on tone_clk
  ------------------------------------------------------------------
  tone_divider : process(clk)
  begin
    if rising_edge(clk) then
      if tone_counter = TONE_N then
        tone_counter <= (others => '0');
        tone_clk     <= not tone_clk;
      else
        tone_counter <= tone_counter + 1;
      end if;
    end if;
  end process tone_divider;

  ------------------------------------------------------------------
  --  6. LED & audio outputs
  ------------------------------------------------------------------
  led_out   <= output_bit;
  -- When output_bit='1', pass through the 440Hz square wave; else drive low
  sound_out <= tone_clk when output_bit = '1' else '0';

end architecture;
