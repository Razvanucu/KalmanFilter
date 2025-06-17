library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_UART_TX_Start_detector is
--  Port ( );
end tb_UART_TX_Start_detector;

architecture Behavioral of tb_UART_TX_Start_detector is

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

signal clk,reset,start,start_reset,tx_start:std_logic :='0';
signal stored_data,tx_data_in : std_logic_vector(7 downto 0) := (others =>'0');

begin

clk <= not clk after 2ns;

startDetector: UART_TX_Start_Detector port map
(
 clk => clk,
 reset => reset,
 stored_data => stored_data,
 tx_data_in => tx_data_in,
 start_reset => start_reset,
 tx_start => tx_start,
 in_start_detected => start,
 out_start_detected => start
);

process
begin

reset <= '1';
wait for 20ns;
reset <= '0';

tx_data_in <= x"3B";
wait for 20ns;

tx_start <= '1';

wait ;
end process;

end Behavioral;
