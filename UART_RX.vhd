library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity UART_RX is
  Port ( 
    clk:in std_logic;
    reset:in std_logic;
    rx_data_in:in std_logic;
    rx_data_valid : out std_logic;
    rx_data_out:out std_logic_vector(7 downto 0)
  );
end UART_RX;

architecture Behavioral of UART_RX is

component UART_Baud_Rate_Generator is
    Generic ( baud_rate: unsigned(15 downto 0):=x"0036"); -- 100.000.000 / 115200 / 16 = 54 //sampling rate
    Port (
        reset : in std_logic;
        clk: in std_logic;
        baud_clk:out std_logic
     );
end component UART_Baud_Rate_Generator;

component UART_RX_FSM is
  Port ( 
    baud_clk:in std_logic;
    reset : in std_logic;
    rx_data_in : in std_logic;
    rx_data_valid : out std_logic;
    rx_data_out : out std_logic_vector(7 downto 0)
  );
end component UART_RX_FSM;

signal baud_clk:std_logic:='0';

begin

BaudRateGenerator:UART_Baud_Rate_Generator generic map(x"0036") port map(
    reset=>reset,
    clk=>clk,
    baud_clk=>baud_clk
);

RXFSM:UART_RX_FSM port map(
    baud_clk=>baud_clk,
    reset=>reset,
    rx_data_in=>rx_data_in,
    rx_data_valid => rx_data_valid,
    rx_data_out=>rx_data_out
);

end Behavioral;
