

-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY Shift_Reg IS
    PORT (
      clk         : in  STD_LOGIC;
      shift_en    : in STD_LOGIC;
      decoded_out : in  STD_LOGIC_VECTOR(26 downto 0);
      output_bit  : out STD_LOGIC;
      shift_done  : out STD_LOGIC
    );
end Shift_Reg;


ARCHITECTURE behavior of Shift_Reg is

signal shift_reg : std_logic_vector(21 downto 0) := (others => '0');
signal counter : unsigned(4 downto 0) := "00000";
signal shift_done_sig : std_logic := '1';
signal LENGTH : unsigned(4 downto 0);

constant TIME_LENGTH : INTEGER := 1000000;


signal transmit : STD_LOGIC;

signal transmit_counter : unsigned(19 downto 0)  := (others => '0');

signal clr_transmit_count: std_logic := '0';
BEGIN

shift_register: process(clk) 
begin 
	if rising_edge(clk) then 
	    clr_transmit_count <= '0';
    	if shift_en = '1' then 
            shift_reg <= decoded_out(26 downto 5);
            counter <= (others => '0');
        else 
          if shift_done_sig = '1' then
            counter <= (others => '0');
            shift_reg <= (others => '0');
          else 
            if transmit = '1' then 
                clr_transmit_count <= '1';
                shift_reg <= shift_reg(20 downto 0) & '0';
                counter <= counter + 1;
            end if;
          end if;
         end if;
    end if;

end process shift_register;



comparison: process(counter, LENGTH)
begin

  shift_done_sig <= '0';
  if counter = LENGTH then
    shift_done_sig <= '1';
  end if;

end process comparison;


count_transmit : process(clk, transmit_counter)
begin

    if rising_edge(clk) then 
        if clr_transmit_count = '1' then 
            transmit_counter <= (others => '0');
        else
            transmit_counter <= transmit_counter + 1;
        end if;
    end if;
    
    transmit <= '0';
    if to_integer(transmit_counter) = TIME_LENGTH - 1 then 
        transmit <= '1';
    end if;
end process count_transmit;

LENGTH <=unsigned(decoded_out(4 downto 0));
Output_bit <= shift_reg(21);

shift_done <= shift_done_sig;

end behavior;
