library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity tb_UART_TX_FSM is
--  Port ( );
end tb_UART_TX_FSM;

architecture Behavioral of tb_UART_TX_FSM is

component UART_TX_FSM is
  Port (
    baud_clk:in std_logic;
    reset:in std_logic;
    start_detected:in std_logic;
    data_index:in std_logic_vector(2 downto 0);
    stored_data:in std_logic_vector(7 downto 0);
    start_reset:out std_logic;
    data_index_reset:out std_logic;
    tx_data_out:out std_logic
   );
end component UART_TX_FSM;

signal baud_clk,reset,start_detected,start_reset,data_index_reset,tx_data_out:std_logic := '0';
signal data_index:unsigned(2 downto 0) := (others =>'0');
signal stored_data:std_logic_vector(7 downto 0) := (others =>'0');

begin

baud_clk <= not baud_clk after 2ns;

data_index <= data_index + 1 when rising_edge(baud_clk) and data_index_reset='0';
stored_data <= x"3B";
 
fsm : UART_TX_FSM port map
(
 baud_clk => baud_clk,
 reset => reset,
 start_detected => start_detected,
 data_index => std_logic_vector(data_index),
 stored_data => stored_data,
 start_reset => start_reset,
 data_index_reset => data_index_reset,
 tx_data_out => tx_data_out
);

process
begin

reset <= '1';
wait for 20ns;
reset <= '0';

wait for 10ns;
start_detected <= '1';

wait ;

end process;


end Behavioral;
