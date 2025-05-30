library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controller_fsm is
  port (
    clk        : in  std_logic;
    empty      : in  std_logic; -- from queue
    shift_done : in  std_logic; -- from shift reg
    read       : out std_logic; -- from decoder
    shift_en   : out std_logic
  );
end entity;

architecture behavior of controller_fsm is
  type state is (IDLE, POP, LOAD, SHIFT);
  signal cs, ns : state := IDLE;
  
begin

  process(clk)
  begin
    if rising_edge(clk) then
        cs <= ns;
    end if;
  end process;
  
  
  process(cs,empty,shift_done)
  begin
       shift_en <= '0';
       read <= '0';
       ns <= cs;
   
      case cs is
        when IDLE  => 
            if empty='0' then 
                ns <= POP; 
            end if;
        when POP   => 
            read <= '1';
            ns <= LOAD;
        when LOAD  => 
            shift_en <= '1';
            ns <= SHIFT;
        when SHIFT => 
            if shift_done='1' then 
                ns <= IDLE; 
            end if;
      end case;

  end process;

end behavior;
