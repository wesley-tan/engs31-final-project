library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_morse is
  port (
    clk         : in  std_logic;  -- 100 MHz clock
    Rx          : in  std_logic;  -- UART Rx input from host
    led_out     : out std_logic -- output, later add in sound_out
  );
end top_morse;

architecture Behavioral_architecture of top_morse is

-- ALL COMPONENTS HERE
component SCI_Rx is
  port (
    clk          : in  std_logic;
    Rx           : in  std_logic;
    Receive_en   : in  std_logic;
    Parallel_out : out std_logic_vector(7 downto 0);
    Rx_done      : out std_logic;
    Valid        : out std_logic
  );
 end component;
 
component morse_decoder is
  port (
    ascii_in  : in  std_logic_vector(7 downto 0);
    morse_out : out std_logic_vector(21 downto 0);  -- 22-bit right-aligned stream
    morse_len : out std_logic_vector(4 downto 0)    -- number-of-bits (0-31)
  );
end component;

component Final_project_controller is
  port (
    clk          : in  std_logic;
    Rx_en        : in  std_logic;   -- External trigger to start RX
    valid        : in  std_logic;   -- Asserted when ASCII character is valid
    Process_done : in  std_logic;   -- Decoder completed and shift_reg is loaded
    Shift_done   : in  std_logic;   -- Done shifting entire Morse sequence
    Receiver_en  : out std_logic;   -- Enables UART receiver
    Error        : out std_logic    -- Optional error signal
  );
end component;

component  clock_divider is
  generic (
    DIVISOR : integer := 100
  );
  port (
    clk       : in  std_logic;
    reset     : in  std_logic;
    tick_T    : out std_logic
  );
end component;

component Shift_Reg IS
PORT ( 	clk			: 	in 	STD_LOGIC;
      	Process_done        :   in  STD_LOGIC;
        Data_in		: 	in 	STD_LOGIC_VECTOR(21 downto 0);
        Data_len 	:	in 	STD_LOGIC_VECTOR(4 downto 0);
        Output_bit :	out STD_LOGIC;
        shift_done : out STD_LOGIC);
end component ;

  -- Internal signals
  signal ascii_char    : std_logic_vector(7 downto 0);
  signal rx_done       : std_logic;
  signal valid         : std_logic;

  signal morse_bits    : std_logic_vector(21 downto 0);
  signal morse_len     : std_logic_vector(4 downto 0);


  signal shift_done    : std_logic;
  signal process_done  : std_logic;

  signal tick_T        : std_logic;
  signal receiver_en   : std_logic;
  signal err_flag      : std_logic;

begin

  --------------------------------------------------------------------
  -- 1. UART Receiver
  --------------------------------------------------------------------
  uart_rx_inst : SCI_Rx
    port map (
      clk          => clk,
      Rx           => Rx,
      Receive_en   => receiver_en,
      Parallel_out => ascii_char,
      Rx_done      => rx_done,
      Valid        => valid
    );

  --------------------------------------------------------------------
  -- 2. Morse Decoder
  --------------------------------------------------------------------
  morse_decoder_inst : morse_decoder
    port map (
      ascii_in   => ascii_char,
      morse_out  => morse_bits,
      morse_len  => morse_len
    );

  --------------------------------------------------------------------
  -- 3. Shift Register
  --------------------------------------------------------------------
  shift_reg_inst : Shift_Reg
    port map (
      clk          => clk,
      Process_done => process_done,
      Data_in      => morse_bits,
      Data_len     => morse_len,
      Output_bit   => led_out,
      shift_done   => shift_done
    );

  --------------------------------------------------------------------
  -- 4. Controller FSM
  --------------------------------------------------------------------
  controller_inst : Final_project_controller
    port map (
      clk          => clk,
      Rx_en        => rx_done,
      valid        => valid,
      Process_done => process_done,
      Shift_done   => shift_done,
      Receiver_en  => receiver_en,
      Error        => err_flag
    );

  --------------------------------------------------------------------
  -- 5. Clock Divider (T = 100 ms)
  --------------------------------------------------------------------
  clk_div_inst : clock_divider
    generic map (
      DIVISOR => 100
    )
    port map (
      clk    => clk,
      reset  => shift_done,
      tick_T => tick_T
    );


end architecture;
