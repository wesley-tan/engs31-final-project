

library IEEE;
use IEEE.std_logic_1164.all;

entity morse_decoder is
  port (
    clk          : in  std_logic;
    data_out     : in  std_logic_vector(7 downto 0);                    
    read         : in  std_logic;                      -- from controller
    decoded_out  : out std_logic_vector(23 downto 0) 
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

        when "01100001" =>  -- a
            decoded_out <= "101110000000000000000101";
        when "01100010" =>  -- b
            decoded_out <= "111010101000000000001001";
        when "01100011" =>  -- c
            decoded_out <= "111010111010000000001011";
        when "01100100" =>  -- d
            decoded_out <= "111010100000000000000111";
        when "01100101" =>  -- e
            decoded_out <= "100000000000000000000001";
        when "01100110" =>  -- f
            decoded_out <= "101011101000000000001001";
        when "01100111" =>  -- g
            decoded_out <= "111011101000000000001001";
        when "01101000" =>  -- h
            decoded_out <= "101010100000000000000111";
        when "01101001" =>  -- i
            decoded_out <= "101000000000000000000011";
        when "01101010" =>  -- j
            decoded_out <= "101110111011100000001101";
        when "01101011" =>  -- k
            decoded_out <= "111010111000000000001001";
        when "01101100" =>  -- l
            decoded_out <= "101110101000000000001001";
        when "01101101" =>  -- m
            decoded_out <= "111011100000000000000111";
        when "01101110" =>  -- n
            decoded_out <= "111010000000000000000101";
        when "01101111" =>  -- o
            decoded_out <= "111011101110000000001011";
        when "01110000" =>  -- p
            decoded_out <= "101110111010000000001011";
        when "01110001" =>  -- q
            decoded_out <= "111011101011100000001101";
        when "01110010" =>  -- r
            decoded_out <= "101110100000000000000111";
        when "01110011" =>  -- s
            decoded_out <= "101010000000000000000101";
        when "01110100" =>  -- t
            decoded_out <= "111000000000000000000011";
        when "01110101" =>  -- u
            decoded_out <= "101011100000000000000111";
        when "01110110" =>  -- v
            decoded_out <= "101010111000000000001001";
        when "01110111" =>  -- w
            decoded_out <= "101110111000000000001001";
        when "01111000" =>  -- x
            decoded_out <= "111010101110000000001011";
        when "01111001" =>  -- y
            decoded_out <= "111010111011100000001101";
        when "01111010" =>  -- z
            decoded_out <= "111011101010000000001011";

    
        when "00110000" =>  -- '0'
            decoded_out <= "111011101110111011110011";
        when "00110001" =>  -- '1'
            decoded_out <= "101110111011101110010001";
        when "00110010" =>  -- '2'
            decoded_out <= "101011101110111000001111";
        when "00110011" =>  -- '3'
            decoded_out <= "101010111011100000001101";
        when "00110100" =>  -- '4'
            decoded_out <= "101010101110000000001011";
        when "00110101" =>  -- '5'
            decoded_out <= "101010101000000000001001";
        when "00110110" =>  -- '6'
            decoded_out <= "111010101010000000001011";
        when "00110111" =>  -- '7'
            decoded_out <= "111011101010100000001101";
        when "00111000" =>  -- '8'
            decoded_out <= "111011101110101000001111";
        when "00111001" =>  -- '9'
            decoded_out <= "111011101110111010010001";

        when "00100000" =>  -- space character
            decoded_out <= "000000000000000000000001"; -- THIS IS TO ENSURE THAT SPACE WORKS FOR 7T

        when others =>
            decoded_out <= (others => '0');
        end case;
      end if;
    end if;
  end process;

end behavior;
