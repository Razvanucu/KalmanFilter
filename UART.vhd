library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART is
  Port ( 
    clk:in std_logic;
    reset:in std_logic;
    tx_start:in std_logic;
    data_in: in  std_logic_vector (7 downto 0);
    data_out: out std_logic_vector (7 downto 0);
    rx_data_valid: out std_logic;
    rx: in  std_logic;
    tx: out std_logic
  );
end UART;

architecture Behavioral of UART is

component UART_RX is
  Port ( 
    clk:in std_logic;
    reset:in std_logic;
    rx_data_in:in std_logic;
    rx_data_valid : out std_logic;
    rx_data_out:out std_logic_vector(7 downto 0)
  );
end component UART_RX;

component UART_TX is
 Port (
    clk:in std_logic;
    reset:in std_logic;
    tx_start:in std_logic;
    tx_data_in:in std_logic_vector(7 downto 0);
    tx_data_out:out std_logic
  );
end component UART_TX;


begin

UARTRX:UART_RX port map(
    clk=>clk,
    reset=>reset,
    rx_data_in=>rx,
    rx_data_valid =>rx_data_valid,
    rx_data_out=>data_out
);

UARTTX:UART_TX port map(
    clk=>clk,
    reset=>reset,
    tx_start=>tx_start,
    tx_data_in=>data_in,
    tx_data_out=>tx
);
end Behavioral;
