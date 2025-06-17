library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity UART_Baud_Rate_Generator is
    Generic ( baud_rate: unsigned(15 downto 0):=x"28B0");
    Port (
        reset : in std_logic;
        clk: in std_logic;
        baud_clk:out std_logic
     );
end UART_Baud_Rate_Generator;

architecture Behavioral of UART_Baud_Rate_Generator is

signal cnt:unsigned(15 downto 0):= (others => '0');
signal baud_clk_sig:std_logic := '0';
begin

process(clk)
begin
    if reset = '1' then
        cnt<=(others => '0');
        baud_clk_sig<='0';
    elsif rising_edge(clk) then
        if cnt = baud_rate - 1 then
           cnt<=(others => '0');
           baud_clk_sig<='1';
        else
           cnt<=cnt + 1;
           baud_clk_sig<='0';
        end if;
     end if;   
end process;

baud_clk <= baud_clk_sig;
end Behavioral;
