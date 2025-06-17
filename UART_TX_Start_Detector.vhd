library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_TX_Start_Detector is
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
end UART_TX_Start_Detector;

architecture Behavioral of UART_TX_Start_Detector is

begin

process(clk)
begin
    if rising_edge(clk)  then
        if reset='1' or start_reset='1' then
            out_start_detected<='0';
            stored_data<=(others =>'0');
        elsif in_start_detected ='0' and tx_start='1' then
            out_start_detected<='1';
            stored_data<=tx_data_in;
        end if;  
    end if;
end process;

end Behavioral;
