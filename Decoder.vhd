library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decoder is
    Port (
        ascii_in   : in  std_logic_vector(7 downto 0);
        decode_sig : in std_logic;
        decoded_out : out std_logic_vector(31 downto 0)  -- Adjust width as needed
    );
end decoder;

architecture Behavioral of decoder is
begin
    process(ascii_in)
    begin
        if decode_sig  = '1' then
        case ascii_in is
            when "01100001" => decoded_out <= "10111"; -- a
            when "01100010" => decoded_out <= "111010101";   -- b
            when "01100011" => decoded_out <= "11101011101";         -- c
            when "01100100" => decoded_out <= "1110101";        -- d
            when "01100101" => decoded_out <= "1";        -- e
            when x"66" => decoded_out <= "000000000000101011101";           -- f
            when x"67" => decoded_out <= "000000000000111011101";           -- g
            when x"68" => decoded_out <= "0000000000001010101";             -- h
            when x"69" => decoded_out <= "000000000000000000000101";        -- i
            when x"6A" => decoded_out <= "1011101110111";                   -- j
            when x"6B" => decoded_out <= "000000000000111010111";           -- k
            when x"6C" => decoded_out <= "000000000000101110101";           -- l
            when x"6D" => decoded_out <= "0000000000001110111";             -- m
            when x"6E" => decoded_out <= "0000000000000011101";             -- n
            when x"6F" => decoded_out <= "11101110111";                     -- o
            when x"70" => decoded_out <= "10111011101";                     -- p
            when x"71" => decoded_out <= "1110111010111";                   -- q
            when x"72" => decoded_out <= "1011101";                         -- r
            when x"73" => decoded_out <= "0000000000000010101";             -- s
            when x"74" => decoded_out <= "00000000000000000111";            -- t
            when x"75" => decoded_out <= "0000000000001010111";             -- u
            when x"76" => decoded_out <= "101010111";                       -- v
            when x"77" => decoded_out <= "101110111";                       -- w
            when x"78" => decoded_out <= "11101010111";                     -- x
            when x"79" => decoded_out <= "1110101110111";                   -- y
            when x"7A" => decoded_out <= "11101110101";                     -- z
            when x"30" => decoded_out <= "1110111011101110111";             -- 0
            when x"31" => decoded_out <= "10111011101110111";               -- 1
            when x"32" => decoded_out <= "101011101110111";                 -- 2
            when x"33" => decoded_out <= "1010101110111";                   -- 3
            when x"34" => decoded_out <= "10101010111";                     -- 4
            when x"35" => decoded_out <= "101010101";                       -- 5
            when x"36" => decoded_out <= "11101010101";                     -- 6
            when x"37" => decoded_out <= "1110111010101";                   -- 7
            when x"38" => decoded_out <= "111011101110101";                 -- 8
            when x"39" => decoded_out <= "11101110111011101";               -- 9
            when x"20" => decoded_out <= "0000";                            -- space
            when others => decoded_out <= (others => '0');                  -- default
        end case;
    end if;
        
    end process;
end Behavioral;
