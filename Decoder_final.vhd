library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY Decoder IS
PORT ( 
        binary_in   :   in  STD_LOGIC_VECTOR(7 downto 0);
        decoded_out :   out STD_LOGIC_VECTOR(21 downto 0);
        data_len    :   out STD_LOGIC_VECTOR(4 downto 0)
);
end Decoder;

ARCHITECTURE behavior of Decoder IS
begin
  
  
convert: process(binary_in)
begin
  case binary_in is
    when "01100001" => 
        decoded_out <= "1011100000000000000000";
        data_len    <= "01000"; -- 5+3 = 8
    when "01100010" => 
        decoded_out <= "1110101010000000000000";
        data_len    <= "01100"; -- 9+3 = 12
    when "01100011" => 
        decoded_out <= "1110101110100000000000";
        data_len    <= "01110"; -- 11+3 = 14
    when "01100100" => 
        decoded_out <= "1110101000000000000000";
        data_len    <= "01010"; -- 7+3 = 10
    when "01100101" => 
        decoded_out <= "1000000000000000000000";
        data_len    <= "00100"; -- 1+3 = 4
    when "01100110" => 
        decoded_out <= "1010111010000000000000";
        data_len    <= "01100"; -- 9+3 = 12
    when "01100111" => 
        decoded_out <= "1110111010000000000000";
        data_len    <= "01100"; -- 9+3 = 12
    when "01101000" => 
        decoded_out <= "1010101000000000000000";
        data_len    <= "01010"; -- 7+3 = 10
    when "01101001" => 
        decoded_out <= "1010000000000000000000";
        data_len    <= "00110"; -- 3+3 = 6
    when "01101010" => 
        decoded_out <= "1011101110111000000000";
        data_len    <= "10000"; -- 13+3 = 16
    when "01101011" => 
        decoded_out <= "1110101110000000000000";
        data_len    <= "01100"; -- 9+3 = 12
    when "01101100" => 
        decoded_out <= "1011101010000000000000";
        data_len    <= "01100"; -- 9+3 = 12
    when "01101101" => 
        decoded_out <= "1110111000000000000000";
        data_len    <= "01010"; -- 7+3 = 10
    when "01101110" => 
        decoded_out <= "1110100000000000000000";
        data_len    <= "01000"; -- 5+3 = 8
    when "01101111" => 
        decoded_out <= "1110111011100000000000";
        data_len    <= "01110"; -- 11+3 = 14
    when "01110000" => 
        decoded_out <= "1011101110100000000000";
        data_len    <= "01110"; -- 11+3 = 14
    when "01110001" => 
        decoded_out <= "1110111010111000000000";
        data_len    <= "10000"; -- 13+3 = 16
    when "01110010" => 
        decoded_out <= "1011101000000000000000";
        data_len    <= "01010"; -- 7+3 = 10
    when "01110011" => 
        decoded_out <= "1010100000000000000000";
        data_len    <= "01000"; -- 5+3 = 8
    when "01110100" => 
        decoded_out <= "1110000000000000000000";
        data_len    <= "00110"; -- 3+3 = 6
    when "01110101" => 
        decoded_out <= "1010111000000000000000";
        data_len    <= "01010"; -- 7+3 = 10
    when "01110110" => 
        decoded_out <= "1010101110000000000000";
        data_len    <= "01100"; -- 9+3 = 12
    when "01110111" => 
        decoded_out <= "1011101110000000000000";
        data_len    <= "01100"; -- 9+3 = 12
    when "01111000" => 
        decoded_out <= "1110101011100000000000";
        data_len    <= "01110"; -- 11+3 = 14
    when "01111001" => 
        decoded_out <= "1110101110111000000000";
        data_len    <= "10000"; -- 13+3 = 16
    when "01111010" => 
        decoded_out <= "1110111010100000000000";
        data_len    <= "01110"; -- 11+3 = 14
    when "00110000" => 
        decoded_out <= "1110111011101110111000";
        data_len    <= "10110"; -- 19+3 = 22
    when "00110001" => 
        decoded_out <= "1011101110111011100000";
        data_len    <= "10100"; -- 17+3 = 20
    when "00110010" => 
        decoded_out <= "1010111011101110000000";
        data_len    <= "10010"; -- 15+3 = 18
    when "00110011" => 
        decoded_out <= "1010101110111000000000";
        data_len    <= "10000"; -- 13+3 = 16
    when "00110100" => 
        decoded_out <= "1010101011100000000000";
        data_len    <= "01110"; -- 11+3 = 14
    when "00110101" => 
        decoded_out <= "1010101010000000000000";
        data_len    <= "01100"; -- 9+3 = 12
    when "00110110" => 
        decoded_out <= "1110101010100000000000";
        data_len    <= "01110"; -- 11+3 = 14
    when "00110111" => 
        decoded_out <= "1110111010101000000000";
        data_len    <= "10000"; -- 13+3 = 16
    when "00111000" => 
        decoded_out <= "1110111011101010000000";
        data_len    <= "10010"; -- 15+3 = 18
    when "00111001" => 
        decoded_out <= "1110111011101110100000";
        data_len    <= "10100"; -- 17+3 = 20
    when "00100000" => 
        decoded_out <= "0000000000000000000000";
        data_len    <= "00111"; -- 4+3 = 7
    when others =>
        decoded_out <= (others => '0');
        data_len    <= (others => '0');
  end case;
end process;
end behavior;
