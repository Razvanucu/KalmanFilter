library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity tb_baud_rate_generator is
--  Port ( );
end tb_baud_rate_generator;

architecture Behavioral of tb_baud_rate_generator is

component UART_Baud_Rate_Generator is
    Generic ( baud_rate: unsigned(15 downto 0):=x"28B0");
    Port (
        reset : in std_logic;
        clk: in std_logic;
        baud_clk:out std_logic
     );
end component UART_Baud_Rate_Generator;

signal reset:std_logic:='0';
signal clk:std_logic:='0';
signal baud_clk:std_logic:='0';
signal cnt: unsigned(15 downto 0):=(others =>'0');

begin

clk <= not clk after 5ns;

reset <='0','1' after 8000ns;
cnt <= cnt + 1 when clk'event and clk='1';

baudrate:UART_Baud_Rate_Generator generic map(x"0036") port map(
reset => reset,
clk => clk,
baud_clk => baud_clk
);

end Behavioral;
