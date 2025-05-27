library IEEE;
use IEEE.std_logic_1164.all;

entity Final_project_controller is
  port (
    clk          : in  std_logic;
    Rx_en        : in  std_logic;   -- External trigger to start RX
    valid        : in  std_logic;   -- Asserted when ASCII character is valid
    Process_done : in  std_logic;   -- Decoder completed and shift_reg is loaded
    Shift_done   : in  std_logic;   -- Done shifting entire Morse sequence
    Receiver_en  : out std_logic;   -- Enables UART receiver
    Error        : out std_logic    -- Optional error signal
  );
end entity Final_project_controller;

architecture Behavioral of Final_project_controller is

  -- FSM states
  type state_t is (sIdle, sAccept, sDecode, sShift, sError);
  signal state, next_state : state_t;

begin

  -----------------------------------------------
  -- 1. State Register (synchronous reset not needed here)
  -----------------------------------------------
  state_reg : process(clk)
  begin
    if rising_edge(clk) then
      state <= next_state;
    end if;
  end process;

  -----------------------------------------------
  -- 2. Next-State and Output Logic
  -----------------------------------------------
  control_proc : process(state, Rx_en, valid, Process_done, Shift_done)
  begin
    -- Default outputs
    Receiver_en <= '0';
    Error       <= '0';
    next_state  <= state;

    case state is

      when sIdle =>
        if Rx_en = '1' then
          next_state <= sAccept;
        end if;

      when sAccept =>
        Receiver_en <= '1';  -- Enable UART receiver
        if valid = '1' then
          next_state <= sDecode;
        end if;

      when sDecode =>
        if Process_done = '1' then
          next_state <= sShift;
        end if;

      when sShift =>
        if Shift_done = '1' then
          next_state <= sIdle;
        end if;

      when sError =>
        Error <= '1';
        next_state <= sIdle;

      when others =>
        next_state <= sError;

    end case;
  end process;

end Behavioral;
