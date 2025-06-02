

library IEEE;
use IEEE.std_logic_1164.all;

entity morse_decoder is
  port (
    clk          : in  std_logic;
    data_out     : in  std_logic_vector(7 downto 0);                    
    read         : in  std_logic;                      -- from controller
    decoded_out  : out std_logic_vector(26 downto 0) 
    -- shift_en     : out std_logic                       -- no longer generated here
  );
end entity morse_decoder;

architecture behavior of morse_decoder is
begin

  process(clk)
  begin
    if rising_edge(clk) then
      if read = '1' then             
 case data_out is
           --UPPER CASE 
         when "01100001" | "01000001" => -- a
            decoded_out <= "101110000000000000000001000";
        when "01100010" | "01000010" => 
            decoded_out <= "111010101000000000000001100";
        when "01100011" | "01000011" => 
            decoded_out <= "111010111010000000000001110";
        when "01100100" | "01000100" => -- d
            decoded_out <= "111010100000000000000001010";
        when "01100101" | "01000101" => 
            decoded_out <= "100000000000000000000000100";
        when "01100110" | "01000110" => 
            decoded_out <= "101011101000000000000001100";
        when "01100111" | "01000111" => 
            decoded_out <= "111011101000000000000001100";
        when "01101000" | "01001000" => 
            decoded_out <= "101010100000000000000001010";
        when "01101001" | "01001001" => 
            decoded_out <= "101000000000000000000000110";
        when "01101010" | "01001010" => 
            decoded_out <= "101110111011100000000010000";
        when "01101011" | "01001011" => 
            decoded_out <= "111010111000000000000001100";
        when "01101100" | "01001100" => 
            decoded_out <= "101110101000000000000001100";
        when "01101101" | "01001101" => 
            decoded_out <= "111011100000000000000001010";
        when "01101110" | "01001110" => 
            decoded_out <= "111010000000000000000001000";
        when "01101111" |"01001111" => -- o
            decoded_out <= "111011101110000000000001110";
        when "01110000" | "01010000" => 
            decoded_out <= "101110111010000000000001110";
        when "01110001" | "01010001" => 
            decoded_out <= "111011101011100000000010000";
        when "01110010" | "01010010" => 
            decoded_out <= "101110100000000000000001010";
        when "01110011" | "01010011" => 
            decoded_out <= "101010000000000000000001000";
        when "01110100" | "01010100" => 
            decoded_out <= "111000000000000000000000110";
        when "01110101" | "01010101" => 
            decoded_out <= "101011100000000000000001010";
        when "01110110" | "01010110" => 
            decoded_out <= "101010111000000000000001100";
        when "01110111" | "01010111" => 
            decoded_out <= "101110111000000000000001100";
        when "01111000" | "01011000" => 
            decoded_out <= "111010101110000000000001110";
        when "01111001" | "01011001" => 
            decoded_out <= "111010111011100000000010000";
        when "01111010" | "01011010" => -- z
            decoded_out <= "111011101010000000000001110";
        when "00110000" => -- 0
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
        when "00111001" => -- 9
            decoded_out <= "111011101110111010000010100";
        when "00100000" => -- space
            decoded_out <= "000000000000000000000000100";
        when others =>
            decoded_out <= (others => '0');
        end case;
      end if;
    end if;
  end process;

end behavior;
