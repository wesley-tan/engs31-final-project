

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


BEGIN

shift_register: process(clk) 
begin 
	if rising_edge(clk) then 
    	if shift_en = '1' then 
            shift_reg <= decoded_out(26 downto 5);
        else 
          if shift_done_sig = '1' then
            counter <= (others => '0');
            shift_reg <= (others => '0');
          else 
            shift_reg <= shift_reg(20 downto 0) & '0';
            counter <= counter + 1;
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

LENGTH <=unsigned(decoded_out(4 downto 0));
Output_bit <= shift_reg(21);

shift_done <= shift_done_sig;

end behavior;
