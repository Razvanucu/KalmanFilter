library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity UART_TX is
 Port (
    clk:in std_logic;
    reset:in std_logic;
    tx_start:in std_logic;
    tx_data_in:in std_logic_vector(7 downto 0);
    tx_data_out:out std_logic
  );
end UART_TX;

architecture Behavioral of UART_TX is

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

component UART_TX_Start_Detector is
  Port (
    clk:in std_logic;
    reset:in std_logic;
    stored_data:out std_logic_vector(7 downto 0);
    tx_data_in:in std_logic_vector(7 downto 0);
    start_reset:in std_logic;
    tx_start:in std_logic;
    in_start_detected:in std_logic;
    out_start_detected:out std_logic
   );
end component UART_TX_Start_Detector;

component UART_Baud_Rate_Generator is
    Generic ( baud_rate: unsigned(15 downto 0):=x"0364"); --1041 100.000.000/9600
    Port (
        reset : in std_logic;
        clk: in std_logic;
        baud_clk:out std_logic
     );
end component UART_Baud_Rate_Generator;

component UART_TX_data_index is
    Port (
        baud_clk : in std_logic;
        reset : in std_logic;
        data_index_reset : in std_logic;
        data_index : out std_logic_vector(2 downto 0)
     );
end component UART_TX_data_index;

signal baud_clk,start_reset,start_detected:std_logic:='0';
signal data_index_reset:std_logic:='0';
signal data_index:std_logic_vector(2 downto 0):="000";
signal stored_data:std_logic_vector(7 downto 0):=(others =>'0');
begin

BaudRateGenerator:UART_Baud_Rate_Generator generic map(x"0364") -- 100.000.000 / 115200 = 868
port map(
    reset=>reset,
    clk=>clk,
    baud_clk=>baud_clk
);

TXdataindex:UART_TX_data_index port map(
    baud_clk=>baud_clk,
    reset=>reset,
    data_index_reset=>data_index_reset,
    data_index=>data_index
);

TXStartDetector:UART_TX_Start_Detector port map(
    clk=>clk,
    reset=>reset,
    stored_data=>stored_data,
    tx_data_in=>tx_data_in,
    start_reset=>start_reset,
    tx_start=>tx_start,
    in_start_detected=>start_detected,
    out_start_detected=>start_detected
);

TXFSM:UART_TX_FSM port map(
    baud_clk=>baud_clk,
    reset=>reset,
    start_detected=>start_detected,
    data_index=>data_index,
    stored_data=>stored_data,
    start_reset=>start_reset,
    data_index_reset=>data_index_reset,
    tx_data_out=>tx_data_out
);
end Behavioral;
