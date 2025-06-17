library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity SevenSegDisplay is
    Port ( 
        clk:in std_logic;
        digit0: in std_logic_vector(3 downto 0);
        digit1: in std_logic_vector(3 downto 0);
        digit2: in std_logic_vector(3 downto 0);
        digit3: in std_logic_vector(3 downto 0);
        anodes: out std_logic_vector(3 downto 0);
        cathodes: out std_logic_vector(6 downto 0)
    );
end SevenSegDisplay;

architecture Behavioral of SevenSegDisplay is

signal cnt : std_logic_vector(15 downto 0) := (others => '0');
signal digit_to_display : std_logic_vector(3 downto 0):= (others => '0');
begin

cnt<= std_logic_vector(unsigned(cnt) + 1) when clk'event and clk='1';

with cnt(15 downto 14) select digit_to_display<= digit0 when "00",
                                                 digit1 when "01",
                                                 digit2 when "10",
                                                 digit3 when others;
                                                 
with cnt(15 downto 14) select anodes<= "1110" when "00",
                                       "1101" when "01",
                                       "1011" when "10",
                                       "0111" when others; 
                                       
with digit_to_display select cathodes<= "1111001" when "0001",   --1
                                        "0100100" when "0010",   --2
                                        "0110000" when "0011",   --3
                                        "0011001" when "0100",   --4
                                        "0010010" when "0101",   --5
                                        "0000010" when "0110",   --6
                                        "1111000" when "0111",   --7
                                        "0000000" when "1000",   --8
                                        "0010000" when "1001",   --9
                                        "0001000" when "1010",   --A
                                        "0000011" when "1011",   --b
                                        "1000110" when "1100",   --C
                                        "0100001" when "1101",   --d
                                        "0000110" when "1110",   --E
                                        "0001110" when "1111",   --F
                                        "1000000" when others;   --0                                                                                     
end Behavioral;
