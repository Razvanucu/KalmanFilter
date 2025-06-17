library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_UART_TX is
--  Port ( );
end tb_UART_TX;

architecture Behavioral of tb_UART_TX is

component UART_TX is
 Port (
    clk:in std_logic;
    reset:in std_logic;
    tx_start:in std_logic;
    tx_data_in:in std_logic_vector(7 downto 0);
    tx_data_out:out std_logic
  );
end component UART_TX;

signal clk,reset,tx_start,tx_data_out : std_logic:='0';
signal tx_data_in : std_logic_vector(7 downto 0) := (others =>'0');

begin

clk <= not clk after 2ns;

tx: UART_TX port map(
 clk => clk,
 reset => reset,
 tx_start => tx_start,
 tx_data_in => tx_data_in,
 tx_data_out => tx_data_out
);

tx_data_in<= x"3B";

process
begin

reset <='1';
wait for 20ns;
reset <='0';

wait for 20ns;

tx_start <='1';

wait;
end process;

end Behavioral;
