library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_UART_TX_data_index is
--  Port ( );
end tb_UART_TX_data_index;

architecture Behavioral of tb_UART_TX_data_index is

component UART_TX_data_index is
    Port (
        baud_clk : in std_logic;
        reset : in std_logic;
        data_index_reset : in std_logic;
        data_index : out std_logic_vector(2 downto 0)
     );
end component UART_TX_data_index;

signal baud_clk,reset,data_index_reset: std_logic := '0';
signal data_index:std_logic_vector(2 downto 0);

begin

baud_clk <= not baud_clk after 2ns;

dataind:UART_TX_data_index port map
(
 baud_clk => baud_clk,
 reset => reset,
 data_index_reset => data_index_reset,
 data_index => data_index
);

process
begin

reset <= '1';
wait for 20ns;
reset <= '0';

wait for 10ns;
data_index_reset <='1';
wait for 20ns;
data_index_reset <='0';

wait;
end process;
end Behavioral;
