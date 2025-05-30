

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY morse_decoder IS
    port (
      clk          : in  std_logic;
      data_out     : in  std_logic_vector(7 downto 0);
      empty        : in  std_logic;
      shift_done   : in std_logic;
      read         : out std_logic;
      decoded_out  : out std_logic_vector(26 downto 0);  -- {22-bit data, 5-bit len}
      shift_en     : out std_logic
    );
end morse_decoder;


ARCHITECTURE behavior of morse_decoder IS

 type state_type is (idle,allow_read,allow_decode, allow_shift);
 signal CS, NS : state_type := idle;
 
 signal decode_bin : std_logic;
 signal read_sig : std_logic;
begin
  StateUpdate: process(clk)
  begin
    if rising_edge(clk) then
      CS <= NS;
    end if;
  end process StateUpdate;  
  
  
  
  NextStateLogic: process(CS, empty, shift_done)
  begin
    NS <= CS;
    read_sig <= '0';
    decode_bin <= '0';
    shift_en <= '0';
    case CS is
        when idle =>
            if empty = '0' and shift_done = '1' then
                NS <= allow_read;
            end if;
        when allow_read => 
            read_sig <= '1';
            NS <= allow_decode;
        when allow_decode =>
            decode_bin <= '1';
            NS <= allow_shift;
        when allow_shift => 
            shift_en <= '1';
            NS <= idle;
        when others =>
            Ns <= idle;
    end case;
  end process NextStateLogic;
  
convert: process(decode_bin)
begin

    if decode_bin = '1' then 
      case data_out is
        when "01100001" => 
            decoded_out <= "101110000000000000000001000";
        when "01100010" => 
            decoded_out <= "111010101000000000000001100";
        when "01100011" => 
            decoded_out <= "111010111010000000000001110";
        when "01100100" => 
            decoded_out <= "111010100000000000000001010";
        when "01100101" => 
            decoded_out <= "100000000000000000000000100";
        when "01100110" => 
            decoded_out <= "101011101000000000000001100";
        when "01100111" => 
            decoded_out <= "111011101000000000000001100";
        when "01101000" => 
            decoded_out <= "101010100000000000000001010";
        when "01101001" => 
            decoded_out <= "101000000000000000000000110";
        when "01101010" => 
            decoded_out <= "101110111011100000000010000";
        when "01101011" => 
            decoded_out <= "111010111000000000000001100";
        when "01101100" => 
            decoded_out <= "101110101000000000000001100";
        when "01101101" => 
            decoded_out <= "111011100000000000000001010";
        when "01101110" => 
            decoded_out <= "111010000000000000000001000";
        when "01101111" => 
            decoded_out <= "111011101110000000000001110";
        when "01110000" => 
            decoded_out <= "101110111010000000000001110";
        when "01110001" => 
            decoded_out <= "111011101011100000000010000";
        when "01110010" => 
            decoded_out <= "101110100000000000000001010";
        when "01110011" => 
            decoded_out <= "101010000000000000000001000";
        when "01110100" => 
            decoded_out <= "111000000000000000000000110";
        when "01110101" => 
            decoded_out <= "101011100000000000000001010";
        when "01110110" => 
            decoded_out <= "101010111000000000000001100";
        when "01110111" => 
            decoded_out <= "101110111000000000000001100";
        when "01111000" => 
            decoded_out <= "111010101110000000000001110";
        when "01111001" => 
            decoded_out <= "111010111011100000000010000";
        when "01111010" => 
            decoded_out <= "111011101010000000000001110";
        when "00110000" => 
            decoded_out <= "111011101110111011100010110";
        when "00110001" => 
            decoded_out <= "101110111011101110000010100";
        when "00110010" => 
            decoded_out <= "101011101110111000000010010";
        when "00110011" => 
            decoded_out <= "101010111011100000000010000";
        when "00110100" => 
            decoded_out <= "101010101110000000000001110";
        when "00110101" => 
            decoded_out <= "101010101000000000000001100";
        when "00110110" => 
            decoded_out <= "111010101010000000000001110";
        when "00110111" => 
            decoded_out <= "111011101010100000000010000";
        when "00111000" => 
            decoded_out <= "111011101110101000000010010";
        when "00111001" => 
            decoded_out <= "111011101110111010000010100";
        when "00100000" => 
            decoded_out <= "000000000000000000000000111";
        when others =>
            decoded_out <= (others => '0');
      end case;
    end if;

end process;

read <= read_sig;
end behavior;
 

