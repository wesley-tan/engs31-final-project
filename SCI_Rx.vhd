-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY SCI_Rx IS
PORT ( 	clk			: 	in 	STD_LOGIC;
		Data_in		: 	in 	STD_LOGIC;
        Rx 		: 	in 	STD_LOGIC;
        Parallel_out :	out STD_LOGIC_VECTOR(7 downto 0);
        Rx_done		:	out STD_Logic);
end SCI_Rx;


ARCHITECTURE behavior of SCI_Rx is

constant BAUD_PERIOD : integer := 391; --baud counter
constant BAUD_PERIOD_HALF : integer := 195; --baud counter
constant BIT_COUNT : integer := 10; --baud counter

signal shift_Reg : std_logic_vector(9 downto 0) := (others => '0'); --data and start and stop bits 
signal Baud_Counter : unsigned(9 downto 0) := (others => '0'); --count to baud - 1
signal tc_baud : std_logic := '0';
signal tc_half_baud : std_logic := '0';
signal tc_bit: std_logic := '0';
signal clr_baud : std_logic := '0';
signal clr_bit: std_logic := '0';
signal clr_shiftreg: std_logic := '0';
signal tc_half_en: std_logic := '0';
signal tc_en: std_logic := '0';
signal bit_counter : unsigned(3 downto 0) := (others => '0'); 
signal shift_en: std_logic := '0';
signal parallel_out_sig :  std_logic_vector(7 downto 0):= (others => '0'); 

signal hold_state : std_logic_vector(2 downto 0):= "000";
type state_type is (idle, wait_half, shift, wait_full, data_ready);
signal CS, NS : state_type := idle;

BEGIN

-- FSM
StateUpdate: process(clk)
   begin
  -- change the state 
    if rising_edge(clk) then 
    	CS <= NS;
    end if;
end process StateUpdate;


NextStateLogic: process(CS, Rx, tc_bit, tc_baud, tc_half_baud)
begin 

	NS <= CS;
    case CS is 
    	when idle =>
        	if Rx = '0' then
            	NS <= wait_half; --when there are values in the queue, go to the load state 
            end if;
       	when wait_half =>
        	if tc_half_baud = '1' then 
            	NS <= shift;
            end if;
        when shift =>
         	if tc_bit = '0' then  
            	NS <= wait_full;
            else
            	NS <= data_ready;
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
        
end process NextStateLogic;  



OutputLogic: process(CS)
begin 
	shift_en <= '0';
    Rx_done <= '0';
    clr_baud <= '0';
    clr_bit <= '0';
    clr_shiftreg <= '0';
    tc_half_en <= '0';
    hold_state <= "000";
    tc_en <= '0';
    case CS is 	
    	when idle =>
        	clr_baud <= '1';
            clr_bit <= '1';
            clr_shiftreg <= '1';
            hold_state <= "000";
        when wait_half =>
        	tc_half_en <= '1';
            hold_state <= "001";
        when shift =>
            shift_en <= '1';
            tc_en <= '1';
            clr_baud <= '1';
            hold_state <= "010";
        when wait_full =>
        	hold_state <= "011";
            tc_en <= '1';
        when data_ready => 
        	Rx_done <= '1';
            hold_state <= "100";
            clr_bit <= '1';
        when others =>
        	shift_en <= '0';
            Rx_done <= '0';
            clr_baud <= '0';
            clr_bit <= '0';
            tc_half_en <= '0';
            clr_shiftreg <= '0';
       	end case;
   
end process OutputLogic;

--Datapath
datapath : process(clk)
begin
  --increment the baud counter and reset for every terminal count 
	if rising_edge(clk) then
        Baud_Counter <= Baud_Counter + 1;
        if clr_baud = '1' then
        	Baud_Counter <= (others => '0');
        end if;
    end if;

     if rising_edge(clk) then        
        if tc_baud = '1' or tc_half_baud = '1' then
        	bit_counter <= bit_counter + 1;
        end if;
        if clr_bit = '1' then --reset the bit counter again
        	bit_counter <= (others =>'0');
        end if;
        
     end if;
   	
end process datapath;


shift_register: process(clk) 
begin 
    -- when loaded, at start and stop bit 
	if rising_edge(clk) then 
    	if shift_en = '1' then 
              shift_reg <= Data_in & shift_reg(9 downto 1);
            
        end if;
        
        if clr_shiftreg = '1' then 
        	shift_reg <= (others => '0');
        end if;
    
    end if;

end process shift_register;

baud_check: process(Baud_Counter)
begin    
 -- set terminal count to high when you have met the baud period
    tc_baud <= '0';
    if tc_en = '1' then
      if Baud_Counter = BAUD_PERIOD-1 then
          tc_baud <= '1';
      end if;  
    end if;
end process baud_check;

baud_check_half: process(Baud_Counter, tc_half_en)
begin    
 -- set terminal count to high when you have met the baud period
    tc_half_baud <= '0';
    if tc_half_en = '1' then 
      if Baud_Counter = BAUD_PERIOD_HALF -1 then
          tc_half_baud <= '1';
      end if;   
    end if;
end process baud_check_half;


bit_check: process(bit_counter)
begin 

 -- set the signal that indicates all of the bits have been shifted out 
    tc_bit <= '0'; 
      if bit_counter = BIT_COUNT-1 then
          tc_bit <= '1';
      end if;

    
end process bit_check;


Parallel_out <= shift_reg(8 downto 1);
end behavior;

        
        